select solicitudscc, pagodec , estatus 
,(select Importe from pagos where NumCredito=d.solicitudscc and d.pagodec=importe)
from det_amortizacion d 
where solicitudscc in (
select distinct solicitudscc 
from det_amortizacion 
where solicitudscc in (
	select distinct solicitudscc 
	from det_amortizacion d
	join creditos c on c.NumCredito=d.solicitudscc 
	where c.TipoCredito in ('RF','AA') and d.estatus in ('17','19')
	)
group by solicitudscc
having COUNT(*) in ('49')	)
and pagare='49' and estatus in ('17','19')