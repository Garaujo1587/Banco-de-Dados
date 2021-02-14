CREATE DATABASE escola 
GO
USE escola

CREATE TABLE Alunos (
ra		INT NOT NULL,
nome	VARCHAR(100) NOT NULL,
idade   INT NOT NULL,
PRIMARY KEY (ra)
) 


CREATE TABLE Disciplinas (
codigo			INT NOT NULL,
nome			VARCHAR(100) NOT NULL,
carga_horaria	INT NOT NULL, CHECK(carga_horaria >= 32), 
PRIMARY KEY (codigo)
)

CREATE TABLE Professor (
registro		INT NOT NULL,
nome			VARCHAR(100) NOT NULL,
titulacao		INT NOT NULL,
PRIMARY KEY (registro),
FOREIGN KEY (titulacao) REFERENCES Titulacao (codigo)
)

CREATE TABLE Curso (
codigo		INT NOT NULL, 
nome		VARCHAR(100) NOT NULL,
area		VARCHAR(100) NOT NULL,
PRIMARY KEY (codigo)
)

CREATE TABLE Titulacao (
codigo		INT NOT NULL,
titulo		VARCHAR(100) NOT NULL,
PRIMARY KEY (codigo)
)

CREATE TABLE Aluno_Disciplina (
codigo_disciplina		INT NOT NULL,
ra_aluno				INT NOT NULL,
PRIMARY KEY (codigo_disciplina, ra_aluno),
FOREIGN KEY (codigo_disciplina) REFERENCES Disciplinas (codigo),
FOREIGN KEY (ra_aluno) REFERENCES Alunos (ra),
)

CREATE TABLE Professor_Disciplina (
codigo_disciplina		INT NOT NULL,
registro_professor		INT NOT NULL,
PRIMARY KEY (codigo_disciplina, registro_professor),
FOREIGN KEY (codigo_disciplina) REFERENCES Disciplinas (codigo),
FOREIGN KEY (registro_professor) REFERENCES Professor (registro)
)

CREATE TABLE Disciplina_Curso (
codigo_disciplina		INT NOT NULL,
codigo_curso			INT NOT NULL,
PRIMARY KEY (codigo_disciplina, codigo_curso),
FOREIGN KEY (codigo_disciplina) REFERENCES Disciplinas (codigo),
FOREIGN KEY (codigo_curso) REFERENCES Curso (codigo)
)

-- A coluna idade na tabela aluno não é apropriada. Alterar a tabela criando uma coluna Ano_Nascimento INT.
ALTER TABLE Alunos ADD ano_nascimento INT
  											
-- Atualizar a coluna Ano_Nascimento usando uma única expressão, com DATEADD e GETDATE, inserindo apenas o ano.		
UPDATE Alunos 
SET ano_nascimento = YEAR(DATEADD(year, -Alunos.idade, GETDATE()))		

-- Excluir a coluna idade	
ALTER TABLE Alunos DROP COLUMN idade												

-- Como fazer as listas de chamadas, com RA e nome por disciplina ?	
SELECT a.nome AS ALUNO, a.ra AS RA, d.nome AS DISCIPLINA FROM Alunos	a INNER JOIN Aluno_Disciplina ad
ON a.ra = ad.ra_aluno INNER JOIN Disciplinas d
ON ad.codigo_disciplina = d.codigo 											

-- Fazer uma pesquisa que liste o nome das disciplinas e o nome dos professores que as ministram
SELECT d.nome AS DISCIPLINA, p.nome AS PROFESSOR FROM Disciplinas d INNER JOIN Professor_Disciplina pd
ON d.codigo = pd.codigo_disciplina INNER JOIN Professor p
ON p.registro = pd.registro_professor 													

-- Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o nome do curso
SELECT c.nome AS CURSO, d.nome AS DISCIPLINA FROM Curso c INNER JOIN Disciplina_Curso dc
ON c.codigo = dc.codigo_curso INNER JOIN Disciplinas d
ON d.codigo = dc.codigo_disciplina
WHERE d.nome LIKE '%lab%' -- nome da disciplina 													

-- Fazer uma pesquisa que , dado o nome de uma disciplina, retorne sua área	
SELECT c.area AS CURSO, d.nome AS DISCIPLINA FROM Curso c INNER JOIN Disciplina_Curso dc
ON c.codigo = dc.codigo_curso INNER JOIN Disciplinas d
ON d.codigo = dc.codigo_disciplina
WHERE d.nome LIKE '%p%'												

-- Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o título do professor que a ministra
SELECT p.nome AS PROFESSOR, t.titulo AS TITULO, d.nome AS DISCIPLINA FROM Professor p INNER JOIN Titulacao t
ON p.titulacao = t.codigo INNER JOIN Professor_Disciplina pd 
ON pd.registro_professor = p.registro INNER JOIN Disciplinas d 
ON pd.codigo_disciplina = d.codigo 							
WHERE d.nome LIKE '%b%'					
	
-- Fazer uma pesquisa que retorne o nome da disciplina e quantos alunos estão matriculados em cada uma delas	
SELECT d.nome AS DISCIPLINA, COUNT (a.ra) AS ALUNOS FROM Disciplinas d INNER JOIN Aluno_Disciplina ad
ON ad.codigo_disciplina = d.codigo INNER JOIN Alunos a
ON a.ra = ad.ra_aluno
GROUP BY d.nome
ORDER BY COUNT (a.ra) DESC

-- Fazer uma pesquisa que, dado o nome de uma disciplina, retorne o nome do professor. Só deve retornar de disciplinas que tenham, no mínimo, 5 alunos matriculados
SELECT d.nome AS DISCIPLINA, p.nome AS PROFESSOR FROM Professor p INNER JOIN Professor_Disciplina pd
ON pd.registro_professor = p.registro INNER JOIN Disciplinas d 
ON d.codigo = pd.codigo_disciplina INNER JOIN Aluno_Disciplina ad
ON ad.codigo_disciplina = d.codigo INNER JOIN Alunos a
ON ad.ra_aluno = a.ra
GROUP BY d.nome, p.nome
HAVING COUNT (a.ra) >= 5
									
-- Fazer uma pesquisa que retorne o nome do curso e a quatidade de professores cadastrados que ministram aula nele. A coluna de ve se chamar quantidade
SELECT c.nome AS CURSO, COUNT (p.registro) AS QUANTIDADE FROM Curso c INNER JOIN Disciplina_Curso dc 
ON c.codigo = dc.codigo_curso INNER JOIN Disciplinas d
ON dc.codigo_disciplina = d.codigo INNER JOIN Professor_Disciplina pd
ON pd.codigo_disciplina = d.codigo INNER JOIN Professor p
ON p.registro = pd.registro_professor 		
GROUP BY c.nome											