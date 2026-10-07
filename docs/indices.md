# Índices e escolhas físicas

Inventário declarativo do [DDL](../sql/01_estrutura.sql): **oito estruturas únicas previstas**, cinco PK e três UNIQUE. O esquema não possui CREATE INDEX adicional. Este inventário descreve as constraints que originam índices; não constitui consulta de índices físicos independentes ou benchmark.

| Constraint | Tabela | Colunas | Motivo |
| --- | --- | --- | --- |
| pk_evento | evento | id_evento | Identificador RF1/RN01 |
| pk_edicao | edicao | id_edicao | Identificador RF1/RN01 |
| pk_participante | participante | id_participante | Identificador RF3/RN02 |
| pk_categoria | categoria | id_categoria | Catálogo global RF5/RN03 |
| pk_inscricao | inscricao | id_inscricao | Identificador RF9/RN07 |
| uq_participante_cpf | participante | cpf | Exclusivo quando informado RN02 |
| uq_categoria_nome | categoria | nome | Nome global distinto RN03 |
| uq_inscricao_participante_edicao | inscricao | id_participante,id_edicao | Uma inscrição por pessoa/edição RN07/RN12 |

PK/UNIQUE originam índices únicos no PostgreSQL. FK/CHECK/NOT NULL não implicam índice adicional na filha. Um índice isolado em inscricao(id_participante) duplicaria o prefixo já coberto pela UNIQUE participante/edição.

A integridade é atendida pelas constraints, sem SLA ou gargalo medido que justifique índices adicionais. Candidatos edicao(id_evento), inscricao(id_edicao) e inscricao(id_categoria) podem apoiar RF26/R01/R02; seu benefício depende de avaliação posterior com uso real. Categoria não possui id_edicao. Não há EXPLAIN ANALYZE ou benchmark.

M05/M06 consultam PK/UNIQUE nos [metadados](metadados_resumo.md). INFORMATION_SCHEMA identifica as constraints de origem, sem inventário físico de índices independentes. A avaliação dos resultados está no [relatório de testes](../testes/relatorio_testes.md).
