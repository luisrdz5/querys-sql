-- pagos 

select [NumCredito]
      ,[Rpu]
      ,[NumPago]
      ,[FechaFac]
      ,[FechaVenci]
      ,[Importe]
      ,[Estatus]
      ,[FechaPago]
      ,[mesfact]
      ,[aniofact]
      ,[extemporaneo]
      ,[ORIGEN]
      ,[FINSERT]
      ,[UsuarioSQL]
      ,[AplicacionSQL]
      ,[StoreusadoSQL]
      ,[IDRegistroSicom]
      ,[fecfac]
      ,[MesFactOrigen]
      ,[AnoFactOrigen]
      ,[tipopago]
from SircaNac.dbo.pagos
where NumCredito in (
'903221417',
'915500118',
'919103565',
'919057259',
'919070109',
'915483231',
'919196195')

-- convenios 


select [tipoconvenio]
      ,[fechasol]
      ,[rpu]
      ,[credito]
      ,[estatus]
      ,[adeudo]
      ,[usuariosol]
      ,[referencia]
      ,[fechavigencia]
      ,[capital]
      ,[interes]
      ,[ivadeinteres]
      ,[moratorio]
      ,[ivamoratorio]
      ,[cargos]
      ,[capitalxd]
      ,[ivaxd]
      ,[interesxd]
      ,[saldoinsolutola]
      ,[anticipo]
      ,[fechaultimopago]
      ,[amorconvenida]
      ,[numpagos]
      ,[lugar]
      ,[folio]
      ,[referparcialidad]
      ,[cargovigente]
      ,[amortVencidas]
      ,[totalmoratorio]
      ,[moratorioxd]
      ,[ivamoratorioxd]
      ,[totalmoratorioxd]
      ,[capitalvencido]
      ,[interesvencido]
      ,[ivainteresvencido]
from SircaNac.dbo.convenios
where credito in (
'903221417',
'915500118',
'919103565',
'919057259')



-- det_convenio
select [folio]
      ,[rpu]
      ,[credito]
      ,[pagare]
      ,[fecha]
      ,[importe]
      ,[estatus]
      ,[importepago]
      ,[fechapago]
      ,[enviolyf]
      ,[IdCargaDiariaFechaRAP]
      ,[moratorio]
      ,[ivamoratorio]
      ,[capitalvencido]
      ,[interesvencido]
      ,[ivainteresvencido]
from SircaNac.dbo.det_convenio
where credito in (
'903221417',
'915500118',
'919103565',
'919057259')


-- liquidaciones anticipadas 
--liquidacion anticipada

select [rpu]
      ,[numcredito]
      ,[referencia]
      ,[montopagar]
      ,[fechamovto]
      ,[fechapago]
      ,[banco]
      ,[montopago]
      ,[bonificacion]
      ,[interesnd]
      ,[ivainteresnd]
      ,0 as estado
      ,[saldosicom]
      ,[cuenta]
      ,[fechalib]
      ,[financiamiento]
      ,[amortizacion]
      ,[pagadocfe]
      ,[pdtaplicar]
      ,[vencido]
      ,[comision]
      ,[ivacomision]
      ,[capitalinsoluto]
      ,[fechafact]
      ,[interesordinario]
      ,[ivainteresordinario]
      ,[interesmoratorio]
      ,[ivamoratorios]
      ,[fechareferencia]
      ,[nota]
      ,[pagoadicional]
      ,[lugar]
      ,[fechacancela]
      ,[usuariosol]
      ,[capitalvencido]
      ,[interesvencido]
      ,[ivainteresvencido]
from SircaNac.dbo.solicitudpagoanticipado
where numcredito in ('919070109')

-- referencias de claudia 
-- referencias especiales

select * 
from dbo.EdoCuenta_REF 
where NumCredito in (
'915483231',
'919196195')




select LEFT(RIGHT(LTRIM(RTRIM(ReferenciaMov)), 17), 9),*
 from SircaNac.dbo.EdoCuenta_HSBC 
Where TipoArchivo = 'RptMovDiario'
order by LEFT(RIGHT(LTRIM(RTRIM(ReferenciaMov)), 17), 9)
--order by fechamov desc