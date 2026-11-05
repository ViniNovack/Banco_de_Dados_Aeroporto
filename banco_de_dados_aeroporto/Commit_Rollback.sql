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

-- A operação mais importante é a Operação de Rota, pois é a partir dela que as demais operações serão organizadas.
-- Como foi registrado um voo da cidade de Curitiba para São Paulo, utilizando a aeronave 12, da companhia Global Wings, 
-- é necessário registrar também as movimentações que essa aeronave realizará dentro do aeroporto antes da decolagem.
-- Por isso, foram criadas três Operações de Solo, representando a sequência de deslocamentos da aeronave:
--          1. Operação de Solo 21: registra a saída da aeronave do Portão G01 em direção à Área de Manobra AM21.
--          2. Operação de Solo 22: registra o deslocamento da aeronave da Área de Manobra AM21 para a Área de Manobra AM22.
--          3. Operação de Solo 23: registra o deslocamento da aeronave da Área de Manobra AM22 até a pista de decolagem.

-- ______________Rollback______________
START TRANSACTION;

INSERT INTO Operacao_de_Rota (id_operacao_rota, id_aeronave, origem, destino, data_inicio, data_termino, objetivo) VALUES
    (21, 12, 'Curitiba', 'Sao Paulo', '2026-02-16 06:30:00', '2026-02-16 07:35:00', 'Transporte de passageiros');
INSERT INTO Operacao_de_Solo (id_operacao_solo, id_operacao_rota, id_infraestrutura, proxima_operacao, origem, destino, data_inicio, data_termino) VALUES
    (23, 21, 42, NULL, 'Area de manobra AM22', 'Pista de decolagem', '2026-02-16 06:05:00', '2026-02-16 06:20:00');
INSERT INTO operacoes_rota_funcionario (id_operacao_rota, id_funcionario) VALUES
    (21, 12);

ROLLBACK;

-- Considerando o mesmo registro de viagem com origem em Curitiba e destino a São Paulo. Porém, agora só foi cadastrado somente uma Operação de Solo, a de número 23,
-- que representa o deslocamento da Área de Manobra AM22 até a pista de decolagem.
-- O problema é que não existem registros das movimentações anteriores que justificariam como a aeronave chegou até a Área AM22. Ou seja, não foram cadastrados:
--            -> A saída do Portão G01 em direção à Área AM21.
--            -> O deslocamento da Área AM21 para a Área AM22.
-- Dessa forma, o sistema teria apenas o registro da última movimentação, sem possuir o histórico completo do trajeto da aeronave dentro do aeroporto.
-- Por conta disso, o sistema não pode permitir esse registro incompleto. Afinal, A ideia é estabelecer uma regra de integridade operacional: antes de
-- registrar uma operação de rota como completa, o sistema deve verificar se todas as movimentações de solo obrigatórias foram registradas e se estão
-- relacionadas corretamente àquela rota.