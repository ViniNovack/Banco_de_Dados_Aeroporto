-- _____________________________________________________________JOIN_____________________________________________________________
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


-- _____________________________________________________________Exigidos pelo Professor_____________________________________________________________
-- Operações por companhia (Para cada companhia: quantidade operações, origem, destino)
select c.id_companhia, c.nome as companhia, op.origem, op.destino,
       count(op.id_operacao_rota) as quantidade_operacoes
from companhia c
join aeronave a on a.id_companhia = c.id_companhia
join operacao_de_rota op on op.id_aeronave = a.id_aeronave
group by c.id_companhia, c.nome, op.origem, op.destino
order by quantidade_operacoes desc, c.nome;

-- Trechos de operação (Para operação, trechos sequenciais e pontos de infraestrutura)
select
    r.id_operacao_rota,
    s.id_operacao_solo as trecho_atual,
    case
        when h.id_hangar        is not null then 'Hangar'
        when po.id_portao       is not null then 'Portao'
        when pst.id_pista       is not null then 'Pista'
        when tx.id_pista_taxi   is not null then 'Pista de Taxi'
        when am.id_area_manobra is not null then 'Area de Manobra'
    end as tipo_ponto_atual,
    s.id_infraestrutura as id_ponto_atual,
    s2.id_operacao_solo as trecho_seguinte,
    case
        when h2.id_hangar        is not null then 'Hangar'
        when po2.id_portao       is not null then 'Portao'
        when pst2.id_pista       is not null then 'Pista'
        when tx2.id_pista_taxi   is not null then 'Pista de Taxi'
        when am2.id_area_manobra is not null then 'Area de Manobra'
    end as tipo_ponto_seguinte,
    s2.id_infraestrutura as id_ponto_seguinte
from Operacao_de_Rota as r
join Operacao_de_Solo as s
    on s.id_operacao_rota = r.id_operacao_rota
left join Hangar          as h   on h.id_hangar          = s.id_infraestrutura
left join Portao          as po  on po.id_portao         = s.id_infraestrutura
left join Area_de_Manobra as am  on am.id_area_manobra   = s.id_infraestrutura
left join Pista           as pst on pst.id_pista         = am.id_area_manobra
left join Pista_de_Taxi   as tx  on tx.id_pista_taxi     = am.id_area_manobra
left join Operacao_de_Solo as s2
    on s2.id_operacao_solo = s.proxima_operacao
left join Hangar          as h2   on h2.id_hangar        = s2.id_infraestrutura
left join Portao          as po2  on po2.id_portao       = s2.id_infraestrutura
left join Area_de_Manobra as am2  on am2.id_area_manobra = s2.id_infraestrutura
left join Pista           as pst2 on pst2.id_pista       = am2.id_area_manobra
left join Pista_de_Taxi   as tx2  on tx2.id_pista_taxi   = am2.id_area_manobra
order by r.id_operacao_rota;

-- Solicitações por setor (Por setor: solicitações pendentes, aprovadas, rejeitadas)
select st.id_setor, st.nome as setor,
       count(s.id_solicitacao) as total_solicitacoes,
       sum(lower(s.status) in ('pendente', 'em análise', 'em analise')) as pendentes,
       sum(lower(s.status) in ('aprovada', 'aceita')) as aprovadas,
       sum(lower(s.status) in ('recusada', 'rejeitada')) as rejeitadas,
       sum(lower(s.status) in ('concluída', 'concluida', 'concluído', 'concluido')) as concluidas
from setor st
left join funcionario f on f.id_setor = st.id_setor
left join solicitacao s on s.id_funcionario = f.id_funcionario
group by st.id_setor, st.nome
order by st.nome;

-- Ocupação de infraestrutura (Por ponto: ocupação atual, histórico, disponibilidade)
select i.id_infraestrutura,
	case
		when h.id_hangar is not null then 'Hangar'
        when p.id_portao is not null then 'Portao'
        when pi.id_pista is not null then 'Pista'
        when pt.id_pista_taxi is not null then 'Pista de Taxi'
        when am.id_area_manobra is not null then 'AreaDeManobra'
	end as tipo_pista,
    case when i.ocupado then 'Ocupado' else 'Livre' end as ocupacao_atual,
    count(s.id_operacao_solo) as total_operacoes,
    coalesce(sum(s.data_inicio <= now() and (s.data_termino is null or s.data_termino >= now())), 0) as operacoes_em_andamento
    from infraestrutura as i
    left join hangar as h on h.id_hangar = i.id_infraestrutura
    left join portao as p on p.id_portao = i.id_infraestrutura
    left join area_de_manobra as am on am.id_area_manobra = i.id_infraestrutura
    left join pista as pi on pi.id_pista = am.id_area_manobra
    left join pista_de_taxi as pt on pt.id_pista_taxi = am.id_area_manobra
    left join operacao_de_solo as s on s.id_infraestrutura = i.id_infraestrutura
    group by i.id_infraestrutura, h.id_hangar, p.id_portao, am.id_area_manobra, pi.id_pista, pt.id_pista_taxi
    order by i.id_infraestrutura;

