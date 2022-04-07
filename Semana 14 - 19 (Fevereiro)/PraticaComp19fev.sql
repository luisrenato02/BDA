--1
declare @numerador float;
declare @denominador float;
declare @resultado float;

set @numerador = 5;
set @denominador=25;
set @resultado = @numerador + @denominador;
print @resultado

select * from Produto



--2
create table Cliente(
id_cliente int identity primary key,
cpf varchar(11) unique not null,
nome varchar(50) not null
)
go

create table Venda(
id_venda int identity primary key,
data_venda date not null,
Id_cliente int references Cliente(Id_cliente)
)
go

create table Produtos(
id_produto int identity primary key,
valor money,
descricao text
)
go
create table ProdutosVendidos(
id_produtosven int identity primary key,
valor_produto money default(0) not null,
qtd float not null,
id_produto int references Produto(id_produto),
id_venda int references Venda(id_venda)
)

--3

declare @nome varchar(25);
set @nome = 'Arroz';
update produto set Nome = @nome where CodigoProduto=10;


--4
declare @nometipo varchar(25)
set @nometipo = 'N�o perec�vel'
update TipoProduto set NomeTipo = @nometipo where NomeTipo = 'Perec�vel';
select * from TipoProduto

--5

--Begin Tran � usado para abrir uma transaction, onde fazemos opera��es e s� ap�s vermos se est� ok, decidimos se concordamos ou n�o com a mudan�a
--Commit � caso feita a transa��o da maneira que desejamos concordamos com a mudan�a
--Rollback � o contr�rio de Commit, ou seja descordamos do resultado e damos um (Rollback) para voltar �s configura��es anteriores


--6
begin tran
update Produto set Nome = 'Macarr�o'
select * from Produto
rollback tran

begin tran
update produto set Nome = 'Macarr�o' where CodigoProduto = 9
select * from Produto
Commit tran