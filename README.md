# MATA60 — EventOS | Marco 1 | Grupo 4

Banco de dados para administrar eventos, edições, participantes, categorias e inscrições. A inscrição liga diretamente participante, edição e categoria. Categoria tem preço vigente comum às edições; cada inscrição preserva seu valor contratado. A extensão opcional registra o canal de divulgação.

## Conteúdo

- `modelos/`: [especificação textual do MER em Peter Chen](modelos/mer_especificacao.md) e [modelo lógico](modelos/modelo_logico.md).
- `sql/`: DDL, carga, verificações, operações controladas, acessos, relatórios e metadados.
- `testes/`: casos válidos, inválidos, acessos, concorrência e [resultados](testes/relatorio_testes.md).
- `evidencias/`: resultados e exportações organizados por finalidade. [Índice](evidencias/README.md).
- `docs/`: escopo, regras, dicionário, dependências, rastreabilidade e explicações técnicas.

Os resultados e os limites de comprovação estão no [relatório de testes](testes/relatorio_testes.md).

## Preparação e reprodução

Requisitos: PostgreSQL 17 e pgAdmin 4. A execução utiliza os scripts SQL deste pacote, sem linguagens externas de conexão.

1. Pelo pgAdmin, criar uma base **nova e vazia**, UTF-8, por exemplo `eventos_entrega`. Abrir Query Tool dessa base como proprietário, com Auto-commit habilitado. Não aplicar o DDL sobre tabelas existentes.
2. Executar [sql/01_estrutura.sql](sql/01_estrutura.sql) inteiro, uma vez: COMMIT sem erro; cinco tabelas.
3. Executar [sql/verificacoes_estrutura.sql](sql/verificacoes_estrutura.sql), Q00–Q09, por consulta. Q01/Q02/Q04: zero linhas. Esperado: 28 colunas, 23 obrigatórias/cinco opcionais, cinco identidades e 33 constraints nomeadas: 5 PK, 3 UNIQUE, 4 FK e 21 CHECK.
4. Executar [sql/02_carga.sql](sql/02_carga.sql) inteiro, uma vez. Depois executar [contagens](sql/contagens.sql) e [sql/verificacoes_populacao.sql](sql/verificacoes_populacao.sql), P00–P05. Esperado: Evento 500, Edição 5000, Categoria 2, Participante 6000, Inscrição 12000; total 23502. P01: zero linhas. Edição/Participante/Inscrição cumprem o mínimo de 5000.
5. Executar [sql/04_verificacoes.sql](sql/04_verificacoes.sql), V01–V06, e [sql/diagnosticos.sql](sql/diagnosticos.sql), DG01–DG04. V01–V04 e DG01–DG04: zero linhas. V05: seis contratos representativos, cinco de 100 e um de 120, com preço vigente 120. Diagnóstico detecta; não impede gravação.
6. Antes dos acessos, conferir/criar no pgAdmin os Login/Group Roles `eventos_operacao` e `eventos_consulta`: login habilitado, senhas locais; sem Superuser/Create databases/Create roles/Replication ou filiação privilegiada. Se necessário, permitir CONNECT na base e USAGE em `public` pela interface. Não conceder CREATE no schema nem privilégios gerais. Senhas não fazem parte do pacote.
7. Como proprietário, executar [sql/acessos.sql](sql/acessos.sql) inteiro: cria quatro views e concede privilégios por objeto/coluna. Executar [sql/relatorios_nucleo.sql](sql/relatorios_nucleo.sql), R01–R05. R01: 5000 edições; R02: duas categorias; bruto previsto 500120.00.
8. Executar [testes/casos_validos.sql](testes/casos_validos.sql), TV01–TV09, **um caso de cada vez**, na ordem interna: transação → alterações → consultas → ROLLBACK → consultas de pós-condição. Salvar resultados antes do ROLLBACK quando indicado.
9. Executar [testes/casos_invalidos.sql](testes/casos_invalidos.sql), TI01–TI20, **isoladamente**. Executar START TRANSACTION + comando inválido; registrar o erro real. Executar **ROLLBACK separado**, depois o SELECT de pós-condição. As expectativas e constraints estão nos comentários. Não executar o arquivo inteiro em uma seleção.
10. Executar [testes/acessos.sql](testes/acessos.sql), PA01–PA05, autenticado no perfil indicado: consulta em PA01/PA04; operação em PA02/PA03/PA05. Abrir conexões com esses logins; renomear a aba não muda o usuário. Após erro, ROLLBACK separado.
11. Executar [testes/concorrencia.sql](testes/concorrencia.sql), TC01–TC02, alternando **duas sessões independentes** A/B conforme os comentários; executar limpeza. Após erro 40001, repetir a transação inteira indicada.
12. Executar [sql/05_metadados.sql](sql/05_metadados.sql), M00–M10, consulta por consulta como proprietário. M10 depende das views. As exportações existentes M00–M09 mostram 5 tabelas, 28 colunas e 33 constraints; [conferência](evidencias/metadados/resultados.md).
13. Conferir novamente contagens, situações, canais e diagnósticos. Nenhuma inscrição de teste 20001/20002 deve permanecer; Categoria 1 deve ter preço 120 e Inscrição 2 deve estar PENDENTE. Situações previstas: PAGA 4001, PENDENTE 4000, CANCELADA 3999.

[sql/operacoes_controladas.sql](sql/operacoes_controladas.sql) contém atos administrativos independentes com parâmetros de demonstração e COMMIT. **Não executar todos os blocos juntos como teste**: os testes válidos já demonstram os atos com reversão. CHECKs não consultam outras tabelas; janela, cópia inicial do preço e transições dependem do protocolo.

A [ordem resumida](docs/ordem_execucao.md) relaciona os scripts e os perfis necessários à reprodução. As consultas e os testes são identificados por bloco; seus resultados estão no [relatório de testes](testes/relatorio_testes.md).
