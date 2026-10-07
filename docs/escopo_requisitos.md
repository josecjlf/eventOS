# Escopo e requisitos — núcleo gerencial EventOS

O núcleo gerencial organiza **o cadastro e a administração da inscrição e sua quitação atual**, com cinco entidades: Evento, Edição, Participante, Categoria e Inscrição. O recorte seleciona dez requisitos funcionais do enunciado, com refinamentos e exclusões justificados, e uma extensão separada. As fontes E/P/R são identificadas ao final.

## Objetivo geral

Organizar eventos, edições, categorias, participantes e inscrições para o gestor consultar inscrições e reconhecer sua quitação, conservando o valor contratado e assegurando integridade no ambiente PostgreSQL/pgAdmin.

## Objetivos específicos

1. Cadastrar eventos e realizações com modalidade, local e uma janela única de inscrições.
2. Definir um catálogo global de categorias e seus preços atuais, compartilhados por todas as edições.
3. Reutilizar participantes com contato e CPF facultativo, evitando duplicações identificáveis.
4. Administrar uma inscrição por participante/edição, com contrato preservado e situação única.
5. Produzir indicadores atuais de volume, pendência, recebimento bruto e canal de divulgação.
6. Reproduzir estrutura/carga/testes por SQL permitido, separando impedimento, procedimento e diagnóstico.

## RF finais — 10 originais, mais uma extensão separada

| RF | Classificação | Texto vigente | Justificativa do refinamento/inclusão |
| --- | --- | --- | --- |
| RF1 | MANTIDO | Cadastrar eventos e respectivas edições, permitindo várias realizações do mesmo evento. | Base do núcleo gerencial. |
| RF3 | REFINADO | Reutilizar cadastro de participante entre edições; código obrigatório, nome e e-mail de contato, CPF facultativo e exclusivo quando informado. | Não exigir passaporte nem identificação documental universal; reconhecer a limitação de deduplicação sem CPF. |
| RF5 | REFINADO | Manter categorias globais, com nomes únicos no catálogo e preço vigente comum às edições; todas as categorias cadastradas podem ser utilizadas em qualquer edição. | Adoção explícita do MER aprovado com Inscrição central. Retira listas e preços independentes por edição; não atende integralmente o RF original. |
| RF6 | REFINADO | Uma edição tem uma janela única de inscrições; cada categoria oferece um preço vigente positivo, copiado para o contrato na criação. | Redução expressa: sem faixa/lote, modalidades individuais ou programação de preço. Não atende o RF original integralmente. |
| RF9 | REFINADO | Administrar somente a situação atual PENDENTE, PAGA ou CANCELADA; pendente pode ser quitada ou cancelada, com estados finais sem reabertura. | Retira etapas intermediárias e trajetória histórica conforme orientação docente. |
| RF13 | REFINADO | Reconhecer administrativamente a quitação integral de inscrição pendente pelo estado PAGA, usando o valor contratado preservado. | Retira registros/tentativas, forma e data de pagamento. É adaptação explícita da finalidade financeira, não atendimento integral ao texto original. |
| RF26 | REFINADO | Produzir contagens por evento/edição/categoria/situação, percentual pago, criações diárias/acumuladas, recebimento bruto atual e distribuição por canal. | Sem receita líquida, forma/data de pagamento, instituição, documento ou presença. |
| RF27 | REFINADO | Preservar valor contratado, data original e vínculos da inscrição após reajustes. Manter canceladas registradas. | Não manter versões de preços, configurações ou situações anteriores. Reconstitui contrato monetário, não auditoria operacional. |
| RF28 | MANTIDO | Aplicar integridade de domínio, unicidade, referência e estratégias adequadas, discriminando constraints, protocolo transacional, privilégios e diagnóstico. | Não atribuir garantia declarativa às regras intertabelas/procedimentais. |
| RF30 | REFINADO | Coletar apenas dados mínimos do núcleo e separar consulta gerencial agregada de acesso operacional, com dados fictícios na entrega. | Sem documentos reais, identidade de aplicação ou gestão legal de consentimento. |

RF1/RF28 são mantidos; os outros oito são refinados. RF5 representa catálogo e preço globais. RF6/RF9/RF13/RF27 têm redução substantiva expressa. A seleção usa a possibilidade de refinamentos e remoções justificados prevista em E, p. 9; não corresponde a atendimento integral dos textos originais. As exclusões de RF8/RF20 e dos demais requisitos constam na tabela abaixo.

## RE1 — Canal de divulgação

