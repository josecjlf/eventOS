# Metadados — modelo com Inscrição central

[sql/05_metadados.sql](../sql/05_metadados.sql) mantém M00–M10 em INFORMATION_SCHEMA. Usar proprietário: a visibilidade de constraints depende dos privilégios. Consultas não operam dados, não criam índices e não substituem testes negativos.

| Bloco | Conteúdo | Resultado esperado na implantação atual |
| --- | --- | --- |
| M00 | Base/schema/usuário | 1 linha de contexto da base consultada |
| M01 | Tabelas | 5 BASE TABLE |
| M02 | Colunas/tipos/tamanhos/identidade | 28 linhas; cinco BY DEFAULT |
| M03 | Nulabilidade | 5 linhas, 23 obrigatórias/5 opcionais |
| M04 | Constraints nomeadas | 33 linhas |
| M05 | PK | 5 componentes |
| M06 | UNIQUE | 4 componentes, 3 constraints |
| M07 | FK e alvo | 4 componentes, 4 FKs simples |
| M08 | CHECKs nomeados | 21 linhas |
| M09 | Resumo | PK 5, UNIQUE 3, FK 4, CHECK 21 |
| M10 | Views comuns | 4 views após acessos.sql |

| Relação | Colunas | Obrigatórias | Opcionais |
| --- | --- | --- | --- |
| evento | 3 | 2 | sigla |
| edicao | 9 | 8 | local_realizacao |
| participante | 4 | 3 | cpf |
| categoria | 4 | 3 | descricao |
| inscricao | 8 | 7 | canal_divulgacao |

M07 deve mostrar edicao.id_evento→evento.id_evento e inscricao.id_participante→participante.id_participante, inscricao.id_categoria→categoria.id_categoria, inscricao.id_edicao→edicao.id_edicao. Ações NO ACTION. Não há FK de Categoria para Edição. M06 contém CPF, nome global de categoria e par participante/edição. M08 permite comparar os nomes e o significado dos 21 CHECKs com o DDL.

VARCHAR aparece como character varying e DECIMAL como numeric; limites/precisão são colunas próprias. A coluna de local é fisicamente opcional, mas CHECK exige local na modalidade presencial/híbrida. O valor contratado é separado do preço vigente; metadados não provam sua cópia/preservação, demonstrada em TV04/PA02.

**Arquivos de metadados disponíveis:** [m00.csv](../evidencias/metadados/m00.csv), [m01.csv](../evidencias/metadados/m01.csv), [m02.csv](../evidencias/metadados/m02.csv), [m03.csv](../evidencias/metadados/m03.csv), [m04.csv](../evidencias/metadados/m04.csv), [m05.csv](../evidencias/metadados/m05.csv), [m06.csv](../evidencias/metadados/m06.csv), [m07.csv](../evidencias/metadados/m07.csv), [m08.csv](../evidencias/metadados/m08.csv) e [m09.csv](../evidencias/metadados/m09.csv) compõem as capturas disponíveis.

M00 identifica new_mer_02_10/public/postgres. M02/M03 confirmam 28 colunas, 23 obrigatórias e cinco opcionais; M04/M09 confirmam 33 constraints nomeadas. M05/M06/M07 conferem os componentes das chaves e ações NO ACTION; M08 preserva o significado dos 21 CHECKs. O [registro de conferência](../evidencias/metadados/resultados.md) apresenta a comparação por bloco.

Metadados descrevem as definições do esquema; não substituem resultados de testes comportamentais ou contagens da população. A comparação entre os grupos consta no [relatório de testes](../testes/relatorio_testes.md).

[Índices](indices.md): oito estruturas decorrentes de PK/UNIQUE, sem índices adicionais. Reprodução: [README](../README.md).
