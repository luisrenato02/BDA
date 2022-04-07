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
set @nometipo = 'Não perecível'
update TipoProduto set NomeTipo = @nometipo where NomeTipo = 'Perecível';
select * from TipoProduto

--5

--Begin Tran é usado para abrir uma transaction, onde fazemos operações e só após vermos se está ok, decidimos se concordamos ou não com a mudança
--Commit é caso feita a transação da maneira que desejamos concordamos com a mudança
--Rollback é o contrário de Commit, ou seja descordamos do resultado e damos um (Rollback) para voltar ás configurações anteriores


--6
begin tran
update Produto set Nome = 'Macarrão'
select * from Produto
rollback tran

begin tran
update produto set Nome = 'Macarrão' where CodigoProduto = 9
select * from Produto
Commit tran