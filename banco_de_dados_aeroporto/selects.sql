-- _____________________________________________________________JOIN_____________________________________________________________
-- Operações de rota de cada companhia
SELECT 
    c.nome AS nome_companhia,
    a.codigo AS codigo_aeronave,
    r.origem,
    r.destino,
    r.data_inicio
FROM companhia c
JOIN aeronave a ON a.id_companhia = c.id_companhia
JOIN operacao_de_rota r ON r.id_aeronave = a.id_aeronave;

-- Portões ocupados por operações de solo
SELECT 
    p.numero AS numero_portao,
    p.terminal,
    p.tipo_de_embarque,
    os.origem,
    os.destino,
    os.data_inicio,
    os.data_termino
FROM portao p
JOIN infraestrutura i ON i.id_infraestrutura = p.id_portao
JOIN operacao_de_solo os ON os.id_infraestrutura = i.id_infraestrutura;

-- Funcionários de cada operação de rota, com nome e setor
SELECT 
    r.id_operacao_rota,
    r.origem,
    r.destino,
    u.nome AS nome_funcionario,
    f.matricula,
    s.nome AS nome_setor
FROM operacao_de_rota r
JOIN operacoes_rota_funcionario orf ON orf.id_operacao_rota = r.id_operacao_rota
JOIN funcionario f ON f.id_funcionario = orf.id_funcionario
JOIN usuario u ON u.id_usuario = f.id_funcionario
JOIN setor s ON s.id_setor = f.id_setor;
-- Operações de solo por companhia
SELECT 
    c.nome AS nome_companhia,
    a.codigo AS aeronave,
    os.id_operacao_solo,
    os.origem AS solo_origem,
    os.destino AS solo_destino,
    os.data_inicio
FROM companhia c
JOIN aeronave a ON a.id_companhia = c.id_companhia
JOIN operacao_de_rota r ON r.id_aeronave = a.id_aeronave
JOIN operacao_de_solo os ON os.id_operacao_rota = r.id_operacao_rota;
-- Terceiros, companhia e solicitações
SELECT 
    u.nome AS terceiro_nome,
    c.nome AS companhia_parceira,
    t.numero_de_identificacao,
    s.id_solicitacao,
    s.status AS status_solicitacao,
    s.data_solicitacao
FROM terceiro t
JOIN usuario u ON u.id_usuario = t.id_terceiro
JOIN companhia c ON c.id_companhia = t.id_companhia
JOIN terceiros_solicitacoes ts ON ts.id_terceiro = t.id_terceiro
JOIN solicitacao s ON s.id_solicitacao = ts.id_solicitacao;
-- Solicitações por aeronave e funcionário responsável
SELECT 
    s.id_solicitacao,
    a.codigo AS aeronave,
    u.nome AS funcionario_responsavel,
    f.cargo,
    s.status,
    s.prazo
FROM solicitacao s
JOIN aeronave a ON a.id_aeronave = s.id_aeronave
JOIN funcionario f ON f.id_funcionario = s.id_funcionario
JOIN usuario u ON u.id_usuario = f.id_funcionario;

-- Aeronaves sem nenhuma operação de rota

SELECT 
    a.id_aeronave,
    a.codigo,
    a.tipo_aeronave,
    a.status
FROM aeronave a
LEFT JOIN operacao_de_rota r ON r.id_aeronave = a.id_aeronave
WHERE r.id_operacao_rota IS NULL;

-- Pistas com designação, categoria ICAO e localização

SELECT 
    p.designacao AS designacao_pista,
    p.peso_maximo_suportado,
    am.categoria_ICAO,
    am.elevacao,
    i.localizacao
FROM pista p
JOIN area_de_manobra am ON am.id_area_manobra = p.id_pista
JOIN infraestrutura i ON i.id_infraestrutura = am.id_area_manobra;

-- Solicitações abertas por cada setor

SELECT 
    st.nome AS setor,
    u.nome AS funcionario,
    s.id_solicitacao,
    s.status,
    s.data_solicitacao
FROM setor st
JOIN funcionario f ON f.id_setor = st.id_setor
JOIN usuario u ON u.id_usuario = f.id_funcionario
JOIN solicitacao s ON s.id_funcionario = f.id_funcionario
WHERE s.status IN ('Pendente', 'Em análise', 'Em analise');

-- Sequência de operações de solo encadeadas

SELECT 
    atual.id_operacao_solo AS operacao_atual,
    atual.origem AS origem_atual,
    atual.destino AS destino_atual,
    prox.id_operacao_solo AS operacao_seguinte,
    prox.origem AS origem_seguinte,
    prox.destino AS destino_seguinte
FROM operacao_de_solo atual
JOIN operacao_de_solo prox ON prox.id_operacao_solo = atual.proxima_operacao;

-- Companhias com frota ativa expressiva

SELECT 
    c.nome AS companhia,
    COUNT(a.id_aeronave) AS total_aeronaves
FROM companhia c
JOIN aeronave a ON a.id_companhia = c.id_companhia
GROUP BY c.id_companhia, c.nome
HAVING COUNT(a.id_aeronave) > 3
ORDER BY total_aeronaves DESC;

-- Aeronaves de uso intenso

