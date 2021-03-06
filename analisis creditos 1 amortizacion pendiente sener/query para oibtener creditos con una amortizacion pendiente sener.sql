
-- 21894
-- 21335
select solicitudscc, estatus, saldo, pagored as amortizacion_completa, saldo - pagored as diferencia_saldo_amortizacion ,EstatusOpFin
from det_amortizacion 
where  estatus not in ('14') and solicitudscc in (
	select solicitudscc
	from det_amortizacion d
	join creditos c on c.NumCredito = d.solicitudscc and tipocredito in ('AA', 'RF') and estatusCredito not in ('8','9','20','24','25','92')  and c.fondosr is not null
	where estatus not in ('14')
	group by solicitudscc
	having COUNT(*)=1
)
--and EstatusOpFin is not null
order by saldo - pagored



select estatus, saldo, pagored, saldo - pagored, *
from det_amortizacion 
where  estatus not in ('14') and solicitudscc in (
	select solicitudscc
	from det_amortizacion d
	join creditos c on c.NumCredito = d.solicitudscc and c.tipocredito in ('AA', 'RF') and c.estatusCredito not in ('8','9','20','24','25','92') and c.fondosr is not null
	where estatus not in ('14')
	group by solicitudscc
	having COUNT(*)=1
)