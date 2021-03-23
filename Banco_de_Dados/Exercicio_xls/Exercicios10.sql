CREATE DATABASE exercicio10
GO 
USE exercicio10

CREATE TABLE medicamentos (
codigo			INT				NOT NULL,
nome			VARCHAR(100)	NOT NULL,
apresentacao	VARCHAR(50)		NOT NULL,
unidade			VARCHAR(50)		NOT NULL,
preco			VARCHAR(6)		NOT NULL,
PRIMARY KEY (codigo)
)

INSERT INTO medicamentos VALUES
(1,	 'Acetato de medroxiprogesterona',  	 '150 mg/ml',  	 'Ampola',  	'6,700'),
(2,	 'Aciclovir',  	 '200mg/comp.',  	 'Comprimido',  	'0,280'),
(3,	 'Ácido Acetilsalicílico',  	 '500mg/comp.',  	 'Comprimido',  	'0,035'),
(4,	 'Ácido Acetilsalicílico',  	 '100mg/comp.',  	 'Comprimido',  	'0,030'),
(5,	 'Ácido Fólico',  	 '5mg/comp.',  	 'Comprimido',  	'0,054'),
(6,	 'Albendazol',  	 ' 400mg/comp. mastigável',  	 'Comprimido',  	'0,560'),
(7,	 'Alopurinol',  	 '100mg/comp.',  	 'Comprimido',  	'0,080'),
(8,	 'Amiodarona',  	 '200mg/comp.',  	 'Comprimido',  	'0,200'),
(9,	 'Amitriptilina(Cloridrato)',  	 '25mg/comp.',  	 'Comprimido',  	'0,220'),
(10, 'Amoxicilina',  	 '500mg/cáps.',  	 'Cápsula',  	'0,190')

CREATE TABLE cliente (
CPF			CHAR(12)		NOT NULL,
nome		VARCHAR(100)	NOT NULL,
rua			VARCHAR(50)		NOT NULL,
num			INT				NOT NULL,
bairro		VARCHAR(50)		NOT NULL,
telefone	CHAR(8)			NOT NULL,
PRIMARY KEY (CPF)
)

INSERT INTO cliente VALUES
('343908987-00',	'Maria Zélia',	'Anhaia',	65,	'Barra Funda',	'92103762'),
('213459862-90',	'Roseli Silva',	'Xv. De Novembro',	987,	'Centro',	'82198763'),
('869279818-25',	'Carlos Campos',	'Voluntários da Pátria',	1276,	'Santana',	'98172361'),
('310981209-00',	'João Perdizes',	'Carlos de Campos',	90,	'Pari',	'61982371')
 
 CREATE TABLE venda (
 nota_fiscal		INT			NOT NULL,
 cpf_cliente		CHAR(12)	NOT NULL,
 codigo_medicamento	INT			NOT NULL,
 quantidade			INT			NOT NULL,
 valor_total		VARCHAR(6)	NOT NULL,
 dat				CHAR(10)	NOT NULL,
 PRIMARY KEY (nota_fiscal, cpf_cliente, codigo_medicamento),
 FOREIGN KEY (cpf_cliente) REFERENCES cliente (CPF),
 FOREIGN KEY (codigo_medicamento) REFERENCES medicamentos (codigo)
 )
 
 INSERT INTO venda VALUES
(31501,	'869279818-25',	10,	3,	'0,57',	'01/11/2010'),
(31501,	'869279818-25',	2,	10,	'2,8',	'01/11/2010'),
(31501,	'869279818-25',	5,	30,	'1,05',	'01/11/2010'),
(31501,	'869279818-25',	8,	30,	'6,6',	'01/11/2010'),
(31502,	'343908987-00',	8,	15,	'3',	'01/11/2010'),
(31502,	'343908987-00',	2,	10,	'2,8',	'01/11/2010'),
(31502,	'343908987-00',	9,	10,	'2,2',	'01/11/2010'),
(31503,	'310981209-00',	1,	20,	'134',	'02/11/2010')

--Consultar												
												
--Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos. Caso a unidade de cadastro seja comprimido, mostrar Comp.
SELECT m.nome AS NOME, m.apresentacao AS APRESENTAÇÃO, m.unidade AS UNIDADE, 
		m.preco AS VALOR
FROM medicamentos m LEFT OUTER JOIN venda v
ON m.codigo = v.codigo_medicamento
WHERE v.codigo_medicamento IS NULL
												
--Nome dos clientes que compraram Amiodarona
SELECT c.nome AS NOME, m.nome AS MEDICAMENTO
FROM cliente c INNER JOIN venda v
ON c.CPF = v.cpf_cliente INNER JOIN medicamentos m 
ON v.codigo_medicamento = m.codigo
WHERE m.nome = 'Amiodarona'				
								
--CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio),  apresentação do remédio, unidade, preço proposto, quantidade vendida e valor total dos remédios vendidos a Maria Zélia
SELECT c.CPF, c.nome AS NOME, 'Rua ' + c.rua + ', Nº ' + CAST(c.num AS VARCHAR(5)) + ', ' + c.bairro AS ENDEREÇO, 
m.nome AS NOME_DE_REMEDIO, m.apresentacao AS APRESENTAÇÃO, m.unidade AS UNIDADE, m.preco AS PREÇO_PROPOSTO, 
v.quantidade AS QUANTIDADE, v.valor_total AS VALOR_TOTAL
FROM cliente c INNER JOIN venda v
ON c.CPF = v.cpf_cliente INNER JOIN medicamentos m 
ON v.codigo_medicamento = m.codigo
WHERE c.nome LIKE 'maria%'
											
--Data de compra, convertida, de Carlos Campos												
SELECT DISTINCT v.dat AS DATA_COMPRA, c.nome AS CLIENTE
FROM cliente c INNER JOIN venda v
ON c.CPF = v.cpf_cliente
WHERE c.nome = 'Carlos Campos'	
										
--Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina		
UPDATE medicamentos 										
SET nome = 'Cloridrato de Amitriptilina'
WHERE nome = 'Amitriptilina(Cloridrato)'
SELECT nome FROM medicamentos