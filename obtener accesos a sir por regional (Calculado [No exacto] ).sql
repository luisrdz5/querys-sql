-- obtenemos los accesos al sistema
select rtrim(tmp.a�o) a�o, rtrim(tmp.mes) mes, tmp.codRegion, tmp.codCoord ,SUM(tmp.numero_accesos) as "numero de accesos"
from (
select cl.codRegion,cl.codCoord, COUNT(*) as numero_accesos, MONTH(s.finsert) as mes , YEAR(s.finsert) as a�o
from solicitudese19 s
join creditos c on convert(varchar,c.NumCredito)=s.numerocredito
join clientes cl on cl.RPU=c.RPU
where s.finsert > '20160601'
group by cl.codRegion,cl.codCoord, MONTH(s.finsert), YEAR(s.finsert)
--order by cl.codRegion,cl.codCoord, MONTH(s.finsert), YEAR(s.finsert)
union
select cl.codRegion,cl.codCoord, COUNT(*)  as numero_accesos, MONTH(fechamovto) as mes , YEAR(fechamovto) as a�o
from  solicitudpagoanticipado s
join creditos c on c.NumCredito=s.numcredito
join clientes cl on cl.RPU=c.RPU
where fechamovto > '20160601'
group by cl.codRegion,cl.codCoord, MONTH(fechamovto), YEAR(fechamovto)
--order by cl.codRegion,cl.codCoord, MONTH(fechamovto), YEAR(fechamovto)
union
select  cl.codRegion,cl.codCoord, COUNT(*)  as numero_accesos, MONTH(fechasol) as mes , YEAR(fechasol) as a�o
from convenios s
join creditos c on c.NumCredito=s.credito
join clientes cl on cl.RPU=c.RPU
where fechasol > '20160601'
group by cl.codRegion,cl.codCoord, MONTH(fechasol), YEAR(fechasol)
--order by cl.codRegion,cl.codCoord, MONTH(fechasol), YEAR(fechasol)
union
select cl.codRegion,cl.codCoord,  COUNT(*)  as numero_accesos, MONTH(fechainsert) as mes , YEAR(fechainsert) as a�o
from LOGSPFIDEAPLICARPAGO s 
join clientes cl on cl.RPU=s.RPU
where fechainsert > '20160601'
group by cl.codRegion,cl.codCoord, MONTH(fechainsert), YEAR(fechainsert)
--order by cl.codRegion,cl.codCoord, MONTH(fechainsert), YEAR(fechainsert)
) as tmp
where codRegion is not null
group by  rtrim(tmp.a�o), rtrim(tmp.mes), tmp.codRegion,tmp.codCoord
order by  rtrim(tmp.a�o), rtrim(tmp.mes), tmp.codregion DESC




