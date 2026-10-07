-- EventOS: exploração do esquema vigente para o Marco 1.
-- Executar M00-M10 separadamente, como proprietário, na nova base escolhida.
-- Consultas de leitura: não criam objetos, índices nem alteram a população.
-- M00-M09 dependem de 01_estrutura.sql; M10 também depende de acessos.sql.
-- Resultados de referência em evidencias/metadados/.

-- M00: contexto da conexão; uma linha para public na base escolhida.
SELECT catalog_name AS banco,
       schema_name AS esquema,
       CURRENT_USER AS usuario
FROM information_schema.schemata
WHERE schema_name = 'public';

-- M01: tabelas do domínio; cinco BASE TABLE, sem misturar views.
SELECT table_catalog,
       table_schema,
       table_name,
       table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

-- M02: 28 colunas; tipos, limites, precisão/escala, nulabilidade e identidade.
-- VARCHAR aparece como character varying; DECIMAL aparece como numeric.
SELECT c.table_name,
       c.ordinal_position,
       c.column_name,
       c.data_type,
       c.character_maximum_length,
       c.numeric_precision,
       c.numeric_precision_radix,
       c.numeric_scale,
       c.is_nullable,
       c.column_default,
       c.is_identity,
       c.identity_generation
FROM information_schema.columns c
JOIN information_schema.tables t
  ON t.table_catalog = c.table_catalog
 AND t.table_schema = c.table_schema
 AND t.table_name = c.table_name
WHERE t.table_schema = 'public'
  AND t.table_type = 'BASE TABLE'
ORDER BY c.table_name, c.ordinal_position;

-- M03: nulabilidade por tabela; cinco linhas, 23 obrigatórias e cinco opcionais.
SELECT c.table_name,
       COUNT(*) AS total_colunas,
       SUM(CASE WHEN c.is_nullable = 'NO' THEN 1 ELSE 0 END) AS obrigatorias,
       SUM(CASE WHEN c.is_nullable = 'YES' THEN 1 ELSE 0 END) AS opcionais
FROM information_schema.columns c
JOIN information_schema.tables t
  ON t.table_catalog = c.table_catalog
 AND t.table_schema = c.table_schema
 AND t.table_name = c.table_name
WHERE t.table_schema = 'public'
  AND t.table_type = 'BASE TABLE'
GROUP BY c.table_name
ORDER BY c.table_name;

-- M04: 33 constraints nomeadas do DDL, com tipo e modo de verificação.
-- NOT NULL é conferido em M02/M03; excluir CHECKs implícitos de nulabilidade.
SELECT tc.table_name,
       tc.constraint_name,
       tc.constraint_type,
       tc.is_deferrable,
       tc.initially_deferred
FROM information_schema.table_constraints tc
JOIN information_schema.tables t
  ON t.table_catalog = tc.table_catalog
 AND t.table_schema = tc.table_schema
 AND t.table_name = tc.table_name
WHERE t.table_schema = 'public'
  AND t.table_type = 'BASE TABLE'
  AND (tc.constraint_type IN ('PRIMARY KEY', 'UNIQUE', 'FOREIGN KEY')
       OR (tc.constraint_type = 'CHECK' AND tc.constraint_name LIKE 'ck_%'))
ORDER BY tc.table_name, tc.constraint_type, tc.constraint_name;

-- M05: PK e respectivas colunas; cinco linhas, uma por identificador físico.
SELECT tc.table_name,
       tc.constraint_name,
       k.column_name,
       k.ordinal_position
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage k
  ON k.constraint_catalog = tc.constraint_catalog
 AND k.constraint_schema = tc.constraint_schema
 AND k.constraint_name = tc.constraint_name
 AND k.table_catalog = tc.table_catalog
 AND k.table_schema = tc.table_schema
 AND k.table_name = tc.table_name
WHERE tc.table_schema = 'public'
  AND tc.constraint_type = 'PRIMARY KEY'
