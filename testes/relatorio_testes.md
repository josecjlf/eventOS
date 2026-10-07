# Resultados dos testes

Os testes verificam a estrutura, os dados, as regras de integridade e as operações do banco EventOS. P1 confirmou em 07/10/2026 a execução com sucesso do conjunto solicitado. Essa data identifica a confirmação, não o horário das consultas.

| Grupo | Script | Resultado disponível |
| --- | --- | --- |
| Estrutura — Q00–Q09 | [verificacoes_estrutura.sql](../sql/verificacoes_estrutura.sql) | Q03/Q07/Q08/Q09 possuem exportações em [estrutura](../evidencias/estrutura/). Demais resultados confirmados por P1, sem exportações individuais. |
| População — P00–P05 | [verificacoes_populacao.sql](../sql/verificacoes_populacao.sql) | Distribuições P02/P03/P04 em [populacao](../evidencias/populacao/). Contagens e P01/P05 confirmados por P1, sem exportações individuais. |
| Consistência — V01–V06 | [04_verificacoes.sql](../sql/04_verificacoes.sql) | V01–V04 registram zero linhas; V05 exporta seis contratos; V06 registra os valores agregados. Arquivos em [verificacoes](../evidencias/verificacoes/). |
| Diagnósticos — DG01–DG04 | [diagnosticos.sql](../sql/diagnosticos.sql) | Registros de zero linhas em [diagnosticos](../evidencias/diagnosticos/). Consultas detectam inconsistências, sem impedir gravações. |
| Relatórios — R01–R05 | [relatorios_nucleo.sql](../sql/relatorios_nucleo.sql) | R03/R04/R05 exportados em [relatorios](../evidencias/relatorios/); R01/R02 com execução confirmada por P1, sem novas grades individuais. |
| Casos válidos — TV01–TV09 | [casos_validos.sql](casos_validos.sql) | Resultados TV02/TV05/TV06/TV09 em [validos](../evidencias/testes/validos/). Outros casos confirmados por P1, sem capturas individuais. |
| Casos inválidos — TI01–TI20 | [casos_invalidos.sql](casos_invalidos.sql) | Erros e pós-condições de TI01–TI05/TI08–TI11/TI17 em [invalidos](../evidencias/testes/invalidos/). Outros casos confirmados por P1; mensagens individuais não fornecidas. |
| Acessos — PA01–PA05 | [acessos.sql](acessos.sql) | Contas e atos de PA01–PA04 em [acessos](../evidencias/testes/acessos/). PA05 confirmado por P1, sem captura individual. |
| Concorrência — TC01–TC02 | [concorrencia.sql](concorrencia.sql) | TC02 registra espera, erro 40001, repetição e limpeza em [concorrencia](../evidencias/testes/concorrencia/). TC01 confirmado por P1, sem exportação individual. |
| Metadados — M00–M10 | [05_metadados.sql](../sql/05_metadados.sql) | M00–M09 comparados ao DDL sem divergências; [resultados e arquivos](../evidencias/metadados/resultados.md). M10 registra uma lista anterior de views, sem comprovar suas definições. |

M00 identifica `new_mer_02_10/public/postgres`. M00–M09 confirmam cinco tabelas, 28 colunas, 23 obrigatórias/cinco opcionais, cinco identidades BY DEFAULT e 33 constraints nomeadas: 5 PK, 3 UNIQUE, 4 FK e 21 CHECK. Os tipos, tamanhos, componentes e referências correspondem ao DDL.

[V05](../evidencias/verificacoes/v05.csv) contém inscrições 1/2501/5001/7501/10001/12000: cinco contratos de 100.00 e um de 120.00, com preço vigente 120.00. As quantidades da carga são expectativas descritas em [populacao.md](../docs/populacao.md), não valores de uma exportação de contagem disponível.

Alguns registros foram produzidos anteriormente e correspondem a mecanismos e dados que permanecem inalterados. P1 confirmou a execução do roteiro; os anexos comprovam os resultados e contextos que registram. Ausência de exportação individual não foi preenchida com valores esperados. Contextos e horários não registrados permanecem ausentes.

CHECKs impedem violações da própria linha. Regras de janela, cópia inicial do preço e transição de situação dependem do protocolo transacional; diagnósticos apenas detectam inconsistências. O proprietário pode contornar o protocolo. Os resultados dos metadados não comprovam, por si sós, a população, os privilégios ou o comportamento concorrente.
