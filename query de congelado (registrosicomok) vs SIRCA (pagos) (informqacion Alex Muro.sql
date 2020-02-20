select *
into #tmp1
from 
(SELECT rs.*
		  FROM dbo.RegistrosSicomOK rs With(Nolock)
		       Inner Join dbo.Creditos c On c.NumCredito = rs.NumCredito
		       -->>Se cambiaron los Inner por Left, debido a que ya no se toma la info. para la generación de Oficios
			   Left Join dbo.Clientes cl With(Nolock) On cl.RPU = rs.RPU
			   Left Join RegionCFE r On r.ZonaCFE = Substring(cl.NumCuenta,3,2)
			   --//
			   Left Join ZonasFIDE zf on zf.fclavesuc = Substring(cl.numcuenta,3,5)
		 WHERE IsNull(rs.Archivo ,'') Not In ('CuentaRAP','PagoRAP',/*'Liquidación en Ventanilla CFE (Pago fuera de Facturación),'*/'NA - Extractor1','NA - Extractor2','NA - ARQUEO1','NA - ARQUEO2')
		   AND rs.Estatus = '01'
		   --AND rs.IDCargaDiariaFecha Is Not Null -->>Pagos pendientes de Solicitar a CFE, pero que todavia no se da la autorización para solicitarlos
		   AND rs.Error = 0
		   AND rs.Procesado = 1 
		   --And IsNull(rs.PagoDeMas,0) = 0 -->>Se quito por que CFE paga todos los pagos
		   AND rs.EstatusFechaEnvio Is Null
		   AND IsNull(rs.Archivo,'') <> ''
		   AND IsNull(rs.PagoEliminado,0) <> 1
		   --AND Convert(varchar(6),rs.FechaPago,112) >= '201901' -->> Fecha de corte
		   AND YEAR(rs.FechaProceso) = 2018

		 UNION -->>Pagos que exceden por una cantidad miníma al Monto de CFE
		SELECT rs.*
   	     FROM dbo.RegistrosSicomOK rs With(Nolock)
		       Inner Join dbo.Creditos c On c.NumCredito = rs.NumCredito
			   Inner Join dbo.Clientes cl With(Nolock) On cl.RPU = rs.RPU
			   Inner Join RegionCFE r On r.ZonaCFE = Substring(cl.NumCuenta,3,2)
			   Left Join ZonasFIDE zf on zf.fclavesuc = Substring(cl.numcuenta,3,5)
		 WHERE IsNull(rs.Archivo ,'') Not In ('CuentaRAP','PagoRAP',/*'Liquidación en Ventanilla CFE (Pago fuera de Facturación),'*/'NA - Extractor1','NA - Extractor2','NA - ARQUEO1','NA - ARQUEO2')
		   AND rs.Estatus = '01'
		   AND rs.Error = 0
		   AND rs.Procesado = 1 
		   AND rs.EstatusFechaEnvio Is Null
		   AND IsNull(rs.Archivo,'') <> ''
		   AND IsNull(rs.PagoEliminado,0) <> 1
		   AND IsNull(rs.PagoDeMas,0) = 2 -->>Importe menor y Fecha de Pago más reciente
		   --AND Convert(varchar(6),rs.FechaPago,112) >= '201901' -->> Fecha de corte
		   AND YEAR(rs.FechaProceso) = 2018
)	as tmp	 



--resumen de cruce entre registrossicomom y sirca 

select  year(a.fechaproceso)
,MONTH(A.FECHAPROCESO)
,SUM(CASE WHEN A.PRODUCTO IN ('CV') THEN A.IMPORTE ELSE 0 END ) AS CONAVI 
,SUM(CASE WHEN A.PRODUCTO IN ('LD') THEN A.IMPORTE ELSE 0 END ) AS LEDS 
,SUM(CASE WHEN A.PRODUCTO IN ('MT') THEN A.IMPORTE ELSE 0 END ) AS MT 
,SUM(CASE WHEN A.PRODUCTO IN ('PR') THEN A.IMPORTE ELSE 0 END ) AS PRESEMEH 
,SUM(CASE WHEN A.PRODUCTO IN ('RF','AA') THEN A.IMPORTE ELSE 0 END ) AS SENER 
,SUM(CASE WHEN A.PRODUCTO IN ('FV','PA') THEN A.IMPORTE ELSE 0 END ) AS PAEEEM 
,COUNT(*)
,SUM(a.importe)
-- select a.numcredito, a.fechapago, a.*--,p.*
from #tmp1 a
left join 
(	select NumCredito,FechaPago,MesFactOrigen,AnoFactOrigen
	from pagos
	where NumCredito in 
	(
		select distinct NumCredito
		from #tmp1
	)
	group by NumCredito,FechaPago,MesFactOrigen,AnoFactOrigen
) as p on p.NumCredito=a.numcredito and a.FechaPago=p.FechaPago and p.MesFactOrigen=a.mesfact and p.AnoFactOrigen=a.anofact
where  p.NumCredito is not null
group by MONTH(a.fechaproceso), year(a.fechaproceso)
order by MONTH(A.FECHAPROCESO)



--detalle de los pagos aplicados 11062019
select  a.id as idregistrosicomok, importe
from #tmp1 a
left join 
(	select NumCredito,FechaPago,MesFactOrigen,AnoFactOrigen
	from pagos
	where NumCredito in 
	(
		select distinct NumCredito
		from #tmp1
	)
	group by NumCredito,FechaPago,MesFactOrigen,AnoFactOrigen
) as p on p.NumCredito=a.numcredito and a.FechaPago=p.FechaPago and p.MesFactOrigen=a.mesfact and p.AnoFactOrigen=a.anofact
where  p.NumCredito is not null

