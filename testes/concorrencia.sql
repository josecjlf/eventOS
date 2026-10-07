-- DUAS Query Tools/conexões distintas da base central. Não executar inteiro.
-- Usar proprietário para isolar integridade; IDs reservados 20001/20002 não existem.

-- TC01: UNIQUE impede inscrições simultâneas para a mesma pessoa/edição, mesmo com categorias distintas.
-- PRÉ-CONDIÇÃO na sessão A: zero linhas de fixture e zero inscrições de 6000 na edição 2.
SELECT id_inscricao FROM inscricao WHERE id_inscricao IN (20001,20002) OR (id_participante=6000 AND id_edicao=2);
-- SESSÃO A / A1: executar e deixar aberta.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,6000,1,2,DATE '2022-01-05','PENDENTE',120.00,NULL);
-- SESSÃO B / B1: executar; aguardará A.
START TRANSACTION;
INSERT INTO inscricao VALUES (20002,6000,2,2,DATE '2022-01-05','PENDENTE',150.00,NULL);
-- SESSÃO A / A2: após capturar a espera de B, confirmar A.
COMMIT;
-- SESSÃO B: esperado 23505 / uq_inscricao_participante_edicao; salvar Messages.
-- Selecionar e executar SOMENTE ROLLBACK na sessão B.
ROLLBACK;
-- SESSÃO A / A3: exatamente uma linha: 20001, categoria 1, edição 2.
SELECT id_inscricao,id_categoria,id_edicao FROM inscricao WHERE id_participante=6000 AND id_edicao=2;
-- LIMPEZA pelo proprietário, somente após salvar evidência; dado exclusivo do teste.
DELETE FROM inscricao WHERE id_inscricao=20001;
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao IN (20001,20002);
-- Esperado: DELETE 1 e COUNT 0.

-- TC02: quitação e cancelamento concorrentes, sem último estado sobrescrito.
-- SESSÃO A: A2; manter aberta.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE inscricao SET situacao='PAGA' WHERE id_inscricao=2 AND situacao='PENDENTE';
-- SESSÃO B: B2 enquanto A ainda aberta; aguardará.
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE inscricao SET situacao='CANCELADA' WHERE id_inscricao=2 AND situacao='PENDENTE';
-- SESSÃO A: confirmar; uma única mudança vence.
COMMIT;
-- SESSÃO B: esperado 40001; ROLLBACK separado e repetir a transação inteira.
ROLLBACK;
START TRANSACTION;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE inscricao SET situacao='CANCELADA' WHERE id_inscricao=2 AND situacao='PENDENTE';
-- Após repetição: UPDATE 0; permanece PAGA. Desfazer transação sem alteração.
ROLLBACK;
SELECT id_inscricao,situacao FROM inscricao WHERE id_inscricao=2;
-- LIMPEZA exclusiva pelo proprietário: restaura a fixture; não é operação de negócio.
UPDATE inscricao SET situacao='PENDENTE' WHERE id_inscricao=2 AND situacao='PAGA';
-- Conferência final seletiva: contagens, P00/P01/P05, V02/V05 e DG02.
