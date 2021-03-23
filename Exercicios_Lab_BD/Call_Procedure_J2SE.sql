CREATE DATABASE callprocedure
GO
USE callprocedure

CREATE TABLE cliente (
id INT NOT NULL,
nome VARCHAR(100) NULL,
telefone CHAR(11) NULL,
dt_registro DATE NULL
PRIMARY KEY (id)
)

CREATE PROCEDURE sp_proc (@nome VARCHAR(100), @telefone CHAR(11), @saida VARCHAR(MAX) OUTPUT)
AS
DECLARE @count INT,
		@id INT

	SET @count = (SELECT COUNT(*) FROM cliente)
	IF (@count = 0)
	BEGIN
		SET @id = 1
	END
	ELSE
	BEGIN
		SET @id = (SELECT MAX(id) FROM cliente) + 1
	END

	INSERT INTO cliente 
	VALUES (@id, @nome, @telefone, GETDATE())
	SET @saida = 'Inserido com sucesso'

DECLARE @out VARCHAR(MAX)
EXEC sp_proc 'Ciclano', '12398765367', @out OUTPUT
PRINT @out

SELECT * FROM cliente
DROP TABLE cliente