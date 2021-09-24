CREATE DATABASE MenuPizza

CREATE TABLE Pizza(
IdPizza int IDENTITY(1,1) not null,
Codice int not null,
Nome nvarchar(50) not null,
Prezzo decimal(3,2) not null,
CONSTRAINT PK_IdPizza PRIMARY KEY (IdPizza),
CONSTRAINT CK_Prezzo CHECK(Prezzo>0)
);

CREATE TABLE Ingrediente(
IdIngrediente int IDENTITY(1,1) not null,
Codice int not null,
Nome nvarchar(50) not null,
Costo decimal(3,2) not null,
ScorteMagazzino int not null,
CONSTRAINT PK_IdIngrediente PRIMARY KEY (IdIngrediente),
CONSTRAINT CK_Costo CHECK(Costo>0)
);

CREATE TABLE Composizione(
IdPizza int not null,
IdIngrediente int not null,
CONSTRAINT PK_Compososizione PRIMARY KEY (IdPizza,IdIngrediente),
CONSTRAINT FK_IngredientePizza FOREIGN KEY (IdIngrediente) references Ingrediente(IdIngrediente),
CONSTRAINT FK_PizzaIngrediente FOREIGN KEY (IdPizza) references Pizza(IdPizza)
);

--creazione dati
insert into Pizza values(001,'Margherita',5),(002,'Bufala',7),(003,'Diavola',6),
						(004,'Quattro Stagioni',6.50),(005,'Porcini',7),(006,'Dioniso',8),
						(007,'Ortolana',8),(008,'Patate e Salsiccia',6),(009,'Pomodorini',6),
						(010,'Quattro Formaggi',7.50),(011,'Caprese',7.50),(012,'Zeus',7.50);
insert into Ingrediente values(1234,'Pomodoro',0.50,150),(2345,'Mozzarella',1.00,250),(3456,'Mozzarella di Bufala',2.00,50),
							  (3456,'Spianata piccante',4.50,20),(4567,'Funghi',2.50,35),(5678,'Carciofi',4.00,10),
							  (6789,'Cotto',2.30,8),(7890,'Olive',1.60,20),(8901,'Funghi porcini',3.00,13),
							  (9012,'Stracchino',2.30,10),(0123,'Speck',1.40,16),(0124,'Rucola',1.00,10),(0125,'Grana',2.30,25),
							  (0126,'Verdure di stagione',1.50,14),(0127,'Patate',1.00,35),(0128,'Salsiccia',3.00,5),(0129,'Pomodorini',1.00,50),
							  (0130,'Ricotta',2.30,10),(0131,'Provola',1.20,25),(0132,'Gorgonzola',2.30,3),(0133,'Pomodoro fresco',1.00,12),
							  (0134,'Basilico',0.50,35),(0135,'Bresaola',2.00,13);

insert into Composizione values(1,1),(1,2),(2,1),(2,3),(3,1),(3,2),(3,4),(4,1),(4,2),(4,5),(4,6),(4,7),(4,8),
							   (5,1),(5,2),(5,9),(6,1),(6,2),(6,10),(6,11),(6,12),(6,13),(6,14),(7,1),(7,2),(7,14),
							   (8,2),(8,15),(8,16),(9,2),(9,17),(9,18),(10,2),(10,19),(10,20),(10,13),(11,2),(11,21),
							   (11,22),(12,2),(12,23),(12,12);