select  d.solicitudscc, d.rpu, d.capital, d.interes, d.ivainteres,
(select top 1 Importe from pagos p where p.NumCredito=d.solicitudscc order by  FechaPago desc)
,d.FechaOpFin
,pagare
--(select top 1 fechapago from pagos p where p.NumCredito=d.solicitudscc order by  FechaPago desc)
from det_amortizacion d
where  d.Rpu in 
(
'669080506659',
'329871200221',
'172130901617',
'869090800911',
'770960400623',
'773980300691',
'173981205067')
and d.estatus = '14'
order by d.solicitudscc, d.fecha desc