# Matriz RN → mecanismo

CHECKs operam sobre a própria linha. Data de inscrição versus janela e preço inicial dependem de outras tabelas; transições dependem do estado anterior. Essas regras são atendidas por protocolos e privilégios, com os limites abaixo.

A matriz relaciona as 14 regras de negócio aos mecanismos e casos de teste. A reprodução segue o [README](../README.md); os resultados estão no [relatório de testes](../testes/relatorio_testes.md).

| RN | Mecanismo definitivo | Tabela/coluna | Script existente | Teste/evidência prevista | Limitação |
| --- | --- | --- | --- | --- | --- |
| RN01 | PK, FK, NOT NULL | edicao.id_evento; inscricao.id_edicao/id_categoria/id_participante | `sql/01_estrutura.sql` | TI01, TI04, TI06, TI19, TV01 | Referência inexistente ou vínculo obrigatório ausente é impedido. |
| RN02 | PK, UNIQUE, CHECK, NOT NULL | participante | `sql/01_estrutura.sql` | TI02, TI03, TI05, TV02 | Não se valida autenticidade/checksum; pessoa sem CPF pode ser duplicada na realidade. Revisão administrativa deve reutilizar o cadastro. |
| RN03 | FKs simples independentes, UNIQUE(nome) global, NOT NULL | categoria.id_categoria/nome; inscricao.id_categoria/id_edicao | `sql/01_estrutura.sql` | TI06, TI07, TI19, TI20, TV01 | Todas as categorias estão disponíveis em qualquer edição; não há preço ou lista por edição. |
| RN04 | CHECK de linha; operação controlada; diagnóstico | edicao; inscricao.data_inscricao | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql`, `sql/diagnosticos.sql` | TI08, TI09, TI10, TI11, TV03, OC01, TV07, DG01 | CHECK impede apenas incoerência na própria edição. Data de inscrição versus edição depende de OC01; DG01 detecta escrita direta indevida. |
| RN05 | Operação controlada em transação; DEFAULT | categoria.preco_vigente; inscricao.valor_contratado/situacao | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql` | TV04, OC01 | DEFAULT não impede INSERT com outro estado. Igualdade inicial não é uma FK/CHECK intertabela. Sem versões não se pode diagnosticar retrospectivamente toda cópia errada. |
| RN06 | CHECK, NOT NULL; operação controlada para reconhecimento | categoria.preco_vigente; inscricao.valor_contratado | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql` | TI12, TI13, TV04, TV05 | Não se verifica movimento financeiro externo; o gestor reconhece a quitação. |
| RN07 | UNIQUE participante/edição, FKs simples, NOT NULL | inscricao(id_participante,id_edicao) | `sql/01_estrutura.sql` | TI14, TV01, TC01 | Proteção é sobre o cadastro identificado, não sobre pessoa real sem identificação exclusiva. |
| RN09 | CHECK, NOT NULL, DEFAULT; operação controlada | inscricao.situacao | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql` | TI15, TV05, TV06, OC02, OC03, TC02 | CHECK valida o domínio, não o estado anterior. UPDATE direto pode burlar a transição. Não há trilha de situação. |
| RN12 | UNIQUE; operação controlada; privilégios sem DELETE | inscricao | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql`, `sql/acessos.sql` | TI14, TV06, PA03 | Não se recupera a data do cancelamento; proprietário/superusuário pode alterar o banco. |
| RN14 | Privilégios por coluna; FK; operação controlada; diagnóstico parcial | inscricao; categoria.preco_vigente; edicao.abertura_inscricoes/fechamento_inscricoes | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql`, `sql/acessos.sql` | TV04, TV08, PA02, PA03, OC04, OC05, DG01 | Snapshot do valor não é histórico de todos os preços. Configuração corrente de nome/local não tem versões. Proprietário pode ultrapassar privilégios. DG01 não prova valor originalmente copiado. |
| RN15 | Consultas SQL e views agregadas | Cinco tabelas; views gerenciais | `sql/01_estrutura.sql`, `sql/relatorios_nucleo.sql` | R01, R02, R03, R04, R05, TV09 | Não há receita líquida, instituições, forma/data de pagamento ou presença. Agregação não gera auditoria passada. |
| RN16 | CHECK | inscricao.canal_divulgacao | `sql/01_estrutura.sql`, `sql/relatorios_nucleo.sql` | TI16, R04, P03 | Não há cadastro de campanha ou rastreamento externo. |
| RN17 | GRANT/REVOKE; restrição de colunas; protocolo manual | Cinco tabelas e views; perfis eventos_operacao/eventos_consulta | `sql/acessos.sql`, `testes/acessos.sql` | PA01, PA02, PA03, PA04 | Perfis são criados manualmente no pgAdmin, sem senha no repositório. Conta proprietária/superusuário não é perfil de teste de acesso. Operador continua responsável por seguir os roteiros de transição/criação. |
| RN18 | Combinação de PK/FK/UNIQUE/NOT NULL/CHECK/operação/diagnóstico | Esquema vigente | `sql/01_estrutura.sql`, `sql/operacoes_controladas.sql`, `sql/diagnosticos.sql`, `sql/verificacoes_estrutura.sql` | Q00–Q09, P00–P05, TI01–TI20, TV01–TV09 | SERIALIZABLE pode abortar com SQLSTATE 40001; desfazer e repetir a transação inteira. A conferência de definições não substitui os resultados individuais dos testes. |

## Declarativo, protocolo e diagnóstico

PK/FK/nulabilidade, referências independentes a categoria/edição, CPF exclusivo/formato, nome global de categoria, uma inscrição pessoa/edição, calendário da própria edição, modalidade/local e domínios/valores positivos são declarativos. Categoria não determina edição; não há regra de coerência entre uma edição proprietária da categoria e a inscrição.

Igualdade do preço na criação, data intertabela, transições e mudanças de janela antes do uso dependem do protocolo SERIALIZABLE. O perfil operacional não recebe atualização de snapshots/vínculos/data nem DELETE. Seu INSERT omite situacao e usa DEFAULT. UPDATE(situacao) permite burlar a transição com SQL arbitrário: seguir OC02/OC03 é obrigação operacional, não garantia absoluta do banco.

DG01 detecta uma criação fora da janela se a escrita direta contornar OC01. Diagnósticos de referências são independentes para categoria e edição. Não recuperam estado anterior, preço passado ou data de quitação. Categoria é global e não possui operação de movimentação entre edições.

## Evidências

A [exploração de metadados](metadados_resumo.md) confere definições de tabelas e constraints. Transições, população e concorrência exigem os casos pertinentes. O [relatório de testes](../testes/relatorio_testes.md) apresenta os resultados e sua avaliação técnica.
