-- ___________________________________VIEWs___________________________________
-- 1. Aeronaves em operações de rota ativas
-- Utilidade: permite acompanhar quais aeronaves estão atualmente envolvidas em operações de rota, 
-- identificando também a companhia responsável por cada operação. Facilita o controle operacional 
-- e a consulta da movimentação das companhias no aeroporto.
CREATE OR REPLACE VIEW vw_aeronave_em_operacao AS
SELECT
    r.id_operacao_rota,
    a.id_aeronave,
    a.codigo AS codigo_aeronave,
    a.tipo_aeronave,
    c.nome AS nome_companhia,
    r.origem,
    r.destino,
    r.data_inicio,
    r.data_termino
FROM operacao_de_rota AS r
JOIN aeronave AS a
	ON a.id_aeronave = r.id_aeronave
JOIN companhia AS c
	on c.id_companhia = a.id_companhia
WHERE r.data_inicio <= NOW() AND (r.data_termino IS NULL OR r.data_termino >= NOW());

-- 2. Infraestruturas bloqueadas ou em manutenção
-- Utilidade: permite que os setores de operações e manutenção identifiquem quais estruturas não podem ser utilizadas. 
-- Isso facilita o planejamento de rotas, pousos, decolagens e atividades de manutenção.
CREATE OR REPLACE VIEW vw_infraestruturas_indisponiveis AS
SELECT i.id_infraestrutura, i.localizacao,
    CASE
        WHEN h.id_hangar IS NOT NULL THEN 'Hangar'
        WHEN p.id_portao IS NOT NULL THEN 'Portao'
        WHEN pi.id_pista IS NOT NULL THEN 'Pista'
        WHEN pt.id_pista_taxi IS NOT NULL THEN 'Pista de Taxi'
        WHEN am.id_area_manobra IS NOT NULL THEN 'Area de Manobra'
    END AS tipo_infraestrutura,
    CASE
        WHEN i.em_manutencao = TRUE OR mi.id_infraestrutura IS NOT NULL THEN 'Em manutencao'
        WHEN i.ocupado = TRUE THEN 'Ocupada' END AS situacao,
    i.ocupado,
    i.em_manutencao,
    mi.data_inicio,
    mi.previsao_termino,
    mi.descricoes AS descricao_manutencao
FROM infraestrutura AS i
LEFT JOIN hangar AS h
    ON h.id_hangar = i.id_infraestrutura
LEFT JOIN portao AS p
    ON p.id_portao = i.id_infraestrutura
LEFT JOIN area_de_manobra AS am
    ON am.id_area_manobra = i.id_infraestrutura
LEFT JOIN pista AS pi
    ON pi.id_pista = am.id_area_manobra
LEFT JOIN pista_de_taxi AS pt
    ON pt.id_pista_taxi = am.id_area_manobra
LEFT JOIN (
    SELECT
        id_infraestrutura,
        MIN(data_inicio) AS data_inicio,
        MAX(previsao_termino) AS previsao_termino,
        GROUP_CONCAT(descricao SEPARATOR '; ') AS descricoes
    FROM manutencao_infraestrutura
    WHERE status = 'Em andamento'
    GROUP BY id_infraestrutura
) AS mi
    ON mi.id_infraestrutura = i.id_infraestrutura
WHERE
    i.ocupado = TRUE
    OR i.em_manutencao = TRUE
    OR mi.id_infraestrutura IS NOT NULL;

-- 3. Operações de rota realizadas no dia
-- Utilidade: facilita o acompanhamento diário dos voos e permite gerar relatórios sobre a movimentação de aeronaves no
-- aeroporto. Também possibilita identificar quais companhias realizaram operações em determinado período.
CREATE OR REPLACE VIEW vw_operacoes_de_rota_diarias AS
SELECT
    r.id_operacao_rota,
    DATE(r.data_inicio) AS data_operacao,
    a.codigo AS codigo_aeronave,
    a.tipo_aeronave,
    c.nome AS nome_companhia,
    r.origem,
    r.destino,
    r.data_inicio,
    r.data_termino,
    r.objetivo
FROM operacao_de_rota AS r
LEFT JOIN aeronave AS a
    ON a.id_aeronave = r.id_aeronave
LEFT JOIN companhia AS c
    ON c.id_companhia = a.id_companhia;

-- 4. Frota e capacidade por companhia
-- Utilidade: permite consultar a composição da frota de cada companhia e comparar a capacidade de transporte das aeronaves.
-- Essas informações podem auxiliar no planejamento da infraestrutura e na análise da capacidade operacional das companhias.
CREATE OR REPLACE VIEW vw_frota_por_companhia AS
SELECT
    c.id_companhia,
    c.nome AS nome_companhia,
    a.tipo_aeronave,
    COUNT(a.id_aeronave) AS quantidade_aeronaves,
    SUM(a.capacidade_passageiros) AS capacidade_total_passageiros,
    SUM(a.capacidade_carga_kg) AS capacidade_total_carga_kg
FROM companhia AS c
JOIN aeronave AS a ON a.id_companhia = c.id_companhia
GROUP BY c.id_companhia, c.nome, a.tipo_aeronave;

-- 5. Histórico de incidentes e acidentes operacionais
-- Utilidade: permite consultar o histórico de ocorrências do aeroporto, identificar locais com maior frequência de 
-- incidentes e acompanhar situações que possam comprometer a segurança operacional.
CREATE OR REPLACE VIEW vw_historico_incidentes_operacionais AS
SELECT
    inc.id_incidente,
    inc.data_hora,
    inc.tipo,
    inc.gravidade,
    inc.descricao,
    inc.status,
    r.id_operacao_rota,
    r.origem,
    r.destino,
    a.codigo AS codigo_aeronave,
    i.id_infraestrutura,
    i.localizacao,
    CASE
        WHEN h.id_hangar IS NOT NULL THEN 'Hangar'
        WHEN p.id_portao IS NOT NULL THEN 'Portao'
        WHEN pi.id_pista IS NOT NULL THEN 'Pista'
        WHEN pt.id_pista_taxi IS NOT NULL THEN 'Pista de Taxi'
        WHEN am.id_area_manobra IS NOT NULL THEN 'Area de Manobra'
    END AS tipo_infraestrutura
FROM incidente_operacional AS inc
LEFT JOIN operacao_de_rota AS r
    ON r.id_operacao_rota = inc.id_operacao_rota
LEFT JOIN aeronave AS a
    ON a.id_aeronave = r.id_aeronave
LEFT JOIN infraestrutura AS i
    ON i.id_infraestrutura = inc.id_infraestrutura
LEFT JOIN hangar AS h
    ON h.id_hangar = i.id_infraestrutura
LEFT JOIN portao AS p
    ON p.id_portao = i.id_infraestrutura
LEFT JOIN area_de_manobra AS am
    ON am.id_area_manobra = i.id_infraestrutura
LEFT JOIN pista AS pi
    ON pi.id_pista = am.id_area_manobra
LEFT JOIN pista_de_taxi AS pt
    ON pt.id_pista_taxi = am.id_area_manobra;