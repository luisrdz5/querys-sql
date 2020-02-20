-- segunda version tabla resumen
-- drop table #tmp4


SELECT 
numcredito,
tipocredito, 
rpu,
(
select SUM(saldo) from LINKsac.arqueo.dbo.Arqueo_2017_01 where RPU=d.rpu and 
( (STSENERGIA IN ('01','06','12','99','74','91','10') AND STATUS='01')  or  (STSENERGIA IN ('06','10') AND STATUS='08') ) AND MOTIVO <>'44'
) as cobranza_sicom,
(select SUM(saldo) from LINKsac.arqueo.dbo.Arqueo_2017_01 where RPU=d.rpu) as cobranza_sicom_sin_filtros,
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.NumCredito and ESTATUS IN ('14','18')) as cobranza_sirca,
(select SUM(saldo) from DET_AMORTIZACION where solicitudscc=d.NumCredito and saldo > 0 ) as saldo_sirca,
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.NumCredito and ESTATUSOPFIN ='1') as cobranza_sac,
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.NumCredito) as total_a_pagar,
(select SUM(importe) from pagos where NumCredito=d.NumCredito) as total_en_pagos,
NULL as procesado,
(select SUM(saldo) from LINKsac.arqueo.dbo.Arqueo_2017_02 where RPU=d.rpu 
and fecfac ='000000'
) saldo_en_sicom
into #tmp4
FROM CREDITOS d
WHERE TIPOCREDITO in ('RF','AA') and estatusCredito not in ('8','9','20','24','92','25')
group by NumCredito, rpu, tipocredito


-- cobranza faltante en sirca y sac  

select COUNT(*), SUM(cobranza_sicom - cobranza_sirca)
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca 


-- cobranza faltante en sirca y sac  detalle 
select COUNT(*), SUM(cobranza_sicom - cobranza_sirca )
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca and saldo_en_sicom=0

--------------------------------------------------------------------------------

select  COUNT(*), SUM(cobranza_sicom - cobranza_sirca )
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca and saldo_en_sicom=0 and cobranza_SICOm < total_a_pagar


select  COUNT(*), SUM(cobranza_sicom - cobranza_sirca )
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca and saldo_en_sicom=0 and ceiling(cobranza_SICOm) = ceiling(total_a_pagar)

select  COUNT(*), SUM(cobranza_sicom - cobranza_sirca )
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca and saldo_en_sicom=0 and ceiling(cobranza_SICOm) > ceiling(total_a_pagar)


--------------------------------------------------------------------------------

select COUNT(*), SUM(cobranza_sicom - cobranza_sirca )
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca and saldo_en_sicom>0


select COUNT(*), SUM(cobranza_sicom - cobranza_sirca )
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca and saldo_en_sicom is null












-- diferencias entre sistemas 

-- creditos que tienen mas en sirca que sac 

select COUNT(*), SUM(cobranza_sirca - cobranza_sac)
from #tmp4
where cobranza_sirca > cobranza_sac 


-- clasificacion de creditos que tienen mas en sirca que sac 

--creditos que solo se debe pasar la cobranza de sirca a sac
select COUNT(*), SUM(cobranza_sirca - cobranza_sac)
from #tmp4
where cobranza_sirca > cobranza_sac and (cobranza_sicom = cobranza_sirca)

--creditos que solo se debe pasar la cobranza de sirca a sac y pasaran al grupo que les falta cobranza de arqueo
select COUNT(*), SUM(cobranza_sirca - cobranza_sac)
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom > cobranza_sirca 

-- se debera verificar por que puede haber llegado la cobranza por diarios y si es asi solo se debera pasar a sac
select COUNT(*), SUM(cobranza_sirca - cobranza_sac)
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom < cobranza_sirca

--------------------------------------------------------------------------------

select COUNT(*), SUM(cobranza_sirca - cobranza_sac)
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom < cobranza_sirca and cobranza_sicom = cobranza_sac

