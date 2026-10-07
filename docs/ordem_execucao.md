# Ordem de execução

Base nova e vazia, PostgreSQL 17/pgAdmin 4, UTF-8. Preparação detalhada e comportamento esperado no [README](../README.md).

1. Criar a base no pgAdmin e abrir Query Tool como proprietário.
2. [Estrutura](../sql/01_estrutura.sql), inteiro uma vez.
3. [Checks estruturais](../sql/verificacoes_estrutura.sql), Q00–Q09 por consulta.
4. [Carga](../sql/02_carga.sql), inteiro uma vez.
5. [Contagens](../sql/contagens.sql) e [checks da carga](../sql/verificacoes_populacao.sql), P00–P05.
6. [Verificações](../sql/04_verificacoes.sql), V01–V06, e [diagnósticos](../sql/diagnosticos.sql), DG01–DG04.
7. Conferir/criar os logins eventos_operacao/eventos_consulta com privilégios mínimos pelo pgAdmin; executar [acessos](../sql/acessos.sql) como proprietário.
8. [Relatórios](../sql/relatorios_nucleo.sql), R01–R05.
9. [Casos válidos](../testes/casos_validos.sql), TV01–TV09, e [inválidos](../testes/casos_invalidos.sql), TI01–TI20, individualmente.
10. [Acessos](../testes/acessos.sql), PA01–PA05, nos logins indicados; [concorrência](../testes/concorrencia.sql), TC01–TC02, com duas sessões.
11. [Metadados](../sql/05_metadados.sql), M00–M10 por consulta como proprietário.
12. Conferir contagens/diagnósticos finais e ausência das fixtures 20001/20002; Categoria 1 = 120 e Inscrição 2 = PENDENTE.

Após erro de teste, ROLLBACK separado antes da pós-consulta; após 40001, repetir a transação inteira. As [operações controladas](../sql/operacoes_controladas.sql) são atos administrativos independentes com COMMIT, não uma sequência para executar inteira. Testes válidos usam ROLLBACK.
