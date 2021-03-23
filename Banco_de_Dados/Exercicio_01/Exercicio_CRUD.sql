CREATE DATABASE livraria
GO

--Conecta a livraria

USE livraria

--Criando Tabelas

CREATE TABLE livro (

codigo_livro INT NOT NULL  IDENTITY(1001,1),
nome         VARCHAR(100)    NOT NULL,
lingua       VARCHAR(50)     NOT NULL,
ano          INT     NOT NULL
PRIMARY KEY(codigo_livro)
)

CREATE TABLE edicoes(

isbn         INT  NOT NULL,
preco        DECIMAL(7,2) NOT NULL,
ano          INT NOT NULL,
num_paginas  INT NOT NULL,
qtd_estoque  INT NOT NULL
PRIMARY KEY(isbn)

)

CREATE TABLE autor(

codigo_autor INT NOT NULL IDENTITY(10001,1),
nome         VARCHAR(100) NOT NULL,
nascimento   DATE NOT NULL,
pais         VARCHAR(50) NOT NULL,
biografia    VARCHAR(MAX) NOT NULL,
PRIMARY KEY(codigo_autor)

)

CREATE TABLE editora(

codigo_editora INT NOT NULL IDENTITY(101,1),
nome           VARCHAR(50) NOT NULL,
logradouro     VARCHAR(255) NOT NULL,
numero         INT NOT NULL,
cep            CHAR(8) NOT NULL,
telefone       CHAR(11) NOT NULL,
PRIMARY KEY(codigo_editora)

)


-- Criando tabelas associativas

CREATE TABLE livro_autor(

livroCodigo_livro INT NOT NULL,
autorCodigo_autor INT NOT NULL,
PRIMARY KEY (livroCodigo_livro,autorCodigo_autor),
FOREIGN KEY (livroCodigo_livro) REFERENCES livro (codigo_livro),
FOREIGN KEY (autorCodigo_autor) REFERENCES autor (codigo_autor)

)

CREATE TABLE livro_edicoes_editora(

edicoesISBN    INT NOT NULL,
editoraCodigo_Editora  INT NOT NULL,
livroCodigo_livro   INT NOT NULL,
PRIMARY KEY (edicoesISBN,editoraCodigo_Editora,livroCodigo_livro),
FOREIGN KEY (edicoesISBN) REFERENCES edicoes(isbn),
FOREIGN KEY (editoraCodigo_Editora) REFERENCES editora(codigo_editora),
FOREIGN KEY (livroCodigo_livro) REFERENCES livro(codigo_livro)
)


--Verificando

EXEC sp_help livro
EXEC sp_help editora
EXEC sp_help autor
EXEC sp_help edicoes 

EXEC sp_help livro_autor
EXEC sp_help livro_edicoes_editora

--Alterações nas tabelas

EXEC sp_rename  'edicoes.ano', 'anoEdicoes', 'COLUMN'

ALTER TABLE editora ALTER COLUMN nome VARCHAR(30)

--Inserindo dados 

INSERT INTO livro (nome, lingua, ano) 
VALUES 
('CCNA 4.1', 'PT-BR', '2015'),
('HTML 5', 'PT-BR', '2017'),
('Redes de Computadores', 'EN', '2010'),
('Android em Ação', 'PT-BR', '2018')


INSERT INTO autor (nome, nascimento, pais, biografia) 
VALUES 
('Inácio da Silva', '1975', 'Brasil', 'Programador WEB desde 1995'),
('Andrew Tannenbaum', '1944', 'EUA', 'Chefe doDepartamentode Sistemas de Computação da Universidade de Vrij'),
('Luis Rocha', '1967', 'Brasil', 'Programador Mobile desde 2000'),
('David Halliday', '1916', 'EUA', 'Físico PH.D desde 1941')
INSERT INTO livro_autor (livroCodigo_livro, autorCodigo_autor) 
VALUES 
('1001', '10001'),
('1002', '10003'),
('1003', '10002'),
('1004', '10003')

INSERT INTO edicoes (isbn, preco, anoEdicoes, num_paginas,qtd_estoque) 
VALUES 
('0130661023', '189.99', '2018', '653', '10')

--Atualizando dados

UPDATE autor SET biografia = 'Chefe doDepartamentode Sistemas de Computação da Universidade de Vrije' WHERE codigo_autor = '10002' 

UPDATE edicoes SET qtd_estoque = qtd_estoque-2 WHERE isbn = '0130661023' 

--Deletando dados

DELETE autor WHERE codigo_autor = '10004'