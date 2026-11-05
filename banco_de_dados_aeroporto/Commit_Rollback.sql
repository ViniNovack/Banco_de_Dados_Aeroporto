-- ________________________________Commit/Rollback________________________________
-- ______________Commit______________
START TRANSACTION;

INSERT INTO Operacao_de_Rota (id_operacao_rota, id_aeronave, origem, destino, data_inicio, data_termino, objetivo) VALUES
    (21, 12, 'Curitiba', 'Sao Paulo', '2026-02-16 06:30:00', '2026-02-16 07:35:00', 'Transporte de passageiros');
INSERT INTO Operacao_de_Solo (id_operacao_solo, id_operacao_rota, id_infraestrutura, proxima_operacao, origem, destino, data_inicio, data_termino) VALUES
    (23, 21, 42, NULL, 'Area de manobra AM22', 'Pista de decolagem', '2026-02-16 06:05:00', '2026-02-16 06:20:00');
INSERT INTO Operacao_de_Solo (id_operacao_solo, id_operacao_rota, id_infraestrutura, proxima_operacao, origem, destino, data_inicio, data_termino) VALUES
    (22, 21, 41, 23, 'Area de manobra AM21', 'Area de manobra AM22', '2026-02-16 05:50:00', '2026-02-16 06:05:00');
INSERT INTO Operacao_de_Solo (id_operacao_solo, id_operacao_rota, id_infraestrutura, proxima_operacao, origem, destino, data_inicio, data_termino) VALUES
    (21, 21, 61, 22, 'Portao G01', 'Area de manobra AM21', '2026-02-16 05:35:00', '2026-02-16 05:50:00');
INSERT INTO operacoes_rota_funcionario (id_operacao_rota, id_funcionario) VALUES
    (21, 12);

COMMIT;

-- ______________Rollback______________
START TRANSACTION;

INSERT INTO Operacao_de_Rota (id_operacao_rota, id_aeronave, origem, destino, data_inicio, data_termino, objetivo) VALUES
    (21, 12, 'Curitiba', 'Sao Paulo', '2026-02-16 06:30:00', '2026-02-16 07:35:00', 'Transporte de passageiros');
INSERT INTO Operacao_de_Solo (id_operacao_solo, id_operacao_rota, id_infraestrutura, proxima_operacao, origem, destino, data_inicio, data_termino) VALUES
    (23, 21, 42, NULL, 'Area de manobra AM22', 'Pista de decolagem', '2026-02-16 06:05:00', '2026-02-16 06:20:00');
INSERT INTO Operacao_de_Solo (id_operacao_solo, id_operacao_rota, id_infraestrutura, proxima_operacao, origem, destino, data_inicio, data_termino) VALUES
    (22, 21, 41, 23, 'Area de manobra AM21', 'Area de manobra AM22', '2026-02-16 05:50:00', '2026-02-16 06:05:00');
INSERT INTO Operacao_de_Solo (id_operacao_solo, id_operacao_rota, id_infraestrutura, proxima_operacao, origem, destino, data_inicio, data_termino) VALUES
    (21, 21, 61, 22, 'Portao G01', 'Area de manobra AM21', '2026-02-16 05:35:00', '2026-02-16 05:50:00');
INSERT INTO operacoes_rota_funcionario (id_operacao_rota, id_funcionario) VALUES
    (21, 12);

ROLLBACK;