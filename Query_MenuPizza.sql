--1. Estrarre tutte le pizza con prezzo superiore a 6 euro.

SELECT Nome as [Pizza], Prezzo FROM Pizza
WHERE Prezzo>6

--2. Estrarre la pizza più costosa.

SELECT Nome as [Pizza], Prezzo FROM Pizza
WHERE Prezzo=(select max(Prezzo) FROM Pizza)

--3. Estrarre le pizze «bianche»
SELECT distinct p.Nome FROM Pizza p
join Composizione c on p.IdPizza=c.IdPizza
join Ingrediente i on c.IdIngrediente=i.IdIngrediente
WHERE i.Nome<>'Pomodoro'
AND p.Nome not in 
(SELECT p.Nome FROM Pizza p
join Composizione c on p.IdPizza=c.IdPizza
join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where i.Nome='Pomodoro')

--4. Estrarre le pizze che contengono funghi (di qualsiasi tipo)
SELECT p.Nome as [Pizza] FROM Pizza p
join Composizione c on p.IdPizza=c.IdPizza
join Ingrediente i on c.IdIngrediente=i.IdIngrediente
WHERE i.Nome like 'Funghi%'

--procedure
--1. Inserimento di una nuova pizza (parametri: nome, prezzo)
CREATE PROCEDURE InserisciPizza
@codicepizza int,
@nome nvarchar(50),
@prezzo decimal(3,2)
AS
begin
	begin try
			insert into Pizza(Codice,Nome,Prezzo) values (@codicepizza,@nome,@prezzo)
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO

execute InserisciPizza @codicepizza= 013, @nome ='Napoletana',@prezzo=6.50;

--2. Assegnazione di un ingrediente a una pizza (parametri: nome pizza, nome 
--ingrediente) 

CREATE PROCEDURE AssegnaIngrediente
@nomepizza varchar(50),
@nomeingrediente varchar(50)

AS
begin
	begin try
			insert into Composizione values ((select IdPizza from Pizza where Nome=@nomepizza),
			(select IdIngrediente from Ingrediente where Nome=@nomeingrediente))
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO

execute AssegnaIngrediente @nomepizza='Napoletana', @nomeingrediente ='Mozzarella'

--3. Aggiornamento del prezzo di una pizza (parametri: nome e nuovo prezzo)
CREATE PROCEDURE AggiornaPrezzo
@nome varchar(50),
@prezzo decimal(3,2)

AS
begin
	begin try
			UPDATE Pizza SET Prezzo=@prezzo WHERE Nome=@nome
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO
execute AggiornaPrezzo @nome='Napoletana', @prezzo=6

--4. Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome 
--ingrediente) 
CREATE PROCEDURE EliminaIngrediente
@nomepizza varchar(50),
@nomeingrediente varchar(50)

AS
begin
	begin try
			DELETE from Composizione 
			where IdIngrediente=(select IdIngrediente from Ingrediente where Nome=@nomeingrediente)
			AND IdPizza=(select IdPizza from Pizza where Nome=@nomepizza)
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO
execute EliminaIngrediente @nomepizza='Napoletana', @nomeingrediente ='Mozzarella'

--5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente 
--(parametro: nome ingrediente) 

CREATE PROCEDURE IncrementoPrezzo
@nomeingrediente varchar(50)

AS
begin
	begin try
			UPDATE Pizza SET Prezzo=Prezzo*(1.10) WHERE IdPizza 
			IN ( SELECT IdIngrediente FROM Ingrediente WHERE Nome=@nomeingrediente)
	end try
	begin catch
		select ERROR_MESSAGE()
	end catch
end
GO
execute IncrementoPrezzo @nomeingrediente='Rucola'

--1. Tabella listino pizze (nome, prezzo) ordinato alfabeticamente (parametri:
--nessuno)
create function ListinoPizze()
returns Table
AS
Return
select [Nome] as Pizza, [Prezzo] 
from Pizza
group by Nome, Prezzo

select *
from dbo.ListinoPizze()
order by[Pizza]

--2. Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome
--ingrediente)
create function TabellaConPizzeIngrediente(@nomeingrediente nvarchar(50))
returns Table
As 
return

select p.Nome as Pizza, p.Prezzo
from Pizza p
join Composizione c on c.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=c.IdIngrediente
where i.Nome=@nomeingrediente


select * from [dbo].[TabellaConPizzeIngrediente]('Mozzarella')

--3. Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente
--(parametri: nome ingrediente)
create function TabellaConPizzeSenzaIngrediente(@nomeingrediente nvarchar(50))
returns Table
As 
return

select distinct p.Nome as Pizza, p.Prezzo
from Pizza p
join Composizione c on c.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=c.IdIngrediente
where i.Nome<>@nomeingrediente
AND p.Nome not in 
(SELECT p.Nome FROM Pizza p
join Composizione c on p.IdPizza=c.IdPizza
join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where i.Nome=@nomeingrediente)

select * from [dbo].[TabellaConPizzeSenzaIngrediente]('Mozzarella')
--4. Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)
create function NumeroPizzeIngrediente(@nomeingrediente nvarchar(50))
returns int
As
begin
declare @output int

select @output=count(p.Nome)
from Pizza p
join Composizione c on c.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=c.IdIngrediente
where i.Nome=@nomeingrediente
return @output

end

select dbo.NumeroPizzeIngrediente('Mozzarella')

--5. Calcolo numero pizze che non contengono un ingrediente (parametri: codice
--ingrediente)
create function NumeroPizzeSenzaIngrediente(@nomeingrediente nvarchar(50))
returns int
As
begin
declare @output int

select distinct @output=count(p.Prezzo)
from Pizza p
join Composizione c on c.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=c.IdIngrediente
where i.Nome<>@nomeingrediente
AND p.Nome not in 
(SELECT p.Nome FROM Pizza p
join Composizione c on p.IdPizza=c.IdPizza
join Ingrediente i on c.IdIngrediente=i.IdIngrediente
where i.Nome=@nomeingrediente)
return @output
end

select dbo.NumeroPizzeSenzaIngrediente('Mozzarella')


--6. Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)
create function NumeroIngredienti(@nomepizza nvarchar(50))
returns int
As
begin
declare @output int

select @output=count(p.Nome)
from Pizza p
join Composizione c on c.IdPizza=p.IdPizza
join Ingrediente i on i.IdIngrediente=c.IdIngrediente
where p.Nome=@nomepizza

return @output
end

select dbo.NumeroIngredienti('Quattro stagioni')

--VIEW
create View MenuPizza ([Nome Pizza], [Prezzo], [Ingredienti])
as (	
select p.Nome, p.Prezzo, i.Nome
from Pizza p join Composizione c on c.IdPizza=p.IdPizza
			   join Ingrediente i on c.IdIngrediente=i.IdIngrediente
			   )