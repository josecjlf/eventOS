-- OC01–OC05: ROTEIROS. Não executar o arquivo inteiro.
-- Cada bloco é uma operação independente com parâmetros literais de demonstração.
-- Antes de COMMIT: exigir exatamente uma linha afetada e conferir resultado.
-- Zero linhas: recusa do protocolo; ROLLBACK. Erro: ROLLBACK.
-- SQLSTATE 40001: repetir a transação inteira. SERIALIZABLE é obrigatório.
-- Nos testes, trocar COMMIT por ROLLBACK para não alterar a carga de referência.
-- Os privilégios limitam colunas; janela e cópia do preço exigem seguir OC01.

-- OC01: criar inscrição PENDENTE copiando o preço do catálogo global.
-- Parâmetros explícitos: pessoa 6000, edição 2, categoria 1, data 2022-01-05.
-- A pessoa 6000 ainda não está na edição 2 na carga oficial. ID de teste reservado 20001.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,valor_contratado,canal_divulgacao)
SELECT 20001,p.id_participante,c.id_categoria,e.id_edicao,DATE '2022-01-05',c.preco_vigente,'OUTRO'
FROM participante p CROSS JOIN categoria c CROSS JOIN edicao e
WHERE p.id_participante=6000 AND e.id_edicao=2 AND c.id_categoria=1
AND DATE '2022-01-05' BETWEEN e.abertura_inscricoes AND e.fechamento_inscricoes
AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_participante=p.id_participante AND i.id_edicao=e.id_edicao);
SELECT id_inscricao,situacao,valor_contratado FROM inscricao WHERE id_inscricao=20001;
-- Esperado na carga oficial: uma linha PENDENTE, 120.00; conferir antes de concluir.
COMMIT;

-- OC02: reconhecer quitação integral de inscrição existente, inclusive depois do fechamento.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE inscricao SET situacao='PAGA' WHERE id_inscricao=2 AND situacao='PENDENTE';
SELECT id_inscricao,situacao,valor_contratado FROM inscricao WHERE id_inscricao=2;
-- Exigir uma linha atualizada; ato é reconhecimento administrativo, não transferência de dinheiro.
COMMIT;

-- OC03: cancelar somente pendente. Não apagar, reabrir nem cancelar paga.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE inscricao SET situacao='CANCELADA' WHERE id_inscricao=5 AND situacao='PENDENTE';
SELECT id_inscricao,situacao FROM inscricao WHERE id_inscricao=5;
COMMIT;

-- OC04: reajustar preço vigente global, aplicável a novas inscrições de todas as edições.
-- Não atualizar contrato de inscrição.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE categoria SET preco_vigente=130.00 WHERE id_categoria=1;
SELECT id_categoria,preco_vigente FROM categoria WHERE id_categoria=1;
SELECT id_inscricao,id_edicao,valor_contratado FROM inscricao WHERE id_categoria=1 ORDER BY id_edicao,id_inscricao;
COMMIT;

-- OC05: configurar janela apenas ANTES de qualquer inscrição. Executar como proprietário.
-- Exemplo da carga: edição 1 já utilizada; operação deve afetar ZERO linhas e ser desfeita.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE edicao SET abertura_inscricoes=DATE '2022-01-06',fechamento_inscricoes=DATE '2022-06-18'
WHERE id_edicao=1 AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_edicao=edicao.id_edicao);
SELECT id_edicao,abertura_inscricoes,fechamento_inscricoes FROM edicao WHERE id_edicao=1;
ROLLBACK;

