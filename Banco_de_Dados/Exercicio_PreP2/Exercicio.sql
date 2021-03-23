CREATE DATABASE exercicioPre_P2
GO
USE exercicioPre_P2

CREATE TABLE autores (
cod INT NOT NULL,
nome VARCHAR(100) NOT NULL,
pais VARCHAR(50) NOT NULL,
biografia VARCHAR(100) NOT NULL
PRIMARY KEY(cod)
)

CREATE TABLE clientes (
cod INT NOT NULL,
nome VARCHAR(100) NOT NULL,
logradouro VARCHAR(200) NULL,
numero INT NULL,
telefone CHAR(9) NULL
PRIMARY KEY(cod)
)

CREATE TABLE corredor (
cod INT NOT NULL,
tipo VARCHAR(50) NOT NULL
PRIMARY KEY(cod) 
)

CREATE TABLE livros(
cod INT NOT NULL,
cod_autor INT NOT NULL,
cod_corredor INT NOT NULL,
nome VARCHAR(100) NOT NULL,
pag INT NOT NULL,
idioma VARCHAR(100)
PRIMARY KEY (cod),
FOREIGN KEY (cod_autor) REFERENCES autores (cod),
FOREIGN KEY (cod_corredor) REFERENCES corredor (cod)  
)

CREATE TABLE emprestimo (
cod_cliente INT NOT NULL,
data DATE NOT NULL,
cod_livro INT NOT NULL
PRIMARY KEY (cod_cliente,cod_livro),
FOREIGN KEY (cod_cliente) REFERENCES clientes(cod),
FOREIGN KEY (cod_livro) REFERENCES livros(cod)
)

SELECT * FROM autores
SELECT * FROM clientes
SELECT * FROM corredor
SELECT * FROM emprestimo
SELECT * FROM livros

--Criar uma database com a estrutura de tabelas conforme o diagrama	
	
--Fazer os seguintes exercícios:	
	
-- Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada padrão BR (dd/mm/yyyy)	
SELECT DISTINCT c.nome AS nome_cliente, CONVERT(CHAR(10), e.data, 103) AS data_emprestimo
FROM clientes c INNER JOIN emprestimo e
ON c.cod = e.cod_cliente

-- Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos por Cada autor, ordenado pelo número de livros. Se o nome do autor tiver mais de 25 caracteres, mostrar só os 13 primeiros.
SELECT CASE WHEN (LEN (a.nome) > 25)
				THEN SUBSTRING (a.nome, 1 , 13) 
				ELSE a.nome
				END AS nome_autor, COUNT (l.cod) AS quantidade_de_livros
FROM autores a INNER JOIN livros l
ON a.cod = l.cod_autor	
GROUP BY a.nome
ORDER BY COUNT(l.cod)

-- Fazer uma consulta que retorne o nome do autor e o país de origem do livro com maior número de páginas cadastrados no sistema
SELECT a.nome AS nome_autor, a.pais, MAX (l.pag) AS numero_paginas
FROM autores a INNER JOIN livros l
ON a.cod = l.cod_autor
GROUP BY a.nome, a.pais
ORDER BY numero_paginas DESC

-- Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem livros emprestados	
SELECT DISTINCT c.nome, c.logradouro + ', Nº ' + CONVERT (VARCHAR(10), c.numero) AS endereco
FROM clientes c INNER JOIN emprestimo e
ON c.cod = e.cod_cliente

/*	
Nome dos Clientes, sem repetir e, concatenados como	
enderço_telefone, o logradouro, o numero e o telefone) dos	
clientes que Não pegaram livros. Se o logradouro e o 	
número forem nulos e o telefone não for nulo, mostrar só o telefone. Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número. Se os três existirem, mostrar os três.	
O telefone deve estar mascarado XXXXX-XXXX	
*/	
SELECT DISTINCT c.nome,
	CASE WHEN (c.logradouro IS NULL)
		THEN
		CASE WHEN (c.numero IS NULL)
		THEN 
		CASE WHEN (c.telefone IS NULL)
		THEN
		'-'
		ELSE
		SUBSTRING(c.telefone, 1, 6) + '-' +SUBSTRING(c.telefone, 7, 9)
		END
		ELSE
		' Nº ' + CONVERT(VARCHAR(10), c.numero) + ' | telefone: ' + SUBSTRING(c.telefone, 1, 6) + '-' + SUBSTRING(c.telefone, 7, 9)
		END
		ELSE
		c.logradouro + ' Nº '+ CONVERT(VARCHAR(10), c.numero)+ ' | telefone: ' + SUBSTRING(c.telefone, 1, 6) + '-' + SUBSTRING(c.telefone, 7, 9)
		END AS endereco_telefone
FROM clientes c
				
-- Fazer uma consulta que retorne Quantos livros não foram emprestados	
SELECT COUNT(l.cod) AS 'Livros não emprestados' 
FROM livros l LEFT OUTER JOIN emprestimo e
ON e.cod_livro = l.cod
WHERE e.cod_livro IS NULL

-- Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, ordenados por quantidade de livro	
SELECT a.nome, c.tipo, COUNT (c.cod) AS quantidade_de_livros 
FROM livros l INNER JOIN autores a
ON l.cod_autor = a.cod INNER JOIN corredor c
ON c.cod = l.cod_corredor
GROUP BY a.nome, c.tipo
ORDER BY quantidade_de_livros 

-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro, o total de dias que cada um está com o livro e, uma coluna que apresente, caso o número de dias seja superior a 4, apresente 'Atrasado', caso contrário, apresente 'No Prazo'
SELECT c.nome AS cliente, l.nome AS livro, DATEDIFF(dd, e.data, '2012-05-18') AS dias,
	CASE WHEN (DATEDIFF(dd, e.data, '2012-05-18') > 4)
		THEN	
		'Atrasado'
		ELSE
		'No Prazo'
	    END AS situacao	
FROM emprestimo e INNER JOIN clientes c 
ON c.cod = e.cod_cliente INNER JOIN livros l 
ON l.cod = e.cod_livro	

-- Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor
SELECT c.cod AS corredor, tipo, COUNT (l.cod_corredor) AS 'quantidade de livros' 
FROM corredor c INNER JOIN livros l 
ON l.cod_corredor = c.cod
GROUP BY c.cod, tipo
	
-- Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado é maior ou igual a 2.	
SELECT a.nome AS autor 
FROM autores a INNER JOIN livros l 
ON l.cod_autor = a.cod
GROUP BY a.nome
HAVING COUNT (l.cod_autor) >= 2

-- Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro dos empréstimos que tem 7 dias ou mais
SELECT c.nome AS cliente, l.nome AS livro, DATEDIFF(dd, e.data, '2012-05-18') AS emprestimo 
FROM emprestimo e INNER JOIN clientes c 
ON c.cod = e.cod_cliente INNER JOIN livros l 
ON l.cod = e.cod_livro	
GROUP BY c.nome, l.nome, e.data
HAVING DATEDIFF(dd, e.data, '2012-05-18') >= 7
	