CREATE DATABASE exercicio07
GO
USE exercicio07

CREATE TABLE clientes (
RG          VARCHAR(15)     NOT NULL,
CPF         CHAR(15)        NOT NULL,
nome        VARCHAR(100)    NOT NULL,
endereco    VARCHAR(200)    NOT NULL,
PRIMARY KEY(RG)
)

INSERT INTO clientes VALUES 
('2.953.184-4',	    '345.198.780-40',	'Luiz André',	    'R. Astorga, 500'),
('13.514.996-x',	'849.842.856-30',	'Maria Luiza',	    'R. Piauí, 174'),
('12.198.554-1',	'233.549.973-10',	'Ana Barbara',      'Av. Jaceguai, 1141'),
('23.987.746-x',	'435.876.699-20',	'Marcos Alberto',	'R. Quinze, 22')

CREATE TABLE pedido (
nota_fiscal     INT         NOT NULL,
valor           INT         NOT NULL,
dat             CHAR(10)    NOT NULL,
RG_cliente      VARCHAR(15) NOT NULL,
PRIMARY KEY (RG_cliente, nota_fiscal),
FOREIGN KEY (RG_cliente) REFERENCES clientes (RG)
)

INSERT INTO pedido VALUES 
(1001,	754,	'01/04/2018',	'12.198.554-1'),
(1002,	350,	'02/04/2018',	'12.198.554-1'),
(1003,	30,	    '02/04/2018',	'2.953.184-4'),
(1004,	1500,	'03/04/2018',	'13.514.996-x')

CREATE TABLE mercadoria (
codigo          INT             NOT NULL,
descricao       VARCHAR(100)    NOT NULL,
preco           INT             NOT NULL,
qtd             INT             NOT NULL,
cod_fornecedor  INT             NOT NULL,
PRIMARY KEY(codigo),
FOREIGN KEY(cod_fornecedor) REFERENCES fornecedor (codigo)
)

INSERT INTO mercadoria VALUES
(10,	'Mouse',	    24,	30,	1),
(11,	'Teclado',	    50,	20,	1),
(12,	'Cx. De Som',	30,	8,	2),
(13,	'Monitor17',	350, 4,	3),
(14,	'Notebook',	    1500,7,	4)

CREATE TABLE fornecedor (
codigo      INT             NOT NULL,
nome        VARCHAR(100)    NOT NULL,
endereco    VARCHAR(100)    NOT NULL,
telefone    VARCHAR(20)         NULL,
CGC         VARCHAR(15)         NULL,
cidade      VARCHAR(100)        NULL,
transporte  VARCHAR(50)         NULL,
pais        VARCHAR(50)         NULL,
moeda       VARCHAR(10)         NULL,
PRIMARY KEY(codigo)
)

INSERT INTO fornecedor VALUES
(1,	'Clone',	'Av. Nações Unidas, 12000',	'(11)4148-7000', NULL, 'São Paulo', NULL, NULL, NULL),			
(2,	'Logitech',	'28th Street, 100',	'1-800-145990', NULL, NULL,	'Avião', 'EUA',	'US$'),
(3,	'LG',	    'Rod. Castello Branco',	'0800-664400',	'415997810/0001',	'Sorocaba', NULL, NULL, NULL),			
(4,	'PcChips',	'Ponte da Amizade', NULL, NULL, NULL,	'Navio',	'Py',	'US$')

--Pede-se:									
--FK: Cliente em Pedido - Fornecedor em Mercadoria									
--Consultar 10% de desconto no pedido 1003
SELECT valor * 0.90 AS DESCONTO_PEDIDO_1003
FROM pedido
WHERE nota_fiscal = 1003								
--Consultar 5% de desconto em pedidos com valor maior de R$700,00
SELECT valor * 0.95 AS DESCONTO, nota_fiscal AS PEDIDO
FROM pedido
WHERE valor > 700								
--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10
SELECT preco * 1.2 AS CONSULTA_AUMENTO, descricao AS MERCADORIA
FROM mercadoria
WHERE qtd < 10  		
UPDATE mercadoria 
SET preco = preco * 1.2
WHERE qtd < 10
SELECT * FROM mercadoria
--Data e valor dos pedidos do Luiz
SELECT dat AS DATA_PEDIDO, valor AS VALOR_PEDIDO
FROM pedido
WHERE RG_cliente IN	(
            SELECT RG
            FROM clientes 
            WHERE nome = 'Luiz André'
            )
--CPF, Nome e endereço do cliente de nota 1004
SELECT CPF, nome AS NOME, endereco AS ENDEREÇO 
FROM clientes 
WHERE RG IN (
        SELECT RG_cliente
        FROM pedido
        WHERE nota_fiscal = 1004
        )
--País e meio de transporte da Cx. De som	
SELECT pais AS PAÍS, transporte AS TRANSPORTE
FROM fornecedor 
WHERE codigo IN (
        SELECT cod_fornecedor
        FROM mercadoria
        WHERE descricao = 'Cx. De som'
        )
--Nome e Quantidade em estoque dos produtos fornecidos pela Clone
SELECT descricao AS NOME, qtd AS QUANTIDADE_EM_ESTOQUE
FROM mercadoria
WHERE cod_fornecedor IN (
            SELECT codigo
            FROM fornecedor
            WHERE nome = 'Clone'
            )
--Endereço e telefone dos fornecedores do monitor
SELECT endereco AS ENDEREÇO, telefone AS TELEFONE 
FROM fornecedor
WHERE codigo IN	(
        SELECT cod_fornecedor
        FROM mercadoria 
        WHERE descricao LIKE 'monitor%'
        )
--Tipo de moeda que se compra o notebook
SELECT moeda AS AQUELA_QUE_COMPRA_NOTEBOOK
FROM fornecedor
WHERE codigo IN	(
        SELECT cod_fornecedor
        FROM mercadoria
        WHERE descricao = 'notebook'
        )
--Há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses
SELECT DATEDIFF (DD, dat, GETDATE()) AS PEDIDO_ANTIGO
FROM pedido									
--Nome e Quantos pedidos foram feitos por cada cliente
SELECT clientes.nome, pedido.nota_fiscal
FROM clientes INNER JOIN pedido
ON clientes.RG = pedido.RG_cliente									
--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
SELECT c.RG, c.CPF, c.nome, c.endereco, p.nota_fiscal
FROM clientes c LEFT OUTER JOIN pedido p
ON	c.RG = p.RG_cliente
WHERE p.RG_cliente IS NULL								