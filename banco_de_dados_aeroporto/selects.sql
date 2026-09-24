USE gerenciador_de_pista_aeroporto;

--OCUPAÇÃO DA INFRAESTRUTURA (HANGAR, PISTAS, TAXIWAYS E PORTÕES)
SELECT 
    i.id_infraestrutura,
    i.localizacao,
    CASE 
        WHEN i.ocupado = 1 THEN 'Ocupado'
        ELSE 'Livre'
    END AS status_ocupacao,
    CASE 
        WHEN h.id_hangar IS NOT NULL THEN CONCAT('Hangar (Capacidade: ', h.capacidade, ')')
        WHEN po.id_portao IS NOT NULL THEN CONCAT('Portão ', po.numero, ' - ', po.terminal, ' (', po.tipo_de_embarque, ')')
        WHEN pt.id_pista_taxi IS NOT NULL THEN CONCAT('Taxiway ', pt.designacao, ' (Vel. Máx: ', pt.velocidade_maxima, ' km/h)')
        WHEN p.id_pista IS NOT NULL THEN CONCAT('Pista ', p.designacao, ' (PMD: ', FORMAT(p.peso_maximo_suportado, 2), ' kg)')
        ELSE 'Área Geral'
    END AS detalhe_infraestrutura,
    CONCAT(i.largura, 'm x ', i.comprimento, 'm') AS dimensoes
FROM Infraestrutura i
LEFT JOIN Hangar h ON i.id_infraestrutura = h.id_hangar
LEFT JOIN Portao po ON i.id_infraestrutura = po.id_portao
LEFT JOIN Area_de_Manobra am ON i.id_infraestrutura = am.id_area_manobra
LEFT JOIN Pista_de_Taxi pt ON am.id_area_manobra = pt.id_pista_taxi
LEFT JOIN Pista p ON am.id_area_manobra = p.id_pista
ORDER BY i.ocupado DESC, i.id_infraestrutura ASC;


--VOOS E ROTAS (CHEGADAS E PARTIDAS)
SELECT 
    r.id_operacao_rota,
    c.nome AS companhia_aerea,
    a.codigo AS prefixo_aeronave,
    r.origem,
    r.destino,
    DATE_FORMAT(r.data_inicio, '%d/%m/%Y %H:%i') AS partida,
    DATE_FORMAT(r.data_termino, '%d/%m/%Y %H:%i') AS previsao_chegada,
    TIMESTAMPDIFF(MINUTE, r.data_inicio, r.data_termino) AS tempo_voo_minutos,
    r.objetivo
FROM Operacao_de_Rota r
JOIN aeronave a ON r.id_aeronave = a.id_aeronave
JOIN companhia c ON a.id_companhia = c.id_companhia
ORDER BY r.data_inicio ASC;


--ROTAS FREQUENTES
SELECT 
    origem,
    destino,
    COUNT(*) AS total_operacoes,
    SEC_TO_TIME(AVG(TIMESTAMPDIFF(SECOND, data_inicio, data_termino))) AS duracao_media
FROM Operacao_de_Rota
GROUP BY origem, destino
ORDER BY total_operacoes DESC;


--STATUS DA FROTA POR COMPANHIA AÉREA
SELECT 
    c.nome AS companhia,
    c.status AS status_companhia,
    COUNT(a.id_aeronave) AS total_aeronaves,
    SUM(CASE WHEN a.status = 'Operacional' THEN 1 ELSE 0 END) AS operacionais,
    SUM(CASE WHEN a.status = 'Em manutenção' THEN 1 ELSE 0 END) AS em_manutencao,
    SUM(CASE WHEN a.status = 'Aguardando inspeção' THEN 1 ELSE 0 END) AS aguardando_inspecao,
    SUM(CASE WHEN a.licenciada = 1 THEN 1 ELSE 0 END) AS frotas_licenciadas
FROM companhia c
LEFT JOIN aeronave a ON c.id_companhia = a.id_companhia
GROUP BY c.id_companhia, c.nome, c.status
ORDER BY total_aeronaves DESC;


--OPERAÇÕES DE SOLO E INFRAESTRUTURAS UTILIZADAS
SELECT 
    os.id_operacao_solo,
    os.id_operacao_rota,
    i.localizacao AS local_operacao,
    os.origem AS deslocamento_de,
    os.destino AS deslocamento_para,
    os.data_inicio,
    os.data_termino,
    os.proxima_operacao
