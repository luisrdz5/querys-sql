set transaction isolation level read uncommitted
select solicitudscc, rpu, COUNT(*),
(select COUNT(*) from det_amortizacion where solicitudscc = det.solicitudscc and estatus in ('17','19') ) as amortizaciones_restantes
,(select SUM(importe) from pagos where NumCredito=det.solicitudscc) pagado 
,(select SUM(pagodec) from det_amortizacion where solicitudscc = det.solicitudscc) as adeudototal
,(select SUM(pagodec) from det_amortizacion where solicitudscc = det.solicitudscc) 
- (select SUM(importe) from pagos where NumCredito=det.solicitudscc) 
from det_amortizacion det
where solicitudscc in (
	select distinct solicitudscc 
	from det_amortizacion d
	join creditos c on c.NumCredito=d.solicitudscc 
	where c.TipoCredito in ('RF','AA') and d.estatus in ('17','19')
)
and (select COUNT(*) from det_amortizacion where solicitudscc = det.solicitudscc and estatus in ('17','19') )  = 1 
group by solicitudscc, rpu
having COUNT(*) in ('25','49')
order by ((select SUM(pagodec) from det_amortizacion where solicitudscc = det.solicitudscc) 
- (select SUM(importe) from pagos where NumCredito=det.solicitudscc))  ASC

