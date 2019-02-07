select s.estatus, e.desc_estatus , COUNT(*) as total_solicitudes
from solicitudese19 s
join estatusE19 e on e.estatus=s.estatus
group by s.estatus, e.desc_estatus


select  s.codregion,COUNT(*) as total_solicitudes
from solicitudese19 s
join estatusE19 e on e.estatus=s.estatus
where s.estatus not in ('A','C')
and tipoe19 not in ('3')
group by s.codregion
order by  s.codregion



select  codRegion, s.estatus, e.desc_estatus , COUNT(*)
from solicitudese19 s
join estatusE19 e on e.estatus=s.estatus
where s.estatus not in ('A','C') and codRegion is null 
group by s.estatus, e.desc_estatus, codRegion
order by  s.codregion