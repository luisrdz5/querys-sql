/*
select storeusadoSQL, estatus, COUNT(*)  , sum(importe)
from pagos p
where FechaPago > '20190101' and FechaPago < '20190201' 
group by storeusadoSQL, estatus
*/

select cr.tipocredito, storeusadoSQL,  COUNT(*)  , sum(importe)
from pagos p
join creditos cr on cr.NumCredito=p.NumCredito
where FechaPago > '20190101' and FechaPago < '20190201' group by storeusadoSQL,  cr.tipocredito



select cr.tipocredito, storeusadoSQL,  COUNT(*)  , sum(importe)
from pagos p
join creditos cr on cr.NumCredito=p.NumCredito
where FechaPago > '20190101' and FechaPago < '20190201' and FINSERT > '20190101' and FINSERT < '20190131'
group by storeusadoSQL,  cr.tipocredito




select cr.tipocredito, storeusadoSQL,  COUNT(*)  , sum(importe)
from pagos p
join creditos cr on cr.NumCredito=p.NumCredito
where FechaPago > '20190101' and FechaPago < '20190201' and (FINSERT < '20190101' or FINSERT > '20190131')
group by storeusadoSQL,  cr.tipocredito