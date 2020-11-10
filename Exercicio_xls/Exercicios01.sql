CREATE DATABASE escola
GO
USE escola

CREATE TABLE aluno(
RA          INT             NOT NULL,
nome        VARCHAR(100)    NOT NULL,
sobrenome   VARCHAR(200)    NOT NULL,
rua         VARCHAR(200)    NOT NULL,
num         INT             NOT NULL    CHECK (num > 0),
bairro      VARCHAR(150)    NOT NULL, 
CEP         CHAR(8)         NOT NULL,
telefone    CHAR(8)         NULL        CHECK(LEN(telefone) = 8),
PRIMARY KEY(RA)
)
GO

INSERT INTO aluno (RA, nome, sobrenome, rua, num, bairro, CEP, telefone) VALUES
(12345, 'José', 'Silva', 'Almirante Noronha', 236, 'Jardim São Paulo', '1589000', '69875287'),
(12346, 'Ana',	'Maria Bastos',	'Anhaia', 1568, 'Barra Funda', '3569000', '25698526'),
(12347,	'Mario', 'Santos', 'XV de Novembro', 1841, 'Centro', '1020030', NULL),	
(12348,	'Marcia', 'Neves',	'Voluntários da Patria',	225,	'Santana',	'2785090',	'78964152')

CREATE TABLE cursos(
codigo          INT             NOT NULL,
nome            VARCHAR(100)    NOT NULL,
carga_horaria   INT             NOT NULL,
turno           VARCHAR(10)     NOT NULL,
PRIMARY KEY(codigo)
)
GO

INSERT INTO cursos (codigo, nome, carga_horaria, turno) VALUES 
(1,	'Informática', 2800, 'Tarde'),
(2,	'Informática', 2800, 'Noite'),
(3,	'Logística', 2650,	'Tarde'),
(4,	'Logística', 2650,	'Noite'),
(5,	'Plásticos', 2500,	'Tarde'),
(6,	'Plásticos', 2500,	'Noite')


CREATE TABLE disciplinas(
codigo          INT             NOT NULL,
nome            VARCHAR(100)    NOT NULL,
carga_horaria   int             NOT NULL,
turno           VARCHAR(5)      NOT NULL,
semestre        INT             NOT NULL,
PRIMARY KEY(codigo)
)
GO

INSERT INTO disciplinas (codigo, nome, carga_horaria, turno, semestre) VALUES
(1,	'Informática',	4,	'Tarde',	1),
(2,	'Informática',	4,	'Noite',	1),
(3,	'Quimica',	4,	'Tarde',	1),
(4,	'Quimica',	4,	'Noite',	1),
(5,	'Banco de Dados I',	2,	'Tarde',	3),
(6,	'Banco de Dados I',	2,	'Noite',	3),
(7,	'Estrutura de Dados',	4,	'Tarde',	4),
(8,	'Estrutura de Dados',	4,	'Noite',	4)			

-- Nome e sobrenome, como nome completo dos Alunos Matriculados		
SELECT nome + ' ' + sobrenome AS NOME_COMPLETO
FROM aluno	
-- Rua, nº , Bairro e CEP como Endereço do aluno que não tem telefone
SELECT 'Rua ' + rua + ', Número: ' + CAST(num AS VARCHAR(5)) + ', Bairro: ' + bairro + ', CEP - ' + CEP AS ENDEREÇO
FROM aluno
WHERE telefone IS NULL
-- Telefone do aluno com RA 12348	
SELECT telefone AS TELEFONE 
FROM aluno
WHERE RA = 12348				
-- Nome e Turno dos cursos com 2800 horas	
SELECT nome + ' - ' + turno AS CURSOS
FROM cursos
WHERE carga_horaria = 2800				
-- O semestre do curso de Banco de Dados I noite	
SELECT semestre AS SEMESTRE_BANCO_DE_DADOS__I__NOITE
FROM disciplinas
WHERE nome = 'Banco de Dados I'	AND turno = 'Noite'			
				