select COUNT(*), SUM(cobranza_sirca - cobranza_sac)
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom < cobranza_sirca and cobranza_sicom > cobranza_sac
select COUNT(*), SUM(cobranza_sirca - cobranza_sac)
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom < cobranza_sirca and cobranza_sicom < cobranza_sac



--------------------------------------------------------------------------------




-- no hay cobranza detectada por arqueo ( se debera verificar en diario )
select COUNT(*), SUM(cobranza_sirca - cobranza_sac)
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom is null




-- creditos que tienen mas en sac que sirca

select COUNT(*), SUM(cobranza_sicom - cobranza_sac)
from #tmp4
where cobranza_sirca < cobranza_sac and  cobranza_sicom >= cobranza_sac

-- Creditos que sac esta igual que arqueo 

select COUNT(*), SUM(cobranza_sac - cobranza_sirca)
from #tmp4
where cobranza_sirca < cobranza_sac and cobranza_sicom = cobranza_sac


select COUNT(*), SUM(cobranza_sicom - cobranza_sac)
from #tmp4
where cobranza_sirca < cobranza_sac and cobranza_sicom > cobranza_sac


--select COUNT(*), SUM( cobranza_sac - cobranza_sicom )
--from #tmp4
--where cobranza_sirca < cobranza_sac and cobranza_sicom < cobranza_sac

select COUNT(*), SUM( cobranza_sac - isnull(cobranza_sicom,0) )
from #tmp4
where cobranza_sirca < cobranza_sac and cobranza_sicom is null



select *
from CobranzaPendiente





select NumCredito, rpu, cobranza_sicom, cobranza_sac, cobranza_sirca
from #tmp4
where cobranza_sirca > cobranza_sac and (cobranza_sicom = cobranza_sirca)

select  NumCredito, rpu, cobranza_sicom, cobranza_sac, cobranza_sirca
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom < cobranza_sirca and cobranza_sicom = cobranza_sac

select  NumCredito, rpu, cobranza_sicom, cobranza_sac, cobranza_sirca
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom < cobranza_sirca and cobranza_sicom > cobranza_sac

select  NumCredito, rpu, cobranza_sicom, cobranza_sac, cobranza_sirca
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom < cobranza_sirca and cobranza_sicom < cobranza_sac

select   NumCredito, rpu, cobranza_sicom, cobranza_sac, cobranza_sirca
from #tmp4
where cobranza_sirca < cobranza_sac and cobranza_sicom > cobranza_sac






select NumCredito, rpu, cobranza_sicom, cobranza_sac, cobranza_sirca, saldo_en_sicom
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca and saldo_en_sicom is null

-- no hay cobranza detectada por arqueo ( se debera verificar en diario )
select  NumCredito, rpu, cobranza_sicom, cobranza_sac, cobranza_sirca
from #tmp4
where cobranza_sirca > cobranza_sac and cobranza_sicom is null

select  NumCredito, rpu, cobranza_sicom, cobranza_sac, cobranza_sirca
from #tmp4
where cobranza_sirca < cobranza_sac and cobranza_sicom is null



_______________________________________________________________________________________



INSERT INTO [SircaNac].[dbo].[CobranzaPendiente]
           ([NumCredito]
           ,[procesado]
           ,[tipocredito]
           ,[rpu]
           ,[cobranza_SICOM]
           ,[cobranza_sirca]
           ,[cobranza_sac]
           ,[tipo])

select  [NumCredito]
           ,null as procesado
           ,[tipocredito]
           ,[rpu]
           ,[cobranza_SICOM]
           ,[cobranza_sirca]
           ,[cobranza_sac]
           ,'1' as tipo
           
from #tmp4
where cobranza_sirca = cobranza_sac and cobranza_SICOM > cobranza_sirca and saldo_en_sicom=0 and ceiling(cobranza_SICOm) = ceiling(total_a_pagar)
