CREATE DATABASE exercicio08
GO
USE exercicio08

CREATE TABLE cliente (
codigo				INT				NOT NULL,
nome				VARCHAR(100)	NOT NULL,
endereco			VARCHAR(150)	NOT NULL,
telefone			CHAR(8)			NOT NULL,
telefone_comercial	CHAR (8)		    NULL,
PRIMARY KEY (codigo)
)

INSERT INTO cliente VALUES
(1,	'Luis Paulo',	'R. Xv de Novembro, 100',	'45657878', NULL),	
(2,	'Maria Fernanda',	'R. Anhaia, 1098',	'27289098',	'40040090'),
(3,	'Ana Claudia',	'Av. Voluntários da Pátria, 876',	'21346548', NULL),	
(4,	'Marcos Henrique',	'R. Pantojo, 76',	'51425890',	'30394540'),
(5,	'Emerson Souza',	'R. Pedro Álvares Cabral, 97',	'44236545',	'39389900'),
(6,	'Ricardo Santos',	'Trav. Hum, 10',	'98789878', NULL)	

CREATE TABLE mercadoria (
codigo		INT				NOT NULL,
nome		VARCHAR(100)	NOT NULL,
corredor	INT				NOT NULL,
tipo		INT				NOT NULL,	
valor		VARCHAR(5)		NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (corredor) REFERENCES corredores (codigo),
FOREIGN KEY (tipo) REFERENCES tipos_mercadoria (codigo)
) 

INSERT INTO mercadoria VALUES
(1001,	'Pão de Forma',	101,	10001,	'3,5'),
(1002,	'Presunto',	101,	10002,	'2,0'),
(1003,	'Cream Cracker',	103,	10003,	'4,5'),
(1004,	'Água Sanitária',	104,	10004,	'6,5'),
(1005,	'Maçã',	105,	10005,	'0,9'),
(1006,	'Palha de Aço',	106,	10006,	'1,3'),
(1007,	'Lasanha',	107,	10007,	'9,7')

CREATE TABLE corredores(
codigo	INT			NOT NULL,
tipo	INT				NULL,
nome	VARCHAR(50)		NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (tipo) REFERENCES tipos_mercadoria (codigo)
)

INSERT INTO corredores VALUES
(101,	10001,	'Padaria'),
(102,	10002,	'Calçados'),
(103,	10003,	'Biscoitos'),
(104,	10004,	'Limpeza'),
(105,	NULL,		NULL),
(106,	NULL,		NULL),
(107,	10007,	'Congelados')

CREATE TABLE tipos_mercadoria(
codigo		INT				NOT NULL,
nome		VARCHAR(50)		NOT NULL,
PRIMARY KEY (codigo)
)

INSERT INTO tipos_mercadoria VALUES
(10001,	'Pães'),
(10002,	'Frios'),
(10003,	'Bolacha'),
(10004,	'Clorados'),
(10005, 'Frutas'),
(10006,	'Esponjas'),
(10007,	'Massas'),
(10008,	'Molhos')

CREATE TABLE compra (
nota_fiscal			INT		NOT NULL,
codigo_cliente		INT		NOT NULL,
valor				INT		NOT NULL,
PRIMARY KEY (nota_fiscal),
FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo)
)

INSERT INTO compra VALUES
(1234,	2,	200),
(2345,	4,	156),
(3456,	6,	354),
(4567,	3,	19)

--Pede-se:		
--Valor da Compra de Luis Paulo
SELECT c.nome AS Luis_Paulo, co.valor AS Não_Comprou_Nada
FROM cliente c INNER JOIN compra co
ON c.codigo = co.codigo_cliente
WHERE nome like 'luis%'
 		
--Valor da Compra de Marcos Henrique
SELECT c.nome AS CLIENTE, co.valor AS VALOR_COMPRA
FROM cliente c INNER JOIN compra co
ON c.codigo = co.codigo_cliente
WHERE nome like 'marcos%'
		
--Endereço e telefone do comprador de Nota Fiscal = 4567
SELECT co.nota_fiscal AS NOTA_FISCAL, c.nome AS CLIENTE, c.endereco AS ENDEREÇO, c.telefone AS TELEFONE
FROM cliente c INNER JOIN compra co
ON c.codigo = co.codigo_cliente
WHERE nota_fiscal = 4567
		
--Valor da mercadoria cadastrada do tipo " Pães"
SELECT m.valor AS VALOR_MERCADORIA, tm.nome AS TIPO
FROM mercadoria m INNER JOIN corredores co
ON m.corredor = co.codigo INNER JOIN tipos_mercadoria tm
ON tm.codigo = co.tipo
WHERE tm.nome = 'Pães'
		
--Nome do corredor onde está a Lasanha	
SELECT co.nome AS CORREDOR, m.nome AS LASANHA
FROM corredores co INNER JOIN mercadoria m
ON co.codigo = m.corredor
WHERE m.nome = 'Lasanha' 

--Nome do corredor onde estão os clorados		
SELECT co.nome AS CORREDOR, tm.nome AS CLORADOS
FROM corredores co INNER JOIN tipos_mercadoria tm
ON co.tipo = tm.codigo
WHERE tm.nome = 'Clorados' 
