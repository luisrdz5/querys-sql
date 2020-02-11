-- ESTADISTICAS OBTENIDAS EL 19/19/2019

--2167 rpus con multicreditos 
select rpu , COUNT(*) 
from creditos
group by rpu
having COUNT(*) >1
order by COUNT(*) desc

-- de los multicreditos necesito saber cuales por lo menos tienen un credito vivo 

-- 4357 creditos existentes en nuestra bd correspondientes a estos rpu's
-- 1434 creditos vivos
select NumCredito
from creditos
where rpu in (
select rpu 
from creditos
group by rpu
having COUNT(*) >1
) AND ESTATUSCREDITO NOT IN (8,9,25,92)



--detalle multicreditos


select 
rpu
, solicitudscc
, datediff(dd,MIN(d.fecha),getdate()) as "dias vencimiento"
, MIN(d.fecha)"fecha de vencimiento"
,(select tipocredito from creditos where NumCredito = d.solicitudscc )
from det_amortizacion d
where estatus not in ('14') 
and  solicitudscc in (
select NumCredito
from creditos
where rpu in (
select rpu 
from creditos
group by rpu
having COUNT(*) >1
) AND ESTATUSCREDITO NOT IN (8,9,25,92)
) 
group by rpu,solicitudscc
order by  datediff(dd,MIN(fecha),getdate()) desc





-- obtener estadisticas de  dias de atraso de multicreditos 

select 
sum(case when diasvencimiento > 2000 then 1 else 0 end)  as "mas de 2000 dias de vencimiento"
,sum(case when diasvencimiento > 1000 and  diasvencimiento <= 2000 then 1 else 0 end)  as "entre 1000 - 2000 dias de vencimiento"
,sum(case when diasvencimiento > 500 and  diasvencimiento <= 1000 then 1 else 0 end)  as "entre 500 - 1000 dias de vencimiento"
,sum(case when diasvencimiento > 250 and  diasvencimiento <= 500 then 1 else 0 end)  as "entre 250 - 500 dias de vencimiento"
,sum(case when diasvencimiento > 100 and  diasvencimiento <= 250 then 1 else 0 end)  as "entre 100 - 250 dias de vencimiento"
,sum(case when diasvencimiento > 0 and  diasvencimiento <= 100 then 1 else 0 end)  as "entre 0 - 100 dias de vencimiento"
,sum(case when diasvencimiento <= 0 then 1 else 0 end)  as "sin dias de vencimiento"	
from (
	select 
	datediff(dd,MIN(d.fecha),getdate()) as diasvencimiento
	from det_amortizacion d
	where estatus not in ('14') 
	and  solicitudscc in (
		select NumCredito
		from creditos
		where rpu in (
			select rpu 
			from creditos
			group by rpu
			having COUNT(*) >1
		) AND ESTATUSCREDITO NOT IN (8,9,25,92)
		and tipocredito in ('CV')
	) 
	group by rpu,solicitudscc
) as tmp
