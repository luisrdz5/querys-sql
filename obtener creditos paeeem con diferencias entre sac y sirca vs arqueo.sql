SELECT 
SOLICITUDSCC,
rpu,
(
select SUM(saldo) from LINKsac.arqueo.dbo.Arqueo_2016_12 where RPU=d.rpu and 
( (STSENERGIA IN ('01','06','12','99','74','91','10') AND STATUS='01')  or  (STSENERGIA IN ('06','10') AND STATUS='08') ) AND MOTIVO <>'44'
) as cobranza_real,
SUM(PAGODEC),
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.solicitudscc and ESTATUS IN ('14','18')) as cobranza_sirca,
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.solicitudscc and ESTATUSOPFIN ='1') as cobranza_sac
FROM DET_AMORTIZACION d
WHERE SOLICITUDSCC IN 
(
SELECT NUMCREDITO 
FROM CREDITOS
WHERE TIPOCREDITO='PA'
)
and 
((select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.solicitudscc and ESTATUS IN ('14','18'))-
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.solicitudscc and ESTATUSOPFIN ='1')) < 0
and 
((select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.solicitudscc and ESTATUSOPFIN ='1') - 
(select SUM(saldo) from LINKsac.arqueo.dbo.Arqueo_2016_12 where RPU=d.rpu 
and 
( (STSENERGIA IN ('01','06','12','99','74','91','10') AND STATUS='01')  or  (STSENERGIA IN ('06','10') AND STATUS='08') ) AND MOTIVO <>'44'))
= 0
GROUP BY SOLICITUDSCC, rpu




select * 
from creditos
where tipocredito='PA'
