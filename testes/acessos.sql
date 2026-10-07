-- PA por conexão própria (login eventos_operacao ou eventos_consulta), nunca postgres.
-- PA01–PA04 verificam os privilégios dos perfis de operação e consulta.
-- PA05 verifica a operação controlada com categoria 1 e edição 2.
-- Em cada erro transacional executar SOMENTE ROLLBACK em comando separado.

-- PA01 — eventos_consulta: SELECT permitido sem identificador pessoal; total 12000.
SELECT SUM(inscricoes) AS inscricoes FROM vw_resumo_edicao;

-- PA02 — eventos_operacao: snapshot protegido; esperado 42501 / permission denied.
START TRANSACTION;
UPDATE inscricao SET valor_contratado=1.00 WHERE id_inscricao=1;
-- Após salvar o erro, selecionar somente ROLLBACK.
ROLLBACK;
SELECT id_inscricao,valor_contratado FROM inscricao WHERE id_inscricao=1;
-- Esperado: 1 / 100.00.

-- PA03 — eventos_operacao: DELETE de inscrição protegido; esperado 42501.
START TRANSACTION;
DELETE FROM inscricao WHERE id_inscricao=3;
-- Após salvar o erro, selecionar somente ROLLBACK.
ROLLBACK;
SELECT id_inscricao,situacao FROM inscricao WHERE id_inscricao=3;
-- Esperado: 3 / CANCELADA.

-- PA04 — eventos_consulta: leitura direta de CPF deve gerar 42501.
SELECT cpf FROM participante WHERE id_participante=1;
-- Consulta sem alteração: não há fixture; salvar erro e contexto de eventos_consulta.

-- PA05 — eventos_operacao: atos autorizados, revertidos ao final.
-- Primeiro salvar o contexto próprio da conexão.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,valor_contratado,canal_divulgacao)
SELECT 20001,p.id_participante,c.id_categoria,e.id_edicao,DATE '2022-01-05',c.preco_vigente,'OUTRO'
FROM participante p CROSS JOIN categoria c CROSS JOIN edicao e
WHERE p.id_participante=6000 AND c.id_categoria=1 AND e.id_edicao=2
AND DATE '2022-01-05' BETWEEN e.abertura_inscricoes AND e.fechamento_inscricoes
AND NOT EXISTS (SELECT 1 FROM inscricao i WHERE i.id_participante=p.id_participante AND i.id_edicao=e.id_edicao);
SELECT id_inscricao,situacao,valor_contratado FROM inscricao WHERE id_inscricao=20001;
-- Esperado: INSERT 1; PENDENTE / 120.00.
UPDATE inscricao SET situacao='PAGA' WHERE id_inscricao=20001 AND situacao='PENDENTE';
UPDATE categoria SET preco_vigente=130.00 WHERE id_categoria=1;
SELECT id_inscricao,situacao,valor_contratado FROM inscricao WHERE id_inscricao=20001;
SELECT id_inscricao,valor_contratado FROM inscricao WHERE id_inscricao=1;
-- Esperado: dois UPDATE 1; nova PAGA/120; contrato antigo da inscrição 1 continua 100.
ROLLBACK;
SELECT COUNT(*) AS inscricao_teste_restante FROM inscricao WHERE id_inscricao=20001;
SELECT preco_vigente FROM categoria WHERE id_categoria=1;
-- Esperado: 0 e 120.00; operação não deixa dados de teste.
