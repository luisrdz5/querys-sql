-- segunda version tabla resumen
-- drop table #tmp3
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
(select SUM(saldo) from DET_AMORTIZACION where solicitudscc=d.NumCredito) as saldo_sirca,
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.NumCredito and ESTATUSOPFIN ='1') as cobranza_sac,
(select SUM(PAGODEC) from DET_AMORTIZACION where solicitudscc=d.NumCredito) as total_a_pagar,
NULL as procesado
into #tmp3
FROM CREDITOS d
WHERE TIPOCREDITO in ('RF','AA', 'PA', 'MT') and estatusCredito not in ('8','9','20','24','92','25')
group by NumCredito, rpu, tipocredito


-- sirca = sac y arqueo mas que sirca 
select tipocredito as programa ,  COUNT(*) as numero_creditos, 
sum( case when cobranza_sicom > total_a_pagar then total_a_pagar - (cobranza_sirca + saldo_sirca )  else cobranza_sicom - (cobranza_sirca + saldo_sirca )  end )  as monto_diferencia
from #tmp3 where cobranza_sicom > (cobranza_sirca+saldo_sirca) and cobranza_sirca = cobranza_sac
group by tipocredito


-- creditos que tienen mas en sirca que sac 
select 'SENER',  COUNT(*), 
SUM(cobranza_sirca - cobranza_sac )as monto
from #tmp3 
where cobranza_sirca > cobranza_sac
and tipocredito in ('RF','AA')


-- creditos que tienen mas en sac que en sirca 
select 'SENER',  COUNT(*), 
SUM(cobranza_sac - cobranza_sirca  )as monto
from #tmp3 
where cobranza_sirca < cobranza_sac
and tipocredito in ('RF','AA')

--31030
-- creditos que se detecto falta un pago en arqueo
select 
*,
(select SUM(importe) from pagos where rpu=t.rpu) pagos_sirca
from #tmp3 t
where cobranza_sirca=cobranza_sac and cobranza_SICOM > cobranza_sirca
and cobranza_SICOM = (select SUM(importe) from pagos where rpu=t.rpu)
and cobranza_sicom = cobranza_sicom_sin_filtros
--and cobranza_sicom = (select SUM(pagodec) from det_amortizacion where solicitudscc=t.numcredito)

-- creditos que se detecto falta un pago en arqueo
--19687
select 
*
,(select SUM(importe) from pagos where rpu=t.rpu) pagos_sirca
from #tmp3 t
where cobranza_sirca=cobranza_sac and cobranza_SICOM > cobranza_sirca
and cobranza_SICOM = (select SUM(importe) from pagos where rpu=t.rpu)
and cobranza_sicom < cobranza_sicom_sin_filtros
