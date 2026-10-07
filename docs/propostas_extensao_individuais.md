# Propostas individuais de extensão — EventOS

As propostas individuais do grupo complementam a análise do [escopo](escopo_requisitos.md) e do [MER](../modelos/mer_especificacao.md). Somente RE1 — Canal de divulgação — integra a implementação.

**RE1 — Canal de divulgação, proposta de P1, permanece a única extensão escolhida e implementada.** P2, P3 e P4 apresentaram avaliações individuais de outras alternativas, mantidas neste documento sem ampliar os RF/RE nem a implementação.

As respostas identificadas de P1/P2/P3/P4 foram encaminhadas por P1. A atribuição individual é: P1 — Canal de divulgação; P2 — Orientação de chegada; P3 — Tema principal do evento; P4 — Observação administrativa da inscrição.

## Visão geral

| Integrante | Proposta | Representação proposta | Situação |
| --- | --- | --- | --- |
| P1 | Canal de divulgação | Atributo opcional de Inscrição | RE1 oficial implementada |
| P2 | Orientação de chegada | Atributo opcional de Edição | Proposta individual avaliada; não incorporada |
| P3 | Tema principal do evento | Atributo opcional de Evento | Proposta individual avaliada; não incorporada |
| P4 | Observação administrativa da inscrição | Atributo opcional de Inscrição | Proposta individual avaliada; não incorporada |

As três alternativas não criam RE2, RE3 ou RE4. A única extensão oficial permanece RE1.

## P1 — RE1: Canal de divulgação

**Resposta encaminhada por P1:**

> Minha proposta seria incluir na inscrição a informação de como o participante ficou sabendo do evento. Com esse dado, seria possível analisar quais meios de divulgação atraem mais inscrições. Como seria apenas um campo opcional, não seria necessário criar nenhuma entidade adicional.

- **Objetivo:** identificar o canal pelo qual o participante tomou conhecimento do evento.
- **Justificativa para o gestor:** comparar a distribuição das inscrições por canal e por edição, auxiliando a avaliação da divulgação.
- **Representação conceitual adotada:** atributo opcional Canal de divulgação em Inscrição. Não cria entidade, relacionamento ou caminho adicional.
- **Valores do recorte vigente:** SITE_EVENTO, REDE_SOCIAL, EMAIL, INDICACAO ou OUTRO. Ausência significa não informado.
- **Limites:** um único canal informado na criação; sem campanhas, rastreamento de cliques, integração externa ou histórico de mudanças.
- **Escolha:** é a extensão oficial porque entrega um indicador útil com um único atributo e uma consulta agregada. Foi sugerida por P1.

Esta seção descreve o comportamento já previsto em RE1; não o altera.

## P2 — Orientação de chegada

**Resposta encaminhada por P1:**

> Eu sugeriria adicionar à edição uma informação breve sobre como chegar ao local, indicando, por exemplo, qual entrada deve ser utilizada. Esse dado complementaria as informações do local sem alterar a estrutura do modelo. Ainda assim, por ter pouca influência na gestão das inscrições, manteria apenas a extensão considerada prioritária.

- **Objetivo:** complementar o local de uma edição com uma instrução curta de chegada, como “Entrada pelo portão lateral da biblioteca”.
- **Justificativa para o gestor:** manter uma orientação prática que possa ser consultada junto ao local, especialmente quando o endereço ou nome do prédio não esclarece o acesso.
- **Alteração conceitual hipotética:** adicionar somente o atributo opcional Orientação de chegada em Edição, sem mudar o atributo Local de realização.
- **Limites:** aplicável a edições PRESENCIAL ou HIBRIDA; ausente em REMOTA. Informação atual, facultativa e curta; sem mapas, geolocalização, transporte, controle de entrada ou presença.
- **Pró:** complementa a administração do local sem nova entidade ou integração.
- **Contra:** pode ser redundante quando o próprio local já é suficientemente claro e precisa ser revisada se a orientação mudar.
- **Motivo de não inclusão:** não é necessária ao registro e à administração das inscrições. A extensão oficial já escolhida oferece uma pergunta gerencial diretamente relacionada ao núcleo.

Não existe coluna, regra, teste ou relatório dessa alternativa na implementação atual.

## P3 — Tema principal do evento

**Resposta encaminhada por P1:**

> Minha sugestão seria incluir no evento um campo para indicar seu tema principal, como Tecnologia ou Educação. Isso facilitaria a classificação e a organização dos eventos sem exigir novas entidades. Como essa informação não é necessária para os relatórios definidos, considero mais adequado priorizar o canal de divulgação.

- **Objetivo:** indicar o assunto principal de um evento, como “Computação”, “Educação” ou “Saúde”.
- **Justificativa para o gestor:** facilitar a organização e a comparação do catálogo de eventos por assunto, além de seus nomes.
- **Alteração conceitual hipotética:** adicionar somente o atributo opcional Tema principal em Evento. Não adicionar cadastro de temas ou associação de vários temas.
- **Limites:** um assunto principal atual por evento; sem taxonomia, subtemas, programação ou histórico. Tema descreve o conteúdo do evento; Categoria continua classificando inscrições, como estudante e geral.
- **Pró:** acrescenta uma classificação gerencial simples, sem mudar os relacionamentos.
- **Contra:** sem vocabulário controlado, termos semelhantes podem ser escritos de formas diferentes; um único tema pode resumir excessivamente eventos multidisciplinares.
- **Motivo de não inclusão:** os relatórios aprovados não dependem dessa classificação. A alternativa permanece documentada sem ampliar o minimundo atual.

Não existe coluna, regra, teste ou relatório dessa alternativa na implementação atual.

## P4 — Observação administrativa da inscrição

**Resposta encaminhada por P1:**

> Eu acrescentaria à inscrição um campo opcional destinado a pequenas observações administrativas. Ele poderia atender casos pontuais durante o gerenciamento das inscrições, embora exista o risco de registrar informações que já estejam presentes em outros campos. Por isso, considero o canal de divulgação uma extensão mais útil para o escopo atual.

- **Objetivo:** permitir que o gestor mantenha uma anotação curta sobre uma inscrição, quando uma explicação administrativa complementar for necessária.
- **Justificativa para o gestor:** registrar, por exemplo, “Participante solicitou contato por e-mail”, sem criar cadastro ou processo adicional.
- **Alteração conceitual hipotética:** adicionar somente o atributo opcional Observação administrativa em Inscrição. O código, os vínculos, o valor contratado e a situação permanecem como estão.
- **Limites:** uma anotação atual, curta e facultativa; sem versões, autor, datas de alteração, atendimento, comprovantes ou dados pessoais adicionais. A anotação não substitui a situação da inscrição nem autoriza exceções às regras.
- **Pró:** atende uma necessidade pontual de administração sem nova entidade.
- **Contra:** texto livre pode repetir informações já representadas e demanda disciplina de preenchimento.
- **Motivo de não inclusão:** a observação não é necessária às perguntas gerenciais atuais. Mantê-la como alternativa evita ampliar o escopo além da única extensão escolhida.

Não existe coluna, regra, teste ou relatório dessa alternativa na implementação atual.

## Extensão adotada

As quatro propostas apresentam utilidade e representação conceitual simples. P2/P3/P4 também avaliam limites e justificam priorizar o canal de divulgação. Somente RE1 integra o banco; as outras três permanecem como análise individual documentada.
