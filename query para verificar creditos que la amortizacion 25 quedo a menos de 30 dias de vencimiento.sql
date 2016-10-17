
select  solicitudscc, rpu, COUNT(*)
,datediff(DD,(select fecha from det_amortizacion where solicitudscc = d.solicitudscc and pagare = 24),(select fecha from det_amortizacion where solicitudscc = d.solicitudscc and pagare = 25))
,(select fecha from det_amortizacion where solicitudscc = d.solicitudscc and pagare = 24)
,(select dateadd(dd,60,fecha) from det_amortizacion where solicitudscc = d.solicitudscc and pagare = 24)
from det_amortizacion d
where solicitudscc in (
	select distinct solicitudscc 
	from det_amortizacion d
	join creditos c on c.NumCredito=d.solicitudscc 
	where c.TipoCredito in ('RF','AA') and d.estatus in ('17','19')
	)
and 
datediff(DD,(select fecha from det_amortizacion where solicitudscc = d.solicitudscc and pagare = 24),(select fecha from det_amortizacion where solicitudscc = d.solicitudscc and pagare = 25)) < 50
group by solicitudscc, rpu
having COUNT(*) in ('25')
