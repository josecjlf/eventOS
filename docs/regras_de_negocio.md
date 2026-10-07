# Regras de negócio — núcleo gerencial

As **14 RN** abaixo detalham o [escopo](escopo_requisitos.md) e as condições do [MER](../modelos/mer_especificacao.md). Os identificadores relacionam cada regra às matrizes e aos casos de teste.

**D**: declarativa; **O**: operação controlada; **Q**: consulta que detecta; **A**: acesso. Operação e diagnóstico têm alcances diferentes de uma constraint. Reprodução: [README](../README.md). A origem e a comprovação dos resultados estão no [relatório de testes](../testes/relatorio_testes.md).

## RN01 — Hierarquia e cadastros

- **Descrição:** Evento → Edição; Inscrição pertence diretamente a uma edição, um participante e uma categoria existentes. Categoria é global e pode classificar inscrições de qualquer edição. Cadastros sem filhos são permitidos.
- **Origem:** Enunciado e MER aprovado.
- **RF/RE:** RF1, RF5, RF28.
- **Entidades/relações e colunas:** edicao.id_evento; inscricao.id_edicao/id_categoria/id_participante.
- **Mecanismo:** PK, FK, NOT NULL.
- **Estado a impedir/preservar e limite:** Referência inexistente ou vínculo obrigatório ausente é impedido.
- **Demonstração:** TI01, TI04, TI06, TI19, TV01; reprodução conforme o [README](../README.md).

## RN02 — Identidade do participante

- **Descrição:** Código identifica o cadastro. CPF opcional tem onze dígitos exclusivos quando informado. Nome/e-mail podem repetir e não são usados para fusão.
- **Origem:** Escolha do recorte aprovada.
- **RF/RE:** RF3, RF30, RF28.
- **Entidades/relações e colunas:** participante.
- **Mecanismo:** PK, UNIQUE, CHECK, NOT NULL.
- **Estado a impedir/preservar e limite:** Não se valida autenticidade/checksum; pessoa sem CPF pode ser duplicada na realidade. Revisão administrativa deve reutilizar o cadastro.
- **Demonstração:** TI02, TI03, TI05, TV02; reprodução conforme o [README](../README.md).

## RN03 — Categoria global e referências independentes

- **Descrição:** Toda categoria cadastrada pode ser utilizada em qualquer edição. Inscrição escolhe uma categoria global e uma edição existentes, por referências independentes. Nome de categoria é distinto em todo o catálogo.
- **Origem:** Regra derivada.
- **RF/RE:** RF5, RF6, RF28.
- **Entidades/relações e colunas:** categoria.id_categoria/nome; inscricao.id_categoria/id_edicao.
- **Mecanismo:** Duas FKs simples e independentes, UNIQUE(nome) global, NOT NULL.
- **Estado a impedir/preservar e limite:** Não há lista ou preço de categoria específicos por edição, relação Categoria→Edição, entidade de faixa ou superchave de contexto.
- **Demonstração:** TI06, TI07, TI19, TI20, TV01; reprodução conforme o [README](../README.md).

## RN04 — Calendário e criação dentro da janela

- **Descrição:** Início ≤ fim de realização; abertura ≤ fechamento ≤ fim. Data de criação da inscrição está no intervalo inclusivo da edição. Local corresponde à modalidade.
- **Origem:** MER aprovado e regra derivada.
- **RF/RE:** RF1, RF6, RF28.
- **Entidades/relações e colunas:** edicao; inscricao.data_inscricao.
- **Mecanismo:** CHECK de linha; operação controlada; diagnóstico.
- **Estado a impedir/preservar e limite:** CHECK impede apenas incoerência na própria edição. Data de inscrição versus edição depende de OC01; DG01 detecta escrita direta indevida.
- **Demonstração:** TI08, TI09, TI10, TI11, TV03, OC01, TV07, DG01; reprodução conforme o [README](../README.md).

## RN05 — Preço inicial contratado

- **Descrição:** OC01 copia o preço global vigente da categoria no momento lógico da criação, independentemente da edição escolhida. Novo cadastro nasce PENDENTE.
- **Origem:** Enunciado refinado e escolha do recorte.
- **RF/RE:** RF6, RF27, RF28.
- **Entidades/relações e colunas:** categoria.preco_vigente; inscricao.valor_contratado/situacao.
- **Mecanismo:** Operação controlada em transação; DEFAULT.
- **Estado a impedir/preservar e limite:** DEFAULT não impede INSERT com outro estado. Igualdade inicial não é uma FK/CHECK intertabela. Sem versões não se pode diagnosticar retrospectivamente toda cópia errada.
- **Demonstração:** TV04, OC01; reprodução conforme o [README](../README.md).

