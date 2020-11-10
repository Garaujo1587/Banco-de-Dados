CREATE DATABASE hospital
GO
USE hospital

CREATE TABLE paciente(
CPF                 CHAR(11)        NOT NULL,          
nome                VARCHAR(200)    NOT NULL,
rua                 VARCHAR(200)    NOT NULL,
num                 INT             NOT NULL    CHECK (num > 0),
bairro              VARCHAR(150)    NOT NULL, 
telefone            VARCHAR(10)         NULL,
PRIMARY KEY(CPF)
)
GO

INSERT INTO paciente (CPF, nome, rua, num, bairro, telefone) VALUES
('35454562890',	'José Rubens',	'Campos Salles',	2750,	'Centro',	'21450998'),
('29865439810',	'Ana Claudia',	'Sete de Setembro',	178,	'Centro',	'97382764'),
('82176534800',	'Marcos Aurélio',	'Timóteo Penteado',	236,	'Vila Galvão',	'68172651'),
('12386758770',	'Maria Rita',	'Castello Branco',	7765,	'Vila Rosália', NULL),	
('92173458910',	'Joana de Souza',	'XV de Novembro',	298,	'Centro',	'21276578')
					
				
CREATE TABLE medico(
codigo          INT             NOT NULL,
nome            VARCHAR(100)    NOT NULL,
especialidade   VARCHAR(100)    NOT NULL,
PRIMARY KEY (codigo)
)
GO

INSERT INTO medico (codigo, nome, especialidade) VALUES 
(1,	'Wilson Cesar',	'Pediatra'),
(2,	'Marcia Matos',	'Geriatra'),
(3,	'Carolina Oliveira', 'Ortopedista'),
(4,	'Vinicius Araujo',	'Clínico Geral')
				
CREATE TABLE prontuario(
dat                     VARCHAR(12)     NOT NULL,
cpf_paciente            CHAR(11)        NOT NULL,
codigo_medico           INT             NOT NULL,
diagnostico             VARCHAR(100)    NOT NULL,
medicamento             VARCHAR(100)    NOT NULL,
PRIMARY KEY (dat, cpf_paciente, codigo_medico),
FOREIGN KEY (cpf_paciente) REFERENCES paciente (CPF),
FOREIGN KEY (codigo_medico) REFERENCES medico (codigo) 
)
GO

INSERT INTO prontuario (dat, cpf_paciente, codigo_medico, diagnostico, medicamento) VALUES
('10/09/2020',	'35454562890',	2,	'Reumatismo',	'Celebra'),
('10/09/2020',	'92173458910',	2,	'Renite Alérgica',	'Allegra'),
('12/09/2020',	'29865439810',	1,	'Inflamação de garganta',	'Nimesulida'),
('13/09/2020',	'35454562890',	2,	'H1N1',	'Tamiflu'),
('15/09/2020',	'82176534800',	4,	'Gripe',	'Resprin'),
('15/09/2020',	'12386758770',	3,	'Braço Quebrado',	'Dorflex + Gesso')

--Consultar:													
--Nome e Endereço (concatenado) dos pacientes com mais de 50 anos
SELECT nome AS NOME, rua + ', Número: ' + CAST(num AS VARCHAR(5)) + ', Bairro: ' + bairro AS ENDEREÇO
FROM paciente
--Qual a especialidade de Carolina Oliveira
SELECT especialidade AS ESPECIALIDADE_CAROLINA
FROM medico 
WHERE nome = 'Carolina Oliveira'													
--Qual medicamento receitado para reumatismo													
SELECT medicamento AS MEDICAMENTO_REUMATISMO
FROM prontuario
WHERE diagnostico = 'Reumatismo'													
													
--Consultar em subqueries:													
--Diagnóstico e Medicamento do paciente José Rubens em suas consultas	
SELECT 'Diagnostico: ' + diagnostico + ', Medicamento: ' + medicamento AS JOSÉ_RUBENS
FROM prontuario
WHERE cpf_paciente IN (
            SELECT CPF
            FROM paciente
            WHERE nome = 'José Rubens'
            )
--Nome e especialidade do(s) Médico(s) que atenderam José Rubens. Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)
SELECT nome, especialidade = (SUBSTRING(especialidade, 1, 3) + '.')
FROM medico
WHERE codigo IN (
            SELECT codigo_medico
            FROM prontuario
            WHERE cpf_paciente IN (
                        SELECT CPF
                        FROM paciente
                        WHERE nome = 'José Rubens'
                        )
                ) 
--CPF (Com a máscara XXX.XXX.XXX-XX), Nome, Endereço completo (Rua, nº - Bairro), Telefone (Caso nulo, mostrar um traço (-)) dos pacientes do médico Vinicius
SELECT SUBSTRING(CPF, 1, 3) + '.' + SUBSTRING(CPF, 4 , 3) + '.' + SUBSTRING(CPF, 7 , 3) + '-' + SUBSTRING(CPF, 10 , 2),
nome, rua + ', Número: ' + CAST(num AS VARCHAR(5)) + ', Bairro: ' + bairro AS endereço_completo,
CASE WHEN (telefone IS NOT NULL) 
     THEN telefone 
     ELSE '-' 
     END AS telefone 
FROM paciente 
WHERE CPF IN (
        SELECT cpf_paciente
        FROM prontuario
        WHERE codigo_medico IN(
                    SELECT codigo
                    FROM medico
                    WHERE nome = 'Vinicius Araujo'
                    )
            )									
--Quantos dias fazem da consulta de Maria Rita até hoje													
SELECT DATEDIFF(DAY, '2020-09-15', GETDATE()) - 1 AS DIAS
--Alterar o telefone da paciente Maria Rita, para 98345621
UPDATE paciente
SET telefone = '98345621'
WHERE nome = 'Maria Rita'											
--Alterar o Endereço de Joana de Souza para Voluntários da Pátria, 1980, Jd. Aeroporto													
UPDATE paciente
SET rua = 'Voluntários da Pátria', num = 1980, bairro = 'Jd. Aeroporto'
WHERE nome = 'Joana de Souza'