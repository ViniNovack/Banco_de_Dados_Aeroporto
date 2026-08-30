create database gerenciador_de_pista_aeroporto;

use gerenciador_de_pista_aeroporto;

 create table Pista_de_Taxi(
	id_pista_taxi int not null auto_increment,
    designacao varchar(10),
    sentido_de_traego varchar(20),
    velocidade_maxima int,
    primary key(id_pista_taxi)
 );
 
 create table Pista(
	id_pista int not null auto_increment,
    designacao varchar(10),
    peso_maximo_suportado decimal(8, 2),
    iluminacao_de_aproximacao boolean,
    primary key(id_pista)
 );
 
 create table Area_de_Manobra(
	id_area_manobra int not null auto_increment,
    designacao varchar(50),
    categoria_ICAO varchar(10),
    elevacao decimal(6, 2),
    primary key(id_area_manobra)
 );
 
 alter table Pista_de_Taxi
 add column id_area_manobra int;
 
 alter table Pista_de_Taxi
 add foreign key(id_area_manobra)
 references Area_de_Manobra(id_area_manobra);
 
 alter table Pista
 add column id_area_manobra int;
 
 alter table Pista
 add foreign key(id_area_manobra)
 references  Area_de_Manobra(id_area_manobra);
 
 create table Hangar(
	id_hangar int not null auto_increment,
    capacidade int,
    tipo varchar(30),
    area decimal(8,2),
    primary key(id_hangar)
 );
 
 create table Infraestrutura(
	id_infraestrutura int not null auto_increment,
    localizacao varchar(100),
    ocupado boolean,
    largura decimal(6,2),
    comprimento decimal(6,2),
    primary key(id_infraestrutura)
 );
 
 alter table Hangar
 add column id_infraestrutura int;
 
 alter table Hangar
 add foreign key(id_infraestrutura)
 references Infraestrutura(id_infraestrutura);
 
 alter table Area_de_Manobra
 add column id_infraestrutura int;
 
 alter table Area_de_Manobra
 add foreign key(id_infraestrutura)
 references Infraestrutura(id_infraestrutura);
 
 create table Portao(
	id_portao int not null auto_increment,
    id_infraestrutura int,
    numero varchar(10),
    tipo_de_embarque varchar(30),
    terminal varchar(10),
    primary key(id_portao),
    foreign key(id_infraestrutura)
    references Infraestrutura(id_infraestrutura)
 );
 
 create table Operacao_de_Solo(
	id_operacao_solo int not null auto_increment,
    id_infraestrutura int,
    origem varchar(50),
    destino varchar(50),
    data_inicio datetime,
    data_termino datetime,
    primary key(id_operacao_solo),
    foreign key(id_infraestrutura)
    references Infraestrutura(id_infraestrutura)
 );
 
create table Operacao_de_Rota(
	id_operacao_rota int not null auto_increment,
    origem varchar(50),
    destino varchar(50),
    data_inicio datetime,
    data_termino datetime,
    objetivo varchar(45),
    primary key(id_operacao_rota)
);

alter table Operacao_de_Solo
add column id_operacao_rota int;

alter table Operacao_de_Solo
add foreign key(id_operacao_rota)
references Operacao_de_Rota(id_operacao_rota);

