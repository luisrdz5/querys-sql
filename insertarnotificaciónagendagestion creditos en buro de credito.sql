INSERT INTO [SIRCANAC].[dbo].[gestioninterna]
           ([rpu]
           ,[fechagestion]
           ,[tipogestion]
           ,[diasvencido]
           ,[importevencido]
           ,[fechapromesa]
           ,[resp1]
           ,[resp2]
           ,[resp2otra]
           ,[resp3]
           ,[resp4]
           ,[comentario]
           ,[moratorios]
           ,[iva]
           ,[gestor]
           ,[NumCredito])
select 
cr.rpu
, buro.FechaAlta
,'7'
,(select isnull(datediff(dd,MIN(fecha),getdate()),0)  from det_amortizacion  where estatus not in ('14','18')and rpu=cr.rpu) 
,(select isnull(SUM(pagodec),0)  from det_amortizacion  where estatus not in ('14','18')and rpu=cr.rpu)
,NULL
,''
,''
,''
,''
,''
,'ENVIADO CON EL VISTO BUENO DE LA ZONA'
,0
,0
,'FINANZAS'
, cr.numcredito
from 
(select *
from muestraBuro 
union
select *
from MuestraBuro_PM ) as buro
join creditos cr on cr.NumCredito=buro.numcredito
where cr.rpu not in (
select rpu 
from gestioninterna
where tipogestion='7'
) and buro.FechaAlta is not null



-- Posteriormente se debe actualizar los clientes


update clientes
set EstatusGestion='7'
where rpu in (
select 
cr.rpu
from 
(select *
from muestraBuro 
union
select *
from MuestraBuro_PM ) as buro
join creditos cr on cr.NumCredito=buro.numcredito
where cr.rpu not in (
select rpu 
from clientes
where EstatusGestion='7'
) and buro.FechaAlta is not null)