FROM Operacao_de_Solo os
JOIN Infraestrutura i ON os.id_infraestrutura = i.id_infraestrutura
ORDER BY os.data_inicio ASC;


--ESCALA DE FUNCIONÁRIOS POR OPERAÇÃOA
SELECT 
    r.id_operacao_rota,
    CONCAT(r.origem, ' -> ', r.destino) AS rota,
    u.nome AS funcionario,
    f.matricula,
    f.cargo,
    s.nome AS setor
FROM Operacao_de_Rota r
JOIN operacoes_rota_funcionario orf ON r.id_operacao_rota = orf.id_operacao_rota
JOIN funcionario f ON orf.id_funcionario = f.id_funcionario
JOIN usuario u ON f.id_funcionario = u.id_usuario
JOIN setor s ON f.id_setor = s.id_setor
ORDER BY r.id_operacao_rota, s.nome, u.nome;


--QUADRO DE FUNCIONÁRIOS E DISTRIBUIÇÃO POR SETOR
SELECT 
    s.nome AS setor,
    COUNT(f.id_funcionario) AS total_colaboradores,
    SUM(CASE WHEN f.status = 'Ativo' THEN 1 ELSE 0 END) AS ativos,
    SUM(CASE WHEN f.status = 'Afastado' THEN 1 ELSE 0 END) AS afastados,
    SUM(CASE WHEN f.status = 'Férias' THEN 1 ELSE 0 END) AS em_ferias,
    SUM(CASE WHEN f.duracao_contrato IS NOT NULL THEN 1 ELSE 0 END) AS temporarios,
    SUM(CASE WHEN f.duracao_contrato IS NULL THEN 1 ELSE 0 END) AS efetivos
FROM setor s
LEFT JOIN funcionario f ON s.id_setor = f.id_setor
GROUP BY s.id_setor, s.nome
ORDER BY total_colaboradores DESC;


--SOLICITAÇÕES OPERACIONAIS E MANUTENÇÃO COM STATUS E PRAZOS
SELECT 
    sol.id_solicitacao,
    u.nome AS funcionario_solicitante,
    f.cargo,
    a.codigo AS prefixo_aeronave,
    c.nome AS companhia_aeronave,
    sol.data_solicitacao,
    sol.prazo,
    sol.conteudo,
    sol.status,
    CASE 
        WHEN sol.status = 'Concluído' THEN 'Finalizado'
        WHEN NOW() > sol.prazo THEN 'Vencido'
        ELSE 'No Prazo'
    END AS situacao_prazo
FROM solicitacao sol
JOIN funcionario f ON sol.id_funcionario = f.id_funcionario
JOIN usuario u ON f.id_funcionario = u.id_usuario
JOIN aeronave a ON sol.id_aeronave = a.id_aeronave
JOIN companhia c ON a.id_companhia = c.id_companhia
ORDER BY sol.prazo ASC;


--TERCEIRIZADOS DE COMPANHIAS E ATENDIMENTO DE SOLICITAÇÕES
SELECT 
    t.numero_de_identificacao AS credencial,
    u.nome AS terceiro,
    u.e_mail,
    c.nome AS companhia_representada,
    sol.id_solicitacao,
    sol.conteudo AS servico_solicitado,
    sol.status AS status_solicitacao
FROM terceiro t
JOIN usuario u ON t.id_terceiro = u.id_usuario
JOIN companhia c ON t.id_companhia = c.id_companhia
LEFT JOIN terceiros_solicitacoes ts ON t.id_terceiro = ts.id_terceiro
LEFT JOIN solicitacao sol ON ts.id_solicitacao = sol.id_solicitacao
ORDER BY c.nome, u.nome;


--OCUPAÇÃO GERAL DO AEROPORTO (KPI OPERACIONAL)
SELECT 
    COUNT(*) AS total_posicoes,
    SUM(CASE WHEN ocupado = 1 THEN 1 ELSE 0 END) AS posicoes_ocupadas,
    SUM(CASE WHEN ocupado = 0 THEN 1 ELSE 0 END) AS posicoes_livres,
    ROUND((SUM(CASE WHEN ocupado = 1 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2) AS percentual_ocupacao
FROM Infraestrutura;
