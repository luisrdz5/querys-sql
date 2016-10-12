declare 
	@rpu			as varchar(12),
	@numcredito		as varchar(9)



SET @rpu=''

select @numcredito=numcredito
from creditos
where rpu=@rpu



update det_amortizacion 
set InteresHistorico=interes , IvaInteresHistorico=ivainteres , saldo=0 , pagodec=capital, pagored=capital
where estatus='18' and rpu=@rpu


update det_amortizacion 
set interes=0 , ivainteres=0, estatus='14'
where estatus='18' and rpu=@rpu


update pagos 
set FechaFac=FechaPago, FechaVenci=FechaPago 
where rpu=@rpu and estatus='92'



exec FIDEArreglaPagos @numcredito



select *
from det_amortizacion 
where rpu=@rpu

select *
from pagos
where rpu=@rpu


