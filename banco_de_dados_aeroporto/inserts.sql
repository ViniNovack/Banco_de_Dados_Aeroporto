-- ==========================================================
-- Infraestrutura (12 registros)
-- ==========================================================
INSERT INTO Infraestrutura (localizacao, ocupado, largura, comprimento) VALUES
('Pátio de Manobras Norte', TRUE, 45.50, 220.00),
('Pátio de Manobras Sul', FALSE, 42.00, 210.50),
('Cabeceira da Pista 15', TRUE, 60.00, 300.00),
('Cabeceira da Pista 33', FALSE, 60.00, 300.00),
('Taxiway Alpha - Trecho 1', FALSE, 23.00, 450.00),
('Taxiway Bravo - Trecho 1', TRUE, 23.00, 380.00),
('Área de Hangares - Setor A', FALSE, 80.00, 150.00),
('Área de Hangares - Setor B', TRUE, 75.00, 140.00),
('Terminal de Passageiros 1', TRUE, 120.00, 500.00),
('Terminal de Passageiros 2', FALSE, 110.00, 480.00),
('Pátio de Carga', TRUE, 55.00, 260.00),
('Área de Manutenção Externa', FALSE, 90.00, 175.00);

-- ==========================================================
-- Area_de_Manobra (6 registros)
-- ==========================================================
INSERT INTO Area_de_Manobra (designacao, categoria_ICAO, elevacao, id_infraestrutura) VALUES
('Área de Manobra Norte', 'CAT I', 908.50, 1),
('Área de Manobra Sul', 'CAT II', 905.30, 3),
('Área de Manobra Leste', 'CAT III', 910.10, 5),
('Área de Manobra Oeste', 'CAT I', 902.75, 7),
('Área de Manobra Central', 'CAT II', 907.00, 9),
('Área de Manobra Auxiliar', 'CAT I', 899.60, 11);

-- ==========================================================
-- Pista (4 registros)
-- ==========================================================
INSERT INTO Pista (designacao, peso_maximo_suportado, iluminacao_de_aproximacao, id_area_manobra) VALUES
('15/33', 396000.00, TRUE, 1),
('11/29', 285000.00, FALSE, 2),
('02/20', 350000.00, TRUE, 3),
('07/25', 180000.00, TRUE, 4);

-- ==========================================================
-- Pista_de_Taxi (4 registros)
-- ==========================================================
INSERT INTO Pista_de_Taxi (designacao, sentido_de_traego, velocidade_maxima, id_area_manobra) VALUES
('A1', 'Único', 25, 2),
('B2', 'Duplo', 30, 4),
('C3', 'Único', 20, 5),
('D4', 'Duplo', 35, 6);

-- ==========================================================
-- Hangar (3 registros)
-- ==========================================================
INSERT INTO Hangar (capacidade, tipo, area, id_infraestrutura) VALUES
(6, 'Manutenção Pesada', 1200.00, 2),
(3, 'Manutenção Leve', 650.00, 6),
(10, 'Armazenamento', 1800.00, 10);

-- ==========================================================
-- Portao (6 registros)
-- ==========================================================
INSERT INTO Portao (id_infraestrutura, numero, tipo_de_embarque, terminal) VALUES
(4, 'A1', 'Ponte de embarque', 'Terminal 1'),
(7, 'A2', 'Escada móvel', 'Terminal 1'),
(8, 'B1', 'Ponte de embarque', 'Terminal 1'),
(9, 'B2', 'Ônibus de pátio', 'Terminal 2'),
(10, 'C1', 'Ponte de embarque', 'Terminal 2'),
(12, 'C2', 'Escada móvel', 'Terminal 2');

-- ==========================================================
-- companhia (5 registros)
-- ==========================================================
INSERT INTO companhia (nome, cnpj, status, pais, dominio) VALUES
('LATAM Airlines Brasil', '02012862000160', 'Ativa', 'Brasil', 'latamairlines.com'),
('GOL Linhas Aéreas', '07575651000159', 'Ativa', 'Brasil', 'voegol.com.br'),
('Azul Linhas Aéreas', '09296295000160', 'Ativa', 'Brasil', 'voeazul.com.br'),
('Emirates', '10293847560012', 'Ativa', 'Emirados Árabes Unidos', 'emirates.com'),
('American Airlines', '55667788000199', 'Suspensa', 'Estados Unidos', 'aa.com');

