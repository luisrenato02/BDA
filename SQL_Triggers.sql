IF NOT EXISTS (SELECT * FROM sys.databases d where NAME = 'AulaTrigger')
BEGIN
	create DATABASE AulaTrigger	
END

GO

-- Acessando o Banco AulaTrigger.
USE AulaTrigger
GO

/***********************************************************************************************************
*
*
* TRIGGER DDL (Linguagem de Definição de Dados)
*
*
***********************************************************************************************************/



/***********************************************************************************************************
* 1. Criando a Tabela HistoricoDDL que irá armazenar todos os comandos de manipulação das tabelas no banco.
***********************************************************************************************************/
CREATE TABLE HistoricoDDL
(
	ID INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
	NomeMaquina VARCHAR(80) NOT NULL DEFAULT HOST_NAME(), -- HOST_NAME() Função que retorna o nome do servidor.,
	DataExecucao DATETIME DEFAULT GETDATE(), -- GETDATE() Função que retorna a data e hora atual.
	CodigoGerado XML
)

GO



/***********************************************************************************************************
* 2. Criando a TRIGGER TR_HistoricoDDL que será disparado toda vez que um comando CREATE TABLE, ALTER TABLE
*	 ou DROP TABLE executado no Banco de Dados. 
*	 A TRIGGER irá inserir um registro com as alterações na tabela HistoricoDDL.
***********************************************************************************************************/
CREATE TRIGGER TR_HistoricoDDL ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS
BEGIN
	INSERT INTO HistoricoDDL(CodigoGerado) VALUES(EVENTDATA())
END

-- Obtendo os registros da tabela HistoricoDDL.
SELECT * FROM HistoricoDDL hd


GO





/***********************************************************************************************************
* 
* 
* TRIGGER AFTER para comandos DML (Linguagem de Manipulação de Dados)
*
*
***********************************************************************************************************/




/***********************************************************************************************************
* RELEMBRANDO O CENÁRIO PROPOSTO:
* CENÁRIO.: Uma loja de departamentos que possui um estoque de produtos e um controle das vendas.
* OBJETIVO: 1. Atualizar a quantidade do estoque de acordo com a quantidade vendida.
*			2. Armazenar em uma tabela de Backup os dados do Cliente.
***********************************************************************************************************/


/***********************************************************************************************************
* 3. Criando a tabela Produto.
***********************************************************************************************************/
CREATE TABLE Produto
(
	ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nome VARCHAR(80) NOT NULL,
	QtdEstoque INT NOT NULL
)

GO

-- Populando a tabela Produto.
INSERT INTO Produto(Nome,QtdEstoque) VALUES('Televisão LCD', 30)
INSERT INTO Produto(Nome,QtdEstoque) VALUES('Notebook', 10)
INSERT INTO Produto(Nome,QtdEstoque) VALUES('Camiseta', 100)

GO






/***********************************************************************************************************
* 4. Criando a tabela de Cliente
***********************************************************************************************************/
CREATE TABLE Cliente
(
	ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Nome VARCHAR(80) NOT NULL
)

GO



/***********************************************************************************************************
* 5. Criando a tabela de BackUp da tabela Cliente.
***********************************************************************************************************/
CREATE TABLE ClienteBackUp
(
	DATA DATETIME DEFAULT GETDATE(),
	ID INT PRIMARY KEY NOT NULL,
	Nome VARCHAR(80) NOT NULL	
)

GO




/***********************************************************************************************************
* 6. Criando uma TRIGGER para a tabela Cliente na ação INSERT a fim de armazenar na tabela de Backup os registros.
***********************************************************************************************************/
CREATE TRIGGER TR_Cliente ON Cliente
FOR INSERT
AS
BEGIN
	
	-- Ao inserir um registro na tabela cliente a trigger insere os mesmos valores na tabela de BackUp.
	INSERT INTO ClienteBackUp(ID, Nome)
	SELECT ID, Nome FROM INSERTED -- tabela inserted contem os valores inseridos na tabela.
		
END

GO



/***********************************************************************************************************
* 7. Obtendo os registros das tabelas Cliente e ClienteBackUp.
***********************************************************************************************************/
SELECT * FROM Cliente
SELECT * FROM ClienteBackUp


GO