ORDER BY tc.table_name, tc.constraint_name, k.ordinal_position;

-- M06: três UNIQUE em quatro componentes; preservar a ordem das chaves compostas.
SELECT tc.table_name,
       tc.constraint_name,
       k.column_name,
       k.ordinal_position
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage k
  ON k.constraint_catalog = tc.constraint_catalog
 AND k.constraint_schema = tc.constraint_schema
 AND k.constraint_name = tc.constraint_name
 AND k.table_catalog = tc.table_catalog
 AND k.table_schema = tc.table_schema
 AND k.table_name = tc.table_name
WHERE tc.table_schema = 'public'
  AND tc.constraint_type = 'UNIQUE'
ORDER BY tc.table_name, tc.constraint_name, k.ordinal_position;

-- M07: quatro FKs em quatro componentes, com coluna e chave de destino.
-- A posição na PK de destino conserva o pareamento das referências.
SELECT tc.table_name AS tabela_origem,
       tc.constraint_name,
       k.column_name AS coluna_origem,
       k.ordinal_position AS ordem_origem,
       p.table_schema AS esquema_destino,
       p.table_name AS tabela_destino,
       p.column_name AS coluna_destino,
       p.ordinal_position AS ordem_destino,
       r.unique_constraint_name AS chave_destino,
       r.match_option,
       r.update_rule,
       r.delete_rule
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage k
  ON k.constraint_catalog = tc.constraint_catalog
 AND k.constraint_schema = tc.constraint_schema
 AND k.constraint_name = tc.constraint_name
 AND k.table_catalog = tc.table_catalog
 AND k.table_schema = tc.table_schema
 AND k.table_name = tc.table_name
JOIN information_schema.referential_constraints r
  ON r.constraint_catalog = tc.constraint_catalog
 AND r.constraint_schema = tc.constraint_schema
 AND r.constraint_name = tc.constraint_name
JOIN information_schema.key_column_usage p
  ON p.constraint_catalog = r.unique_constraint_catalog
 AND p.constraint_schema = r.unique_constraint_schema
 AND p.constraint_name = r.unique_constraint_name
 AND p.ordinal_position = k.position_in_unique_constraint
WHERE tc.table_schema = 'public'
  AND tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name, tc.constraint_name, k.ordinal_position;

-- M08: 21 CHECKs nomeados e seus predicados; comparar o sentido com o DDL.
SELECT tc.table_name,
       tc.constraint_name,
       cc.check_clause
FROM information_schema.table_constraints tc
JOIN information_schema.check_constraints cc
  ON cc.constraint_catalog = tc.constraint_catalog
 AND cc.constraint_schema = tc.constraint_schema
 AND cc.constraint_name = tc.constraint_name
WHERE tc.table_schema = 'public'
  AND tc.constraint_type = 'CHECK'
  AND tc.constraint_name LIKE 'ck_%'
ORDER BY tc.table_name, tc.constraint_name;

-- M09: resumo das constraints nomeadas; quatro linhas: CHECK 21/FK 4/PK 5/UNIQUE 3.
SELECT tc.constraint_type,
       COUNT(*) AS quantidade
FROM information_schema.table_constraints tc
JOIN information_schema.tables t
  ON t.table_catalog = tc.table_catalog
 AND t.table_schema = tc.table_schema
 AND t.table_name = tc.table_name
WHERE t.table_schema = 'public'
  AND t.table_type = 'BASE TABLE'
  AND (tc.constraint_type IN ('PRIMARY KEY', 'UNIQUE', 'FOREIGN KEY')
       OR (tc.constraint_type = 'CHECK' AND tc.constraint_name LIKE 'ck_%'))
GROUP BY tc.constraint_type
ORDER BY tc.constraint_type;

-- M10: quatro views comuns definidas em acessos.sql; não são novas entidades.
SELECT table_catalog,
       table_schema,
       table_name,
       table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'VIEW'
ORDER BY table_name;
