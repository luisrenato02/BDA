alter procedure STPInsertLoja
(
@NomeLoja varchar(25),
@CepLoja int
)
as begin
insert into Loja (Nome,CEP)
values(@NomeLoja, @CepLoja)
end




Create procedure STPInsertVendedor
(
@NomeVendedor varchar(25),
@GeneroVendedor char(1),
@CodigoLoja smallint
)
as begin
insert into Vendedor
(Nome, Sexo, CodigoLoja)
values(@NomeVendedor,@GeneroVendedor,@Codigoloja)
end





alter procedure STPInsertCliente
(
@NomeCliente varchar(25),
@GeneroCliente char(1),
@CPF numeric, 
@DataNac date, 
@CepCliente int,
@Inadimplente char(1)
)
as begin
insert into Cliente (Nome, Sexo, CPF, DataNascimento, CEP, Inadimplente)
values (@NomeCliente, @GeneroCliente, @CPF, @DataNac, @CepCliente, @Inadimplente)
end




Create procedure STPInsertProduto
(
@NomeProd varchar(25),
@ProdTipo smallint,
@VCompra money,
@VVenda money, 
@QtdEstoque int
)
as begin
insert into Produto (Nome,CodigoProdutoTipo,ValorCompra, ValorVenda, QtdEstoque)
values(@NomeProd, @ProdTipo, @VCompra, @VVenda, @QtdEstoque)
end





Create procedure STPInsertTipo
(
@NomeTipo varchar(25)
)
as begin
insert into ProdutoTipo (Nome)
values (@NomeTipo)
end

exec STPInsertProduto Ovos,1,10,5,250
exec STPInsertLoja varejão, 13904854
exec STPInsertTipo perecível
exec STPInsertCliente Claudin, 'M', 45595415687,'1999-05-03', 13904854,'S' 
exec STPInserVendedor Bastião, 'M', 2

select * from ProdutoTipo






















Alter procedure STPInserirProdutosVenda
(
@CodigoVenda int,
@CodigoProduto int,
@Qtd int,
@valorDesconto money

)
as begin 

declare @QtdEstoqueAtual int
set @QtdEstoqueAtual = (select QtdEstoque from Produto where CodigoProduto=@CodigoProduto)

if @Qtd <= @QtdEstoqueAtual begin


   declare @ValorProduto money
   set @ValorProduto = (select ValorVenda from Produto where CodigoProduto = @CodigoProduto)

   declare @ValorTotalSemDesc money
   set @ValorTotalSemDesc = (@ValorProduto * @Qtd)

   declare @Valortotal money
   set @ValorTotal = @ValorTotalSemDesc - @valorDesconto


   insert into VendaItem(CodigoVenda,CodigoProduto,Qtd,ValorDesconto, ValorTotal)
   values (@CodigoVenda,@CodigoProduto,@Qtd,@ValorDesconto, @ValorTotal)

   update Produto set QtdEstoque = QtdEstoque - @Qtd where CodigoProduto = @CodigoProduto
end


else begin
   print('Estoque atual inferior á quantidade de compra')

   end
end



exec STPInserirProdutosVenda 1,1,4,250

exec STPInserirVenda 2,3,2


Stored Procedure para inserir registro em cada uma das tabelas (Loja, Vendedor, Cliente, Produto, ProdutoTipo)



select * from Vendedor
select * from Loja
select * from Cliente
select * from Produto
select * from ProdutoTipo