SELECT 
    a.codigo AS prefixo_aeronave,
    COUNT(r.id_operacao_rota) AS total_operacoes
FROM aeronave a
JOIN operacao_de_rota r ON r.id_aeronave = a.id_aeronave
GROUP BY a.id_aeronave, a.codigo
HAVING COUNT(r.id_operacao_rota) > 10
ORDER BY total_operacoes DESC;

-- Setores de grande porte

SELECT 
    s.nome AS setor,
    COUNT(f.id_funcionario) AS total_funcionarios
FROM setor s
JOIN funcionario f ON f.id_setor = s.id_setor
GROUP BY s.id_setor, s.nome
HAVING COUNT(f.id_funcionario) > 2
ORDER BY total_funcionarios DESC;

-- Origens com alto tráfego aéreo

SELECT 
    r.origem,
    COUNT(r.id_operacao_rota) AS total_voos
FROM operacao_de_rota r
GROUP BY r.origem
HAVING COUNT(r.id_operacao_rota) > 20
ORDER BY total_voos DESC;

-- Tipos de solicitação mais recorrentes

SELECT 
    ts.nome AS tipo_solicitacao,
    COUNT(s.id_solicitacao) AS total_solicitacoes
FROM tipo_solicitacao ts
JOIN solicitacao s ON s.id_tipo_solicitacao = ts.id_tipo_solicitacao
GROUP BY ts.id_tipo_solicitacao, ts.nome
HAVING COUNT(s.id_solicitacao) >= 5
ORDER BY total_solicitacoes DESC;


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

-- Infraestrutura em manutenção (Pontos em manutenção com datas início e previsão término)
select
	case
		when h.id_hangar is not null then 'Hangar'
        when p.id_portao is not null then 'Portao'
        when pi.id_pista is not null then 'Pista'
        when ptx.id_pista_taxi is not null then 'Pista_de_Taxi'
        when am.id_area_manobra is not null then 'Area_de_Manobra'
	end as tipo_pista,
    i.localizacao, mi.data_inicio, mi.previsao_termino
 from infraestrutura as i
 join manutencao_infraestrutura as mi on mi.id_infraestrutura = i.id_infraestrutura and mi.status = 'Em andamento'
 left join portao as p on p.id_portao = i.id_infraestrutura
 left join hangar as h on h.id_hangar = i.id_infraestrutura
 left join area_de_manobra as am on am.id_area_manobra = i.id_infraestrutura
 left join pista as pi on pi.id_pista = am.id_area_manobra
 left join pista_de_taxi as ptx on ptx.id_pista_taxi = am.id_area_manobra
 order by tipo_pista;
 
-- Tempo de processamento (Por tipo solicitação: tempo médio análise e aprovação)
select ts.id_tipo_solicitacao, ts.nome, round((round(avg(timestampdiff(minute, s.data_inicio_analise, s.data_decisao))))/60) as temp_horas, count(s.id_solicitacao) as qtd_aprovacoes from tipo_solicitacao as ts
join solicitacao as s on s.id_tipo_solicitacao = ts.id_tipo_solicitacao
where s.status in ('Aprovada', 'Concluída')
group by ts.id_tipo_solicitacao, ts.nome
order by qtd_aprovacoes desc;

-- Frotas por companhia (Para companhia: tipos de aeronaves e capacidade)
select c.nome, a.tipo_aeronave, count(a.id_aeronave) as qtd_aeronaves, a.capacidade_passageiros, a.capacidade_carga_kg from aeronave as a
join companhia as c on c.id_companhia = a.id_companhia
group by a.tipo_aeronave, c.nome, c.id_companhia, a.capacidade_passageiros, a.capacidade_carga_kg
order by c.nome, a.tipo_aeronave;

-- Relatório operacional (Dashboard diário: pousos, decolagens, movimentações, incidentes)
select c.nome as companhia, 
	round(count(distinct r.id_operacao_rota) / p.dias, 2), 
	round(coalesce(sum(r.objetivo = 'Voo internacional de passageiros'), 0) / p.dias, 2) as voo_internacional,
	round(coalesce(sum(r.objetivo = 'Voo comercial de passageiros'), 0) / p.dias, 2) as voo_comercial,
    round(coalesce(sum(r.objetivo = 'Voo cargueiro'), 0)) as voo_cargueiro,
    round(coalesce(sum(r.objetivo = 'Translado para manutenção programada'), 0)) as translado_manutencao,
    round(coalesce(sum(r.objetivo = 'Voo fretado'), 0)) as voo_fretado,
    round(coalesce(sum(r.objetivo = 'Reposicionamento de aeronave'), 0)) as reposicionamento,
    round(coalesce(sum(inc.qtd), 0) / p.dias, 2)
from operacao_de_rota as r
left join aeronave as a on a.id_aeronave = r.id_aeronave
left join companhia as c on c.id_companhia = a.id_companhia
cross join (
	select datediff(max(date(data_inicio)), min(date(data_inicio))) + 1 as dias
    from operacao_de_rota
) as p
left join(
	select id_operacao_rota, count(*) as qtd
    from incidente_operacional
    group by id_operacao_rota
) as inc on inc.id_operacao_rota = r.id_operacao_rota
group by c.id_companhia, c.nome, p.dias
order by companhia;