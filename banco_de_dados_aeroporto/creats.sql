drop database if exists gerenciador_de_pista_aeroporto;

create database gerenciador_de_pista_aeroporto;

use gerenciador_de_pista_aeroporto;

 create table Infraestrutura(
	id_infraestrutura int primary key auto_increment,
    localizacao varchar(100) UNIQUE,
    ocupado boolean,
    largura decimal(6,2),
    comprimento decimal(6,2),
 );

  create table Hangar(
	id_hangar int primary key,
    capacidade int,
    tipo varchar(30),
    area decimal(8,2),
    foreign key(id_hangar) references Infraestrutura(id_infraestrutura),
 );

 create table Area_de_Manobra(
	id_area_manobra int primary key,
    designacao varchar(50),
    categoria_ICAO varchar(10),
    elevacao decimal(6, 2),
    foreign key(id_area_manobra) references Infraestrutura(id_infraestrutura),
 );

  create table Portao(
	id_portao int primary key,
    numero varchar(10) UNIQUE,
    tipo_de_embarque varchar(30),
    terminal varchar(10),
    foreign key(id_portao) references Infraestrutura(id_infraestrutura),
 );

 create table Pista_de_Taxi(
	id_pista_taxi int primary key,
    designacao varchar(10),
    sentido_de_traego varchar(20),
    velocidade_maxima int,
    foreign key(id_pista_taxi) references Area_de_Manobra(id_area_manobra),
 );

 
 create table Pista(
	id_pista int primary key,
    designacao varchar(10),
    peso_maximo_suportado decimal(8, 2),
    iluminacao_de_aproximacao boolean,
    foreign key(id_pista) references Area_de_Manobra(id_area_manobra),
 );

 create table companhia(
	id_companhia int primary key auto_increment,
    nome varchar(100),
    cnpj char(14) UNIQUE,
    status varchar(20),
    pais varchar(50),
    dominio varchar(50) UNIQUE,
);

create table aeronave(
	id_aeronave int primary key auto_increment,
    id_companhia int,
    codigo varchar(10) UNIQUE,
    licenciada boolean,
    status varchar(20),
    foreign key(id_companhia)
    references companhia(id_companhia)
);

 create table Operacao_de_Rota(
	id_operacao_rota int primary key auto_increment,
    id_aeronave int,
    origem varchar(50),
    destino varchar(50),
    data_inicio datetime,
    data_termino datetime,
    objetivo varchar(45),
    foreign key(id_aeronave) references aeronave(id_aeronave)
);

 create table Operacao_de_Solo(
	id_operacao_solo int primary key auto_increment,
    id_operacao_rota int UNIQUE,
    id_infraestrutura int,
    proxima_operacao int,
    origem varchar(50),
    destino varchar(50),
    data_inicio datetime,
    data_termino datetime,
    foreign key(id_operacao_rota) references Operacao_de_Rota(id_operacao_rota),
    foreign key(id_infraestrutura) references Infraestrutura(id_infraestrutura),
    foreign key(proxima_operacao) references Operacao_de_Solo(id_operacao_solo)
 );
 

create table usuario(
	id_usuario int primary key auto_increment,
    nome varchar(45),
    cpf char(11) UNIQUE,
    e_mail varchar(45) UNIQUE,
    endereco varchar(150),
    senha varchar(255),
);

create table setor(
	id_setor int primary key auto_increment,
    nome varchar(50),
    funcao varchar(50),
);

create table funcionario(
	id_funcionario int primary key,
    id_setor int,
    matricula varchar(20) UNIQUE,
    cargo varchar(50),
    data_admissao date,
    duracao_contrato int,
    status varchar(20),
    foreign key(id_funcionario) references usuario(id_usuario),
    foreign key(id_setor)references setor(id_setor)
);

create table operacoes_rota__funcionario(
	id_operacao_rota int,
    id_funcionario int,
    primary key(id_operacao_rota, id_funcionario),
    foreign key(id_operacao_rota) references operacao_de_rota(id_operacao_rota),
    foreign key(id_funcionario)references funcionario(id_funcionario)
);

create table terceiro(
	id_terceiro int primary key,
    id_companhia int not null,
    numero_de_identificacao varchar(20) UNIQUE,
    foreign key(id_terceiro) references usuario(id_usuario),
    foreign key(id_companhia) references companhia(id_companhia)
);

create table solicitacao(
	id_solicitacao int primary key auto_increment,
    id_funcionario int not null,
    id_aeronave int not null,
    data_solicitacao datetime default (current_timestamp()),
    prazo datetime,
    conteudo text,
    status varchar(20),
    foreign key(id_funcionario) references funcionario(id_funcionario),
    foreign key(id_aeronave) references aeronave(id_aeronave)
);

create table terceiros_solicitacoes(
	id_terceiro int,
    id_solicitacao int,
    primary key(id_terceiro, id_solicitacao),
    foreign key(id_terceiro) references terceiro(id_usuario),
    foreign key(id_solicitacao) references solicitacao(id_solicitacao)
);
