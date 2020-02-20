set transaction isolation level read uncommitted 
select 
rpu
,solicitudscc
,SUM(pagodec) adeudototal
,(select sum(saldototal) from LINKsac.arqueo.dbo.Arqueo_2016_08 where rpu=d.rpu ) cantidadcargadasicom
,SUM(pagodec) - (select sum(saldototal) from LINKsac.arqueo.dbo.Arqueo_2016_08 where rpu=d.rpu ) resta
from det_amortizacion d
where solicitudscc in (
	select distinct solicitudscc
	from det_amortizacion 
	where estatus in ('17','19')
)
group by rpu, solicitudscc
having  SUM(pagodec) > (select sum(saldototal) from LINKsac.arqueo.dbo.Arqueo_2016_08 where rpu=d.rpu )
order by SUM(pagodec) - (select sum(saldototal) from LINKsac.arqueo.dbo.Arqueo_2016_08 where rpu=d.rpu ) asc