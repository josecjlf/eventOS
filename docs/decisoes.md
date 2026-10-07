# Decisões de modelagem e implementação

Inscrição liga diretamente Participante, Categoria e Edição. Evento liga-se somente a Edição. São cinco entidades, quatro relacionamentos e zero ciclos. Categoria é catálogo global com nome exclusivo e preço comum a todas as edições; não existe oferta/preço próprio por edição.

Uma inscrição por participante/edição, mesmo cancelada. CPF facultativo e exclusivo quando informado; homônimos e contatos repetidos são permitidos. O valor contratado fica separado do preço vigente para reajustes não reescreverem contratos anteriores.

Estados atuais PENDENTE/PAGA/CANCELADA, sem histórico operacional. Criação, quitação e cancelamento seguem transações SERIALIZABLE com condições explícitas. Janela, cópia inicial e transição não são CHECKs intertabelas. Privilégios limitam alterações de vínculos/contrato, mas o proprietário pode contornar o protocolo. Diagnósticos detectam inconsistências; não impedem a gravação.

A nomenclatura física usa nomes em singular e snake_case, conforme MAD = DATA SUS. Identidades BIGINT BY DEFAULT, VARCHAR com limites e DECIMAL(12,2). Oito estruturas únicas de PK/UNIQUE, sem índices adicionais ou benchmark. RE1 canal de divulgação é a única extensão implementada.

[Escopo](escopo_requisitos.md), [modelo lógico](../modelos/modelo_logico.md), [integridade](matriz_regra_mecanismo.md), [conformidade SQL](sql_conformidade.md), [índices](indices.md) e [resultados](../testes/relatorio_testes.md).
