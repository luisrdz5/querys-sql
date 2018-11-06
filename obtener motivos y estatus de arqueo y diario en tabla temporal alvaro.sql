--Obteniendo de arqeuo
select r.Numcredito, t.NumCredito, r.FechaPago, t.FechaPago , a.motivo, a.status, a.stsenergia , a.fecfac, r.AnoFact+r.MesFact , convert(varchar,a.FECHAFACTPAGO,112) as fechapago , convert(varchar,r.FechaFactura,112)
,convert(varchar,a.fechaoperacion,112) , convert(varchar,r.FechaPago,112)
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join [LINKsac].[Arqueo].[dbo].[Arqueo_2018_09] a on a.rpu=t.RPU and  a.saldo=r.importe and ISDATE(a.FECHAFACTPAGO) = 1 
where  a.fecfac = r.AnoFact+Right('0'+r.MesFact,2)
and convert(varchar,a.fechaoperacion,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null

--update



update  t
set t.motivo=a.motivo, t.status=a.status, t.stsenergia=a.stsenergia 
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join [LINKsac].[Arqueo].[dbo].[Arqueo_2018_09] a on a.rpu=t.RPU and  a.saldo=r.importe and ISDATE(a.FECHAFACTPAGO) = 1 
where  a.fecfac = r.AnoFact+Right('0'+r.MesFact,2)
and convert(varchar,a.fechaoperacion,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null






-- obteniendo faltantes de cargadiariafecha


select r.Numcredito, t.NumCredito, r.FechaPago, t.FechaPago , a.motivo, a.estatus, a.Anofact , r.AnoFact ,a.MesFact,  r.MesFact ,a.fechapago,a.fechafactura
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join CargaDiariaFecha a on a.rpu=t.RPU and  a.importe=r.importe
where a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null




--update



update  t
set t.motivo=a.motivo, t.status=a.estatus
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join CargaDiariaFecha a on a.rpu=t.RPU and  a.importe=r.importe
where a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null



-- obteniendo faltantes de cargadiariafechaArqueo


select r.Numcredito, t.NumCredito, r.FechaPago, t.FechaPago , a.motivo, a.estatus, a.Anofact , r.AnoFact ,a.MesFact,  r.MesFact ,a.fechapago,a.fechafactura
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join CargaDiariaFechaArqueo a on a.rpu=t.RPU and  a.importe=r.importe
where a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null



--update



update  t
set t.motivo=a.motivo, t.status=a.estatus --, t.stsenergia=a.stsenergia 
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join CargaDiariaFechaArqueo a on a.rpu=t.RPU and  a.importe=r.importe
where a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null




-- obteniendo de arqueofide

--1130
select r.Numcredito, t.NumCredito, r.FechaPago, r.FechaFactura, a.motivo, a.status, a.fecfac , r.AnoFact,r.MesFact ,a.FECHAFACTPAGO,a.fechaoperacion ,r.*
from tmpcredsmotivooct t
join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago and t.motivo is null
join [LINKsac].[Arqueo].[dbo].[Arqueo_2018_09] a on a.rpu=t.RPU and  a.saldo=r.importe
and convert(varchar,a.FECHAFACTPAGO,112) = convert(varchar,r.FechaFactura,112) 
and convert(varchar,a.fechaoperacion,112) = convert(varchar,r.FechaPago,112)
--and a.fecfac = r.AnoFact+Right('0'+r.MesFact,2)
where spSQL is not null
--left join CargaDiariaFechaArqueo a on a.rpu=t.RPU and  a.importe=r.importe
--where convert(varchar,a.fechafactura,112) = convert(varchar,r.FechaFactura,112) 
--and a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
--and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
--and t.motivo is null




update  t
set t.motivo=a.motivo, t.status=a.status
from tmpcredsmotivooct t
join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago and t.motivo is null
join [LINKsac].[Arqueo].[dbo].[Arqueo_2018_09] a on a.rpu=t.RPU and  a.saldo=r.importe
and convert(varchar,a.FECHAFACTPAGO,112) = convert(varchar,r.FechaFactura,112) 
and convert(varchar,a.fechaoperacion,112) = convert(varchar,r.FechaPago,112)
--and a.fecfac = r.AnoFact+Right('0'+r.MesFact,2)



-- buscamos mas 

select r.Numcredito, t.NumCredito, r.FechaPago, r.FechaFactura, r.* --, a.motivo, a.status, a.fecfac , r.AnoFact,r.MesFact ,a.FECHAFACTPAGO,a.fechaoperacion ,r.*
from tmpcredsmotivooct t
join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago and t.motivo is null
--and a.fecfac = r.AnoFact+Right('0'+r.MesFact,2)
where spSQL is  null
-


-----------------------------Obtengo datos de creditos que presentaron cambios de rpu  ----------------------------------------------




--Obteniendo de arqeuo
select r.Numcredito, t.NumCredito, r.FechaPago, t.FechaPago , a.motivo, a.status, a.stsenergia , a.fecfac, r.AnoFact+r.MesFact , convert(varchar,a.FECHAFACTPAGO,112) as fechapago , convert(varchar,r.FechaFactura,112)
,convert(varchar,a.fechaoperacion,112) , convert(varchar,r.FechaPago,112)
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join [LINKsac].[Arqueo].[dbo].[Arqueo_2018_09] a on a.rpu=t.rpuorigen and  a.saldo=r.importe and ISDATE(a.FECHAFACTPAGO) = 1 
where  a.fecfac = r.AnoFact+r.MesFact
and convert(varchar,a.fechaoperacion,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null
and  t.rpuorigen <>'NULL'

--update



update  t
set t.motivo=a.motivo, t.status=a.status, t.stsenergia=a.stsenergia 
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join [LINKsac].[Arqueo].[dbo].[Arqueo_2018_09] a on a.rpu=t.rpuorigen and  a.saldo=r.importe and ISDATE(a.FECHAFACTPAGO) = 1 
where  a.fecfac = r.AnoFact+r.MesFact
and convert(varchar,a.fechaoperacion,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null
and  t.rpuorigen <>'NULL'






-- obteniendo faltantes de cargadiariafecha


select r.Numcredito, t.NumCredito, r.FechaPago, t.FechaPago , a.motivo, a.estatus, a.Anofact , r.AnoFact ,a.MesFact,  r.MesFact ,a.fechapago,a.fechafactura
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join CargaDiariaFecha a on a.rpu=t.rpuorigen and  a.importe=r.importe
where a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null
and  t.rpuorigen <>'NULL'




--update



update  t
set t.motivo=a.motivo, t.status=a.estatus
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join CargaDiariaFecha a on a.rpu=t.rpuorigen and  a.importe=r.importe
where a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null
and  t.rpuorigen <>'NULL'




-- obteniendo faltantes de cargadiariafechaArqueo


select r.Numcredito, t.NumCredito, r.FechaPago, t.FechaPago , a.motivo, a.estatus, a.Anofact , r.AnoFact ,a.MesFact,  r.MesFact ,a.fechapago,a.fechafactura
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join CargaDiariaFechaArqueo a on a.rpu=t.rpuorigen and  a.importe=r.importe
where a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null
and  t.rpuorigen <>'NULL'



--update



update  t
set t.motivo=a.motivo, t.status=a.estatus --, t.stsenergia=a.stsenergia 
from tmpcredsmotivooct t
left join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago
left join CargaDiariaFechaArqueo a on a.rpu=t.rpuorigen and  a.importe=r.importe
where a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
and t.motivo is null
and  t.rpuorigen <>'NULL'





-- obteniendo de arqueofide

--1130
select r.Numcredito, t.NumCredito, r.FechaPago, r.FechaFactura, a.motivo, a.status, a.fecfac , r.AnoFact,r.MesFact ,a.FECHAFACTPAGO,a.fechaoperacion ,r.*
from tmpcredsmotivooct t
join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago and t.motivo is null
join [LINKsac].[Arqueo].[dbo].[Arqueo_2018_09] a on a.rpu=t.rpuorigen and  a.saldo=r.importe
and convert(varchar,a.fechaoperacion,112) = convert(varchar,r.FechaPago,112)
--and a.fecfac = r.AnoFact+Right('0'+r.MesFact,2)
where  t.rpuorigen <>'NULL'
--left join CargaDiariaFechaArqueo a on a.rpu=t.RPU and  a.importe=r.importe
--where convert(varchar,a.fechafactura,112) = convert(varchar,r.FechaFactura,112) 
--and a.Anofact = r.AnoFact and a.MesFact =  Right('0'+r.MesFact,2)
--and convert(varchar,a.fechapago,112) = convert(varchar,r.FechaPago,112)
--and t.motivo is null




update  t
set t.motivo=a.motivo, t.status=a.status
from tmpcredsmotivooct t
join registrossicomok r on t.IDReferencia = r.ID and r.Numcredito=t.NumCredito and r.FechaPago=t.FechaPago and t.motivo is null
join [LINKsac].[Arqueo].[dbo].[Arqueo_2018_09] a on a.rpu=t.rpuorigen and  a.saldo=r.importe
and convert(varchar,a.fechaoperacion,112) = convert(varchar,r.FechaPago,112)
--and a.fecfac = r.AnoFact+Right('0'+r.MesFact,2)
where  t.rpuorigen <>'NULL'








