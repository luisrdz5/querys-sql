
select *
from SircaNac.dbo.pagos
where NumCredito in (
'903221417',
'915500118',
'919103565',
'919057259',
'919070109',
'915483231',
'919196195')

/*
-- Eliminiacion de pagos
delete
from SircaNac.dbo.pagos
where NumCredito in (
'903221417',
'915500118',
'919103565',
'919057259',
'919070109',
'915483231',
'919196195')
*/


/*
Eliminar pagos anteriores de convenios, liquidacion anticipada y referencias manuales
delete 
from SircaNac.dbo.convenios
where credito in (
'903221417',
'915500118',
'919103565',
'919057259')

delete 
from SircaNac.dbo.det_convenio
where credito in (
'903221417',
'915500118',
'919103565',
'919057259')

delete 
from solicitudpagoanticipado
where numcredito in ('919070109')


delete 
from dbo.EdoCuenta_REF 
where NumCredito in (
'915483231',
'919196195')
*/

/*
correr arregla pagos a los creditos 
*/
exec dbo.FIDEArreglaPagos '903221417'
exec dbo.FIDEArreglaPagos '915500118'
exec dbo.FIDEArreglaPagos '919103565'
exec dbo.FIDEArreglaPagos '919057259'
exec dbo.FIDEArreglaPagos '919070109'
exec dbo.FIDEArreglaPagos '915483231'
exec dbo.FIDEArreglaPagos '919196195'

/*
Ajustar pagos
delete
from pagos 
where numcredito='915500118'
and fechapago > '20200120'
exec dbo.FIDEArreglaPagos '915500118'

delete
from pagos 
where numcredito='919103565'
and fechapago > '20200120'
exec dbo.FIDEArreglaPagos '919103565'

delete
from pagos 
where numcredito='919057259'
and fechapago > '20200120'
exec dbo.FIDEArreglaPagos '919057259'


delete
from pagos 
where numcredito='919070109'
and fechapago > '20200120'
exec dbo.FIDEArreglaPagos '919070109'


delete
from pagos 
where numcredito='915483231'
and fechapago > '20200120'
exec dbo.FIDEArreglaPagos '915483231'


delete
from pagos 
where numcredito='919196195'
and fechapago > '20200120'
exec dbo.FIDEArreglaPagos '919196195'



/*
--ajustar convenios 
select *
from estatusconvenios

update convenios 
set estatus='0'
where credito='915500118'

update det_convenio
set estatus ='17', importepago=0.00, fechapago=NULL, moratorio=null, ivamoratorio=NULL
where credito='915500118' and pagare=0


update det_convenio
set estatus ='17', importepago=0.00, fechapago=NULL, moratorio=null, ivamoratorio=NULL
where credito='919103565' and pagare=1



update det_convenio
set estatus ='17', importepago=0.00, fechapago=NULL, moratorio=null, ivamoratorio=NULL
where credito='919057259' and pagare=3

select *
from convenios
where credito='915500118'

select *
from det_convenio
where credito='915500118'



*/


/*
ajustar liquidaciones anticipadas

select *
from estatuspagos

update solicitudpagoanticipado
SET estado=0
where numcredito ='919070109'

select *
from solicitudpagoanticipado
where numcredito ='919070109'

*/


/*
marcar todas las referencias hsbc como  aplicadas y dejar solo las que vamos a probar


update SircaNac.dbo.EdoCuenta_HSBC 
set estatus='Pendiente'
Where TipoArchivo = 'RptMovDiario'
and LEFT(RIGHT(LTRIM(RTRIM(ReferenciaMov)), 17), 9) in (
'903221417',
'915500118',
'919103565',
'919057259',
'919070109',
'915483231',
'919196195')


update SircaNac.dbo.EdoCuenta_HSBC 
set estatus='Procesado'
Where TipoArchivo = 'RptMovDiario'
and LEFT(RIGHT(LTRIM(RTRIM(ReferenciaMov)), 17), 9) in (
'919057259')
and FechaMov < '2020-02-01'

*/