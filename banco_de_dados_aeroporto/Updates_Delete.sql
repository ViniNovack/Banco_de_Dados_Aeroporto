-- _____________________________________________________________Updates_____________________________________________________________

-- UPDATE 1: Reativação de companhia aérea
-- Justificativa: A companhia Rhein Luftfracht (id 7) quitou as taxas pendentes e teve sua autorização de voo reativada.
UPDATE companhia
SET status = 'Ativa'
WHERE id_companhia = 7;


-- UPDATE 2: Liberação de portão de embarque
-- Justificativa: O voo no portão T1-02 (id 14) finalizou a decolagem, liberando o portão para as próximas aeronaves.
UPDATE infraestrutura
SET ocupado = FALSE
WHERE id_infraestrutura = 14;


-- UPDATE 3: Aprovação de solicitação de pátio
-- Justificativa: A solicitação (id 101) foi analisada pela supervisão e aprovada para estacionamento no pátio.
UPDATE solicitacao
SET status = 'Aprovada',
    data_decisao = '2026-09-23 10:30:00'
WHERE id_solicitacao = 101;


-- _____________________________________________________________Delete_____________________________________________________________

-- DELETE 1: Remoção de ordem de manutenção cancelada
-- Justificativa: A ordem de serviço de calibração (id 9) foi cancelada antes de iniciar, sendo excluída para limpar o histórico.
DELETE FROM manutencao_infraestrutura
WHERE id_manutencao = 9;