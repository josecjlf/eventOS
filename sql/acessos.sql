-- Executar como proprietário, após DDL; não adiciona entidades ao MER.
-- Antes: criar eventos_operacao/eventos_consulta manualmente no pgAdmin, sem superpoderes.
-- Sem privilégios herdados adicionais; a operação usa IDs explícitos, sem acessar sequências.
-- As concessões não impõem janela/cópia inicial do preço: seguir o protocolo OC01–OC05.
CREATE VIEW vw_resumo_edicao AS
SELECT e.id_edicao,e.id_evento,e.designacao,COUNT(i.id_inscricao) AS inscricoes,
SUM(CASE WHEN i.situacao='PAGA' THEN 1 ELSE 0 END) AS pagas,
SUM(CASE WHEN i.situacao='PENDENTE' THEN 1 ELSE 0 END) AS pendentes,
SUM(CASE WHEN i.situacao='CANCELADA' THEN 1 ELSE 0 END) AS canceladas,
COALESCE(SUM(CASE WHEN i.situacao='PAGA' THEN i.valor_contratado ELSE 0 END),0) AS recebimento_bruto
FROM edicao e LEFT JOIN inscricao i ON i.id_edicao=e.id_edicao
GROUP BY e.id_edicao,e.id_evento,e.designacao;
CREATE VIEW vw_resumo_categoria AS
-- Categoria resume o catálogo em todas as edições, inclusive categorias sem inscrições.
SELECT c.id_categoria,c.nome,c.preco_vigente,COUNT(i.id_inscricao) AS inscricoes,
COALESCE(SUM(CASE WHEN i.situacao='PAGA' THEN i.valor_contratado ELSE 0 END),0) AS recebimento_bruto
FROM categoria c LEFT JOIN inscricao i ON i.id_categoria=c.id_categoria GROUP BY c.id_categoria,c.nome,c.preco_vigente;
CREATE VIEW vw_resumo_canal AS
SELECT id_edicao,canal_divulgacao,COUNT(*) AS inscricoes FROM inscricao GROUP BY id_edicao,canal_divulgacao;
CREATE VIEW vw_inscricoes_diarias AS
SELECT id_edicao,data_inscricao,COUNT(*) AS novas_inscricoes FROM inscricao GROUP BY id_edicao,data_inscricao;

REVOKE ALL PRIVILEGES ON evento FROM PUBLIC RESTRICT;
REVOKE ALL PRIVILEGES ON edicao FROM PUBLIC RESTRICT;
REVOKE ALL PRIVILEGES ON participante FROM PUBLIC RESTRICT;
REVOKE ALL PRIVILEGES ON categoria FROM PUBLIC RESTRICT;
REVOKE ALL PRIVILEGES ON inscricao FROM PUBLIC RESTRICT;
REVOKE ALL PRIVILEGES ON evento FROM eventos_consulta RESTRICT;
REVOKE ALL PRIVILEGES ON edicao FROM eventos_consulta RESTRICT;
REVOKE ALL PRIVILEGES ON participante FROM eventos_consulta RESTRICT;
REVOKE ALL PRIVILEGES ON categoria FROM eventos_consulta RESTRICT;
REVOKE ALL PRIVILEGES ON inscricao FROM eventos_consulta RESTRICT;
REVOKE ALL PRIVILEGES ON evento FROM eventos_operacao RESTRICT;
REVOKE ALL PRIVILEGES ON edicao FROM eventos_operacao RESTRICT;
REVOKE ALL PRIVILEGES ON participante FROM eventos_operacao RESTRICT;
REVOKE ALL PRIVILEGES ON categoria FROM eventos_operacao RESTRICT;
REVOKE ALL PRIVILEGES ON inscricao FROM eventos_operacao RESTRICT;
REVOKE ALL PRIVILEGES ON vw_resumo_edicao FROM PUBLIC RESTRICT;
REVOKE ALL PRIVILEGES ON vw_resumo_categoria FROM PUBLIC RESTRICT;
REVOKE ALL PRIVILEGES ON vw_resumo_canal FROM PUBLIC RESTRICT;
REVOKE ALL PRIVILEGES ON vw_inscricoes_diarias FROM PUBLIC RESTRICT;
GRANT SELECT ON evento TO eventos_operacao;
GRANT SELECT ON edicao TO eventos_operacao;
GRANT SELECT ON participante TO eventos_operacao;
GRANT SELECT ON categoria TO eventos_operacao;
GRANT SELECT ON inscricao TO eventos_operacao;
GRANT INSERT (id_inscricao,id_participante,id_categoria,id_edicao,data_inscricao,valor_contratado,canal_divulgacao) ON inscricao TO eventos_operacao;
GRANT UPDATE (situacao) ON inscricao TO eventos_operacao;
GRANT UPDATE (preco_vigente) ON categoria TO eventos_operacao;
GRANT SELECT ON vw_resumo_edicao TO eventos_consulta;
GRANT SELECT ON vw_resumo_categoria TO eventos_consulta;
GRANT SELECT ON vw_resumo_canal TO eventos_consulta;
GRANT SELECT ON vw_inscricoes_diarias TO eventos_consulta;
