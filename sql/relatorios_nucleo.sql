-- Executar como proprietário ou eventos_consulta, após acessos.sql.
-- R01: quantidade, situação, percentual pago e recebimento bruto por edição.
SELECT id_evento,id_edicao,designacao,inscricoes,pagas,pendentes,canceladas,
CASE WHEN inscricoes=0 THEN 0 ELSE 100.00*pagas/inscricoes END AS percentual_pago,recebimento_bruto
FROM vw_resumo_edicao ORDER BY id_evento,id_edicao;
-- R02: categoria global, agregada em todas as edições (preço atual não é receita).
SELECT id_categoria,nome,preco_vigente,inscricoes,recebimento_bruto FROM vw_resumo_categoria ORDER BY id_categoria;
-- R03: evolução acumulada das CRIAÇÕES, incluindo as atualmente canceladas.
SELECT d.id_edicao,d.data_inscricao,d.novas_inscricoes,
(SELECT SUM(a.novas_inscricoes) FROM vw_inscricoes_diarias a WHERE a.id_edicao=d.id_edicao AND a.data_inscricao<=d.data_inscricao) AS acumulado
FROM vw_inscricoes_diarias d ORDER BY d.id_edicao,d.data_inscricao;
-- R04: canal e percentual; NULL significa não informado.
SELECT c.id_edicao,c.canal_divulgacao,c.inscricoes,100.00*c.inscricoes/e.inscricoes AS percentual
FROM vw_resumo_canal c JOIN vw_resumo_edicao e ON e.id_edicao=c.id_edicao ORDER BY c.id_edicao,c.canal_divulgacao;
-- R05: totais por evento. Soma dos contratos PAGA, sem reconstruir datas de recebimento.
SELECT id_evento,SUM(inscricoes) AS inscricoes,SUM(pagas) AS pagas,SUM(recebimento_bruto) AS recebimento_bruto
FROM vw_resumo_edicao GROUP BY id_evento ORDER BY id_evento;
