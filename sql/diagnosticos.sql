-- Diagnósticos: zero linhas esperado; detectar não significa impedir.
-- DG01: inscrição criada fora da janela da edição.
SELECT i.id_inscricao,i.data_inscricao,e.abertura_inscricoes,e.fechamento_inscricoes
FROM inscricao i JOIN edicao e ON e.id_edicao=i.id_edicao
WHERE i.data_inscricao < e.abertura_inscricoes OR i.data_inscricao > e.fechamento_inscricoes;
-- DG02: categoria ou edição inexistente (também protegido pelas FKs independentes).
-- Toda categoria global pode ser usada em qualquer edição existente.
SELECT i.id_inscricao,i.id_categoria,i.id_edicao FROM inscricao i
LEFT JOIN categoria c ON c.id_categoria=i.id_categoria
LEFT JOIN edicao e ON e.id_edicao=i.id_edicao
WHERE c.id_categoria IS NULL OR e.id_edicao IS NULL;
-- DG03: participante repetido na mesma edição (também protegido por UNIQUE).
SELECT id_participante,id_edicao,COUNT(*) AS quantidade FROM inscricao GROUP BY id_participante,id_edicao HAVING COUNT(*)>1;
-- DG04: contratos/domínios inválidos (também protegidos por CHECK).
SELECT id_inscricao FROM inscricao WHERE valor_contratado<=0 OR situacao NOT IN ('PENDENTE','PAGA','CANCELADA');
-- Não comparar contrato antigo com preço vigente como se diferença fosse erro.
