# Evidências

| Pasta | Conteúdo | Script relacionado |
| --- | --- | --- |
| ambiente/ | Versões de PostgreSQL e pgAdmin | Ambiente de execução |
| estrutura/ | Colunas, constraints e identidades | [verificacoes_estrutura.sql](../sql/verificacoes_estrutura.sql) |
| populacao/ | Distribuições de situação, canal e cadastro | [verificacoes_populacao.sql](../sql/verificacoes_populacao.sql) |
| metadados/ | Exportações M00–M10 e [resultados](metadados/resultados.md) | [05_metadados.sql](../sql/05_metadados.sql) |
| verificacoes/ | Consistência dos dados e contratos | [04_verificacoes.sql](../sql/04_verificacoes.sql) |
| diagnosticos/ | Consultas de detecção de incoerências | [diagnosticos.sql](../sql/diagnosticos.sql) |
| relatorios/ | Resultados das consultas gerenciais | [relatorios_nucleo.sql](../sql/relatorios_nucleo.sql) |
| testes/validos/ | Casos permitidos e pós-condições | [casos_validos.sql](../testes/casos_validos.sql) |
| testes/invalidos/ | Erros esperados e pós-condições | [casos_invalidos.sql](../testes/casos_invalidos.sql) |
| testes/acessos/ | Permissões e identificação das contas | [acessos.sql](../testes/acessos.sql) |
| testes/concorrencia/ | Sessões, conflitos e limpeza | [concorrencia.sql](../testes/concorrencia.sql) |

Os nomes identificam o bloco do script. CSVs contêm resultados tabulares; logs e alguns Markdown contêm mensagens; Markdown com “0 linhas” registram resultados vazios. Sufixos distinguem etapas de um mesmo caso, como pós-condição, reversão ou repetição.

O [resumo dos testes](../testes/relatorio_testes.md) apresenta resultados e alcance das evidências. A consulta de contagem está em [sql/contagens.sql](../sql/contagens.sql).
