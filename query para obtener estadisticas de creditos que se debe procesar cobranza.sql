--DROP TABLE  #tmp
/*
SELECT 
numcredito,
tipocredito, 
rpu,
(
select SUM(saldo) from LINKsac.arqueo.dbo.Arqueo_2017_01 where RPU=d.rpu and 
( (STSENERGIA IN ('01','06','12','99','74','91','10') AND STATUS='01')  or  (STSENERGIA IN ('06','10') AND STATUS='08') ) AND MOTIVO <>'44'
) as cobranza_sicom,
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.NumCredito and ESTATUS IN ('14','18')) as cobranza_sirca,
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.NumCredito and ESTATUSOPFIN ='1') as cobranza_sac,
NULL as procesado
into #tmp
FROM CREDITOS d
WHERE TIPOCREDITO in ('RF','AA', 'PA', 'MT') and estatusCredito not in ('8','9','20','24','92','25')
group by NumCredito, rpu, tipocredito


*/


select tmp.Numcredito, tmp.rpu, tmp.monto, c.*
from cargadiariafecha c 
join (select NumCredito, rpu, ceiling(cobranza_SICOM - cobranza_sirca) as monto
from #tmp
where cobranza_sirca=cobranza_sac and cobranza_SICOM > cobranza_sirca) as tmp on tmp.rpu=c.rpu and tmp.monto=c.importe
where error <> 0 and c.credito = '0000000000' 


update c
SET c.credito=tmp.Numcredito, error = 0 , listo = 2
from cargadiariafecha c 
join (select NumCredito, rpu, ceiling(cobranza_SICOM - cobranza_sirca) as monto
from #tmp
where cobranza_sirca=cobranza_sac and cobranza_SICOM > cobranza_sirca) as tmp on tmp.rpu=c.rpu and tmp.monto=c.importe
where error <> 0 and c.credito = '0000000000'




select top 100 *
from CargaDiariaFecha








Select 
(select COUNT(*) from #tmp where cobranza_sirca=cobranza_sac and cobranza_SICOM > cobranza_sirca) creditos_pasar_de_sicom,
(select COUNT(*) from #tmp where cobranza_sirca > cobranza_sac and cobranza_SICOM = cobranza_sirca) creditos_pasar_de_sirca_a_sac


select * from #tmp where cobranza_sirca > cobranza_sac and cobranza_SICOM = cobranza_sirca