-- ==========================================================
-- aeronave (8 registros)
-- ==========================================================
INSERT INTO aeronave (id_companhia, codigo, licenciada, status) VALUES
(1, 'PT-MXA', TRUE, 'Operacional'),
(1, 'PT-MXB', TRUE, 'Em manutenção'),
(2, 'PR-GOA', TRUE, 'Operacional'),
(2, 'PR-GOB', FALSE, 'Aguardando inspeção'),
(3, 'PS-AZC', TRUE, 'Operacional'),
(4, 'A6-EMK', TRUE, 'Operacional'),
(4, 'A6-EML', TRUE, 'Em manutenção'),
(5, 'N778AA', FALSE, 'Operacional');

-- ==========================================================
-- Operacao_de_Rota (8 registros)
-- ==========================================================
INSERT INTO Operacao_de_Rota (origem, destino, data_inicio, data_termino, objetivo, id_aeronave) VALUES
('CWB', 'GRU', '2026-03-02 07:15:00', '2026-03-02 08:20:00', 'Voo comercial de passageiros', 1),
('GRU', 'CWB', '2026-03-02 20:10:00', '2026-03-02 21:15:00', 'Voo comercial de passageiros', 1),
('CWB', 'GIG', '2026-04-10 09:00:00', '2026-04-10 10:35:00', 'Voo comercial de passageiros', 2),
('CWB', 'BSB', '2026-05-14 06:45:00', '2026-05-14 08:30:00', 'Voo comercial de passageiros', 3),
('CWB', 'MIA', '2026-06-01 23:30:00', '2026-06-02 07:10:00', 'Voo internacional de passageiros', 4),
('CWB', 'EZE', '2026-06-20 14:00:00', '2026-06-20 17:45:00', 'Voo internacional de passageiros', 5),
('GRU', 'DXB', '2026-07-08 22:00:00', '2026-07-09 18:30:00', 'Voo cargueiro', 6),
('CWB', 'CGH', '2026-08-15 12:00:00', '2026-08-15 12:50:00', 'Reposicionamento de aeronave', 8);

-- ==========================================================
-- Operacao_de_Solo (8 registros)
-- proxima_operacao entra como NULL e é encadeada depois com UPDATE,
-- já que algumas operações apontam para uma próxima que ainda não existe no momento do insert
-- ==========================================================
INSERT INTO Operacao_de_Solo (id_infraestrutura, proxima_operacao, origem, destino, data_inicio, data_termino, id_operacao_rota) VALUES
(9, NULL, 'Portão A1', 'Taxiway Alpha', '2026-03-02 06:40:00', '2026-03-02 07:00:00', 1),
(5, NULL, 'Taxiway Alpha', 'Cabeceira da Pista 15', '2026-03-02 07:00:00', '2026-03-02 07:15:00', 1),
(4, NULL, 'Cabeceira da Pista 33', 'Taxiway Bravo', '2026-03-02 21:15:00', '2026-03-02 21:30:00', 2),
(10, NULL, 'Taxiway Bravo', 'Portão C1', '2026-03-02 21:30:00', '2026-03-02 21:45:00', 2),
(9, NULL, 'Portão A2', 'Taxiway Alpha', '2026-04-10 08:35:00', '2026-04-10 08:55:00', 3),
(11, NULL, 'Pátio de Carga', 'Taxiway Bravo', '2026-07-08 21:00:00', '2026-07-08 21:20:00', 7),
(6, NULL, 'Taxiway Bravo', 'Cabeceira da Pista 07', '2026-07-08 21:20:00', '2026-07-08 21:50:00', 7),
(8, NULL, 'Hangar Setor B', 'Portão B1', '2026-08-15 11:30:00', '2026-08-15 11:50:00', 8);

UPDATE Operacao_de_Solo SET proxima_operacao = 2 WHERE id_operacao_solo = 1;
UPDATE Operacao_de_Solo SET proxima_operacao = 4 WHERE id_operacao_solo = 3;
UPDATE Operacao_de_Solo SET proxima_operacao = 7 WHERE id_operacao_solo = 6;