Extensão proposta por P1 e única implementada. As [propostas individuais](propostas_extensao_individuais.md) de P2/P3/P4 foram avaliadas e não integram RF/RN/modelo/SQL.

Registrar opcionalmente um único canal informado na criação: SITE_EVENTO, REDE_SOCIAL, EMAIL, INDICACAO ou OUTRO; NULL significa não informado. Justificativa: comparar divulgação por edição com uma coluna e consulta agregada, sem campanha, site ou integração. RE1 não integra a contagem dos dez RF.

## Exclusões justificadas — 20 RF

| RF | Justificativa específica |
| --- | --- |
| RF2 | Co-localização/agregação faria uma inscrição cobrir vários eventos; cada contrato seleciona uma única categoria/edição. |
| RF4 | Associação exige períodos de filiação; preço não depende desse cadastro. |
| RF7 | COMBO compõe inscrição e associação; o contrato atual tem um único valor. |
| RF8 | Envio/análise de comprovação foi retirado pelo feedback docente; categoria é classificação administrativa. |
| RF10 | Seleção de atividades exigiria programação e inscrições adicionais. |
| RF11 | Capacidade depende de vagas/atividades ausentes; não há lotação no núcleo. |
| RF12 | Composição por itens não existe: valor é somente a contratação da categoria. |
| RF14 | Formas e processamento financeiro distintos não são armazenados; PAGA é reconhecimento administrativo. |
| RF15 | Reembolso exige política e movimentos financeiros adicionais; paga não pode ser cancelada. |
| RF16 | Instituição e vínculos não são necessários ao cadastro mínimo aprovado. |
| RF17 | Benefícios, cotas e consumo de direitos adicionam concessões além da oferta simples. |
| RF18 | Trabalhos/autorias pertencem ao gerenciamento acadêmico excluído. |
| RF19 | Cobertura/taxa de publicação depende de trabalhos e autorias excluídos. |
| RF20 | Chegada/credenciamento foi retirado pela orientação docente, sem atributo de presença substituto. |
| RF21 | Frequência em sessões depende da programação de atividades retirada. |
| RF22 | Certificação adiciona critérios, emissão e autenticidade sem uso no núcleo. |
| RF23 | Termos e versões criariam um ciclo de consentimento próprio. |
| RF24 | Equipes/papéis por edição ampliam para gestão organizacional; contas do SGBD são apenas acesso técnico. |
| RF25 | Auditoria de atos exige autor/data/mudanças intermediárias que o MER simplificado não conserva. |
| RF29 | Disputa de últimas vagas pressupõe capacidade não modelada; testes concorrentes atuais apenas verificam UNIQUE e transição controlada. |

## Fronteiras, premissas e limites

O banco administra os cinco conceitos do MER aprovado com Inscrição central, cadastro mínimo, preço global atual, valor contratado e condição atual da inscrição. Todas as categorias cadastradas são utilizáveis em todas as edições, sem ofertas específicas por edição. Reajuste de uma categoria afeta apenas novas contratações em qualquer edição. Valores positivos, cobrança integral em reais, datas inclusivas, uma inscrição por participante/edição incluindo canceladas. Não há reabertura, troca de pessoa/categoria/edição, parcelas ou cancelamento de paga. Pendentes podem ser quitadas depois do fechamento. Local obrigatório em presencial/híbrida; ausente em remota. Nomes de evento/participante e e-mails não são exclusivos; nome de categoria é exclusivo no catálogo global; CPF opcional exclusivo não assegura identidade universal.

Não administra lotes, documentos de comprovação, tentativas/forma/data de pagamento, histórico de situação, credenciamento/presença, reembolso, associação, atividades, benefícios, publicação, termos ou equipe administrativa. Não há site, API ou gateway. Recebimento bruto atual soma contratos PAGA; não é extrato financeiro, receita líquida nem recebimento histórico por dia.

A nomenclatura física usa nomes em singular e snake_case, conforme a orientação MAD = DATA SUS comunicada ao grupo.

## Fontes

| ID | Referência | Uso |
| --- | --- | --- |
| E | MATA60 — Caso 1: EventOS, 28 páginas. | Requisitos pp. 5–9, refinamentos permitidos p. 9 e critérios da primeira entrega p. 25. |
| P | Plano EventOS — Marco 1, Grupo 4, 9 páginas. | Planejamento do grupo. |
| R | Recursos não permitidos SQL, 7 páginas. | Restrições de recursos e portabilidade dos scripts. |
