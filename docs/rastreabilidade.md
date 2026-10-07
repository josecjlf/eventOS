# Rastreabilidade

A matriz relaciona dez RF selecionados e RE1 às 14 RN, entidades, tabelas, mecanismos e casos de teste. A fonte conceitual é o [MER](../modelos/mer_especificacao.md). Reprodução: [README](../README.md). O [relatório de testes](../testes/relatorio_testes.md) apresenta os resultados e sua avaliação.

| RF/RE | RN | Entidade/relação / tabela | Mecanismo | Scripts reais | Teste/evidência |
| --- | --- | --- | --- | --- | --- |
| RF1, RF5, RF28 | RN01 | edicao.id_evento; inscricao.id_edicao/id_categoria/id_participante | PK, FK, NOT NULL | `sql/01_estrutura.sql` | TI01, TI04, TI06, TI19, TV01 |
| RF3, RF30, RF28 | RN02 | participante | PK, UNIQUE, CHECK, NOT NULL | `sql/01_estrutura.sql` | TI02, TI03, TI05, TV02 |
| RF5, RF6, RF28 | RN03 | categoria.id_categoria/nome; inscricao.id_categoria/id_edicao | FKs simples independentes, UNIQUE(nome) global, NOT NULL | `sql/01_estrutura.sql` | TI06, TI07, TI19, TI20, TV01 |
| RF1, RF6, RF28 | RN04 | edicao; inscricao.data_inscricao | CHECK de linha; operação controlada; diagnóstico | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql`, `sql/diagnosticos.sql` | TI08, TI09, TI10, TI11, TV03, OC01, TV07, DG01 |
| RF6, RF27, RF28 | RN05 | categoria.preco_vigente; inscricao.valor_contratado/situacao | Operação controlada em transação; DEFAULT | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql` | TV04, OC01 |
| RF6, RF13, RF27, RF28 | RN06 | categoria.preco_vigente; inscricao.valor_contratado | CHECK, NOT NULL; operação controlada para reconhecimento | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql` | TI12, TI13, TV04, TV05 |
| RF3, RF9, RF28 | RN07 | inscricao(id_participante,id_edicao) | UNIQUE participante/edição, FKs simples, NOT NULL | `sql/01_estrutura.sql` | TI14, TV01, TC01 |
| RF9, RF13, RF28 | RN09 | inscricao.situacao | CHECK, NOT NULL, DEFAULT; operação controlada | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql` | TI15, TV05, TV06, OC02, OC03, TC02 |
| RF9, RF27, RF28 | RN12 | inscricao | UNIQUE; operação controlada; privilégios sem DELETE | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql`, `sql/acessos.sql` | TI14, TV06, PA03 |
| RF27, RF28 | RN14 | inscricao; categoria.preco_vigente; edicao.abertura_inscricoes/fechamento_inscricoes | Privilégios por coluna; FK; operação controlada; diagnóstico parcial | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql`, `sql/acessos.sql` | TV04, TV08, PA02, PA03, OC04, OC05, DG01 |
| RF26 | RN15 | Cinco tabelas; views gerenciais | Consultas SQL e views agregadas | `sql/01_estrutura.sql`, `sql/relatorios_nucleo.sql` | R01, R02, R03, R04, R05, TV09 |
| RE1, RF26, RF28 | RN16 | inscricao.canal_divulgacao | CHECK | `sql/01_estrutura.sql`, `sql/relatorios_nucleo.sql` | TI16, R04, P03 |
| RF30 | RN17 | Cinco tabelas e views; perfis eventos_operacao/eventos_consulta | GRANT/REVOKE; restrição de colunas; protocolo manual | `sql/acessos.sql`, `testes/acessos.sql` | PA01, PA02, PA03, PA04 |
| RF28 | RN18 | Esquema vigente | Combinação de PK/FK/UNIQUE/NOT NULL/CHECK/operação/diagnóstico | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql`, `sql/diagnosticos.sql`, `sql/verificacoes_estrutura.sql` | Q00–Q09, P00–P05, TI01–TI20, TV01–TV09 |

Todas as RN estão vinculadas a requisitos e mecanismos. As exclusões justificadas constam no [escopo](escopo_requisitos.md); os IDs de testes correspondem aos scripts do pacote.

## Evidência de definições — metadados

[sql/05_metadados.sql](../sql/05_metadados.sql) consulta INFORMATION_SCHEMA. M00 registra base/esquema/usuário; M01/M02/M03 conferem tabelas, colunas e nulabilidade; M05/M06, PK/UNIQUE; M07, as quatro FKs simples; M08, os 21 CHECKs; M10, as views.

M00–M09 documentam cinco tabelas, 28 colunas, 23 obrigatórias/cinco opcionais e 5 PK/3 UNIQUE/4 FK/21 CHECK. A [conferência dos metadados](../evidencias/metadados/resultados.md) compara os CSVs com o DDL.

Metadados não substituem TI/TV/PA/TC ou as contagens da população. O alcance das evidências está no [relatório de testes](../testes/relatorio_testes.md). O [inventário de índices](indices.md) descreve as estruturas decorrentes das constraints, sem medição de desempenho.
