-- Executar P00–P05 individualmente após a carga oficial, antes dos testes.
-- P00: quantidades e requisito de pelo menos três tabelas com 5000 linhas.
SELECT 'evento' AS tabela, COUNT(*) AS quantidade FROM evento
UNION ALL
SELECT 'edicao' AS tabela, COUNT(*) AS quantidade FROM edicao
UNION ALL
SELECT 'participante' AS tabela, COUNT(*) AS quantidade FROM participante
UNION ALL
SELECT 'categoria' AS tabela, COUNT(*) AS quantidade FROM categoria
UNION ALL
SELECT 'inscricao' AS tabela, COUNT(*) AS quantidade FROM inscricao
ORDER BY tabela;
-- P01: diferença versus carga determinística. Zero linhas.
SELECT tabela,obtido,esperado FROM (
SELECT 'evento' AS tabela,COUNT(*) AS obtido,500 AS esperado FROM evento
UNION ALL
SELECT 'edicao' AS tabela,COUNT(*) AS obtido,5000 AS esperado FROM edicao
UNION ALL
SELECT 'participante' AS tabela,COUNT(*) AS obtido,6000 AS esperado FROM participante
UNION ALL
SELECT 'categoria' AS tabela,COUNT(*) AS obtido,2 AS esperado FROM categoria
UNION ALL
SELECT 'inscricao' AS tabela,COUNT(*) AS obtido,12000 AS esperado FROM inscricao
) AS contagens WHERE obtido<>esperado;
-- P02: estados. PAGA 4001, PENDENTE 4000, CANCELADA 3999.
SELECT situacao,COUNT(*) AS quantidade FROM inscricao GROUP BY situacao ORDER BY situacao;
-- P03: canais. SITE_EVENTO 2000, REDE_SOCIAL 2000, EMAIL 2000, INDICACAO 2001, OUTRO 2000, NULL 1999.
SELECT canal_divulgacao,COUNT(*) AS quantidade FROM inscricao GROUP BY canal_divulgacao ORDER BY canal_divulgacao;
-- P04: CPF opcional e homônimos. 1200 sem CPF; dois Alex com contato comum e CPFs diferentes.
SELECT COUNT(*) AS sem_cpf FROM participante WHERE cpf IS NULL;
SELECT id_participante,nome_completo,email,cpf FROM participante WHERE id_participante IN (1,2) ORDER BY id_participante;
-- P05: reajuste. Amostra de cinco contratos anteriores de 100 e um novo de 120; preço vigente 120.
SELECT i.id_inscricao,i.valor_contratado,c.preco_vigente FROM inscricao i JOIN categoria c ON c.id_categoria=i.id_categoria WHERE i.id_inscricao IN (1,2501,5001,7501,10001,12000) ORDER BY i.id_inscricao;
