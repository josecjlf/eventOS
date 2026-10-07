# Especificação do MER oficial — Inscrição central

O MER representa Evento, Edição, Participante, Categoria e Inscrição, com esta última ligada diretamente à edição, ao participante e à categoria global. A [tradução física](modelo_logico.md) apresenta as tabelas e constraints.

Esta especificação textual define as entidades, os atributos, os relacionamentos e as cardinalidades do modelo conceitual em Peter Chen.

## Entidades e atributos conceituais

| Entidade | Finalidade | Identificador conceitual | Atributos obrigatórios além do identificador | Opcionais |
| --- | --- | --- | --- | --- |
| Evento | Identificar um evento recorrente | Código do evento | Nome do evento | Sigla |
| Edição | Identificar uma realização e sua janela de inscrições | Código da edição | Designação da edição; Data inicial de realização; Data final de realização; Modalidade de realização; Abertura das inscrições; Fechamento das inscrições | Local de realização, condicionado à modalidade |
| Participante | Identificar e contatar uma pessoa, reutilizando o cadastro | Código do participante | Nome completo; E-mail de contato | CPF, exclusivo quando informado |
| Categoria | Classificar inscrições de qualquer edição e oferecer preço global atual | Código da categoria | Nome da categoria; Preço vigente comum às edições | Descrição da categoria |
| Inscrição | Registrar a contratação de categoria por pessoa em uma edição | Código da inscrição | Data da inscrição; Situação da inscrição; Valor contratado | Canal de divulgação, RE1 |

São **5 entidades, 24 atributos simples e 5 identificadores**. Cinco atributos são opcionais/condicionados. Nenhum atributo derivado é desenhado. CPF opcional não é o identificador obrigatório; nomes de evento/participante e e-mails não são exclusivos. Nome de categoria é globalmente exclusivo. Não há data do pagamento nem unicidade da designação da edição.

## Relacionamentos e leitura das cardinalidades

A cardinalidade junto a uma entidade indica quantas ocorrências da outra se associam a ela. A tabela explicita o significado de cada relacionamento.

| Relação | Entidade A / cardinalidade | Entidade B / cardinalidade | Significado |
| --- | --- | --- | --- |
| Tem edição | Evento (0,N) | Edição (1,1) | Evento pode ter nenhuma ou várias edições; edição pertence exatamente a um evento. |
| Recebe inscrição | Edição (0,N) | Inscrição (1,1) | Edição pode receber nenhuma ou várias inscrições; inscrição pertence exatamente a uma edição. |
| Realiza | Participante (0,N) | Inscrição (1,1) | Pessoa pode ter nenhuma ou várias inscrições; inscrição pertence a uma pessoa. |
| Classifica-se em | Inscrição (1,1) | Categoria (0,N) | Inscrição seleciona uma categoria; categoria pode classificar inscrições de várias edições. |

Não há N:N direto. Inscrição é um fato com identidade e atributos próprios. Os vínculos com Edição e Categoria são independentes. O modelo não possui relações diretas de Categoria com Edição/Evento ou de Participante com Categoria.

## Condições do minimundo

1. A edição possui uma janela única, inclusiva, compartilhada por todas as categorias. Abertura ≤ fechamento ≤ data final de realização; início ≤ fim de realização. Inscrição é criada dentro da janela da edição selecionada, podendo iniciar antes da realização.
2. Categoria pertence ao catálogo global, tem nome exclusivo nesse catálogo e preço vigente positivo, em reais, comum a todas as edições. Todas as categorias cadastradas podem ser utilizadas em qualquer edição. O valor contratado também é positivo e é copiado do preço na criação, permanecendo após reajustes. Não há oferta ou preço por edição, agenda por lote ou versões de preços ofertados.
3. Participante pode ter uma única inscrição na edição, incluindo a cancelada e independentemente da categoria. Inscrição determina sua edição diretamente, e esta determina o evento; Categoria não determina edição nem evento.
4. Situação é somente PENDENTE, PAGA ou CANCELADA. A inscrição nasce PENDENTE; pode ir a PAGA ou CANCELADA, estados terminais. Quitação é reconhecimento administrativo integral. Fechamento limita criação; pendentes existentes podem ser pagas depois. Não há presença, reabertura, troca de categoria/pessoa/edição ou cancelamento de paga.
5. Data original, contrato e vínculos da inscrição são preservados. Janela de edição com inscrições não é reescrita. Reajuste global de categoria afeta somente novas inscrições em qualquer edição. Nome/local atuais não possuem versões.
6. Local é obrigatório em modalidade PRESENCIAL/HIBRIDA e ausente em REMOTA. CPF pode faltar; se informado tem onze dígitos exclusivos. Ausência de CPF não assegura deduplicação real de pessoas.
7. Canal é opcional: SITE_EVENTO, REDE_SOCIAL, EMAIL, INDICACAO ou OUTRO. Não há entidade de campanha.

O banco administra dados de contratação e a condição atual. Não processa dinheiro. Não reconstrói situação passada ou recebimento por data de pagamento. As regras e seus limites físicos estão em [regras_de_negocio.md](../docs/regras_de_negocio.md).

## Verificação formal de ciclos

Pares: Evento — Tem edição — Edição; Edição — Recebe inscrição — Inscrição; Participante — Realiza — Inscrição; Inscrição — Classifica-se em — Categoria.

O grafo não dirigido é conectado, com 5 vértices e 4 arestas; 4−5+1 = 0 ciclos independentes. Incluindo os quatro losangos e 24 atributos, são 33 vértices e 32 ligações. Cada atributo é uma folha. **LOOPS CONCEITUAIS: 0.**

Preço vigente fica em Categoria; Valor contratado e a única Situação ficam em Inscrição.
