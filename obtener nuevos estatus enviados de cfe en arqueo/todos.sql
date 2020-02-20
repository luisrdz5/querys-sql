--5313
/****** Script for SelectTopNRows command from SSMS  ******/
select  
sum(SALDO)
,COUNT(*) as "veces que aparece el pago"
from (
select  
RPU
,FECFAC
,NOMBRE
,SALDO
,SALDOTOTAL
,MOTIVO
,SUFIJO
,STSSERV
,STATUS
,FECHAOPERACION
,STSENERGIA
,FECHAFACTPAGO
,FECHAVENCPAGO
,COUNT(*) as "veces que aparece el pago"
from (
SELECT 'Arqueo_2018_10' as archivo,  *
FROM [Arqueo].[dbo].[Arqueo_2018_10]
where STATUS in ('04','06','10','12','64','74','77',91)
union 
SELECT  'Arqueo_2017_10' as archivo,*
FROM [Arqueo].[dbo].Arqueo_2017_10
where STATUS in ('04','06','10','12','64','74','77',91)
union
SELECT  'Arqueo_2016_10' as archivo,*
FROM [Arqueo].[dbo].Arqueo_2016_10
where STATUS in ('04','06','10','12','64','74','77',91)
union
SELECT  'Arqueo_2015_10' as archivo,*
FROM [Arqueo].[dbo].Arqueo_2015_10
where STATUS in ('04','06','10','12','64','74','77',91) 
union
SELECT  'Arqueo_2014_10' as archivo,*
FROM [Arqueo].[dbo].Arqueo_2014_10
where STATUS in ('04','06','10','12','64','74','77',91)
) as tmp 
group by 
RPU
,FECFAC
,NOMBRE
,SALDO
,SALDOTOTAL
,MOTIVO
,SUFIJO
,STSSERV
,STATUS
,FECHAOPERACION
,STSENERGIA
,FECHAFACTPAGO
,FECHAVENCPAGO
) as tmp2

