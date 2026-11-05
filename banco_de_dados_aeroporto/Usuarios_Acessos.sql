-- _____________________________________________________________Usuarios_____________________________________________________________
-- ________________________________Acesso________________________________
CREATE USER 'chafe_de_manutencao'@'localhost'
	identified by 'sou_um_chefe_legal';
GRANT select ON infraestrutura to 'chafe_de_manutencao'@'localhost';
GRANT select ON area_de_manobra to 'chafe_de_manutencao'@'localhost';
GRANT select ON pista to 'chafe_de_manutencao'@'localhost';
GRANT select ON pista_de_taxi to 'chafe_de_manutencao'@'localhost';
GRANT select ON hangar to 'chafe_de_manutencao'@'localhost';
GRANT select ON portao to 'chafe_de_manutencao'@'localhost';
GRANT all privileges ON manutencao_infraestrutura to 'chafe_de_manutencao'@'localhost';
GRANT all privileges ON incidente_operacional to 'chafe_de_manutencao'@'localhost';

CREATE USER 'chefe_de_operacoes'@'localhost'
	identified by 'sou_um_chefe_mal';
GRANT all privileges ON operacao_de_rota to 'chefe_de_operacoes'@'localhost';
GRANT all privileges ON operacao_de_solo to 'chefe_de_operacoes'@'localhost';
GRANT select, update, insert ON incidente_operacional to 'chefe_de_operacoes'@'localhost';

CREATE USER 'gerente_atlas_aviation'@'localhost'
	identified by 'sou_um_gerente_nota_10';
CREATE VIEW vw_operacao_de_rota as
SELECT r.* FROM operacao_de_rota as r
join aeronave as a ON a.id_aeronave = r.id_aeronave
where a.id_companhia = 7
WITH check option;
GRANT select ON gerenciador_de_pista_aeroporto.vw_operacao_de_rota to 'gerente_atlas_aviation'@'localhost';

CREATE VIEW vw_aeronave AS
SELECT * FROM aeronave
where id_companhia = 7
WITH check option;  -- Ele faz o banco conferir, a cada INSERT ou UPDATE feito pela view, se a linha resultante ainda satisfaz o WHERE da view. Se não satisfizer, o comando é recusado com Error 1369: CHECK OPTION failed.
GRANT all privileges ON gerenciador_de_pista_aeroporto.vw_aeronave to 'gerente_atlas_aviation'@'localhost';

CREATE VIEW vw_companhia AS
SELECT * FROM companhia
WHERE id_companhia = 7
WITH check option;
GRANT select, update ON gerenciador_de_pista_aeroporto.vw_companhia to 'gerente_atlas_aviation'@'localhost';

CREATE VIEW vw_infraestrutura AS
SELECT id_infraestrutura, localizacao FROM infraestrutura
WHERE id_infraestrutura = 7
WITH check option;
GRANT select ON gerenciador_de_pista_aeroporto.vw_infraestrutura to 'gerente_atlas_aviation'@'localhost';

-- ________________________________Revogação de Acesso________________________________
REVOKE update, insert ON incidente_operacional FROM 'chefe_de_operacoes'@'localhost';
               -- Não faz sentido o chefe de operações ter permissão para inserir e alterar incidentes, uma vez que essa responsabilidade deveria pertencer ao setor de infraestrutura. 
               -- Um exemplo de cargo que poderia ter essas permissões seria o chefe de manutenção, responsável por lidar diretamente com esse tipo de ocorrência.
               -- Como o chefe de operações é responsável por gerenciar as operações, ter acesso às informações sobre a ocorrência de acidentes já é suficiente para que ele possa tomar 
               -- decisões relacionadas às rotas, alocações de recursos e outras atividades operacionais, sem precisar ter permissão para cadastrar ou modificar os incidentes.