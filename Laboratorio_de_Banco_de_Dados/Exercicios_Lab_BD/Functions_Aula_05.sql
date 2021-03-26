CREATE DATABASE exfuncao
GO
USE exfuncao
/* 
3) A partir das tabelas abaixo, faça:
Funcionário (Código, Nome, Salário)
Dependendente (Código_Funcionário, Nome_Dependente, Salário_Dependente)*/

CREATE TABLE funcionario (
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL,
salario DECIMAL(7,2) NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE dependente (
codigo_funcionario INT NOT NULL,
nome_dependente VARCHAR(100) NOT NULL,
salario_dependente DECIMAL(7,2) NOT NULL
FOREIGN KEY (codigo_funcionario) REFERENCES funcionario (codigo)
)

INSERT INTO funcionario VALUES
(1001, 'Fulano', 4500)

INSERT INTO dependente VALUES
(1001, 'Ciclano', 1000)

INSERT INTO dependente VALUES
(1001, 'Beltrano', 1500)

/*
a) Uma Function que Retorne uma tabela:
(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)*/

CREATE FUNCTION fn_funcionario()
RETURNS @table TABLE (
nome_funcionario VARCHAR(100),
nome_dependente VARCHAR(100),
salario_funcionario DECIMAL(7,2),
salario_dependente DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table (nome_funcionario, nome_dependente, salario_funcionario, salario_dependente)
		SELECT f.nome, d.nome_dependente, f.salario, d.salario_dependente FROM funcionario f, dependente d
	RETURN
END

SELECT * FROM fn_funcionario()

/*
b) Uma Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário.*/

CREATE FUNCTION fn_soma_salario()
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @sal_f AS DECIMAL(7,2),
			@sal_d AS DECIMAL(7,2),
			@soma AS DECIMAL(7,2)

	SET @sal_f = (SELECT salario FROM funcionario)
	SET @sal_d = (SELECT SUM (salario_dependente) FROM dependente)
	SET @soma = @sal_d + @sal_f
	RETURN (@soma)
END

SELECT dbo.fn_soma_salario() AS Soma

/*
4)A partir das tabelas abaixo, faça:
Cliente (CPF, nome, telefone, e-mail)
Produto (Código, nome, descrição, valor_unitário)
Venda (CPF_Cliente, Código_Produto, Quantidade, Data(Formato DATE)) */

CREATE TABLE cliente (
cpf CHAR(11) NOT NULL,
nome VARCHAR(100),
telefone CHAR(11),
email VARCHAR(100)
PRIMARY KEY(cpf)
)

CREATE TABLE produto (
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL,
descricao VARCHAR(100),
valor_unitario DECIMAL(7,2) NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE venda (
cpf_cliente CHAR(11) NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT NOT NULL,
data DATE NOT NULL
PRIMARY KEY (cpf_cliente, codigo_produto)
FOREIGN KEY (cpf_cliente) REFERENCES cliente (cpf),
FOREIGN KEY (codigo_produto) REFERENCES produto (codigo)
)

INSERT INTO cliente VALUES
('22233366638', 'Beltrano', '11974539274', 'beltrano@gmail.com'),
('37368192035', 'Ciclano', '11939283642', 'ciclano@gmail.com')

INSERT INTO produto VALUES 
(1001, 'The Witcher 3', 'Jogo de video game', 100.00),
(1002, 'God of war', 'Mais um jogo de vídeo game', 120.00),
(1003, 'GTA V', 'Estou sem criatividade para produtos', 150.00)

INSERT INTO venda VALUES
('22233366638', 1001, 2, '2020-09-23'),
('22233366638', 1002, 1, '2020-09-23'),
('22233366638', 1003, 1, '2015-05-08'),
('37368192035', 1002, 3, '2020-09-23')

/*
a) Uma Function que Retorne uma tabela:
(Nome_Cliente, Nome_Produto, Quantidade, Valor_Total) */

CREATE FUNCTION fn_tabela()
RETURNS @table TABLE (
nome_cliente VARCHAR(100),
nome_produto VARCHAR(100),
quantidade INT,
valor_total DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table (nome_cliente, nome_produto, quantidade, valor_total)
		SELECT c.nome, p.nome, v.quantidade, p.valor_unitario * v.quantidade 
		FROM cliente c, produto p, venda v 
		WHERE p.codigo = v.codigo_produto AND c.cpf = v.cpf_cliente
	RETURN
END

SELECT * FROM fn_tabela()

/*
b) Uma Scalar Function que Retorne a soma dos produtos comprados na Última Compra
*/

CREATE FUNCTION fn_soma_produtos(@cpf CHAR(11))
RETURNS DECIMAL(7,2)
AS
BEGIN
	RETURN (SELECT  SUM (p.valor_unitario * v.quantidade)
		FROM produto p, venda v, cliente c 
		WHERE p.codigo = v.codigo_produto 
		AND c.cpf = v.cpf_cliente 
		AND v.cpf_cliente = @cpf
		AND v.data = (SELECT MAX(v.data) FROM venda v
		WHERE v.cpf_cliente = @cpf))
END

SELECT dbo.fn_soma_produtos('22233366638') AS Soma_ultima_compra
SELECT dbo.fn_soma_produtos('37368192035') AS Soma_ultima_compra