CREATE DATABASE mecanica
GO
USE mecanica

CREATE TABLE cliente(
nome                VARCHAR(200)    NOT NULL,
logradouro          VARCHAR(200)    NOT NULL,
num                 INT             NOT NULL    CHECK (num > 0),
bairro              VARCHAR(150)    NOT NULL, 
telefone            VARCHAR(10)         NULL,
carro               VARCHAR(10)     NOT NULL,
PRIMARY KEY(carro),
FOREIGN KEY(carro) REFERENCES carro (placa)
)
GO

INSERT INTO cliente (nome, logradouro, num, bairro, telefone, carro) VALUES
('João Alves',	'R. Pereira Barreto',	1258,	'Jd. Oliveiras',	'2154-9658',	'DXO9876'),
('Ana Maria',	'R. 7 de Setembro',	259,	'Centro',	'9658-8541',	'LKM7380'),
('Clara Oliveira',	'Av. Nações Unidas',	10254,	'Pinheiros',	'2458-9658',	'EGT4631'),
('José Simões',	'R. XV de Novembro',	36,	'Água Branca',	'7895-2459',	'BCD7521'),
('Paula Rocha',	'R. Anhaia',	548,	'Barra Funda',	'6958-2548',	'AFT9087')
				
CREATE TABLE carro(
placa   VARCHAR(10)     NOT NULL,
marca   VARCHAR(100)    NOT NULL,
modelo  VARCHAR(100)    NOT NULL,
cor     VARCHAR(50)     NOT NULL,
ano     INT             NOT NULL,
PRIMARY KEY (placa)
)
GO

INSERT INTO carro (placa, marca, modelo, cor, ano) VALUES 
('AFT9087',	'VW',	'Gol',	'Preto',	2007),
('DXO9876',	'Ford',	'Ka',	'Azul',	    2000),
('EGT4631',	'Renault',	'Clio',	'Verde',	2004),
('LKM7380',	'Fiat',	'Palio',	'Prata',	1997),
('BCD7521',	'Ford',	'Fiesta',	'Preto',	1999)
				
CREATE TABLE pecas(
codigo          INT             NOT NULL,
nome            VARCHAR(100)    NOT NULL,
valor           INT             NOT NULL,
PRIMARY KEY(codigo)
)
GO

INSERT INTO pecas (codigo, nome, valor) VALUES
(1,	'Vela',	70),
(2,	'Correia Dentada',	125),
(3,	'Trambulador',	90),
(4,	'Filtro de Ar',	30)
		
CREATE TABLE servico(
carro       VARCHAR(10)     NOT NULL,
peca        INT             NOT NULL,
quantidade  INT             NOT NULL,
valor       INT             NOT NULL,
dat         VARCHAR(12)     NOT NULL,
PRIMARY KEY (carro, peca, dat),
FOREIGN KEY (carro) REFERENCES carro(placa),
FOREIGN KEY (peca) REFERENCES pecas(codigo)
)
GO

INSERT INTO servico (carro, peca, quantidade, valor, dat) VALUES
('DXO9876',	1,	4,	280,	'01/08/2020'),
('DXO9876',	4,	1,	30,	'01/08/2020'),
('EGT4631',	3,	1,	90,	'02/08/2020'),
('DXO9876',	2,	1,	125,	'07/08/2020')

SELECT * FROM cliente
SELECT * FROM carro
SELECT * FROM pecas
SELECT * FROM servico
				
-- Consultar em Subqueries					
-- Telefone do dono do carro Ka, Azul
SELECT telefone AS TELEFONE_DONO_CARRO_KA
FROM cliente
WHERE carro IN (
        SELECT placa
        FROM carro
        WHERE modelo = 'Ka' AND cor = 'Azul'
        )
--Endereço concatenado do cliente que fez o serviço do dia 02/08/2009					
SELECT logradouro + ', Número: ' + CAST(num AS VARCHAR(5)) + ', Bairro: ' + bairro AS ENDEREÇO_CLIENTE
FROM cliente
WHERE carro IN (
            SELECT placa
            FROM carro
            WHERE carro IN (
                        SELECT carro
                        FROM servico
                        WHERE dat = '02/08/2020'
                        )
            )
--Consultar:					
--Placas dos carros de anos anteriores a 2001
SELECT placa AS PLACA_ANTES_2001
FROM carro
WHERE ano < 2001					
--Marca, modelo e cor, concatenado dos carros posteriores a 2005
SELECT 'Marca: ' + marca + ', Modelo: ' + modelo + ', Cor: ' + cor AS DEPOIS_2005
FROM carro
WHERE ano > 2005					
--Código e nome das peças que custam menos de R$80,00					
SELECT codigo, nome
FROM pecas
WHERE valor < 80