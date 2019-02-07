-- 7472 pagos 
-- 392 creditos 

select *
from (
select c.rpu as "rpu_cargadiaria", p.rpu as "rpu_pagos", p.*
from CargaDiariaFecha c
join pagos p on p.NumCredito=c.Credito and c.FechaPago=p.FechaPago
where c.rpu in (
	select distinct rpu_d 
	from solicitudese19
	where estatus <> 'a' and rpu_d not in (
		select  RpuOriginal
		from solicitudese19 
		where estatus='a' 
	)
	and rpu_d not in (
		select  rpu_d
		from solicitudese19 
		where estatus='a' and rpu_d is not null
	)
)
and credito <> '0000000000' and p.StoreusadoSQL not in ('FIDEArreglaPagos','sp_bitacorasgrabar', 'spFideAplicarPago')
) as tmp




