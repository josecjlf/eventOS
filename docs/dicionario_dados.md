# Dicionário de dados

O [DDL](../sql/01_estrutura.sql) materializa o modelo com Inscrição central em 5 tabelas, 28 colunas, 23 NOT NULL e 5 opcionais. Categoria é global e Inscrição referencia diretamente a edição. Todos os tipos são SQL padronizados. Nome de coluna sem acento, singular snake_case. Datas são DATE inclusivas; moeda única BRL. NULL representa ausência opcional. Limites de VARCHAR constam por coluna. Não há conteúdo binário nem processo externo.

## evento

| Coluna | Tipo SQL | Aceita NULL | Significado / tamanho |
| --- | --- | --- | --- |
| id_evento | BIGINT | Não | Identificador; identidade BY DEFAULT |
| nome | VARCHAR(200) | Não | Nome do evento; 200 caracteres para títulos |
| sigla | VARCHAR(30) | Sim | Sigla opcional; 30 caracteres |

Restrições: `pk_evento`, `ck_evento_id`, `ck_evento_nome`, `ck_evento_sigla`.

## edicao

| Coluna | Tipo SQL | Aceita NULL | Significado / tamanho |
| --- | --- | --- | --- |
| id_edicao | BIGINT | Não | Identificador; identidade BY DEFAULT |
| id_evento | BIGINT | Não | Evento ao qual pertence |
| designacao | VARCHAR(60) | Não | Rótulo da edição, não exclusivo; 60 caracteres |
| data_inicio | DATE | Não | Primeiro dia de realização |
| data_fim | DATE | Não | Último dia de realização |
| modalidade | VARCHAR(10) | Não | PRESENCIAL, HIBRIDA ou REMOTA |
| local_realizacao | VARCHAR(200) | Sim | Descrição de local; exigida em presencial/híbrida, ausente em remota |
| abertura_inscricoes | DATE | Não | Primeiro dia inclusivo de inscrições |
| fechamento_inscricoes | DATE | Não | Último dia inclusivo de inscrições |

Restrições: `pk_edicao`, `ck_edicao_id`, `fk_edicao_evento`, `ck_edicao_designacao`, `ck_edicao_realizacao`, `ck_edicao_janela`, `ck_edicao_modalidade`, `ck_edicao_local`.

## participante

| Coluna | Tipo SQL | Aceita NULL | Significado / tamanho |
| --- | --- | --- | --- |
| id_participante | BIGINT | Não | Identificador; identidade BY DEFAULT |
| nome_completo | VARCHAR(150) | Não | Nome de contato; homônimos permitidos; 150 caracteres |
| email | VARCHAR(254) | Não | Contato; compartilhamento permitido; limite usual de endereço |
| cpf | VARCHAR(11) | Sim | Onze dígitos, sem pontuação; exclusivo quando informado; sem validação de autenticidade |

Restrições: `pk_participante`, `ck_participante_id`, `uq_participante_cpf`, `ck_participante_nome`, `ck_participante_email`, `ck_participante_cpf`.

## categoria

| Coluna | Tipo SQL | Aceita NULL | Significado / tamanho |
| --- | --- | --- | --- |
| id_categoria | BIGINT | Não | Identificador; identidade BY DEFAULT |
| nome | VARCHAR(80) | Não | Nome único no catálogo global; 80 caracteres |
| descricao | VARCHAR(300) | Sim | Descrição simples opcional; 300 caracteres |
| preco_vigente | DECIMAL(12,2) | Não | Preço global atual positivo em reais, compartilhado por todas as edições; até 9.999.999.999,99 |

Restrições: `pk_categoria`, `ck_categoria_id`, `uq_categoria_nome`, `ck_categoria_nome`, `ck_categoria_descricao`, `ck_categoria_preco`.

## inscricao

| Coluna | Tipo SQL | Aceita NULL | Significado / tamanho |
| --- | --- | --- | --- |
| id_inscricao | BIGINT | Não | Identificador; identidade BY DEFAULT |
| id_participante | BIGINT | Não | Participante cadastrado |
| id_categoria | BIGINT | Não | Categoria escolhida, vínculo preservado |
| id_edicao | BIGINT | Não | Edição escolhida diretamente, independente da categoria; vínculo preservado |
| data_inscricao | DATE | Não | Dia original, preservado, dentro da janela |
| situacao | VARCHAR(9) | Não | PENDENTE, PAGA ou CANCELADA; padrão PENDENTE |
| valor_contratado | DECIMAL(12,2) | Não | Snapshot positivo do preço na contratação, preservado |
| canal_divulgacao | VARCHAR(11) | Sim | RE1: SITE_EVENTO, REDE_SOCIAL, EMAIL, INDICACAO, OUTRO; ausência NULL |

Restrições: `pk_inscricao`, `ck_inscricao_id`, `fk_inscricao_participante`, `fk_inscricao_categoria`, `fk_inscricao_edicao`, `uq_inscricao_participante_edicao`, `ck_inscricao_situacao`, `ck_inscricao_valor`, `ck_inscricao_canal`.

## Imutabilidade e política de atualização

Inscrição: id_participante, id_categoria, id_edicao, data_inscricao e valor_contratado não são atualizados pelo perfil operacional. Situação recebe somente operações condicionadas; canal é informação única da criação. Categoria: preço global pode mudar por OC04; reajuste afeta novas inscrições em todas as edições. Não há edição proprietária da categoria nem operação para movê-la. Edição: janela só muda por OC05 antes de existir inscrição.

DEFAULT de situação não obriga o estado inicial quando há INSERT explícito. CHECK de CPF valida formato, sem dígitos verificadores ou autenticidade. DECIMAL(12,2) arredonda entradas com mais casas conforme o tipo; a carga e as operações devem fornecer valores com duas casas. Proprietário/superusuário possui poder de alteração e não é usado para demonstrar acesso restrito.
