/*
Obtener todos los pagos por mes por programa
para los meses de septiembre octubre noviembre y diciembre 2018 
universo fecha pago max 
1.- traer todos los pagos con fechapago dentro del mes 
2.- traer todos los pagos con fechapago fuera del mes 
*/
select  SUM(importe) as importe, COUNT(*) as pagos
from pagos p
left join creditos cr on p.NumCredito=cr.NumCredito 
where MONTH(FINSERT)='01' and YEAR(FINSERT) = '2019' and estatus not in ('92')
--and not (month(p.FechaPago)  in ('09') and YEAR(p.fechapago)  in ('2018'))


select cr.TipoCredito, SUM(p.importe) as importe, COUNT(*) as pagos
from pagos p
left join creditos cr on p.NumCredito=cr.NumCredito
where MONTH(FINSERT)='02' and YEAR(FINSERT) = '2019' and estatus not in ('92')
and month(p.FechaPago) in('02') and YEAR(p.fechapago) in ('2019')
group by cr.TipoCredito

select cr.TipoCredito, SUM(p.importe) as importe, COUNT(*) as pagos
from pagos p
left join creditos cr on p.NumCredito=cr.NumCredito
where MONTH(FINSERT)='02' and YEAR(FINSERT) = '2019' and estatus not in ('92')
and not (month(p.FechaPago)  in ('02') and YEAR(p.fechapago)  in ('2019'))
group by cr.TipoCredito




select p.*
from pagos p
left join creditos cr on p.NumCredito=cr.NumCredito
where MONTH(FINSERT)='02' and YEAR(FINSERT) = '2019' and estatus not in ('92')
and month(p.FechaPago) in('02') and YEAR(p.fechapago) in ('2019')
order  by cr.TipoCredito

select p.*
from pagos p
left join creditos cr on p.NumCredito=cr.NumCredito
where MONTH(FINSERT)='02' and YEAR(FINSERT) = '2019' and estatus not in ('92')
and not (month(p.FechaPago)  in ('02') and YEAR(p.fechapago)  in ('2019'))
order by cr.TipoCredito