## RN06 — Cobrança integral positiva

- **Descrição:** Preço e contrato positivos, DECIMAL(12,2), em reais. PAGA significa quitação integral do contrato. Sem parcela, desconto, gratuidade ou moeda adicional.
- **Origem:** Escolha do recorte.
- **RF/RE:** RF6, RF13, RF27, RF28.
- **Entidades/relações e colunas:** categoria.preco_vigente; inscricao.valor_contratado.
- **Mecanismo:** CHECK, NOT NULL; operação controlada para reconhecimento.
- **Estado a impedir/preservar e limite:** Não se verifica movimento financeiro externo; o gestor reconhece a quitação.
- **Demonstração:** TI12, TI13, TV04, TV05; reprodução conforme o [README](../README.md).

## RN07 — Uma inscrição por participante e edição

- **Descrição:** No máximo uma inscrição por pessoa cadastrada e edição, inclusive CANCELADA e independentemente da categoria. Outra edição é permitida.
- **Origem:** Decisão mantida do recorte.
- **RF/RE:** RF3, RF9, RF28.
- **Entidades/relações e colunas:** inscricao(id_participante,id_edicao).
- **Mecanismo:** UNIQUE participante/edição, FKs simples, NOT NULL.
- **Estado a impedir/preservar e limite:** Proteção é sobre o cadastro identificado, não sobre pessoa real sem identificação exclusiva.
- **Demonstração:** TI14, TV01, TC01; reprodução conforme o [README](../README.md).

## RN09 — Situação atual e transições

- **Descrição:** Estados válidos PENDENTE/PAGA/CANCELADA. Nasce PENDENTE; só PENDENTE→PAGA ou PENDENTE→CANCELADA. PAGA/CANCELADA terminais. Quitação posterior ao fechamento é permitida.
- **Origem:** Simplificação aprovada.
- **RF/RE:** RF9, RF13, RF28.
- **Entidades/relações e colunas:** inscricao.situacao.
- **Mecanismo:** CHECK, NOT NULL, DEFAULT; operação controlada.
- **Estado a impedir/preservar e limite:** CHECK valida o domínio, não o estado anterior. UPDATE direto pode burlar a transição. Não há trilha de situação.
- **Demonstração:** TI15, TV05, TV06, OC02, OC03, TC02; reprodução conforme o [README](../README.md).

## RN12 — Cancelamento sem apagar contratação

- **Descrição:** Cancelamento apenas de PENDENTE, por mudança para CANCELADA. Manter a inscrição e sua unicidade. Não cancelar PAGA, reabrir, reembolsar ou liberar reinscrição.
- **Origem:** Escolha do recorte.
- **RF/RE:** RF9, RF27, RF28.
- **Entidades/relações e colunas:** inscricao.
- **Mecanismo:** UNIQUE; operação controlada; privilégios sem DELETE.
- **Estado a impedir/preservar e limite:** Não se recupera a data do cancelamento; proprietário/superusuário pode alterar o banco.
- **Demonstração:** TI14, TV06, PA03; reprodução conforme o [README](../README.md).

## RN14 — Preservar contrato e vínculos

- **Descrição:** Preservar data, valor, participante, categoria e edição da inscrição. Janela não é reescrita após inscrições. Reajuste do preço global de categoria afeta apenas novos contratos em todas as edições; snapshots anteriores permanecem.
- **Origem:** RF27 refinado e MER aprovado.
- **RF/RE:** RF27, RF28.
- **Entidades/relações e colunas:** inscricao.id_participante/id_categoria/id_edicao/data_inscricao/valor_contratado; categoria.preco_vigente; edicao.abertura_inscricoes/fechamento_inscricoes.
- **Mecanismo:** Privilégios por coluna; FK; operação controlada; diagnóstico parcial.
- **Estado a impedir/preservar e limite:** Snapshot do valor não é histórico de todos os preços. Configuração corrente de nome/local não tem versões. Proprietário pode ultrapassar privilégios. DG01 não prova valor originalmente copiado.
- **Demonstração:** TV04, TV08, PA02, PA03, OC04, OC05, DG01; reprodução conforme o [README](../README.md).

## RN15 — Relatórios do núcleo atual

