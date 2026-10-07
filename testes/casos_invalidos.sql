-- BASE CENTRAL CARREGADA. Executar CADA TI isoladamente como proprietário.
-- Após o erro, executar ROLLBACK separadamente antes do próximo TI.
-- Salvar erro real (SQLSTATE e constraint/coluna), não apenas "falhou".
-- Resultados disponíveis e alcance das provas: testes/relatorio_testes.md.

-- TI01: RN01; mecanismo esperado: fk_edicao_evento.
START TRANSACTION;
INSERT INTO edicao VALUES (20001,99999,'Teste',DATE '2026-10-20',DATE '2026-10-22','REMOTA',NULL,DATE '2026-09-01',DATE '2026-10-19');
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM edicao WHERE id_edicao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI02: RN02; mecanismo esperado: uq_participante_cpf.
START TRANSACTION;
INSERT INTO participante VALUES (20001,'Outro nome','outro@example.invalid','90000000001');
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM participante WHERE id_participante=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI03: RN02; mecanismo esperado: ck_participante_cpf.
START TRANSACTION;
INSERT INTO participante VALUES (20001,'Formato errado','outro@example.invalid','123ABC');
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM participante WHERE id_participante=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI04: RN01; mecanismo esperado: NOT NULL: inscricao.id_participante.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,NULL,1,1,DATE '2022-01-05','PENDENTE',120.00,NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI05: RN02; mecanismo esperado: ck_participante_nome.
START TRANSACTION;
INSERT INTO participante VALUES (20001,'   ','outro@example.invalid',NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM participante WHERE id_participante=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI06: RN03; categoria global inexistente; esperado 23503 / fk_inscricao_categoria.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,6000,99999,2,DATE '2022-01-05','PENDENTE',120.00,NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI07: RN03; nome global repetido; esperado 23505 / uq_categoria_nome.
START TRANSACTION;
INSERT INTO categoria VALUES (20001,'Estudante',NULL,120.00);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM categoria WHERE id_categoria=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI08: RN04; mecanismo esperado: ck_edicao_realizacao.
START TRANSACTION;
INSERT INTO edicao VALUES (20001,1,'Teste',DATE '2026-10-22',DATE '2026-10-20','REMOTA',NULL,DATE '2026-09-01',DATE '2026-10-19');
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM edicao WHERE id_edicao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI09: RN04; mecanismo esperado: ck_edicao_janela.
START TRANSACTION;
INSERT INTO edicao VALUES (20001,1,'Teste',DATE '2026-10-20',DATE '2026-10-22','REMOTA',NULL,DATE '2026-10-19',DATE '2026-09-01');
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM edicao WHERE id_edicao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI10: RN04; mecanismo esperado: ck_edicao_modalidade.
START TRANSACTION;
INSERT INTO edicao VALUES (20001,1,'Teste',DATE '2026-10-20',DATE '2026-10-22','OUTRA',NULL,DATE '2026-09-01',DATE '2026-10-19');
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM edicao WHERE id_edicao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI11: RN04; mecanismo esperado: ck_edicao_local.
START TRANSACTION;
INSERT INTO edicao VALUES (20001,1,'Teste',DATE '2026-10-20',DATE '2026-10-22','PRESENCIAL',NULL,DATE '2026-09-01',DATE '2026-10-19');
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM edicao WHERE id_edicao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI12: RN06; mecanismo esperado: ck_categoria_preco.
START TRANSACTION;
INSERT INTO categoria VALUES (20001,'Teste negativo',NULL,-1.00);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM categoria WHERE id_categoria=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI13: RN06; mecanismo esperado: ck_inscricao_valor.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,6000,1,2,DATE '2022-01-05','PENDENTE',0.00,NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI14: RN07, RN12; mecanismo esperado: uq_inscricao_participante_edicao.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,3,2,3,DATE '2022-01-05','PENDENTE',150.00,NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI15: RN09; mecanismo esperado: ck_inscricao_situacao.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,6000,1,2,DATE '2022-01-05','QUITADA',100.00,NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI16: RN16; mecanismo esperado: ck_inscricao_canal.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,6000,1,2,DATE '2022-01-05','PENDENTE',100.00,'WHATSAPP');
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0; preparação/reversão confirmada.


-- TI17: RN18; mecanismo esperado: pk_evento.
START TRANSACTION;
INSERT INTO evento VALUES (1,'Duplicado',NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT id_evento,nome FROM evento WHERE id_evento=1;
-- Esperado: nome original Evento Sintético 1, sem mudança.


-- TI18: RN01, RN18; mecanismo esperado: fk_inscricao_participante.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,99999,1,2,DATE '2022-01-05','PENDENTE',100.00,NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0; preparação/reversão confirmada.

-- TI19: RN01/RN03/RN18; edição inexistente; esperado 23503 / fk_inscricao_edicao.
-- Categoria 1 e participante 6000 existem; somente a edição 99999 é inexistente.
START TRANSACTION;
INSERT INTO inscricao VALUES (20001,6000,1,99999,DATE '2022-01-05','PENDENTE',120.00,NULL);
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT COUNT(*) AS registro_teste_restante FROM inscricao WHERE id_inscricao=20001;
-- Esperado: 0.

-- TI20: RN03/RN14/RN18; remover categoria referenciada; esperado 23503 / fk_inscricao_categoria.
-- Exercita a ação referencial no DELETE da categoria, complementar ao INSERT inválido de TI06.
START TRANSACTION;
DELETE FROM categoria WHERE id_categoria=1;
-- Esperado: erro. Agora selecione somente ROLLBACK e execute.
ROLLBACK;
-- Executar esta pós-condição APÓS o ROLLBACK separado.
SELECT id_categoria,nome,preco_vigente FROM categoria WHERE id_categoria=1;
-- Esperado: uma linha, 1 / Estudante / 120.00; inscrições permanecem referenciadas.
