# Modelo lógico oficial — Inscrição central

Fonte conceitual: [mer_especificacao.md](mer_especificacao.md). **5 relações, 28 colunas e 5 identidades**. Inventário: **5 PK, 3 UNIQUE, 4 FK, 21 CHECK, 23 NOT NULL, 5 colunas opcionais e 33 constraints nomeadas**. Os nomes físicos usam singular e snake_case.

## evento

| Coluna | Tipo SQL | Aceita NULL | Significado / tamanho |
| --- | --- | --- | --- |
| id_evento | BIGINT | Não | Identificador; identidade BY DEFAULT |
| nome | VARCHAR(200) | Não | Nome do evento; 200 caracteres para títulos |
| sigla | VARCHAR(30) | Sim | Sigla opcional; 30 caracteres |

- `pk_evento`: `PRIMARY KEY (id_evento)`.
- `ck_evento_id`: `CHECK (id_evento > 0)`.
- `ck_evento_nome`: `CHECK (CHAR_LENGTH(TRIM(nome)) > 0)`.
- `ck_evento_sigla`: `CHECK (sigla IS NULL OR CHAR_LENGTH(TRIM(sigla)) > 0)`.

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

- `pk_edicao`: `PRIMARY KEY (id_edicao)`.
- `ck_edicao_id`: `CHECK (id_edicao > 0)`.
- `fk_edicao_evento`: `FOREIGN KEY (id_evento) REFERENCES evento (id_evento)`.
- `ck_edicao_designacao`: `CHECK (CHAR_LENGTH(TRIM(designacao)) > 0)`.
- `ck_edicao_realizacao`: `CHECK (data_inicio <= data_fim)`.
- `ck_edicao_janela`: `CHECK (abertura_inscricoes <= fechamento_inscricoes AND fechamento_inscricoes <= data_fim)`.
- `ck_edicao_modalidade`: `CHECK (modalidade IN ('PRESENCIAL', 'HIBRIDA', 'REMOTA'))`.
- `ck_edicao_local`: `CHECK (modalidade NOT IN ('PRESENCIAL', 'HIBRIDA', 'REMOTA') OR (modalidade = 'REMOTA' AND local_realizacao IS NULL) OR (modalidade IN ('PRESENCIAL', 'HIBRIDA') AND local_realizacao IS NOT NULL AND CHAR_LENGTH(TRIM(local_realizacao)) > 0))`.

## participante

| Coluna | Tipo SQL | Aceita NULL | Significado / tamanho |
| --- | --- | --- | --- |
| id_participante | BIGINT | Não | Identificador; identidade BY DEFAULT |
| nome_completo | VARCHAR(150) | Não | Nome de contato; homônimos permitidos; 150 caracteres |
| email | VARCHAR(254) | Não | Contato; compartilhamento permitido; limite usual de endereço |
| cpf | VARCHAR(11) | Sim | Onze dígitos, sem pontuação; exclusivo quando informado; sem validação de autenticidade |

- `pk_participante`: `PRIMARY KEY (id_participante)`.
- `ck_participante_id`: `CHECK (id_participante > 0)`.
- `uq_participante_cpf`: `UNIQUE (cpf)`.
- `ck_participante_nome`: `CHECK (CHAR_LENGTH(TRIM(nome_completo)) > 0)`.
- `ck_participante_email`: `CHECK (CHAR_LENGTH(TRIM(email)) > 0)`.
- `ck_participante_cpf`: `CHECK (cpf IS NULL OR cpf SIMILAR TO '[0-9]{11}')`.

## categoria

| Coluna | Tipo SQL | Aceita NULL | Significado / tamanho |
| --- | --- | --- | --- |
| id_categoria | BIGINT | Não | Identificador; identidade BY DEFAULT |
| nome | VARCHAR(80) | Não | Nome único no catálogo global; 80 caracteres |
| descricao | VARCHAR(300) | Sim | Descrição simples opcional; 300 caracteres |
| preco_vigente | DECIMAL(12,2) | Não | Preço global atual positivo em reais, compartilhado por todas as edições; até 9.999.999.999,99 |

- `pk_categoria`: `PRIMARY KEY (id_categoria)`.
- `ck_categoria_id`: `CHECK (id_categoria > 0)`.
- `uq_categoria_nome`: `UNIQUE (nome)`.
- `ck_categoria_nome`: `CHECK (CHAR_LENGTH(TRIM(nome)) > 0)`.
- `ck_categoria_descricao`: `CHECK (descricao IS NULL OR CHAR_LENGTH(TRIM(descricao)) > 0)`.
- `ck_categoria_preco`: `CHECK (preco_vigente > 0)`.

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

- `pk_inscricao`: `PRIMARY KEY (id_inscricao)`.
- `ck_inscricao_id`: `CHECK (id_inscricao > 0)`.
- `fk_inscricao_participante`: `FOREIGN KEY (id_participante) REFERENCES participante (id_participante)`.
- `fk_inscricao_categoria`: `FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)`.
- `fk_inscricao_edicao`: `FOREIGN KEY (id_edicao) REFERENCES edicao (id_edicao)`.
- `uq_inscricao_participante_edicao`: `UNIQUE (id_participante, id_edicao)`.
- `ck_inscricao_situacao`: `CHECK (situacao IN ('PENDENTE', 'PAGA', 'CANCELADA'))`.
- `ck_inscricao_valor`: `CHECK (valor_contratado > 0)`.
- `ck_inscricao_canal`: `CHECK (canal_divulgacao IS NULL OR canal_divulgacao IN ('SITE_EVENTO', 'REDE_SOCIAL', 'EMAIL', 'INDICACAO', 'OUTRO'))`.

## Tradução dos relacionamentos e unicidade

Evento→Edição: FK id_evento NOT NULL. Edição→Inscrição: FK id_edicao NOT NULL. Participante→Inscrição: FK id_participante NOT NULL. Categoria→Inscrição: FK id_categoria NOT NULL. São quatro referências simples; pais não precisam possuir filhos: mínimo zero.

Inscrição contém id_edicao porque pertence diretamente a uma edição no MER. Categoria é global e não determina edição; qualquer categoria existente pode ser usada em qualquer edição existente. UNIQUE(id_participante,id_edicao) impede nova inscrição do mesmo cadastro na edição, inclusive quando CANCELADA. Não há coluna de edição em Categoria, FK composta ou superchave de contexto.

Preço vigente é atributo da Categoria. Valor contratado da Inscrição é snapshot econômico distinto, não uma FK para o preço atual, e não mantém igualdade permanente com o preço vigente. Apenas OC01 assegura a cópia inicial. Estados são VARCHAR(9)+CHECK e DEFAULT PENDENTE.

As cinco PK substitutas usam BIGINT GENERATED BY DEFAULT AS IDENTITY. Carga usa IDs explícitos e ALTER TABLE ... ALTER COLUMN ... RESTART WITH após a carga. Chaves não geram significado de negócio. Nome de categoria é globalmente único; nome de evento/participante, e-mail e designação da edição não são exclusivos.

Imutabilidade, transições e calendário intertabela dependem de operações/permissões com os limites da [matriz de mecanismos](../docs/matriz_regra_mecanismo.md). O modelo não armazena histórico operacional.
