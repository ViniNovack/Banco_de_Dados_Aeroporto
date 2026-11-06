-- ________________________Explain/Create Index________________________
-- Consulta Escolhida -> [Relatório operacional (Dashboard diário: pousos, decolagens, movimentações, incidentes)]
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

-- Plano de Execução (EXPLAIN)
		-- O EXPLAIN é um comando utilizado para analisar como o MySQL pretende executar uma consulta SQL.
		-- Ele permite identificar informações como:
		--      - Quais tabelas serão consultadas.
		--      - Qual índice será utilizado.
		--      - Se o banco precisará percorrer toda a tabela.
		--      - Quantos registros ele estima precisar examinar.
		--      - Como os relacionamentos entre tabelas serão realizados.
		-- Em outras palavras, ele permite analisar se uma consulta está sendo executada de maneira eficiente.
EXPLAIN
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

-- Proposta de Otimização (CREATE INDEX)
CREATE INDEX idx_rota_data_inicio     -- ->permite ao MySQL utilizar o índice para encontrar os valores mínimo e máximo de data_inicio,
ON operacao_de_rota (data_inicio);    -- evitando uma leitura completa da tabela para esse cálculo, quando o otimizador conseguir aplicar a otimização de MIN() e MAX().

CREATE INDEX idx_rota_cobertura                 -- ->Funcionar como índice de cobertura para a consulta principal, pois contém id_aeronave e objetivo.
ON operacao_de_rota (id_aeronave, objetivo);    -- Se id_operacao_rota for chave primária e a tabela utilizar InnoDB, a chave primária também estará disponível nas entradas desse índice.

SELECT
    c.nome AS companhia,
    ROUND(COUNT(*) / p.dias, 2) AS operacoes_dia,                                                                  -- Remoção do DISTINCT
    ROUND(COALESCE(SUM(r.objetivo = 'Voo internacional de passageiros'), 0) / p.dias, 2) AS voo_internacional,     -- [COUNT(DISTINCT r.id_operacao_rota)] -> [count(*)]
    ROUND(COALESCE(SUM(r.objetivo = 'Voo comercial de passageiros'), 0) / p.dias, 2) AS voo_comercial,             -- Motivo: se id_operacao_rota é chave primária, cada registro representa uma operação única.
    ROUND(COALESCE(SUM(r.objetivo = 'Voo cargueiro'), 0)) AS voo_cargueiro,                                        -- Nesse caso, não precisamos pedir ao MySQL para eliminar duplicidades durante a contagem.
    ROUND(COALESCE(SUM(r.objetivo = 'Translado para manutenção programada'), 0)) AS translado_manutencao,		   -- Isso evita um processamento desnecessário.
    ROUND(COALESCE(SUM(r.objetivo = 'Voo fretado'), 0)) AS voo_fretado,
    ROUND(COALESCE(SUM(r.objetivo = 'Reposicionamento de aeronave'), 0)) AS reposicionamento,
    ROUND(COALESCE(SUM(inc.qtd), 0) / p.dias, 2) AS incidentes_dia
FROM operacao_de_rota AS r
LEFT JOIN aeronave AS a
    ON a.id_aeronave = r.id_aeronave
LEFT JOIN companhia AS c
    ON c.id_companhia = a.id_companhia
CROSS JOIN (
    SELECT
        DATEDIFF(MAX(data_inicio), MIN(data_inicio)) + 1 AS dias                -- [DATEDIFF(MAX(DATE(data_inicio)), MIN(DATE(data_inicio))) + 1] -> DATEDIFF(MAX(data_inicio), MIN(data_inicio)) + 1
    FROM operacao_de_rota                                                       -- Motivo: o DATEDIFF() já ignora a parte de horário dos valores. Portanto, o DATE() é desnecessário.
) AS p                                                                          -- Essa mudança permite que o MySQL tenha melhores condições de aproveitar o índice de data_inicio para encontrar o mínimo e o máximo.
LEFT JOIN (
    SELECT
        id_operacao_rota,
        COUNT(*) AS qtd
    FROM incidente_operacional
    GROUP BY id_operacao_rota
) AS inc
    ON inc.id_operacao_rota = r.id_operacao_rota
GROUP BY
    c.id_companhia,
    c.nome,
    p.dias
ORDER BY companhia;