-- ==========================================================
-- usuario (10 registros)
-- ==========================================================
INSERT INTO usuario (nome, cpf, e_mail, endereco, senha) VALUES
('Fernanda Souza Lima', '32165498700', 'fernanda.lima@aeroservico.com.br', 'Rua das Araucárias, 120, Curitiba - PR', 'x9F2aQ81zM'),
('Ricardo Almeida Torres', '45632178900', 'ricardo.torres@aeroservico.com.br', 'Av. Cândido de Abreu, 540, Curitiba - PR', 'p7Lk3Vb92T'),
('Juliana Ferreira Prado', '78945612300', 'juliana.prado@aeroservico.com.br', 'Rua XV de Novembro, 890, Curitiba - PR', 'zR5tY0nQ44'),
('Marcos Vinícius Rocha', '65498732100', 'marcos.rocha@aeroservico.com.br', 'Rua Marechal Deodoro, 310, Curitiba - PR', 'a1Wc8Ef37U'),
('Camila Duarte Nunes', '15975346800', 'camila.nunes@aeroservico.com.br', 'Av. Sete de Setembro, 2200, Curitiba - PR', 'q9Xz4Rt10L'),
('Eduardo Barbosa Melo', '85274196300', 'eduardo.melo@fornecedorxyz.com', 'Rua José Loureiro, 45, Curitiba - PR', 'm3Bn7Yp62K'),
('Patrícia Gomes Vieira', '96385274100', 'patricia.vieira@aviacaocargo.com', 'Av. Marechal Floriano, 1030, São José dos Pinhais - PR', 'v6Cd1Ho93S'),
('André Luiz Cardoso', '75319864200', 'andre.cardoso@voegol.com.br', 'Rua Comendador Araújo, 670, Curitiba - PR', 'j2Pf5Nm81R'),
('Bianca Ramos Teixeira', '14725836900', 'bianca.teixeira@auditoriaexterna.com', 'Av. Iguaçu, 3100, Curitiba - PR', 'g8Qa3Ls74W'),
('Rodrigo Castilho Nogueira', '25836914700', 'rodrigo.nogueira@consultoriasec.com', 'Rua Brigadeiro Franco, 1580, Curitiba - PR', 'h4Tz9Ju20D');

-- ==========================================================
-- setor (4 registros)
-- ==========================================================
INSERT INTO setor (nome, funcao) VALUES
('Operações de Pátio', 'Coordenar o tráfego de aeronaves em solo'),
('Manutenção Aeroportuária', 'Realizar manutenção preventiva e corretiva da infraestrutura'),
('Segurança Aeroportuária', 'Controlar acesso e monitorar áreas restritas'),
('Atendimento ao Passageiro', 'Prestar suporte a passageiros nos terminais');

-- ==========================================================
-- funcionario (5 registros)
-- id_usuario reaproveita os ids 1 a 5 de usuario
-- ==========================================================
INSERT INTO funcionario (id_usuario, id_setor, matricula, cargo, data_admissao, status) VALUES
(1, 1, 'FN-1001', 'Controladora de Pátio', '2021-02-15', 'Ativo'),
(2, 2, 'FN-1002', 'Técnico de Manutenção', '2019-08-01', 'Ativo'),
(3, 3, 'FN-1003', 'Agente de Segurança', '2022-05-20', 'Ativo'),
(4, 1, 'FN-1004', 'Supervisor de Pista', '2018-11-03', 'Ativo'),
(5, 4, 'FN-1005', 'Atendente de Terminal', '2023-01-10', 'Afastado');

-- ==========================================================
-- operacoes_rota__funcionario (5 registros)
-- ==========================================================
INSERT INTO operacoes_rota__funcionario (id_operacao_rota, id_funcionario) VALUES
(1, 2),
(2, 4),
(3, 1),
(5, 3),
(7, 4);

-- ==========================================================
-- terceiro (5 registros)
-- id_usuario reaproveita os ids 6 a 10 de usuario, sem sobrepor os de funcionario
-- ==========================================================
INSERT INTO terceiro (id_usuario, id_companhia, motivo_de_acesso, numero_de_identificacao, validade_de_acesso) VALUES
(6, 1, 'Prestador de serviço de manutenção de aeronaves', 'TC-2201', '2026-12-31'),
(7, 2, 'Fornecedor de combustível de aviação', 'TC-2202', '2026-10-15'),
(8, 2, 'Representante comercial da companhia aérea', 'TC-2203', '2027-01-20'),
(9, 3, 'Auditoria externa de segurança operacional', 'TC-2204', '2026-11-05'),
(10, 4, 'Consultoria em segurança aeroportuária', 'TC-2205', '2027-03-12');

-- ==========================================================
-- solicitacao (4 registros)
-- ==========================================================
INSERT INTO solicitacao (id_funcionario, id_aeronave, data, prazo, conteudo, status) VALUES
(2, 1, '2026-03-01', '2026-03-05', 'Solicitação de vaga em hangar para manutenção preventiva', 'Aprovada'),
(4, 4, '2026-05-30', '2026-06-01', 'Autorização para pouso fora do horário padrão de operação', 'Pendente'),
(1, 6, '2026-06-15', '2026-06-18', 'Reserva de posição de pátio para aeronave internacional', 'Concluída'),
(3, 8, '2026-08-10', '2026-08-12', 'Vistoria de segurança para reposicionamento de aeronave', 'Pendente');

-- ==========================================================
-- terceiros_solicitacoes (3 registros)
-- ==========================================================
INSERT INTO terceiros_solicitacoes (id_terceiro, id_solicitacao) VALUES
(6, 1),
(8, 2),
(9, 4);