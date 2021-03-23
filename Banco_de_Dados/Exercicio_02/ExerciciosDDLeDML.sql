CREATE DATABASE projeto
go
USE projeto

EXEC sp_configure 'default language', 27;
GO
RECONFIGURE ;
GO

--Criar tabelas:
CREATE TABLE users(

id INT NOT NULL IDENTITY(1,1),
name VARCHAR(45) NOT NULL,
username VARCHAR(45) NOT NULL UNIQUE,
password VARCHAR(45) DEFAULT('123mudar'),
email VARCHAR(45) NOT NULL,
PRIMARY KEY(id)

)

CREATE TABLE projects(
id INT NOT NULL IDENTITY(10001,1),
name VARCHAR(45) NOT NULL,
description VARCHAR(45),
date DATE NOT NULL,
PRIMARY KEY(id),
CONSTRAINT chk_dt CHECK(date > '01/09/2014')
)

CREATE TABLE users_has_projects(

users_id INT NOT NULL,
projects_id INT NOT NULL,
PRIMARY KEY(users_id,projects_id),
FOREIGN KEY (users_id) REFERENCES users (id),
FOREIGN KEY (projects_id) REFERENCES projects (id)
)

exec sp_help users

--Modificar a coluna username da tabela Users para varchar(10)
--Modificar a coluna password da tabela Users para varchar(8)
ALTER TABLE users DROP CONSTRAINT UQ__users__F3DBC572F27D078E
ALTER TABLE users ALTER COLUMN username VARCHAR(10)
ALTER TABLE users ADD UNIQUE (username); 
ALTER TABLE users ALTER COLUMN password VARCHAR(8)

--Inserir dados:
INSERT INTO users (name,username,password,email) VALUES
('Maria',  'Rh_maria',  '123mudar',  'maria@empresa.com'), 
('Paulo',  'Ti_paulo',  '123@456',  'paulo@empresa.com'), 
('Ana',  'Rh_ana',  '123mudar', 'ana@empresa.com'),
('Clara',  'Ti_clara',  '123mudar',  'clara@empresa.com'),
('Aparecido', 'Rh_apareci',  '55@!cido',  'aparecido@empresa.com')

Select * from users

INSERT INTO projects (name,description,date) VALUES
('Re‐folha',  'Refatoração das Folhas', '05/09/2014'), 
('Manutenção PC´s',  'Manutenção PC´s', '06/09/2014'),
('Auditoria', NULL,  '07/09/2014') 

Select * from projects

INSERT INTO users_has_projects (users_id, projects_id) VALUES
('1','10001'),
('5','10001'),
('3','10003'),
('4','10002'),
('2','10002')

select * from users_has_projects

--Considerar as situações:

--Projeto Manutenção atrasou, mudar a data para 12/09/2014
UPDATE projects SET date = '2014-09-12' WHERE name LIKE 'Manutenção%'

--Username Aparecido está feio, mudar para Rh_cido
UPDATE users SET username = 'Rh_cido' WHERE name = 'Aparecido'

--Mudar o password do username Rh_maria para 888@*, mas a condição deve verificar se o password dela ainda é 123mudar
UPDATE users SET password = '888@*' WHERE username = 'Rh_maria' AND password = '123mudar'

--O user de id 2 não participa mais do projeto 1002, removê-lo da associativa
DELETE users_has_projects WHERE	users_id = '2'

--Adicionar uma coluna budget DECIMAL(7,2) NULL na tabela Project
ALTER TABLE projects ADD budget DECIMAL(7,2) NULL

--Atualizar a coluna budget com: 
--5750.00 para id 10001
--7850.00 para id 10002
--9530.00 para id 10003
UPDATE projects SET budget = '5750.00' WHERE id = '10001'
UPDATE projects SET budget = '7850.00' WHERE id = '10002'
UPDATE projects SET budget = '9530.00' WHERE id = '10003'

--Consultar:

--1) username e password da Ana
SELECT username, password from users WHERE name = 'Ana';

--2) nome, budget e valor hipotético de um budget 25% maior
SELECT name, budget, CAST( budget * 1.25 AS DECIMAL(7,2)) AS budget_25 FROM projects

--3) id, nome, email do usuário que ainda mantém o password padrão (123mudar)
SELECT id, name, email FROM users WHERE password = '123mudar'

--4)id, nome e budgets cujo valor está entre 2000.00 e 8000.00
SELECT id, name FROM projects WHERE budget BETWEEN 2000.00 AND 8000.00