CREATE DATABASE progsql
GO
USE progsql

/*Fazer um algoritmo que leia 3 valores e retorne se os valores formam um triângulo e se ele é
isóceles, escaleno ou equilátero.
Condições para formar um triângulo
	Nenhum valor pode ser = 0
	Um lado não pode ser maior que a soma dos outros 2.
*/

DECLARE @lado01 AS INT,
        @lado02 AS INT,
        @lado03 AS INT

SET @lado01 = 1
SET @lado02 = 2
SET @lado03 = 3

IF (@lado01 = 0 OR @lado02 = 0 OR @lado03 = 0)
BEGIN 
    PRINT 'Nenhum valor pode ser igual a 0'
END
ELSE 
BEGIN
    IF ((@lado01 + @lado02) < @lado03 OR (@lado01 + @lado03) < @lado02 OR (@lado02 + @lado03) < @lado01)
    BEGIN
        PRINT 'Um lado não pode ser maior que a soma dos outros 2'
    END
    ELSE
    BEGIN
        IF ((@lado01 = @lado02) AND (@lado02 = @lado03)) 
        BEGIN
            PRINT 'Equilátero' -- todos lados iguais
        END
        ELSE
            IF ((@lado01 = @lado02) OR (@lado02 = @lado03) OR (@lado03 = @lado01))
            BEGIN
                PRINT 'Isóceles' -- 2 lados iguais e 1 diferente
            END
            ELSE
            BEGIN
                PRINT 'Escaleno' -- todos os lados diferentes
            END
    END
END

 -- Fazer um algoritmo que leia 1 número e mostre se são múltiplos de 2,3,5 ou nenhum deles

DECLARE @num	AS INT,
        @mult2	AS INT,
        @mult3	AS INT,
        @mult5	AS INT

SET @num = 30

IF (@num % 2 = 0)
BEGIN 
    SET @mult2 = 1
END

IF (@num % 3 = 0)
BEGIN
    SET @mult3 = 1
END

IF (@num % 5 = 0)
BEGIN
    SET @mult5 = 1
END

IF (@mult2 = 0 AND @mult3 = 0 AND @mult5 = 0)
BEGIN 
    PRINT 'Não é múltiplo de 2, 3 nem 5'
END
ELSE
BEGIN
    IF (@mult2 = 1)
    BEGIN
        PRINT 'Multiplo de 2'
    END

    IF (@mult3 = 1)
    BEGIN
        PRINT 'Multiplo de 3'
    END

    IF (@mult5 = 1)
    BEGIN
        PRINT 'Multiplo de 5'
    END
END

 -- Fazer um algoritmo que leia 3 número e mostre o maior e o menor

CREATE TABLE tbNumeros(
numero INT NOT NULL
)

INSERT INTO tbNumeros VALUES 
(4), 
(1), 
(7)

DECLARE @maior AS INT,
		@menor AS INT

SET @maior = (SELECT MAX (numero) FROM tbNumeros)

SET @menor = (SELECT MIN (numero) FROM tbNumeros)

PRINT 'O maior número é ' + CONVERT (VARCHAR (5), @maior) + ' e o menor número é ' + CONVERT (VARCHAR (5), @menor)

/*
Fazer um algoritmo que calcule os 15 primeiros termos da série
1,1,2,3,5,8,13,21,...
E calcule a soma dos 15 termos
*/

DECLARE @ant	AS INT,
        @atual	AS INT,
        @prox	AS INT,
        @i		AS INT,
        @soma	AS INT
 
SET @ant = 0
SET @atual = 1
SET @prox = 0
SET @i = 0
SET @soma = 0

WHILE (@i < 15)
BEGIN
    PRINT CONVERT (CHAR (3), @atual)

    SET @soma = @soma + @atual

    SET @prox = @ant + @atual
    SET @ant = @atual
    SET @atual = @prox

    SET @i = @i + 1
END

PRINT 'A soma é: ' + CONVERT (VARCHAR (5), @soma)

-- Fazer um algorimto que separa uma frase, colocando todas as letras em maiúsculo e em minúsculo

DECLARE		@frase			AS VARCHAR(100),
			@fraseMaius		AS VARCHAR(100),
			@fraseMinus		AS VARCHAR(100)

SET @frase = 'Programando em SqlServer'
SET @fraseMaius = UPPER (@frase)
SET @fraseMinus = LOWER (@frase)

