set transaction isolation level read uncommitted
select --top 10 --*
c.RPU
,c.NumCredito
,c.fecha
,c.Total
,(select SUM(importe) from pagos where NumCredito = c.NumCredito) as totalPagado
,isnull((select SUM(pagodec) from det_amortizacion where solicitudscc = c.NumCredito and estatus in ('17','19')),0) as totaladeudado
,c.CodRegion
,c.CodCoord
,(select MAX(fechapago) from pagos where NumCredito = c.NumCredito ) as fechaUltimoPago
,c.estatusCredito
from creditos c
join clientes cl on cl.RPU=c.RPU and IdZona in (
													select zona
													from zonas
													where estado = 'Tabasco'
												)
where isnull((select SUM(pagodec) from det_amortizacion where solicitudscc = c.NumCredito and estatus in ('17','19')),0) > 0



select top 1000 *
from clientes
where IdZona in (
select zona
from zonas
where estado = 'Tabasco'
)

--where solicitudscc = '900088319'


