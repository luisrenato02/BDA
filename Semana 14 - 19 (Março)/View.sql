create view VWDataVenda
as


select v.CodigoVenda, v.DataVenda, v.CodigoCliente, v.CodigoVendedor, v.CodigoLoja, vi.CodigoVendaItem, vi.CodigoProduto, p.CodigoProdutoTipo, p.ValorVenda
from Venda v inner join VendaItem vi
on vi.CodigoVendaItem = v.CodigoVenda
inner join  Produto p
on p.CodigoProduto=vi.CodigoVendaItem

group by v.CodigoVenda, v.DataVenda, v.CodigoVendedor, v.CodigoCliente, v.CodigoLoja, vi.CodigoProduto, vi.CodigoVendaItem, p.CodigoProdutoTipo, p.ValorVenda
