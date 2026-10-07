# População de referência — catálogo geral

A carga [sql/02_carga.sql](../sql/02_carga.sql) é determinística: INSERT VALUES/SELECT, CTE de dígitos e produto cartesiano, sem conexão por linguagem externa. As contagens abaixo são **expectativas calculadas a partir do SQL**. A reprodução segue o [README](../README.md); os resultados são avaliados no [relatório de testes](../testes/relatorio_testes.md).

| Tabela | Esperado | IDs | Próximo automático |
| --- | --- | --- | --- |
| evento | 500 | 1–500 | 501 |
| edicao | 5000 | 1–5000 | 5001 |
| categoria | 2 | 1–2 | 3 |
| participante | 6000 | 1–6000 | 6001 |
| inscricao | 12000 | 1–12000 | 12001 |

Total esperado: **23502**. Edição, Participante e Inscrição atingem na carga prevista o mínimo de três tabelas com 5000 registros. Cada evento tem dez edições, 2022–2031; as inscrições usam edições 1–2500. Edições 2501–5000 sem inscrições são um cenário válido, pois participação mínima é zero.

## Cenários da carga

O catálogo global contém Estudante (1) e Geral (2). As inscrições selecionam essas categorias independentemente da edição. A carga combina participantes reutilizados entre edições, modalidades, datas, contratos, situações e canais para demonstrar o recorte gerencial.

Preço inicial Estudante 100, Geral 150; depois Estudante reajustado globalmente para 120. Há 6000 contratos antigos Estudante de 100 e uma nova inscrição 12000 de 120. P05/V05 exibem apenas a amostra 1/2501/5001/7501/10001/12000; não representam todos os contratos da categoria. Diferença entre preço vigente e contrato antigo não é erro.

Estados esperados: PAGA 4001, PENDENTE 4000, CANCELADA 3999; recebimento bruto esperado **500120.00**. Canais: SITE_EVENTO/REDE_SOCIAL/EMAIL/OUTRO 2000 cada, INDICACAO 2001, NULL 1999. Há 1200 participantes sem CPF; participantes 1/2 são homônimos com contato compartilhado e CPFs diferentes.

Fixtures: inscrição 1 PAGA/100, 2 PENDENTE/150, 3 CANCELADA/100, 5 PENDENTE/100, 12000 PAGA/120. Participante 6000 não está inscrito na edição 2; 5999 não está nas edições 1/3. Reservar IDs temporários 20001/20002 e reverter testes. Local/CPF/datas mantêm os domínios originais. Nenhum dado pessoal real.

## Conferência

[Checks P00–P05](../sql/verificacoes_populacao.sql), [contagens](../sql/contagens.sql), [verificações](../sql/04_verificacoes.sql) e [README](../README.md) orientam a reprodução. Se a carga falhar, executar ROLLBACK antes de investigar; reinícios de identidade usam ALTER TABLE padronizado, sem funções de sequência.
