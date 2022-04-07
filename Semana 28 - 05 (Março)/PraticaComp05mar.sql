
--1
create procedure InsereTipo
as begin
insert into TipoProduto(NomeTipo, Observacao)
values('Macarrão', 'Dona Benta')
end

--update TipoProduto set NomeTipo = 'Perecível' where CodigoTipoProduto = 7

exec InsereTipo

--2
create procedure InsereProduto
as begin
insert into Produto(Nome, PrecoCompra, PrecoVenda, Observacao, CodigoTipoProduto)
values('Macarrão', '3,00', '4,50', 'fabricação própria', '7')
end

exec InsereProduto
select * from Produto

--3 
create procedure AlteraColunaTipoProduto
as begin
alter table TipoProduto
alter column NomeTipo varchar(20);
alter table TipoProduto
alter column Obs text;
--add column Obs text;
--sp_rename 'TipoProduto.[CodigoTipo]' , 'CodigoTipo';
--sp_rename 'TipoProduto.[Obs]', 'ObsTipo';
end
select * from TipoProduto
exec AlteraColunaTipoProduto


--4 
create procedure AlteraColunaProduto
as begin
alter table Produto
alter column PrecoVenda float(5,2);
alter table Produto alter column PrecoCompra float(5,2)
alter table Produto alter column Observacao text
alter table Produto alter column Nome varchar(25)
 end
 exec AlteraColunaProduto



--select * from TipoProduto

--drop procedure DeletaRegitroTipoProduto

create procedure DeletaRegitroTipoProduto
as begin
delete  from TipoProduto where Observacao = 'teste';
end
exec DeletaRegitroTipoProduto
select* from TipoProduto;


create procedure DeletaRegistroProduto
as begin
delete from Produto where CodigoProduto = 1;
end
exec DeletaRegistroProduto
select * from Produto


--drop procedure Calculo



create procedure Calculo
as begin
declare @numerador float;
declare @denominador float;
declare @resultado float;

set @numerador = 5;
set @denominador=25;
set @resultado = @numerador + @denominador;
print @resultado
end

exec Calculo;


