--detectamos los pagos con error 8 qhe tienen diferente fecha de pago con pagos

--62
-- -21 
--41 reprocesar 
select r.mesfact, p.MesFactOrigen, isnull(p.MesFactOrigen, MONTH(p.FechaFac) ) ,r.AnoFact, p.AnoFactOrigen, isnull(p.AnoFactOrigen,YEAR(p.FechaFac)),p.fechafac,r.FechaFactura,r.FechaPago,p.FechaPago,r.Numcredito,p.NumCredito,r.RPU,p.Rpu,r.*,p.*
from RegistrosSicomOK r
left join pagos p on p.NumCredito=r.Numcredito 
				and YEAR(r.FechaFactura)  = isnull(p.AnoFactOrigen,YEAR(p.FechaFac))  
				and MONTH(r.FechaFactura) = isnull(p.MesFactOrigen, MONTH(p.FechaFac) )   
				and r.FechaPago=p.FechaPago  
where Archivo='PAGOS FIDE SEPTIEMBRE 2019 Prt 1.xlsx' and error=8  and p.NumCredito is not null


select r.mesfact, p.MesFactOrigen, isnull(p.MesFactOrigen, MONTH(p.FechaFac) ) ,r.AnoFact, p.AnoFactOrigen, isnull(p.AnoFactOrigen,YEAR(p.FechaFac)),p.fechafac,r.FechaFactura,r.FechaPago,p.FechaPago,r.Numcredito,p.NumCredito,r.RPU,p.Rpu,r.*,p.*
from RegistrosSicomOK r
left join pagos p on p.NumCredito=r.Numcredito 
				and r.AnoFact  = isnull(p.AnoFactOrigen,YEAR(p.FechaFac))  
				and r.mesfact = isnull(p.MesFactOrigen, MONTH(p.FechaFac) )      
				and r.FechaPago=p.FechaPago  
where Archivo='PAGOS FIDE SEPTIEMBRE 2019 Prt 1.xlsx' and error=8  and p.NumCredito is  null

--obtener resumen

select archivo, COUNT(*), SUM(importe)
from (
select r.*
from RegistrosSicomOK r
left join pagos p on p.NumCredito=r.Numcredito 
				and r.AnoFact  = isnull(p.AnoFactOrigen,YEAR(p.FechaFac))  
				and r.mesfact = isnull(p.MesFactOrigen, MONTH(p.FechaFac) )   
				and r.FechaPago=p.FechaPago  
where Archivo='PAGOS FIDE SEPTIEMBRE 2019 Prt 1.xlsx' and error=8  and p.NumCredito is  null) as tmp 
group by Archivo


-- resumen de todo el año

select archivo, COUNT(*), SUM(importe)
from (
select r.*
from RegistrosSicomOK r
left join pagos p on p.NumCredito=r.Numcredito 
				and r.AnoFact  = isnull(p.AnoFactOrigen,YEAR(p.FechaFac))  
				and r.mesfact = isnull(p.MesFactOrigen, MONTH(p.FechaFac) )     
				and r.FechaPago=p.FechaPago  
where error=8  and r.Numcredito not in ('0000000000') and p.NumCredito is  null and archivo in (
					SELECT [Archivo]
					FROM [SOF_SircaNac].[dbo].[Control_ARQUEO]
  )
							) as tmp 
group by Archivo
order by Archivo 

--detalle de todo el año


select r.*
from RegistrosSicomOK r
left join pagos p on p.NumCredito=r.Numcredito 
				and r.AnoFact  = isnull(p.AnoFactOrigen,YEAR(p.FechaFac))  
				and r.mesfact = isnull(p.MesFactOrigen, MONTH(p.FechaFac) )    
				and r.FechaPago=p.FechaPago  
where error=8 and r.Numcredito not in ('0000000000') and p.NumCredito is  null and archivo in (
					SELECT [Archivo]
					FROM [SOF_SircaNac].[dbo].[Control_ARQUEO]
  )
  
  --pagos updateados 
/*  
update r
set error=0, procesado=0
from RegistrosSicomOK r
left join pagos p on p.NumCredito=r.Numcredito 
				and r.AnoFact  = isnull(p.AnoFactOrigen,YEAR(p.FechaFac))  
				and r.mesfact = isnull(p.MesFactOrigen, MONTH(p.FechaFac) )    
				and r.FechaPago=p.FechaPago  
where error=8 and r.Numcredito not in ('0000000000') and p.NumCredito is  null and archivo in (
					SELECT [Archivo]
					FROM [SOF_SircaNac].[dbo].[Control_ARQUEO]
  )
  
  */
  
  
  

select r.numcredito, r.Error,r.Procesado,r.importe,t.importe,t.*
from tmppagos8reaplicados t
join RegistrosSicomOK r on r.ID=t.id

--obtencion de resumen

select *
from (
	select r.error, COUNT(*), sum(r.importe)
	from tmppagos8reaplicados t
	join RegistrosSicomOK r on r.ID=t.id
	where r.error <> 20
	group by r.error
	union 
	select 0 as error , COUNT(*), sum(t.importe)
	from tmppagos8reaplicados t
	join RegistrosSicomOK r on r.ID=t.id
	where r.error = 20 and r.importe=0
	group by r.error
	
) as tmp 
group by tmp.error



-- saco los error 20

select r.numcredito, (t.importe - r.importe) as aplicado,(r.importe) as no_aplicado , r.Error,r.Procesado,r.importe,t.importe,t.*
from tmppagos8reaplicados t
join RegistrosSicomOK r on r.ID=t.id
where r.error=20 and r.importe > 0



-- obtenermos resumen de los 20 
select sum(t.importe - r.importe) as aplicado,sum(r.importe) as no_aplicado , SUM(t.importe) as total, COUNT(*) 
from tmppagos8reaplicados t
join RegistrosSicomOK r on r.ID=t.id
where r.error=20 and r.importe > 0





-- detalles para enviar
-- detalle de correctos 
select r.*
from tmppagos8reaplicados t
join RegistrosSicomOK r on r.ID=t.id
where r.error = 0
union
select 
(select top 1 id from RegistrosSicomOK where IDCargaDiariaFecha = r.IDCargaDiariaFecha and error=0) as id
,r.IDCargaDiariaFecha
,r.Archivo
,r.RPU
,r.Numcredito
,r.Producto
,r.FechaFactura
,r.FechaPago
,r.FechaVencimiento
,r.importe
,r.Estatus
,r.AnoFact
,r.MesFact
,0 as error
,r.TipoCred
,r.EsPagoFin
,r.FechaArchivo
,r.FechaProceso
,r.HostName
,r.UsuarioSQL
,r.spSQL
,r.Procesado
,r.fecha
,r.EstatusFechaEnvio
,r.FechaLlegada
,r.FechaPagoCFE
,r.PagoDeMas
,r.PagoEliminado
,r.AppBusquedaPago
,r.estatusSicom
,r.motivo
,r.stsenergia
from tmppagos8reaplicados t
join RegistrosSicomOK r on r.ID=t.id
where r.error=20 and r.importe = 0






--detalle de error 8 
select r.*
from tmppagos8reaplicados t
join RegistrosSicomOK r on r.ID=t.id
where r.error=8

-- detalle de error 20 
select (t.importe - r.importe) as aplicado,r.importe as no_aplicado , t.importe as total_llego_cfe, t.*  
from tmppagos8reaplicados t
join RegistrosSicomOK r on r.ID=t.id
where r.error=20 and r.importe > 0
