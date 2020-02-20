;With Multicreditos
As
(
	select c.rpu, c.NumCredito, c.TipoCredito, c.fecha as fecha_apertura,  e.Descripcion as estatus, c.Total
	,(select SUM(importe) from pagos where numcredito=c.NumCredito) as pagado
	,(c.Total - (select SUM(importe) from pagos where numcredito=c.NumCredito)) as adeudo
	,(select datediff(dd,MIN(fecha),GETDATE()) from det_amortizacion where solicitudscc = c.NumCredito and estatus not in ('14','18')) as dias_amortizacion_mas_vieja
	,(select MIN(fecha) from det_amortizacion where solicitudscc = c.NumCredito and estatus not in ('14','18')) as vencimiento_amortizacion_mas_vieja
	,(select datediff(dd,MIN(fecha),GETDATE()) from det_amortizacion where rpu = c.rpu and estatus not in ('14','18')) as dias_amortizacion_mas_vieja_por_rpu
	from creditos c
	join estatus e on e.IdEst=c.estatusCredito
	where rpu in ( 
		select distinct rpu
		from creditos 
		where estatusCredito not in ('8','9','20','25') and tipocredito in ('PA','FV','CV') and rpu in (
				select rpu
				from creditos
				group by rpu
				having COUNT(*) >1 
			)
		)
)
/*
-- se hace analisis de aproximadamente cuantos pagos con estatus 20 fueron no pedidos antes de noviembre del 2017
select RPU, Numcredito, error, importe, FechaPago, FechaVencimiento, FechaFactura 
from RegistrosSicomOK
where rpu in ( 
select distinct rpu
from Multicreditos)
and error=20 
and Producto in ('PA','FV','CV')
and FechaPago < '20171101'
group by  RPU, Numcredito, error, importe, FechaPago, FechaVencimiento, FechaFactura 
order by rpu
*/
-- resumen de analisis anterior

select COUNT(*), SUM(importe)
from (
select RPU, Numcredito, error, importe, FechaPago, FechaVencimiento, FechaFactura 
from RegistrosSicomOK
where rpu in ( 
select distinct rpu
from Multicreditos)
and error=20 
and Producto in ('PA','FV','CV')
and FechaPago < '20171101'
group by  RPU, Numcredito, error, importe, FechaPago, FechaVencimiento, FechaFactura 
) as tmp 



-- se hace analisis de aproximadamente cuantos pagos con estatus 20 fueron aplicados de forma erronea ( a un credito que no le correspoindia)