-- Operadores por setor (Por setor: funcionários e volume processado)
select s.id_setor, s.nome, count(distinct f.id_funcionario) as qtd_funcionarios, count(distinct opr.id_operacao_rota) as qtd_operacoes, count(distinct so.id_solicitacao) as qtd_solicitacoes from setor as s
left join funcionario as f on f.id_setor = s.id_setor
left join operacoes_rota_funcionario as orf on orf.id_funcionario = f.id_funcionario
left join operacao_de_rota as opr on opr.id_operacao_rota = orf.id_operacao_rota
left join solicitacao as so on so.id_funcionario = f.id_funcionario
group by s.id_setor, s.nome
order by s.id_setor;

-- Histórico de solicitações (Para companhia aérea: todas solicitações abertas/aprovadas/rejeitadas)
select c.nome, s.status, count(s.id_solicitacao) as qnt_solicitacoes from solicitacao as s
join terceiros_solicitacoes as ts on ts.id_solicitacao = s.id_solicitacao
join terceiro as t on t.id_terceiro = ts.id_terceiro
join companhia as c on c.id_companhia = t.id_companhia
group by s.status, c.id_companhia, c.nome
order by s.status;

-- Infraestrutura em manutenção: situação atual e histórico de datas.
select i.id_infraestrutura, i.localizacao, i.em_manutencao,
       m.data_inicio, m.previsao_termino, m.data_termino,
       m.descricao, m.status as status_manutencao
from infraestrutura i
left join manutencao_infraestrutura m
  on m.id_infraestrutura = i.id_infraestrutura and m.data_termino is null
order by i.em_manutencao desc, m.previsao_termino;

-- Tempo médio por tipo: análise (início até fim) e decisão (fim da análise até decisão).
select ts.id_tipo_solicitacao, ts.nome as tipo_solicitacao,
       count(s.id_solicitacao) as total_solicitacoes,
       round(avg(timestampdiff(minute, s.data_inicio_analise, s.data_fim_analise)), 2) as media_analise_minutos,
       round(avg(timestampdiff(minute, s.data_fim_analise, s.data_decisao)), 2) as media_decisao_minutos
from tipo_solicitacao ts
left join solicitacao s on s.id_tipo_solicitacao = ts.id_tipo_solicitacao
group by ts.id_tipo_solicitacao, ts.nome
order by ts.nome;

-- Frotas por companhia: tipo, quantidade e capacidade total.
select c.id_companhia, c.nome as companhia, a.tipo_aeronave,
       count(a.id_aeronave) as quantidade_aeronaves,
       sum(a.capacidade_passageiros) as capacidade_total_passageiros,
       sum(a.capacidade_carga_kg) as capacidade_total_carga_kg
from companhia c
left join aeronave a on a.id_companhia = c.id_companhia
group by c.id_companhia, c.nome, a.tipo_aeronave
order by c.nome, a.tipo_aeronave;

-- Dashboard diário. Troque CURDATE() por uma data específica, se necessário.
set @data_relatorio = curdate();
select @data_relatorio as data_relatorio,
    (select count(*) from operacao_de_rota r
     where date(r.data_inicio) = @data_relatorio
       and (lower(r.objetivo) like '%pous%' or lower(r.objetivo) like '%landing%')) as pousos,
    (select count(*) from operacao_de_rota r
     where date(r.data_inicio) = @data_relatorio
       and (lower(r.objetivo) like '%decol%' or lower(r.objetivo) like '%takeoff%')) as decolagens,
    (select count(*) from operacao_de_solo s
     where date(s.data_inicio) = @data_relatorio) as movimentacoes_solo,
    (select count(*) from incidente_operacional i
     where date(i.data_hora) = @data_relatorio) as incidentes;

-- Histórico de incidentes por dia, gravidade e status.
select date(data_hora) as dia, gravidade, status, count(*) as quantidade
from incidente_operacional
group by date(data_hora), gravidade, status
order by dia desc, gravidade;