/***********************************************************************************************************
* 8. Inserindo na tabela Cliente
***********************************************************************************************************/
INSERT INTO Cliente(Nome) VALUES ('Ana')
INSERT INTO Cliente(Nome) VALUES ('Jose')


GO



/***********************************************************************************************************
* 9. Criando a tabela Venda.
***********************************************************************************************************/
CREATE TABLE Venda
(
	IDVenda INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	DataVenda DATETIME DEFAULT GETDATE(),
	IDCliente INT NOT NULL,
	IDProduto INT NOT NULL,
	QuantidadeVenda INT NOT NULL,
	CONSTRAINT FK_Venda_Cliente FOREIGN KEY (IDCliente) REFERENCES Cliente(ID),
	CONSTRAINT FK_Venda_Produto FOREIGN KEY (IDProduto) REFERENCES Produto(ID)
)

GO




/***********************************************************************************************************
* 10. Criando uma TRIGGER AFTER para a tabela Venda na ação INSERT.
***********************************************************************************************************/
CREATE TRIGGER TR_Venda ON Venda
FOR INSERT
AS
BEGIN
	
	-- Obtendo o ID do Produto Vendido.
	DECLARE @IDProduto INT
	SET @IDProduto = (SELECT IDProduto FROM INSERTED)
	
	-- Obtendo a Quantidade Vendida.
	DECLARE @QtdVenda INT
	SET @QtdVenda = (SELECT QuantidadeVenda FROM INSERTED)
	
	-- Atualizando o Estoque.
	UPDATE Produto 
	SET QtdEstoque = (QtdEstoque - @QtdVenda) 
	WHERE ID = @IDProduto 
	
END


GO



/***********************************************************************************************************
* 11. Obtendo os registros das tabelas Cliente, Produto e Venda.
***********************************************************************************************************/
SELECT * FROM Cliente c
SELECT * FROM Produto p
SELECT * FROM Venda v


GO


/***********************************************************************************************************
* 12. Inserindo uma venda na tabela Venda.
***********************************************************************************************************/
INSERT INTO Venda(IDCliente,IDProduto,QuantidadeVenda) VALUES (1, 1, 1)
INSERT INTO venda(IDCliente,IDProduto,QuantidadeVenda) VALUES (2, 3, 10)  



GO



/*************************************************************************************************
* Considere que a loja que está comprando o Sistema pediu uma alteração para que 
* no momento da venda o Sistema analise se o cliente é inadimplente ou não, caso ele seja
* a venda deverá ser cancelada, caso o cliente seja um bom pagador a vende será efetivada.
**************************************************************************************************/



/***********************************************************************************************************
* 13. Adicionando o campo Inadimplente para a tabela Cliente e ClienteBackUp.
***********************************************************************************************************/
ALTER TABLE Cliente ADD Inadimplente CHAR(1) DEFAULT 'N'
ALTER TABLE ClienteBackUp ADD Inadimplente CHAR(1)


GO


/***********************************************************************************************************
* 14. Colocando o valor 'N' para todos os registros da tabela.
***********************************************************************************************************/ 
UPDATE Cliente SET Inadimplente = 'N'
UPDATE ClienteBackup SET Inadimplente = 'N' 

SELECT * FROM Cliente c


GO



/***********************************************************************************************************
* 15. Mudando o status de Inadimplente da Ana para 'S'
***********************************************************************************************************/
UPDATE Cliente SET Inadimplente = 'S' WHERE ID = 1

SELECT * FROM Cliente c


GO


