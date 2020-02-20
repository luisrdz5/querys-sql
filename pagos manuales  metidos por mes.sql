select MONTH(p.FINSERT), YEAR(p.finsert) ,cr.TipoCredito , COUNT(*), SUM(p.Importe), p.StoreusadoSQL
from pagos p
join creditos cr on cr.NumCredito=p.NumCredito
where FINSERT > '20181231' and UsuarioSQL = 'cmezau'  --UsuarioSQL= ''
group by MONTH(FINSERT), YEAR(finsert), cr.TipoCredito, p.StoreusadoSQL


-- 


select MONTH(p.FINSERT), YEAR(p.finsert),cr.TipoCredito  , COUNT(*)
from pagos p
join creditos cr on cr.NumCredito=p.NumCredito
where FINSERT > '20181231' and UsuarioSQL = 'cmezau'  --UsuarioSQL= ''
group by MONTH(FINSERT), YEAR(finsert),  cr.TipoCredito


-- estatus de los creditos afectados 



select MONTH(p.FINSERT), YEAR(p.finsert) , e.Descripcion , COUNT(*), SUM(p.Importe)
from pagos p
join creditos cr on cr.NumCredito=p.NumCredito
join estatus e on e.IdEst=cr.estatusCredito
where FINSERT > '20181231' and UsuarioSQL = 'cmezau'  --UsuarioSQL= ''
group by MONTH(FINSERT), YEAR(finsert),  e.Descripcion 









/*
select top 100 * 
from pagos
where UsuarioSQL = 'cmezau' 
*/


select cr.TipoCredito, p.*
from pagos p
join creditos cr on cr.NumCredito=p.NumCredito
where FINSERT > '20181231' and UsuarioSQL = 'cmezau'  --UsuarioSQL= ''
group by MONTH(FINSERT), YEAR(finsert), cr.TipoCredito, p.StoreusadoSQL