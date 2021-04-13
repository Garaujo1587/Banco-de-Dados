CREATE DATABASE dbtrigger
GO
USE dbtrigger

CREATE TABLE cliente (
codigo INT NOT NULL IDENTITY(1000, 1),
nome VARCHAR(100)
PRIMARY KEY (codigo)
)

INSERT INTO cliente VALUES
('Fulano'),
('Beltrano'),
('Ciclano')

CREATE TABLE venda (
codigo_venda INT NOT NULL IDENTITY(100, 1),
codigo_cliente INT NOT NULL,
valor_total DECIMAL(7,2) NOT NULL
PRIMARY KEY (codigo_venda)
FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo)
)

CREATE TABLE pontos (
codigo_cliente INT NOT NULL, 
total_pontos DECIMAL(7,2) NOT NULL
PRIMARY KEY(codigo_cliente)
FOREIGN KEY (codigo_cliente) REFERENCES cliente (codigo)
)

/*
- Uma empresa vende produtos alimentícios
- A empresa dá pontos, para seus clientes, que podem ser revertidos em prêmios
- Para não prejudicar a tabela venda, nenhum produto pode ser deletado, mesmo que não venha mais a ser vendido
- Para não prejudicar os relatórios e a contabilidade, a tabela venda não pode ser alterada. 
- Ao invés de alterar a tabela venda deve-se exibir uma tabela com o nome do último cliente que comprou e o valor da 
última compra
- Após a inserção de cada linha na tabela venda, 10% do total deverá ser transformado em pontos.
- Se o cliente ainda não estiver na tabela de pontos, deve ser inserido automaticamente após sua primeira compra
- Se o cliente atingir 1 ponto, deve receber uma mensagem dizendo que ganhou
Tabela Cliente (Codigo | Nome)

Tabela Venda (Codigo_Venda | Codigo_Cliente | Valor_Total)

Tabela Pontos (Codigo_Cliente | Total_Pontos)

*/

-- trigger que impede realizar as operacoes delete e update na tabela venda
CREATE TRIGGER t_venda ON venda
FOR DELETE, UPDATE
AS
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('Nao pode deletar e atualizar a tabela venda', 16, 1)
	SELECT c.nome AS cliente, v.valor_total AS valor_ultima_compra 
	FROM venda v, cliente c 
	WHERE v.codigo_cliente = c.codigo 
	GROUP BY v.codigo_venda, c.nome, c.codigo, v.valor_total
	HAVING v.codigo_venda = (SELECT MAX(v.codigo_venda) FROM venda v)
END

-- testando trigger t_venda
DELETE FROM venda

UPDATE venda
SET valor_total = 100
WHERE codigo_cliente = 1001

-- trigger que garante a insercao de valores corretamente nas tabelas venda e pontos
CREATE TRIGGER t_insert ON venda
FOR INSERT
AS 
BEGIN
	DECLARE @pontos AS DECIMAL (7,2),
			@cod_cliente AS INT,
			@nome_cliente AS VARCHAR(100)
	SET @cod_cliente = (SELECT codigo_cliente FROM INSERTED)
	SET @pontos = (SELECT (valor_total * 0.10) FROM INSERTED)
	SET @nome_cliente = (SELECT nome FROM INSERTED i, cliente c WHERE i.codigo_cliente = c.codigo)
	IF NOT EXISTS (SELECT @cod_cliente FROM pontos p, cliente c WHERE p.codigo_cliente = @cod_cliente AND c.codigo = @cod_cliente)
	BEGIN
		INSERT INTO pontos VALUES (@cod_cliente, @pontos)
	END
	ELSE
	BEGIN
		UPDATE pontos
		SET total_pontos = @pontos + total_pontos
		WHERE codigo_cliente = @cod_cliente
	END
	IF ((SELECT total_pontos FROM pontos WHERE codigo_cliente = @cod_cliente) >= 1)
	BEGIN
		PRINT @nome_cliente + ' atingiu 1 ponto, você ganhou!'
	END
END

-- inserindo valores na tabela venda e testando trigger t_insert
INSERT INTO venda VALUES 
(1001, 5)

INSERT INTO venda VALUES
(1002, 78)

-- verificando as tabelas venda e pontos
SELECT * FROM pontos
SELECT * FROM venda