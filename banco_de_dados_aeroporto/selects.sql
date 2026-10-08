-- ____________________JOIN_________________
-- Operações de rota de cada companhia
-- Portões ocupados por operações de solo
-- Funcionários de cada operação de rota, com nome e setor
-- Operações de solo por companhia
-- Terceiros, companhia e solicitações
-- Solicitações por aeronave e funcionário responsável
-- Aeronaves sem nenhuma operação de rota
-- Pistas com designação, categoria ICAO e localização
-- Solicitações abertas por cada setor
-- Sequência de operações de solo encadeadas

-- ___________________ Exigidos pelo Professor____________________
-- Operações por companhia (Para cada companhia: quantidade operações, origem, destino)
select c.nome, op.origem, op.destino, count(op.id_operacao_rota) as quant_op from companhia as c
join aeronave as a
on a.id_companhia = c.id_companhia
join operacao_de_rota as op
on op.id_aeronave = a.id_aeronave
group by op.id_operacao_rota, c.nome, op.origem, op.destino
order by quant_op desc;

-- Trechos de operação (Para operação, trechos sequenciais e pontos de infraestrutura)


-- Solicitações por setor (Por setor: solicitações pendentes, aprovadas, rejeitadas)
-- Ocupação de infraestrutura (Por ponto: ocupação atual, histórico, disponibilidade)
-- Operadores por setor (Por setor: funcionários e volume processado)
-- Histórico de solicitações (Para companhia aérea: todas solicitações abertas/aprovadas/rejeitadas)
-- Infraestrutura em manutenção (Pontos em manutenção com datas início e previsão término)
-- Tempo de processamento (Por tipo solicitação: tempo médio análise e aprovação)
-- Frotas por companhia (Para companhia: tipos de aeronaves e capacidade)
-- Relatório operacional (Dashboard diário: pousos, decolagens, movimentações, incidentes)