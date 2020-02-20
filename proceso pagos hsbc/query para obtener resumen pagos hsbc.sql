select LEFT(RIGHT(LTRIM(RTRIM(referenciamov)), 17), 9)
, (select top 1 tipoconvenio from convenios where referencia=RIGHT(LTRIM(RTRIM(referenciamov)), 17))
, (select top 1 tipoconvenio from convenios where referparcialidad=RIGHT(LTRIM(RTRIM(referenciamov)), 17))
, (select top 1 numcredito from solicitudpagoanticipado where referencia=RIGHT(LTRIM(RTRIM(referenciamov)), 17))
,(select top 1 numcredito from dbo.EdoCuenta_REF where REF_Bancaria=RIGHT(LTRIM(RTRIM(referenciamov)), 17))
, * 
from SircaNac.dbo.EdoCuenta_HSBC 
Where TipoArchivo = 'RptMovDiario' and estatus ='Pendiente' 
order by fechamov desc


-- tipo 5 primer pago
903221417
-- tipo 4 primer pago 
915500118
-- tipo 2 parcialidad
919103565
-- tipo 5 parcialidad 
919057259
--liquidacion anticipada
919070109
-- referencias especiales
915483231
919196195





