CREATE DATABASE exunion
GO
USE exunion

CREATE TABLE Curso (
codigo_curso		INT				NOT NULL,
nome				VARCHAR(70)		NOT NULL,
sigla				VARCHAR(10)		NOT NULL,
PRIMARY KEY (codigo_curso)
)

CREATE TABLE Aluno (
ra				CHAR(7)			NOT NULL,
nome			VARCHAR(250)	NOT NULL,
codigo_curso	INT				NOT NULL,
PRIMARY KEY (ra),
FOREIGN KEY (codigo_curso) REFERENCES Curso
)

CREATE TABLE Palestrante (
codigo_palestrante		INT					NOT NULL IDENTITY,
nome					VARCHAR(250)		NOT NULL,
empresa					VARCHAR(100)		NOT NULL,
PRIMARY KEY (codigo_palestrante)
)

CREATE TABLE Palestra (
codigo_palestra			INT				NOT NULL IDENTITY,
titulo					VARCHAR(MAX)	NOT NULL,
carga_horaria			INT				NOT NULL,
data					DATETIME		NOT NULL,
codigo_palestrante		INT				NOT NULL,
PRIMARY KEY (codigo_palestra),
FOREIGN KEY (codigo_palestrante) REFERENCES Palestrante
)

CREATE TABLE Alunos_Inscritos (
ra					CHAR(7)			NOT NULL,
codigo_palestra		INT				NOT NULL,
PRIMARY KEY (ra, codigo_palestra),
FOREIGN KEY (ra) REFERENCES Aluno,
FOREIGN KEY (codigo_palestra) REFERENCES Palestra
)

CREATE TABLE Nao_Alunos (
rg			VARCHAR(9)			NOT NULL,
orgao_exp	CHAR(5)				NOT NULL,
nome		VARCHAR(250)		NOT NULL,
PRIMARY KEY (rg, orgao_exp)
)

CREATE TABLE Nao_Alunos_Inscritos (
codigo_palestra			INT			NOT NULL,
rg						VARCHAR(9)	NOT NULL,
orgao_exp				CHAR(5)		NOT NULL,
PRIMARY KEY (codigo_palestra, rg, orgao_exp),
FOREIGN KEY (codigo_palestra) REFERENCES Palestra (codigo_palestra),
FOREIGN KEY (rg, orgao_exp) REFERENCES Nao_Alunos,
)

INSERT INTO Palestrante VALUES
('Leandro', 'FATEC'),
('Colevati', 'FATEC'),
('do Santos', 'FATEC')

INSERT INTO Palestra VALUES 
('Union', 4, '01/02/2020', 1),
('Joins', 2, '08/02/2020', 2),
('Kernel', 4, '10/02/2020', 2)

INSERT INTO Curso VALUES 
(101, 'Lab BD', 'LBD'),
(100, 'Banco de Dados', 'BD'),
(102, 'Sistemas Operacionais', 'SO') 

INSERT INTO Aluno VALUES
(1110481, 'Gugu Narciso',101),
(1110482, 'Garaujo',100),
(1110483, 'Gustavson', 102)

INSERT INTO Alunos_Inscritos VALUES
(1110481, 2),
(1110482, 1)

INSERT INTO Nao_Alunos VALUES
(269874631, 63825, 'Ojuara'),
(356288473, 73529, 'Marujo'),
(192836490, 53203, 'Gugols')

INSERT INTO Nao_Alunos_Inscritos VALUES
(3, 269874631, 63825),
(3, 192836490, 53203)

/*O problema está no momento de gerar a lista de presença. A lista de presença deverá vir de uma
consulta que retorna (Num_Documento, Nome_Pessoa, Titulo_Palestra, Nome_Palestrante,
Carga_Horária e Data). A lista deverá ser uma só, por palestra (A condição da consulta é o código
da palestra) e contemplar alunos e não alunos (O Num_Documento se referencia ao RA para
alunos e RG + Orgao_Exp para não alunos) e estar ordenada pelo Nome_Pessoa.
Fazer uma view de select que forneça a saída conforme se pede. 
*/

CREATE VIEW v_lista
AS
SELECT p.codigo_palestra AS Codigo_Palestra, a.ra AS Num_Documento, a.nome AS Nome, p.titulo AS Titulo_palestra, 
pe.nome AS Nome_Palestrante, p.carga_horaria AS Carga_horaria, p.Data AS Data_Palestra
FROM Aluno a INNER JOIN Alunos_Inscritos ai 
ON a.ra = ai.ra INNER JOIN Palestra p 
ON p.codigo_palestra = ai.codigo_palestra INNER JOIN Palestrante pe 
ON pe.codigo_palestrante = p.codigo_palestrante 
UNION 
SELECT p.codigo_palestra AS Codigo_Palestra, na.rg + ' ' + na.orgao_exp AS Num_Documento, na.nome AS Nome, p.titulo AS Titulo_Palestra, 
pe.nome AS Nome_Palestrante, p.carga_horaria AS carga_horaria, p.Data AS Data_Palestra
FROM Nao_Alunos na INNER JOIN Nao_Alunos_Inscritos nai 
ON na.rg = nai.rg AND na.orgao_exp = nai.orgao_exp INNER JOIN Palestra p 
ON p.codigo_palestra = nai.codigo_palestra INNER JOIN Palestrante pe 
ON pe.codigo_palestrante = p.codigo_palestrante 

SELECT Num_Documento, Nome, Titulo_palestra, Nome_Palestrante, Carga_Horaria, Data_Palestra 
FROM v_lista
WHERE codigo_palestra = 1
ORDER BY Nome