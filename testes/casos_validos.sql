-- Base central carregada com acessos.sql. Executar cada TV isoladamente como proprietário.
-- Todos os casos terminam ROLLBACK; valores da carga não devem mudar.
-- Resultados disponíveis e alcance das provas: testes/relatorio_testes.md.

-- TV01: Categoria global compartilhada entre edições (RN01, RN03, RN07).
-- Esperado: INSERT 1; pessoa 1 com três inscrições, mesma categoria 1 nas edições 1/2/1001.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO inscricao VALUES (20001,1,1,2,DATE '2022-01-05','PENDENTE',120.00,NULL);
SELECT i.id_inscricao,i.id_participante,i.id_categoria,i.id_edicao,c.nome
FROM inscricao i JOIN categoria c ON c.id_categoria=i.id_categoria
WHERE i.id_participante=1 ORDER BY i.id_inscricao;
ROLLBACK;
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0.

-- TV02: Homônimos/contato comum e CPF ausente (RN02).
-- Esperado: Quatro cadastros; dois CPFs distintos e dois NULL.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO participante VALUES (20001,'Alex Exemplo','contato-compartilhado@example.invalid',NULL),(20002,'Alex Exemplo','contato-compartilhado@example.invalid',NULL);
SELECT id_participante,nome_completo,email,cpf FROM participante WHERE id_participante IN (1,2,20001,20002) ORDER BY id_participante;
ROLLBACK;

-- TV03: Limites inclusivos e estado inicial por OC01 (RN04, RN05).
-- Esperado: Duas linhas PENDENTE/120, datas 2022-01-05 e 2022-06-19; edições 2/3.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,valor_contratado)
SELECT 20001,6000,c.id_categoria,e.id_edicao,e.abertura_inscricoes,c.preco_vigente
FROM categoria c CROSS JOIN edicao e WHERE c.id_categoria=1 AND e.id_edicao=2
AND e.abertura_inscricoes BETWEEN e.abertura_inscricoes AND e.fechamento_inscricoes
AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_participante=6000 AND i.id_edicao=e.id_edicao);
INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,valor_contratado)
SELECT 20002,5999,c.id_categoria,e.id_edicao,e.fechamento_inscricoes,c.preco_vigente
FROM categoria c CROSS JOIN edicao e WHERE c.id_categoria=1 AND e.id_edicao=3
AND e.fechamento_inscricoes BETWEEN e.abertura_inscricoes AND e.fechamento_inscricoes
AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_participante=5999 AND i.id_edicao=e.id_edicao);
SELECT id_inscricao,id_edicao,data_inscricao,situacao,valor_contratado
FROM inscricao WHERE id_inscricao IN (20001,20002) ORDER BY id_inscricao;
ROLLBACK;
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao IN (20001,20002);
-- Esperado: 0.

-- TV04: Reajuste global e snapshots em duas edições (RN05, RN06, RN14).
-- Esperado: UPDATE 1; duas INSERT 1; contratos 100/120/130/130 e preço atual 130.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE categoria SET preco_vigente=130.00 WHERE id_categoria=1;
INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,valor_contratado)
SELECT 20001,5999,c.id_categoria,e.id_edicao,DATE '2022-01-05',c.preco_vigente
FROM categoria c CROSS JOIN edicao e WHERE c.id_categoria=1 AND e.id_edicao=1
AND DATE '2022-01-05' BETWEEN e.abertura_inscricoes AND e.fechamento_inscricoes
AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_participante=5999 AND i.id_edicao=e.id_edicao);
INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,valor_contratado)
SELECT 20002,6000,c.id_categoria,e.id_edicao,DATE '2022-01-05',c.preco_vigente
FROM categoria c CROSS JOIN edicao e WHERE c.id_categoria=1 AND e.id_edicao=2
AND DATE '2022-01-05' BETWEEN e.abertura_inscricoes AND e.fechamento_inscricoes
AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_participante=6000 AND i.id_edicao=e.id_edicao);
SELECT i.id_inscricao,i.id_edicao,i.valor_contratado,c.preco_vigente
FROM inscricao i JOIN categoria c ON c.id_categoria=i.id_categoria
WHERE i.id_inscricao IN (1,12000,20001,20002) ORDER BY i.id_inscricao;
ROLLBACK;
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao IN (20001,20002);
SELECT i.id_inscricao,i.valor_contratado,c.preco_vigente
FROM inscricao i JOIN categoria c ON c.id_categoria=i.id_categoria
WHERE i.id_inscricao IN (1,12000) ORDER BY i.id_inscricao;
-- Esperado: fixture 0; contratos antigos 100/120 e preço global restaurado 120.

