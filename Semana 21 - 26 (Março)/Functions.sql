select ASCII ('A')
select CHAR(65)

declare @Frase varchar(100)
set @Frase = 'Só sei que nada sei'
select CHARINDEX('sei', @Frase, 0) as Frase

declare @Frase varchar(100)
set @Frase = 'Só sei que nada sei'
select LEFT(@Frase, 6) as Direita
select RIGHT(@Frase, 12) as Esquerda
select LEN(@Frase) as Qtd
select UPPER(@Frase)
select LOWER(@Frase)


declare @Frase2 Varchar(100)
set @Frase2 = '          AVISO         '
select LTRIM(@Frase2)
select RTRIM(@Frase2)


declare @Frase3 Varchar(100)
set @Frase3 = '## ISSO É UM AVISO##'
select REPLACE(@Frase3, '#', '!')
select REPLICATE(@Frase3,2)

declare @Frase4 Varchar(40)
set @Frase4 = 'Daqui até aqui, esse resto não importa'
select SUBSTRING(@Frase4,0,15)

create table #nome
(
id_nome int identity primary key,
Nome varchar(50)
)

insert into #nome(Nome)
values('Larissa'), ('Largissa'), ('Linguiça'), ('Laryssa'), ('Larisa')
select * from #nome where SOUNDEX(nome) = SOUNDEX('Larissa')

select GETDATE()
select DATEPART(week, getdate())
select DATEADD(month, -4, getdate())

select CONVERT(varchar(10), GETDATE(), 103) as cudat

select datediff(YEAR, '2002-01-03', GETDATE())

select GETDATE() as ToComSede ,
case DATENAME(WEEKDAY,GETDATE())
when 'Domingo' then 'até meia noite pode'
when 'Segunda-feira' then '0 alcool'
when 'Terça-feira' then 'ainda sem alcool'
when 'Quarta-feira' then 'Já ta dando sede'
when 'Quinta-feira' then 'Um golinho pode'
when 'Sexta-feira' then 'Graças a Deus, Desce a gelada'
when 'Sábado' then 'Pode continuar descendo'

end as ConsultaSePode

--MATEMÁTICA

select power(2,2)
select abs(-84)
select sqrt(25)
select FLOOR(49.99)

declare @Valor int
set @Valor= null
select isnull(@Valor, '0')

select isdate(GETDATE()), isdate('String')

declare @Valor int
set @Valor= 154
select cast (@Valor as Varchar(10))








----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--2

declare @Cpf char(11)
set @Cpf = '45693160858'
select left(@Cpf, 3)+ '.'+ substring(@Cpf,4,3) + '.' +  substring(@Cpf,6,3)+'-' + substring(@Cpf,10,2)


--3

declare @Frase5 varchar(25)
set @Frase5 ='Essa tem 22 caractéres'
select len(@Frase5)


--4
declare @Nome varchar(25)
set @Nome = 'renato'
select Upper(left(@Nome,1)) + substring(@Nome,2,len(@Nome))


