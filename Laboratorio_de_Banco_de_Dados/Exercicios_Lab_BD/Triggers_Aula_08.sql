CREATE DATABASE gatilhos
GO
USE gatilhos

CREATE TABLE produto (
codigo INT NOT NULL,
nome VARCHAR(50),
descrição VARCHAR(100),
valor_unitario DECIMAL(7,2)
PRIMARY KEY(codigo)
)

INSERT INTO produto VALUES
(1001, 'Tv', 'Tela para assistir coisas', 700.00),
(1002, 'Teclado', 'Instrumento musical', 1200.00),
(1003, 'PS5', 'Vídeo game', 7000.00),
(1004, 'Laptop', 'Computador', 4500.00)

CREATE TABLE estoque (
codigo_produto INT NOT NULL,
qtd_estoque INT NOT NULL,
estoque_minimo INT NOT NULL
PRIMARY KEY (codigo_produto)
FOREIGN KEY(codigo_produto) REFERENCES produto (codigo) 
)

INSERT INTO estoque VALUES
(1001, 10, 3),
(1002, 4, 1),
(1003, 3, 5),
(1004, 5, 2)

CREATE TABLE venda (
nota_fiscal INT NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT NOT NULL
PRIMARY KEY (nota_fiscal)
FOREIGN KEY (codigo_produto) REFERENCES produto (codigo)
)

/* Fazer uma TRIGGER AFTER na tabela Venda que, uma vez feito um INSERT, verifique se a 
quantidade está disponível em estoque. Caso esteja, a venda se concretiza, caso contrário, a 
venda deverá ser cancelada e uma mensagem de erro deverá ser enviada. A mesma TRIGGER 
deverá validar, caso a venda se concretize, se o estoque está abaixo do estoque mínimo 
determinado ou se após a venda, ficará abaixo do estoque considerado mínimo e deverá lançar 
um print na tela avisando das duas situações. */

-- Venda cancelada, estoque indisponivel
INSERT INTO venda VALUES
(2, 1003, 5)

-- Estoque abaixo do estoque minimo
INSERT INTO venda VALUES
(2, 1003, 1)

CREATE TRIGGER t_estoque ON venda
AFTER INSERT
AS
BEGIN
	DECLARE @qtdestoque AS INT,
			@qtdvenda AS INT,
			@codigo AS INT, 
			@estminimo AS INT
			
			SET @codigo = (SELECT codigo_produto FROM INSERTED)
			SET @qtdvenda = (SELECT quantidade FROM INSERTED)
			SET @qtdestoque = (SELECT qtd_estoque FROM estoque WHERE codigo_produto = @codigo)
			SET @estminimo = (SELECT estoque_minimo FROM estoque WHERE codigo_produto = @codigo)
			 
		IF (@qtdestoque >= @qtdvenda)
		BEGIN
			PRINT 'Venda realizada com sucesso'
			IF ((@qtdestoque < @estminimo) OR (@qtdestoque - @qtdvenda < @estminimo))
			BEGIN
				PRINT 'Estoque abaixo do estoque minimo'
			END
		END
		ELSE
		BEGIN
			ROLLBACK TRANSACTION
			RAISERROR('Venda cancelada, estoque indisponivel', 16, 1)
		END
END


/* Fazer uma UDF (User Defined Function) Multi Statement Table, que apresente, para uma dada 
nota fiscal, a seguinte saída:
(Nota_Fiscal | Codigo_Produto | Nome_Produto | Descricao_Produto | Valor_Unitario | 
Quantidade | Valor_Total*)
* Considere que Valor_Total = Valor_Unitário * Quantidade
*/

CREATE FUNCTION fn_nota_fiscal()
RETURNS @table TABLE (
nota_fiscal			INT,
codigo_produto		INT,
nome_produto		VARCHAR(50),
descricao_produto	VARCHAR(100),
valor_unitario		DECIMAL(7,2),
quantidade			INT,
valor_total			DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table (nota_fiscal, codigo_produto, nome_produto, descricao_produto, valor_unitario, quantidade, valor_total)
		SELECT v.nota_fiscal, v.codigo_produto, p.nome, p.descrição, p.valor_unitario, v.quantidade, (p.valor_unitario * v.quantidade)
		FROM venda v, produto p WHERE v.codigo_produto = p.codigo
	RETURN
END

SELECT * FROM fn_nota_fiscal()