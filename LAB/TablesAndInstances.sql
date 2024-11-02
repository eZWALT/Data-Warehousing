CREATE TABLE perfil (
	Id INTEGER,
	Sexe CHAR CHECK (sexe='M' OR sexe='F') NOT NULL,
	Edat INTEGER,
           CONSTRAINT perfil_PK PRIMARY KEY (id)
);

CREATE TABLE poblacio (
	Nom CHAR(30),
	Provincia CHAR(10),
	Comarca CHAR(15),
           CONSTRAINT poblacio_PK PRIMARY KEY (nom)
	);

CREATE TABLE data (
	Id DATE,
mes CHAR(8) NOT NULL CHECK (mes IN ('Gener', 'Febrer', 'Marc', 'Abril', 'Maig', 'Juny', 'Juliol', 'Agost', 'Setembre', 'Octubre', 'Novembre', 'Decembre')), 
anyo CHAR(4) NOT NULL,
          CONSTRAINT data_PK PRIMARY KEY (id)
);

CREATE TABLE especialitat (
	Nom CHAR(12),
	Tipus CHAR(18),
           CONSTRAINT especialitat_PK PRIMARY KEY (nom)
);

CREATE TABLE rang (
	Nom CHAR(13),
	Escala CHAR(9),
           CONSTRAINT rang_PK PRIMARY KEY (nom)
	);

CREATE TABLE destinacio (
	perfilId INTEGER ,
	poblacioId CHAR(30) ,
	dataId DATE,
	especialitatId CHAR(12) ,
	rangId CHAR(13),
	mossos INTEGER,
           CONSTRAINT destinacio_PK PRIMARY KEY (perfilId,poblacioId,dataId,especialitatId,rangId),
          CONSTRAINT destinacio_FK_perfil FOREIGN KEY (perfilId) REFERENCES perfil(id),
          CONSTRAINT destinacio_FK_rang FOREIGN KEY (rangId) REFERENCES rang(nom),
          CONSTRAINT destinacio_FK_especialitat FOREIGN KEY (especialitatId) REFERENCES especialitat(nom),
          CONSTRAINT destinacio_FK_data FOREIGN KEY (dataId) REFERENCES data(id),
          CONSTRAINT destinacio_FK_poblacio FOREIGN KEY (poblacioId) REFERENCES poblacio(nom)
	);

-------------------------------------------------------------------

INSERT INTO perfil VALUES (1, 'F', 23);
INSERT INTO especialitat VALUES ('Transit','A');
INSERT INTO especialitat VALUES ('TEDAX','B');
INSERT INTO especialitat VALUES ('Antidisturbi','A');
INSERT INTO rang VALUES ('Mosso', 'Basica');
INSERT INTO rang VALUES ('Caporal', 'Basica');
INSERT INTO rang VALUES ('Inspector', 'Comand.');
INSERT INTO poblacio VALUES ('Badalona', 'Barcelona', 'Barcelones');
INSERT INTO poblacio VALUES ('Hospitalet', 'Barcelona', 'Barcelones');
INSERT INTO poblacio VALUES ('Lleida', 'Lleida', 'Segria');
INSERT INTO poblacio VALUES ('Ponts', 'Lleida', 'Noguera');
INSERT INTO poblacio VALUES ('Tarragona', 'Tarragona', 'Tarragones');
INSERT INTO poblacio VALUES ('Girona', 'Girona', 'Girones');
INSERT INTO data VALUES (to_date('10/10/2003', 'DD/MM/YY'),'Octubre', '2003');
INSERT INTO data VALUES (to_date('10/10/2004', 'DD/MM/YY'),'Octubre', '2004');
INSERT INTO data VALUES (to_date('10/10/2009', 'DD/MM/YY'),'Octubre', '2009');
INSERT INTO destinacio VALUES (1, 'Badalona', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Mosso', 150);
INSERT INTO destinacio VALUES (1, 'Badalona', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Caporal', 6);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Mosso', 200);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Caporal', 8);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Mosso', 201);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Caporal', 8);
INSERT INTO destinacio VALUES (1, 'Ponts', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Mosso', 50);
INSERT INTO destinacio VALUES (1, 'Ponts', to_date('10/10/2003', 'DD/MM/YY'), 'Transit', 'Caporal', 2);
INSERT INTO destinacio VALUES (1, 'Badalona', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Mosso', 200);
INSERT INTO destinacio VALUES (1, 'Badalona', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Caporal', 20);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Mosso', 250);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Caporal', 23);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Mosso', 137);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Caporal', 15);
INSERT INTO destinacio VALUES (1, 'Ponts', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Mosso', 50);
INSERT INTO destinacio VALUES (1, 'Ponts', to_date('10/10/2004', 'DD/MM/YY'), 'TEDAX', 'Caporal', 8);
INSERT INTO destinacio VALUES (1, 'Tarragona', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Mosso', 2);
INSERT INTO destinacio VALUES (1, 'Tarragona', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Inspector',1);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Mosso',100);
INSERT INTO destinacio VALUES (1, 'Hospitalet', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Inspector',4);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Mosso', 20);
INSERT INTO destinacio VALUES (1, 'Lleida', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Inspector', 1);
INSERT INTO destinacio VALUES (1, 'Girona', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Mosso', 30);
INSERT INTO destinacio VALUES (1, 'Girona', to_date('10/10/2009', 'DD/MM/YY'), 'Antidisturbi', 'Inspector', 1);