/***********************************************************************************************************
* 16. Alterando a Trigger TR_Venda para implementar a regra de verificação de inadimplencia no momento da venda.
***********************************************************************************************************/
alter TRIGGER TR_Venda ON Venda
FOR INSERT
AS
BEGIN
	
	-- Obtendo o ID do Cliente.
	DECLARE @IDCliente INT
	SET @IDCliente = (SELECT IDCliente FROM INSERTED)


	
	-- Verificando se o cliente Não é Inadimplente, caso ele for, então impede a venda.
	DECLARE @ClienteInadimplente CHAR(1)
	SET @ClienteInadimplente = (SELECT Inadimplente FROM Cliente c WHERE ID = @IDCliente)	
	
	--Obtendo Id do Produto
	declare @IdProduto int
	set @IdProduto = (select IDProduto from inserted)

	 --Obtendo o estoque atual
	declare @QtdEstoque int
	set @QtdEstoque = (select QtdEstoque from Produto where ID = @IdProduto)

	--Obtendo Quantidade Vendida
	declare @QtdVenda int
	set @QtdVenda = (select QuantidadeVenda from inserted)
	
	-- Fazendo uma condição para que SE o cliente for inadimplente, ENTÃO cancela a venda.
	IF(@ClienteInadimplente = 'S')
		BEGIN
			
			PRINT 'Cliente em situação de inadimplência, a venda será cancelada automaticamente pelo Sistema.'
			ROLLBACK
			
		END

	if(@QtdEstoque<@QtdVenda)
	   begin
	      print('Quantidade do Estoque insuficiente para a Venda')
		  rollback
		end
		
	ELSE
		BEGIN	
				
			-- Atualizando a Quantidade do Produto no Estoque.
			UPDATE Produto 
			SET QtdEstoque = (QtdEstoque - @QtdVenda) 
			WHERE ID = @IdProduto 
	
		END
END

insert into Venda(IDCliente,IDProduto,QuantidadeVenda)
values(2,1,1)


/***********************************************************************************************************
* 17. Inserindo uma venda para o Cliente 2 (José) na tabela Venda. 
* OBS: Ele não está inadimplente, portanto a venda deverá ser concretizada. 
***********************************************************************************************************/
SELECT * FROM Cliente c
SELECT * FROM Produto p
SELECT * FROM Venda v

INSERT INTO Venda(IDCliente,IDProduto,QuantidadeVenda) VALUES (2, 3, 10)

SELECT * FROM Cliente c
SELECT * FROM Produto p
SELECT * FROM Venda v


GO




/***********************************************************************************************************
* 18. Inserindo uma venda para o Cliente 1 (Ana) na tabela Venda. 
* OBS: Ele está inadimplente, portanto a venda deverá ser desfeita.
***********************************************************************************************************/
SELECT * FROM Cliente c
SELECT * FROM Produto p
SELECT * FROM Venda v

INSERT INTO Venda(IDCliente,IDProduto,QuantidadeVenda) VALUES (1, 3, 2)

SELECT * FROM Cliente c
SELECT * FROM Produto p
SELECT * FROM Venda v



GO



/***********************************************************************************************************
* 
* 
* TRIGGER INSTEAD OF para comandos DML (Linguagem de Manipulação de Dados)
* 
* 
***********************************************************************************************************/




/***********************************************************************************************************
* 19. Criando uma TRIGGER INSTEAD OF para a tabela VEnda no evento DELETE.
***********************************************************************************************************/
CREATE TRIGGER TR_ImpedirExclusaoVenda ON Venda
INSTEAD OF DELETE
AS
BEGIN
	PRINT 'O Sistema está configurado para impedir comandos de exclusão de registros na tabela Venda' 	
END


GO



/***********************************************************************************************************
* 20. Removendo um cliente da tabela de Vendas.
***********************************************************************************************************/
SELECT * FROM Venda v
DELETE FROM Venda WHERE IDVenda = 2
SELECT * FROM Venda v


GO



/***********************************************************************************************************
* 21. Desabilitando e Habilitando uma TRIGGER.
***********************************************************************************************************/
DISABLE TRIGGER TR_ImpedirExclusaoVenda ON Venda
ENABLE TRIGGER TR_ImpedirExclusaoVenda ON Venda

/***********************************************************************************************************
* 22. Criando tabela Backup produto.
***********************************************************************************************************/
create table ProdutoBkp(
   id int,
   nome varchar(80),
   historico varchar(50),
   preco money
   
)

alter table Produto add preco money --Adicionando a coluna preço na tabela Produto


 /***********************************************************************************************************
* 23. Criando A Trigger que fará o insert na tabela ProdutoBkp toda vez que o preço dos Produtos forem alterados
***********************************************************************************************************/

create trigger TR_BkpProdutos on Produto
   for update
   as
   begin
      

       insert into ProdutoBkp(id, nome, preco, historico) 
	   select id, nome, preco, ('Preço alterado para') FROM inserted -- tabela inserted contem os valores inseridos na tabela.




   end


update Produto set preco = 1500 where ID = 3 --alterando o preço dos produtos



