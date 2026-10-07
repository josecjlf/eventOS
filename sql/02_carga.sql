-- Carga oficial sintética do MER atual. Base limpa com apenas 01_estrutura.sql.

-- Executar integralmente uma vez. 500 eventos, 5000 edições, 2 categorias globais,

-- 6000 participantes e 12000 inscrições.

START TRANSACTION;

INSERT INTO evento (id_evento,nome,sigla)
WITH digitos(d) AS (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)),
numeros(n) AS (SELECT 1 + 1 * a.d + 10 * b.d + 100 * c.d FROM digitos a CROSS JOIN digitos b CROSS JOIN digitos c WHERE 1 + 1 * a.d + 10 * b.d + 100 * c.d <= 500)
SELECT n, 'Evento Sintético ' || CAST(n AS VARCHAR(4)), 'EV' || CAST(n AS VARCHAR(4)) FROM numeros;

INSERT INTO edicao (id_edicao,id_evento,designacao,data_inicio,data_fim,modalidade,local_realizacao,abertura_inscricoes,fechamento_inscricoes)
WITH digitos(d) AS (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)),
numeros(n) AS (SELECT 1 + 1 * a.d + 10 * b.d + 100 * c.d + 1000 * d.d FROM digitos a CROSS JOIN digitos b CROSS JOIN digitos c CROSS JOIN digitos d WHERE 1 + 1 * a.d + 10 * b.d + 100 * c.d + 1000 * d.d <= 5000)
SELECT n, MOD(n-1,500)+1, CAST(2022+FLOOR((n-1)/500.0) AS VARCHAR(60)),
CASE FLOOR((n-1)/500.0) WHEN 0 THEN DATE '2022-06-20' WHEN 1 THEN DATE '2023-06-20' WHEN 2 THEN DATE '2024-06-20' WHEN 3 THEN DATE '2025-06-20' WHEN 4 THEN DATE '2026-06-20' WHEN 5 THEN DATE '2027-06-20' WHEN 6 THEN DATE '2028-06-20' WHEN 7 THEN DATE '2029-06-20' WHEN 8 THEN DATE '2030-06-20' ELSE DATE '2031-06-20' END,
CASE FLOOR((n-1)/500.0) WHEN 0 THEN DATE '2022-06-22' WHEN 1 THEN DATE '2023-06-22' WHEN 2 THEN DATE '2024-06-22' WHEN 3 THEN DATE '2025-06-22' WHEN 4 THEN DATE '2026-06-22' WHEN 5 THEN DATE '2027-06-22' WHEN 6 THEN DATE '2028-06-22' WHEN 7 THEN DATE '2029-06-22' WHEN 8 THEN DATE '2030-06-22' ELSE DATE '2031-06-22' END,
CASE MOD(n-1,3) WHEN 0 THEN 'PRESENCIAL' WHEN 1 THEN 'HIBRIDA' ELSE 'REMOTA' END,
CASE WHEN MOD(n-1,3)=2 THEN CAST(NULL AS VARCHAR(200)) ELSE 'Campus Sintético ' || CAST(MOD(n-1,500)+1 AS VARCHAR(4)) END,
CASE FLOOR((n-1)/500.0) WHEN 0 THEN DATE '2022-01-05' WHEN 1 THEN DATE '2023-01-05' WHEN 2 THEN DATE '2024-01-05' WHEN 3 THEN DATE '2025-01-05' WHEN 4 THEN DATE '2026-01-05' WHEN 5 THEN DATE '2027-01-05' WHEN 6 THEN DATE '2028-01-05' WHEN 7 THEN DATE '2029-01-05' WHEN 8 THEN DATE '2030-01-05' ELSE DATE '2031-01-05' END,
CASE FLOOR((n-1)/500.0) WHEN 0 THEN DATE '2022-06-19' WHEN 1 THEN DATE '2023-06-19' WHEN 2 THEN DATE '2024-06-19' WHEN 3 THEN DATE '2025-06-19' WHEN 4 THEN DATE '2026-06-19' WHEN 5 THEN DATE '2027-06-19' WHEN 6 THEN DATE '2028-06-19' WHEN 7 THEN DATE '2029-06-19' WHEN 8 THEN DATE '2030-06-19' ELSE DATE '2031-06-19' END
FROM numeros;