- **Descrição:** Contar por evento/edição/categoria, situação, data original e canal. Recebimento bruto atual = soma dos contratos PAGA; pendência = PENDENTE; canceladas separadas. Evolução acumulada é de criações, não de pagamentos históricos.
- **Origem:** Escolha do recorte.
- **RF/RE:** RF26.
- **Entidades/relações e colunas:** Cinco tabelas; views gerenciais.
- **Mecanismo:** Consultas SQL e views agregadas.
- **Estado a impedir/preservar e limite:** Não há receita líquida, instituições, forma/data de pagamento ou presença. Agregação não gera auditoria passada.
- **Demonstração:** R01, R02, R03, R04, R05, TV09; reprodução conforme o [README](../README.md).

## RN16 — Canal de divulgação

- **Descrição:** Canal opcional e único: SITE_EVENTO, REDE_SOCIAL, EMAIL, INDICACAO ou OUTRO. NULL = não informado.
- **Origem:** Extensão aprovada.
- **RF/RE:** RE1, RF26, RF28.
- **Entidades/relações e colunas:** inscricao.canal_divulgacao.
- **Mecanismo:** CHECK.
- **Estado a impedir/preservar e limite:** Não há cadastro de campanha ou rastreamento externo.
- **Demonstração:** TI16, R04, P03; reprodução conforme o [README](../README.md).

## RN17 — Minimização e acesso

- **Descrição:** Dados fictícios. Consulta gerencial apenas em views agregadas sem dados pessoais; operação por conta sem privilégios de proprietário. CPF é facultativo e não representa documento armazenado.
- **Origem:** Enunciado refinado e decisão de governança.
- **RF/RE:** RF30.
- **Entidades/relações e colunas:** Cinco tabelas e views; perfis eventos_operacao/eventos_consulta.
- **Mecanismo:** GRANT/REVOKE; restrição de colunas; protocolo manual.
- **Estado a impedir/preservar e limite:** Perfis são criados manualmente no pgAdmin, sem senha no repositório. Conta proprietária/superusuário não é perfil de teste de acesso. Operador continua responsável por seguir os roteiros de transição/criação. Na criação informa separadamente id_edicao e id_categoria; não recebe alteração dos vínculos/snapshots e o INSERT operacional omite situacao, usando DEFAULT.
- **Demonstração:** PA01, PA02, PA03, PA04; reprodução conforme o [README](../README.md).

## RN18 — Integridade e alcance honesto

- **Descrição:** Cada regra tem mecanismo e evidência. CHECK só usa a linha. FK/UNIQUE/NOT NULL impedem; operações condicionadas impedem quando executadas pelo protocolo; diagnósticos apenas detectam.
- **Origem:** Enunciado e limite técnico.
- **RF/RE:** RF28.
- **Entidades/relações e colunas:** Esquema vigente.
- **Mecanismo:** Combinação de PK/FK/UNIQUE/NOT NULL/CHECK/operação/diagnóstico.
- **Estado a impedir/preservar e limite:** SERIALIZABLE pode abortar com SQLSTATE 40001; desfazer e repetir a transação inteira. Metadados conferem definições implantadas; não comprovam transições, concorrência ou totais de dados. A comprovação de uma regra depende das evidências pertinentes, sem aprovação por associação.
- **Demonstração:** Q00–Q09, P00–P05, TI01–TI20, TV01–TV09; reprodução conforme o [README](../README.md).

## Protocolo transacional comum

Operações OC01–OC05 estão em [sql/operacoes_controladas.sql](../sql/operacoes_controladas.sql). Categoria é global e não possui edição proprietária nem operação de movimentação entre edições. Executar **um bloco por vez**: START TRANSACTION; SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; ato condicionado; conferência do número de linhas e do resultado; COMMIT só se o ato permitido afetou exatamente uma linha, caso contrário ROLLBACK. Erro 40001 exige ROLLBACK e repetição integral, nunca apenas a última instrução. Não usar bloqueios específicos do PostgreSQL.

Para testes, usar os IDs/datas indicados nos blocos; para operação normal, substituir os parâmetros antes de começar. Datas sintéticas não constituem prova de execução real. A carga de referência pode inserir estados atuais diretamente; o protocolo “nasce PENDENTE” rege novas inscrições.

Não existem regras atuais de análise documental, tentativas recusadas, chegada ou trajetória histórica. Os requisitos correspondentes foram retirados formalmente do recorte, sem simular atendimento.

## Evidências

A [matriz de mecanismos](matriz_regra_mecanismo.md) relaciona cada RN aos scripts e casos de teste. A exploração de [metadados](metadados_resumo.md) descreve as definições implantadas. Os resultados e sua avaliação estão no [relatório de testes](../testes/relatorio_testes.md).
