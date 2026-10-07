# Resultados dos metadados

Resultados de [sql/05_metadados.sql](../../sql/05_metadados.sql), obtidos via INFORMATION_SCHEMA. Os arquivos M00–M09 foram comparados ao DDL, sem divergências. A conferência foi registrada em 07/10/2026; horários de execução não constam nas exportações.

| Bloco | Arquivo recebido | Linhas de dados | Resultado efetivamente encontrado | Conferência |
| --- | --- | --- | --- | --- |
| M00 | [m00.csv](m00.csv) | 1 | Base new_mer_02_10, esquema public, usuário postgres. | Conforme ao contexto informado por P1. |
| M01 | [m01.csv](m01.csv) | 5 | categoria, edicao, evento, inscricao e participante; todas BASE TABLE, na base indicada. | Conforme ao modelo atual. |
| M02 | [m02.csv](m02.csv) | 28 | Nomes, posições, tipos, tamanhos, precisão/escala, nulabilidade, cinco identidades BY DEFAULT e DEFAULT PENDENTE. | Conforme ao DDL, coluna por coluna. |
| M03 | [m03.csv](m03.csv) | 5 | 28 colunas ao todo: 23 obrigatórias e cinco opcionais. Categoria tem quatro colunas, três obrigatórias. | Conforme a M02 e ao DDL. |
| M04 | [m04.csv](m04.csv) | 33 | 21 CHECKs, quatro FKs, cinco PKs e três UNIQUEs nomeados; todos não adiáveis. | Nomes, tabelas, tipos e modos conferidos. |
| M05 | [m05.csv](m05.csv) | 5 | Uma PK por tabela, na respectiva coluna identificadora. | Conforme ao DDL. |
| M06 | [m06.csv](m06.csv) | 4 | UNIQUE de nome global de Categoria, par participante/edição e CPF de Participante. | Três constraints, quatro componentes, na ordem correta. |
| M07 | [m07.csv](m07.csv) | 4 | Edição→Evento; Inscrição→Categoria/ Edição/Participante. Referências simples e NO ACTION nas duas ações. | Origens, destinos, posições e chaves de destino conferidos. |
| M08 | [m08.csv](m08.csv) | 21 | Predicados dos 21 CHECKs nomeados. | Nomes e significado conferidos; sem ausências, extras ou diferenças semânticas. |
| M09 | [m09.csv](m09.csv) | 4 | CHECK 21; FOREIGN KEY 4; PRIMARY KEY 5; UNIQUE 3. | Conforme a M04 e ao DDL. |

M00 registra `new_mer_02_10/public/postgres`. M02/M03 demonstram os tipos e a nulabilidade. M04–M09 demonstram as constraints e seus componentes. Categoria é global; Inscrição possui referências separadas para Categoria e Edição.

M10 contém somente uma lista anterior de nomes de views; não comprova os corpos das consultas. A visibilidade de INFORMATION_SCHEMA depende dos privilégios da conta. Casts e representações internas exportados pelo servidor descrevem as expressões; não constituem comandos dos scripts.

[Exploração dos metadados](../../docs/metadados_resumo.md) e [alcance dos testes](../../testes/relatorio_testes.md).
