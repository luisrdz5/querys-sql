-- Query para obtener creditos con mas amortizaciones en sac que en sirca 

select NumCredito,rpu,

(select sum(isnull(estatusopfin,1))
from det_amortizacion
where solicitudscc =c.numcredito and estatusopfin is null) as "amortizaciones restantes del credito",
/*
(select COUNT(estatus)
from det_amortizacion
where solicitudscc =c.numcredito and estatus <> 14) as restan_sirca,
*/
(select COUNT(*)
from det_amortizacion
where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is not null) as "amortizaciones pagadas en sac y no en sirca",
(select SUM(saldo)
from det_amortizacion
where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is not null) as saldo_restante_sirca
from creditos c
where tipocredito in ('AA', 'RF') and estatusCredito not in ('8','9','20','24','25','92') 
and (select COUNT(estatus)
from det_amortizacion
where solicitudscc =c.numcredito and estatus <> 14) > 
(select sum(isnull(estatusopfin,1))
from det_amortizacion
where solicitudscc =c.numcredito and estatusopfin is null)
and
(select SUM(saldo)
from det_amortizacion
where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is null) is not null
order by 
(select SUM(saldo)
from det_amortizacion
where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is not null)  asc


























select top 100 NumCredito
from creditos
where tipocredito in ('AA', 'RF') and estatusCredito not in ('8','9','20','24','25','92') 


select solicitudscc, COUNT(*), SUM(saldo) as saldo, SUM(pagored) as montoamortizacionfinal, SUM(pagored) - SUM(saldo) as diferencia
from det_amortizacion d
join creditos c on c.NumCredito = d.solicitudscc and tipocredito in ('AA', 'RF') and estatusCredito not in ('8','9','20','24','25','92') 
where estatus not in ('14')
group by solicitudscc
having COUNT(*)=1
order by SUM(pagored) - SUM(saldo)


select top 100  * --distinct estatusCredito
from creditos
where tipocredito in ('AA', 'RF') and fondosr is null




select COUNT(estatusopfin)
from det_amortizacion
where solicitudscc ='900291691' and estatusopfin<>1


select COUNT(estatusopfin)
from det_amortizacion
where solicitudscc ='900291691' and estatus <> 14




select *
from estatus