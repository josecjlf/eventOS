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
