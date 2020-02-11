-- Se inicia proceso de reporte de pagos rap 
-- se deberan recibir 5 variables 
Declare 
@codRegion			as varchar(2), 
@codCoord			as varchar(2), 
@fechaInicial		as varchar(8), 
@fechaFinal			as varchar(8) 

-- se generan ejemplos para ejecución 
SET @codRegion = NULL 
SET @codCoord = NULL 
SET @fechaInicial = '20190901'
SET @fechaFinal	= '20190915'



-- se obtiene la información de pagos por rap (todos los pagos que no son estatus 1 
--92	PAGO ANTICIPADO
--94	PAGO CONVENIO ANTICIPO
--95	PAGO CONVENIO PARCIALIDAD
--96	PAGO REFERENCIA ESPECIALIDAD
select *
from pagos 
where estatus in (92,94,95,96) and FechaPago >= @fechaInicial and FechaPago < @fechaFinal 