PRINT @fraseMaius
PRINT @fraseMinus

-- Fazer um algoritmo que inverta uma palavra

DECLARE @palavra			AS VARCHAR(50),
        @palavraInversa		AS VARCHAR(50)

SET @palavra = 'abacate'
SET @palavraInversa = REVERSE (@palavra)

PRINT @palavra
PRINT @palavraInversa

-- Verificar palindromo

DECLARE @palav				AS VARCHAR(50),
        @palavInversa		AS VARCHAR(50)

SET @palav = 'luz azul'
SET @palav =  REPLACE (@palav, ' ', '' )
SET @palavInversa = REVERSE (@palav)

IF (@palav = @palavInversa)
BEGIN
    PRINT 'Palíndromo'
END
ELSE
BEGIN
    PRINT 'Não é palíndromo'
END

-- Algoritmo do CPF

DECLARE @cpf			AS CHAR(11),
		@j				AS INT,
		@aux			AS INT,
		@multiplica		AS INT, 
		@somatorio		AS INT

SET @cpf = '22233366638' 
SET @j = 10
SET @aux = 1
SET @somatorio = 0

-- Calculando o primeiro dígito verificador

WHILE (@j > 1)
BEGIN
	SET @multiplica = (@j * SUBSTRING(@cpf, @aux, 1))
	SET @somatorio = @somatorio + @multiplica
--	PRINT @multiplica
	SET @j = @j - 1
	SET @aux = @aux + 1
END

/*
PRINT @somatorio
PRINT @somatorio / 11
PRINT @somatorio % 11
*/

-- Verificando se o primeiro dígito verificador é válido

IF (@somatorio % 11 < 2)
BEGIN
	IF (SUBSTRING(@cpf, 10, 1) = 0)
	BEGIN
		PRINT 'Primeiro dígito verificador válido'
	END
	ELSE
	BEGIN
		PRINT 'CPF inválido, primeiro dígito verificador não está correto'
	END
END
ELSE
BEGIN
	IF (SUBSTRING(@cpf, 10, 1) = 11 - @somatorio % 11)
	BEGIN
		PRINT 'Primeiro dígito verificador válido'
	END
	ELSE
	BEGIN
		PRINT 'CPF inválido, primeiro dígito verificador não está correto'
	END
END

-- Calculando o segundo dígito verificador

SET @j = 11
SET @aux = 1
SET @somatorio = 0

WHILE (@j > 1)
BEGIN
	SET @multiplica = (@j * SUBSTRING(@cpf, @aux, 1))
	SET @somatorio = @somatorio + @multiplica
--	PRINT @multiplica
	SET @j = @j - 1
	SET @aux = @aux + 1
END

/*
PRINT @somatorio
PRINT @somatorio / 11
PRINT @somatorio % 11
*/

-- Verificando se o segundo dígito verificador é válido

IF (@somatorio % 11 < 2)
BEGIN
	IF (SUBSTRING(@cpf, 11, 1) = 0)
	BEGIN
		PRINT 'Segundo dígito verificador válido'
	END
	ELSE
	BEGIN
		PRINT 'CPF inválido, segundo dígito verificador não está correto'
	END
END
ELSE
BEGIN
	IF (SUBSTRING(@cpf, 11, 1) = 11 - @somatorio % 11)
	BEGIN
		PRINT 'Segundo dígito verificador válido'
	END
	ELSE
	BEGIN
		PRINT 'CPF inválido, segundo dígito verificador não está correto'
	END
END

-- Apesar de satisfazer o algoritmo, cpf com todos os números iguais devem ser considerados inválidos

IF (@cpf = '00000000000' OR @cpf = '11111111111' OR @cpf = '22222222222' OR @cpf = '33333333333' OR 
	@cpf = '44444444444' OR @cpf = '55555555555' OR @cpf = '66666666666' OR @cpf = '77777777777' OR
	@cpf = '88888888888' OR @cpf = '99999999999')
BEGIN
	PRINT 'O CPF: ' + SUBSTRING(@cpf, 1, 9) + '-' + SUBSTRING(@cpf, 10, 2) + ' é inválido, todos os números estão iguais'
END
ELSE
BEGIN
	PRINT 'O CPF: ' + SUBSTRING(@cpf, 1, 9) + '-' + SUBSTRING(@cpf, 10, 2) + ' é válido'
END