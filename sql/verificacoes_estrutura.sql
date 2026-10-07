-- Conferir como proprietário, em public, antes da carga. Selecionar Q00–Q09 separadamente.

-- Q00: contexto da conexão; conferir o nome da base limpa escolhida.
SELECT catalog_name,schema_name FROM information_schema.schemata WHERE schema_name='public';

-- Q01: tabelas ausentes/inesperadas; zero linhas.
WITH esperadas(tabela) AS (VALUES ('evento'),('edicao'),('participante'),('categoria'),('inscricao'))
SELECT e.tabela AS esperada,a.table_name AS encontrada FROM esperadas e FULL OUTER JOIN
(SELECT table_name FROM information_schema.tables WHERE table_schema='public' AND table_type='BASE TABLE') a
ON a.table_name=e.tabela WHERE e.tabela IS NULL OR a.table_name IS NULL;

-- Q02: colunas, ordem, tipo, tamanho, nulabilidade e identidade; zero linhas.
WITH esperadas(tabela,coluna,ordem,tipo,tamanho,nulavel,identidade) AS (VALUES
('evento','id_evento',1,'bigint',NULL,'NO','YES'),
('evento','nome',2,'character varying',200,'NO','NO'),
('evento','sigla',3,'character varying',30,'YES','NO'),
('edicao','id_edicao',1,'bigint',NULL,'NO','YES'),
('edicao','id_evento',2,'bigint',NULL,'NO','NO'),
('edicao','designacao',3,'character varying',60,'NO','NO'),
('edicao','data_inicio',4,'date',NULL,'NO','NO'),
('edicao','data_fim',5,'date',NULL,'NO','NO'),
('edicao','modalidade',6,'character varying',10,'NO','NO'),
('edicao','local_realizacao',7,'character varying',200,'YES','NO'),
('edicao','abertura_inscricoes',8,'date',NULL,'NO','NO'),
('edicao','fechamento_inscricoes',9,'date',NULL,'NO','NO'),
('participante','id_participante',1,'bigint',NULL,'NO','YES'),
('participante','nome_completo',2,'character varying',150,'NO','NO'),
('participante','email',3,'character varying',254,'NO','NO'),
('participante','cpf',4,'character varying',11,'YES','NO'),
('categoria','id_categoria',1,'bigint',NULL,'NO','YES'),
('categoria','nome',2,'character varying',80,'NO','NO'),
('categoria','descricao',3,'character varying',300,'YES','NO'),
('categoria','preco_vigente',4,'numeric',NULL,'NO','NO'),
('inscricao','id_inscricao',1,'bigint',NULL,'NO','YES'),
('inscricao','id_participante',2,'bigint',NULL,'NO','NO'),
('inscricao','id_categoria',3,'bigint',NULL,'NO','NO'),
('inscricao','id_edicao',4,'bigint',NULL,'NO','NO'),
('inscricao','data_inscricao',5,'date',NULL,'NO','NO'),
('inscricao','situacao',6,'character varying',9,'NO','NO'),
('inscricao','valor_contratado',7,'numeric',NULL,'NO','NO'),
('inscricao','canal_divulgacao',8,'character varying',11,'YES','NO'))
SELECT e.*,a.table_name,a.column_name,a.data_type,a.character_maximum_length,a.is_nullable,a.is_identity
FROM esperadas e FULL OUTER JOIN
(SELECT * FROM information_schema.columns WHERE table_schema='public' AND table_name IN ('evento','edicao','participante','categoria','inscricao')) a
ON a.table_name=e.tabela AND a.column_name=e.coluna
WHERE e.coluna IS NULL OR a.column_name IS NULL OR e.ordem<>a.ordinal_position OR e.tipo<>a.data_type
OR COALESCE(e.tamanho,0)<>COALESCE(a.character_maximum_length,0) OR e.nulavel<>a.is_nullable OR e.identidade<>a.is_identity;

-- Q03: monetários DECIMAL(12,2); duas linhas, precisão 12/escala 2.
SELECT table_name,column_name,numeric_precision,numeric_scale FROM information_schema.columns
WHERE table_schema='public' AND ((table_name='categoria' AND column_name='preco_vigente') OR (table_name='inscricao' AND column_name='valor_contratado')) ORDER BY table_name;

