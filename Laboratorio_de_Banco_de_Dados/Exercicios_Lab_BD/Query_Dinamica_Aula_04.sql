/*
Atividade:

Fazer no SQL Seever a solução do seguinte enunciado (Subir no GIT e enviar na tarefa):

Considere a tabela Produto com os seguintes atributos:
Produto (Codigo | Nome | Valor)
Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), 
criar uma exceção de erro para código inválido, receba o codigo_transacao, codigo_produto e a quantidade 
e preencha a tabela correta, com o valor_total de cada transação de cada produto.
*/

CREATE DATABASE querydinamica
GO
USE querydinamica

CREATE TABLE produto (
codigo INT NOT NULL,
nome VARCHAR(50) NOT NULL,
valor DECIMAL(7,2) NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE entrada (
codigo_transacao INT NOT NULL,
codigo_produto INT NOT NULL, 
quantidade INT NOT NULL,
valor_total DECIMAL(7,2) NOT NULL
PRIMARY KEY (codigo_transacao)
FOREIGN KEY (codigo_produto) REFERENCES produto (codigo)
)

CREATE TABLE saida (
codigo_transacao INT NOT NULL,
codigo_produto INT NOT NULL, 
quantidade INT NOT NULL,
valor_total DECIMAL(7,2) NOT NULL
PRIMARY KEY (codigo_transacao)
FOREIGN KEY (codigo_produto) REFERENCES produto (codigo)
)

CREATE PROCEDURE sp_insereproduto(@acao CHAR(1), @codigo INT, 
	@nome VARCHAR(50), @valor DECIMAL(7,2), @quantidade INT)
AS
	DECLARE @cod	INT,
			@tabela	VARCHAR(10),
			@query	VARCHAR(MAX),
			@erro	VARCHAR(MAX),
			@valor_total DECIMAL(7,2),
			@prox_cod INT

	IF (@acao <> 'e' AND @acao <> 's')
	BEGIN
		RAISERROR ('Acao Invalida', 16, 1)
	END

	ELSE
	BEGIN
		IF (@codigo < 0 OR @codigo IS NULL)
			BEGIN
				RAISERROR('Codigo Invalido', 16, 1)
			END
		ELSE
			BEGIN
				IF (@acao = 'e')
				BEGIN
					SET @tabela = 'entrada'
					SET @valor_total = @quantidade * @valor
					EXEC sp_prox_cod_aluno 'entrada', @prox_cod OUTPUT
				END
				ELSE
				BEGIN
					SET @tabela = 'saida'
					SET @valor_total = @quantidade * @valor
					EXEC sp_prox_cod_aluno 'saida', @prox_cod OUTPUT
				END
				SET @query = 'INSERT INTO '+@tabela+' VALUES ('+
				CAST(@prox_cod AS VARCHAR(5))+','+
				CAST(@codigo AS VARCHAR(5))+','+
				CAST(@quantidade AS VARCHAR(5))+','+
				CAST(@valor_total AS VARCHAR(15))+')'
				PRINT @query

				BEGIN TRY
					INSERT INTO produto VALUES (@codigo, @nome, @valor)
					EXEC (@query)
				END TRY
				BEGIN CATCH
				SET @erro = ERROR_MESSAGE()
				IF (@erro LIKE '%primary%')
				BEGIN
					RAISERROR('Codigo produto duplicado', 16, 1)
				END
				ELSE
				BEGIN
					RAISERROR('Erro de processamento', 16, 1)
				END
				END CATCH
			END 
	END

EXEC sp_insereproduto 'e', 1001, 'Camisa', 20.0, 5
EXEC sp_insereproduto 's', 1002, 'Tenis', 80.0, 10
EXEC sp_insereproduto 'e', 1003, 'Calça', 100.0, 7
EXEC sp_insereproduto 's', 1004, 'Chapeu', 30.0, 2

SELECT * FROM produto
SELECT * FROM entrada
SELECT * FROM saida

-- Select produto e entrada
SELECT e.codigo_transacao, e.codigo_produto, p.nome, p.valor, e.quantidade, e.valor_total 
FROM produto p INNER JOIN entrada e
ON p.codigo = e.codigo_produto

--Select produto e saida
SELECT s.codigo_transacao, s.codigo_produto, p.nome, p.valor, s.quantidade, s.valor_total 
FROM produto p INNER JOIN saida s
ON p.codigo = s.codigo_produto

-- Código de auto incremento

CREATE PROCEDURE sp_prox_cod_aluno(@tabela VARCHAR(10), @cod INT OUTPUT)
AS
	DECLARE @count INT
	IF(@tabela = 'entrada')
	BEGIN
	SET @count = (SELECT COUNT(*) FROM entrada)
	IF (@count = 0)
	BEGIN
		SET @cod = 1
	END
	ELSE
	BEGIN
		SET @cod = (SELECT MAX(codigo_transacao) FROM entrada) + 1
	END
	END
	ELSE
	BEGIN
	SET @count = (SELECT COUNT(*) FROM saida)
	IF (@count = 0)
	BEGIN
		SET @cod = 1
	END
	ELSE
	BEGIN
		SET @cod = (SELECT MAX(codigo_transacao) FROM saida) + 1
	END
	END