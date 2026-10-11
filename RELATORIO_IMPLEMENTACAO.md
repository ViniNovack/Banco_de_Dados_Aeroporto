# Relatório de implementação — Banco de Dados do Aeroporto

## Objetivo
Preparar o esquema para suportar quatro relatórios que estavam apenas como tópicos em `selects.sql`: infraestrutura em manutenção, tempo de processamento de solicitações, frotas por companhia e painel operacional diário.

## Arquivos alterados
- `banco_de_dados_aeroporto/creats.sql`: ampliação do esquema por meio dos próprios `CREATE TABLE` e campos definidos na criação; nenhum `ALTER TABLE` foi utilizado.
- `banco_de_dados_aeroporto/inserts.sql`: dados de demonstração para manutenção, tipos de solicitação, capacidades/tipos de aeronave, tempos de processamento e incidentes.
- `banco_de_dados_aeroporto/selects.sql`: implementação dos quatro relatórios, consulta de incidentes por dia e correção da agregação de operações por companhia e de solicitações por setor.
- `Modelos/Conceptual_Logical_Models.xml` e `Modelos/Modelos_Conceitual_Logico.xml`: inclusão de campos e entidades de relatório na página lógica e nota explicativa na página conceitual.
- `RELATORIO_IMPLEMENTACAO.md`: este documento.

## Alterações de modelagem

### Infraestrutura e manutenção
- Adicionado `Infraestrutura.em_manutencao BOOLEAN NOT NULL DEFAULT FALSE`.
- Criada `Manutencao_Infraestrutura`, com data de início, previsão de término, término real, descrição e status.
- O booleano representa o estado atual; a tabela de manutenção preserva o histórico. Assim, não é necessário tentar guardar várias datas na tabela `Infraestrutura`.

### Solicitações e processamento
- Criada `Tipo_Solicitacao` para classificar os pedidos.
- Adicionado `solicitacao.id_tipo_solicitacao` como chave estrangeira.
- Adicionados `data_inicio_analise`, `data_fim_analise` e `data_decisao`.
- A consulta calcula a média em minutos para análise e para o intervalo entre o fim da análise e a decisão final.

### Frotas
- Adicionados `tipo_aeronave`, `capacidade_passageiros` e `capacidade_carga_kg` à tabela `aeronave`.
- O relatório agrupa as aeronaves por companhia e tipo e soma as capacidades.

### Relatório operacional e incidentes
- Criada `Incidente_Operacional`, com data/hora, tipo, gravidade, descrição, status e referências opcionais a operação de rota e infraestrutura.
- O dashboard diário retorna pousos, decolagens, movimentações de solo e incidentes para `@data_relatorio`, inicialmente definida como `CURDATE()`.

## Dados de demonstração
O arquivo de carga adiciona exemplos para que os relatórios tenham dados com os quais trabalhar. Os tipos e capacidades atribuídos à frota, tempos de processamento e incidentes são **dados fictícios para demonstração**, não dados operacionais reais. As datas de manutenção/incidentes acompanham o cenário de exemplo já existente no script.

## Como executar
1. Execute `banco_de_dados_aeroporto/creats.sql`.
2. Execute `banco_de_dados_aeroporto/inserts.sql`.
3. Execute `banco_de_dados_aeroporto/selects.sql`.
4. Para consultar outro dia no dashboard, altere `SET @data_relatorio = CURDATE();` para `SET @data_relatorio = 'AAAA-MM-DD';`.

> Como `creats.sql` começa com `DROP DATABASE IF EXISTS`, executar novamente o script de criação apaga e recria o banco. Faça backup antes de executar em um banco que contenha dados que deseja preservar.

## Observações
- Os novos campos foram incorporados diretamente aos comandos de criação; não foram usados comandos `ALTER TABLE`.
- Os tempos médios só consideram registros que possuem os timestamps necessários, pois `AVG` ignora valores nulos.
- O dashboard usa a data de início da operação de rota para pousos/decolagens e a data de início da operação de solo para movimentações.
- A classificação de pouso/decolagem considera palavras em português e inglês no campo `objetivo`; os valores desse campo devem seguir uma nomenclatura consistente.
- Os arquivos XML foram atualizados preservando os diagramas e conexões anteriores e adicionando as novas entidades de apoio. Recomenda-se abrir ambos no diagrams.net para conferência visual final.