-- Q04: catálogo das constraints nomeadas; zero divergências.
-- Restrições implícitas de nulabilidade não são contadas como CHECK nomeado.
WITH esperadas(tabela,nome,tipo) AS (VALUES
('evento','pk_evento','PRIMARY KEY'),
('evento','ck_evento_id','CHECK'),
('evento','ck_evento_nome','CHECK'),
('evento','ck_evento_sigla','CHECK'),
('edicao','pk_edicao','PRIMARY KEY'),
('edicao','ck_edicao_id','CHECK'),
('edicao','fk_edicao_evento','FOREIGN KEY'),
('edicao','ck_edicao_designacao','CHECK'),
('edicao','ck_edicao_realizacao','CHECK'),
('edicao','ck_edicao_janela','CHECK'),
('edicao','ck_edicao_modalidade','CHECK'),
('edicao','ck_edicao_local','CHECK'),
('participante','pk_participante','PRIMARY KEY'),
('participante','ck_participante_id','CHECK'),
('participante','uq_participante_cpf','UNIQUE'),
('participante','ck_participante_nome','CHECK'),
('participante','ck_participante_email','CHECK'),
('participante','ck_participante_cpf','CHECK'),
('categoria','pk_categoria','PRIMARY KEY'),
('categoria','ck_categoria_id','CHECK'),
('categoria','uq_categoria_nome','UNIQUE'),
('categoria','ck_categoria_nome','CHECK'),
('categoria','ck_categoria_descricao','CHECK'),
('categoria','ck_categoria_preco','CHECK'),
('inscricao','pk_inscricao','PRIMARY KEY'),
('inscricao','ck_inscricao_id','CHECK'),
('inscricao','fk_inscricao_participante','FOREIGN KEY'),
('inscricao','fk_inscricao_categoria','FOREIGN KEY'),
('inscricao','fk_inscricao_edicao','FOREIGN KEY'),
('inscricao','uq_inscricao_participante_edicao','UNIQUE'),
('inscricao','ck_inscricao_situacao','CHECK'),
('inscricao','ck_inscricao_valor','CHECK'),
('inscricao','ck_inscricao_canal','CHECK'))
SELECT e.*,a.table_name,a.constraint_name,a.constraint_type FROM esperadas e FULL OUTER JOIN
(SELECT * FROM information_schema.table_constraints WHERE table_schema='public' AND table_name IN ('evento','edicao','participante','categoria','inscricao')
AND (constraint_type IN ('PRIMARY KEY','UNIQUE','FOREIGN KEY') OR constraint_name LIKE 'ck_%')) a
ON e.tabela=a.table_name AND e.nome=a.constraint_name WHERE e.nome IS NULL OR a.constraint_name IS NULL OR e.tipo<>a.constraint_type;

-- Q05: componentes de PK/UNIQUE/FK, na ordem; conferir modelo_logico.md.
SELECT table_name,constraint_name,column_name,ordinal_position FROM information_schema.key_column_usage
WHERE table_schema='public' ORDER BY table_name,constraint_name,ordinal_position;

-- Q06: FKs e respectivos alvos/componentes; quatro linhas para quatro FKs.
SELECT k.table_name,k.constraint_name,k.column_name,k.ordinal_position,p.table_name AS tabela_alvo,p.column_name AS coluna_alvo
FROM information_schema.key_column_usage k JOIN information_schema.referential_constraints r
ON r.constraint_catalog=k.constraint_catalog AND r.constraint_schema=k.constraint_schema AND r.constraint_name=k.constraint_name
JOIN information_schema.key_column_usage p ON p.constraint_catalog=r.unique_constraint_catalog
AND p.constraint_schema=r.unique_constraint_schema AND p.constraint_name=r.unique_constraint_name
AND p.ordinal_position=k.position_in_unique_constraint
WHERE k.table_schema='public' ORDER BY k.constraint_name,k.ordinal_position;

-- Q07: predicados de CHECK nomeados; conferir contra o DDL, não somente sua existência.
SELECT constraint_name,check_clause FROM information_schema.check_constraints WHERE constraint_schema='public' AND constraint_name LIKE 'ck_%' ORDER BY constraint_name;

-- Q08: colunas opcionais; cinco linhas.
SELECT table_name,column_name FROM information_schema.columns WHERE table_schema='public'
AND table_name IN ('evento','edicao','participante','categoria','inscricao') AND is_nullable='YES' ORDER BY table_name,column_name;

-- Q09: cinco identidades e DEFAULT PENDENTE; seis linhas.
SELECT table_name,column_name,is_identity,identity_generation,column_default FROM information_schema.columns
WHERE table_schema='public' AND (is_identity='YES' OR (table_name='inscricao' AND column_name='situacao')) ORDER BY table_name,column_name;
