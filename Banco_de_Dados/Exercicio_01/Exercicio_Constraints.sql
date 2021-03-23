use livraria

ALTER TABLE edicoes_editora DROP CONSTRAINT FK__livro_edi__livro__31EC6D26,PK__livro_ed__8DA46ED84EE83859

ALTER TABLE edicoes_editora ADD PRIMARY KEY (edicoesISBN, editoraCodigo_Editora);

ALTER TABLE edicoes_editora DROP COLUMN livroCodigo_livro

EXEC sp_rename 'livro_edicoes_editora', 'edicoes_editora';

exec sp_help edicoes_editora

ALTER TABLE edicoes ADD livroCodigo_livro INT 

ALTER TABLE edicoes ADD FOREIGN KEY (livroCodigo_livro) REFERENCES livro(codigo_livro)

exec sp_help edicoes

ALTER TABLE autor ADD UNIQUE (nome);

DELETE FROM livro_autor WHERE autorCodigo_autor = 10002;

DELETE FROM autor WHERE codigo_autor = 10002;

select * from autor

ALTER TABLE autor ADD CONSTRAINT chk_pais CHECK((pais = 'Brasil') OR (pais = 'Alemanha'))

exec sp_help autor

ALTER TABLE livro ADD DEFAULT('PT-BR') FOR lingua

ALTER TABLE livro ADD CONSTRAINT chk_ano_1990 CHECK((ano >= 1990))

exec sp_help livro

ALTER TABLE edicoes ADD CONSTRAINT chk_ano_1993 CHECK((anoEdicoes >= 1993))

ALTER TABLE edicoes ADD CONSTRAINT chk_neg CHECK((preco >= 0))

ALTER TABLE edicoes ADD CONSTRAINT chk_pag CHECK((num_paginas >= 0))

exec sp_help edicoes

ALTER TABLE editora ADD CONSTRAINT chk_end CHECK((numero >= 0))

ALTER TABLE editora	 ADD UNIQUE (nome);

exec sp_help editora

