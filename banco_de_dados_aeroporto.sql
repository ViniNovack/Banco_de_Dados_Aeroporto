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
 add column id_area_manobra int
 foreign key(id_area_manobra)
 references Area_de_Manobra(id_area_manobra);