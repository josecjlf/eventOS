# Dependências funcionais

Análise preliminar do esquema oficial com Inscrição central. Não é certificação de normalização nem estudo de desempenho.

## evento

`id_evento → nome, sigla`.

## edicao

`id_edicao → id_evento, designacao, data_inicio, data_fim, modalidade, local_realizacao, abertura_inscricoes, fechamento_inscricoes`.

## participante

`id_participante → nome_completo, email, cpf`.

## categoria

`id_categoria → nome, descricao, preco_vigente`.

`nome → id_categoria, descricao, preco_vigente`, pela unicidade global do nome obrigatório.

## inscricao

`id_inscricao → id_participante, id_categoria, id_edicao, data_inscricao, situacao, valor_contratado, canal_divulgacao`.

`(id_participante,id_edicao) → id_inscricao, id_categoria, data_inscricao, situacao, valor_contratado, canal_divulgacao`.

## Chaves alternativas e limites

- Categoria: nome é chave alternativa global, com UNIQUE(nome). Não existe coluna id_edicao nessa relação nem superchave de contexto.
- Participante: CPF **quando não nulo** determina o cadastro. Não é chave candidata total porque é opcional. Nome/e-mail não determinam pessoa.
- Inscrição: as referências a edição e categoria são independentes. A dependência `id_categoria → id_edicao` é **falsa** no modelo vigente: a mesma categoria pode aparecer em inscrições de várias edições.
- id_edicao em Inscrição representa sua relação conceitual com Edição e sustenta a unicidade pessoa/edição.
- `id_categoria → valor_contratado` é **falsa**: a mesma categoria tem contratos anteriores e posteriores ao reajuste, em uma ou várias edições. Preço vigente e valor contratado não representam o mesmo fato.
- Datas/local são dependentes da edição atual, sem versões; não permitem reconstituir configurações ou situações passadas.
- Sem CPF informado, duplicação real permanece possível. Não há regra `nome → participante` nem `email → participante`.

O esquema contém oito estruturas únicas decorrentes de 5 PK e 3 UNIQUE, sem índices adicionais. O [inventário de índices](indices.md) apresenta sua finalidade e possíveis candidatos a avaliar, sem alegação de medição de desempenho.