INSERT INTO categoria (id_categoria,nome,descricao,preco_vigente) VALUES
(1,'Estudante','Classificação administrativa estudante',100.00),
(2,'Geral','Categoria geral',150.00);

INSERT INTO participante (id_participante,nome_completo,email,cpf)
WITH digitos(d) AS (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)),
numeros(n) AS (SELECT 1 + 1 * a.d + 10 * b.d + 100 * c.d + 1000 * d.d FROM digitos a CROSS JOIN digitos b CROSS JOIN digitos c CROSS JOIN digitos d WHERE 1 + 1 * a.d + 10 * b.d + 100 * c.d + 1000 * d.d <= 6000)
SELECT n, CASE WHEN n IN (1,2) THEN 'Alex Exemplo' ELSE 'Participante Sintético ' || CAST(n AS VARCHAR(4)) END,
CASE WHEN n IN (1,2) THEN 'contato-compartilhado@example.invalid' ELSE 'participante' || CAST(n AS VARCHAR(4)) || '@example.invalid' END,
CASE WHEN MOD(n,5)=0 THEN CAST(NULL AS VARCHAR(11)) ELSE '9000000' || SUBSTRING(CAST(10000+n AS VARCHAR(5)) FROM 2 FOR 4) END
FROM numeros;

INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,situacao,valor_contratado,canal_divulgacao)
WITH digitos(d) AS (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)),
numeros(n) AS (SELECT 1 + 1 * a.d + 10 * b.d + 100 * c.d + 1000 * d.d + 10000 * e.d FROM digitos a CROSS JOIN digitos b CROSS JOIN digitos c CROSS JOIN digitos d CROSS JOIN digitos e WHERE 1 + 1 * a.d + 10 * b.d + 100 * c.d + 1000 * d.d + 10000 * e.d <= 11999)
SELECT n, MOD(n-1,6000)+1, c.id_categoria, e.id_edicao, e.abertura_inscricoes,
CASE MOD(n-1,3) WHEN 0 THEN 'PAGA' WHEN 1 THEN 'PENDENTE' ELSE 'CANCELADA' END, c.preco_vigente,
CASE MOD(n-1,6) WHEN 0 THEN 'SITE_EVENTO' WHEN 1 THEN 'REDE_SOCIAL' WHEN 2 THEN 'EMAIL' WHEN 3 THEN 'INDICACAO' WHEN 4 THEN 'OUTRO' ELSE CAST(NULL AS VARCHAR(11)) END
FROM numeros JOIN categoria c ON c.id_categoria=MOD(n-1,2)+1
JOIN edicao e ON e.id_edicao=MOD(n-1,2500)+1;

-- Reajuste: 6000 contratos anteriores da categoria global 1 continuam em 100,00.
UPDATE categoria SET preco_vigente=120.00 WHERE id_categoria=1;
INSERT INTO inscricao (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,situacao,valor_contratado,canal_divulgacao)
SELECT 12000,6000,c.id_categoria,e.id_edicao,e.abertura_inscricoes,'PAGA',c.preco_vigente,'INDICACAO'
FROM categoria c CROSS JOIN edicao e WHERE c.id_categoria=1 AND e.id_edicao=1;

ALTER TABLE evento ALTER COLUMN id_evento RESTART WITH 501;

ALTER TABLE edicao ALTER COLUMN id_edicao RESTART WITH 5001;

ALTER TABLE participante ALTER COLUMN id_participante RESTART WITH 6001;

ALTER TABLE categoria ALTER COLUMN id_categoria RESTART WITH 3;

ALTER TABLE inscricao ALTER COLUMN id_inscricao RESTART WITH 12001;

COMMIT;
