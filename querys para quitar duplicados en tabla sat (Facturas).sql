-- paso un registro unico de todos los dubpkicados a una tabla temporal #tmp 
select region
,Fecha
,Serie
,Proyecto
,RFC
,Razonsocial
,Estatus
,ligapdf
,ligaxml
into #tmp
from sat
group by Serie
,region
,Fecha
,Proyecto
,RFC
,Razonsocial
,Estatus
,ligapdf
,ligaxml
having COUNT(*)>1


--eliminamos todos los registros duplicados 
delete
from sat where Serie in (
select Serie 
from sat
group by Serie
,region
,Fecha
,Proyecto
,RFC
,Razonsocial
,Estatus
,ligapdf
,ligaxml
having COUNT(*)>1
)

-- Se insertan 

INSERT INTO [SircaNac].[dbo].[sat]
           ([region]
           ,[Fecha]
           ,[Serie]
           ,[Proyecto]
           ,[RFC]
           ,[Razonsocial]
           ,[Estatus]
           ,[ligapdf]
           ,[ligaxml])
select [region]
           ,[Fecha]
           ,[Serie]
           ,[Proyecto]
           ,[RFC]
           ,[Razonsocial]
           ,[Estatus]
           ,[ligapdf]
           ,[ligaxml]
from  #tmp         