-- TV05: Quitação somente de pendente, mesmo após fechamento (RN06, RN09).
-- Esperado: Primeiro UPDATE 1: PAGA. Segundo UPDATE 0: inscrição 3 permanece CANCELADA.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE inscricao SET situacao='PAGA' WHERE id_inscricao=2 AND situacao='PENDENTE';
SELECT id_inscricao,situacao,valor_contratado FROM inscricao WHERE id_inscricao=2;
UPDATE inscricao SET situacao='PAGA' WHERE id_inscricao=3 AND situacao='PENDENTE';
SELECT id_inscricao,situacao FROM inscricao WHERE id_inscricao=3;
ROLLBACK;

-- TV06: Cancelamento terminal pelo protocolo (RN09, RN12).
-- Esperado: Primeiro UPDATE 1: CANCELADA. Segundo 0: inscrição 1 continua PAGA.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE inscricao SET situacao='CANCELADA' WHERE id_inscricao=5 AND situacao='PENDENTE';
SELECT id_inscricao,situacao FROM inscricao WHERE id_inscricao=5;
UPDATE inscricao SET situacao='CANCELADA' WHERE id_inscricao=1 AND situacao='PENDENTE';
SELECT id_inscricao,situacao FROM inscricao WHERE id_inscricao=1;
ROLLBACK;

-- TV07: Recusa de data fora da janela e diagnóstico de escrita direta (RN04, RN18).
-- Esperado: OC01 INSERT 0; direta INSERT 1; DG01 detecta 20001; ROLLBACK remove tudo.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,valor_contratado)
SELECT 20001,6000,c.id_categoria,e.id_edicao,DATE '2022-01-04',c.preco_vigente
FROM categoria c CROSS JOIN edicao e WHERE c.id_categoria=1 AND e.id_edicao=2
AND DATE '2022-01-04' BETWEEN e.abertura_inscricoes AND e.fechamento_inscricoes
AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_participante=6000 AND i.id_edicao=e.id_edicao);
SELECT COUNT(*) AS criada_indevidamente FROM inscricao WHERE id_inscricao=20001;
-- Proprietário: a escrita direta É aceita; a data intertabela depende do protocolo.
INSERT INTO inscricao VALUES (20001,6000,1,2,DATE '2022-01-04','PENDENTE',120.00,NULL);
SELECT i.id_inscricao FROM inscricao i JOIN edicao e ON e.id_edicao=i.id_edicao
WHERE i.data_inscricao<e.abertura_inscricoes OR i.data_inscricao>e.fechamento_inscricoes;
ROLLBACK;
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0.

-- TV08: Não reescrever janela já utilizada (RN14).
-- Esperado: UPDATE 0; edição 1 preserva abertura 2022-01-05/fechamento 2022-06-19.
-- Categoria global não possui edição de origem nem operação de mover categoria.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE edicao SET abertura_inscricoes=DATE '2022-01-06'
WHERE id_edicao=1 AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_edicao=edicao.id_edicao);
SELECT id_edicao,abertura_inscricoes,fechamento_inscricoes FROM edicao WHERE id_edicao=1;
ROLLBACK;
SELECT id_edicao,abertura_inscricoes,fechamento_inscricoes FROM edicao WHERE id_edicao=1;

-- TV09: Relatórios coerentes com a carga (RN15, RN16).
-- Esperado: 12000, 4001, 4000, 3999, 500120.00; canais total 12000.
-- Edições sem inscrições não alteram estas somas.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT SUM(inscricoes) AS inscricoes,SUM(pagas) AS pagas,SUM(pendentes) AS pendentes,SUM(canceladas) AS canceladas,SUM(recebimento_bruto) AS recebimento_bruto FROM vw_resumo_edicao;
SELECT SUM(inscricoes) AS inscricoes FROM vw_resumo_canal;
ROLLBACK;
