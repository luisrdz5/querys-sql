select es.descripcion,estatus, SUM(moratorio) as moratorio, SUM(ivamoratorio) as ivamoratorio, cr.TipoCredito, COUNT(*) as TotalConvenios
from convenios c
join creditos cr on cr.numcredito=c.credito
join estatusconvenios es on es.id_estatus=c.estatus
where cr.TipoCredito='PA' and c.tipoconvenio <> 5
group by estatus, es.descripcion, cr.TipoCredito




select s.estado ,c.tipocredito, COUNT(*) as TotalSolicitudesPagoAnticipado, sum(s.interesmoratorio) as interesmoratorio , sum(s.ivamoratorios) as ivamoratorios
from solicitudpagoanticipado s
join creditos c on c.NumCredito= s.numcredito
where c.TipoCredito='pa'
group by c.tipocredito, s.estado



select  es.descripcion,estatus, SUM(moratorio) as moratorio, SUM(ivamoratorio) as ivamoratorio, cr.TipoCredito, COUNT(*) as TotalConvenios
from convenioshistorico c
join creditos cr on cr.numcredito=c.credito
join estatusconvenios es on es.id_estatus=c.estatus
where cr.TipoCredito='PA' and c.tipoconvenio <> 5
group by estatus, es.descripcion, cr.TipoCredito


select es.descripcion,estatus, SUM(moratorio) as moratorio, SUM(ivamoratorio) as ivamoratorio, cr.TipoCredito, COUNT(*) as TotalConvenios
from convenios c
join creditos cr on cr.numcredito=c.credito
join estatusconvenios es on es.id_estatus=c.estatus
where cr.TipoCredito='PA' and c.tipoconvenio = 5
group by estatus, es.descripcion, cr.TipoCredito



select top 100  *
from convenioshistorico


select top 10  *
from solicitudpagoanticipado


