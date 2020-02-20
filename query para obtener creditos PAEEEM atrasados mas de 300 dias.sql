truncate Table porcentajesZonas
;with cobranza
as(
	select 
	c.CodRegion,
	c.CodCoord,
	c.NumCredito,
	c.tipocredito,
	c.estatuscredito, 
	(select MIN(fecha) from det_amortizacion where solicitudscc=c.NumCredito and estatus in ('17','19')) as fechaminimadepago,
	(select datediff(dd,isnull(MIN(fecha),GETDATE()),getdate()) from det_amortizacion where solicitudscc=c.NumCredito and estatus in ('17','19')) as dias_de_atraso,
	(select SUM(isnull(pagodec,0)) from det_amortizacion where solicitudscc=c.NumCredito and estatus in ('17','19')) as monto_adeudado,
	(select SUM(isnull(pagodec,0)) from det_amortizacion where solicitudscc=c.NumCredito and estatus in ('17','19') and datediff(dd,isnull(fecha,GETDATE()),getdate())>= 300) as monto_atraso
	from creditos c
	where tipocredito in ('PA','FV') and estatusCredito not in ('8','9')
)

INSERT INTO [SircaNac].[dbo].[porcentajesZonas]
           ([cve_Region]
           ,[cve_zona]
           ,[region]
           ,[zona]
           ,[codregion]
           ,[codcoord]
           ,[nombreRegion]
           ,[nombreCoord]
           ,[id_coordinacion]
           ,[montoTotalAdeudado]
           ,[montoAtraso]
           ,[porcentajeAdeudo]
           ,[fechaUltimaModificacion])
           
SELECT 
	tep.*
	--,tmp.totalcreditos as totalCreditos
	--,tmp.creditosEnAtraso240Dias as creditosEnAtraso240Dias	
	, tmp.monto_adeudado as montoTotalAdeudado
	, tmp.monto_atraso as montoAtraso
	, tmp.porcentajeAdeudo as porcentajeAdeudo
	, GETDATE() as fechaUltimaModificacion
FROM SircaNac.dbo.tabla_eqv_paeeem tep 
left join (
	select 
	CodRegion, 
	CodCoord, 
	--COUNT(*) as totalcreditos,
	--SUM(case when dias_de_atraso >= 300 then 1 else 0 end ) as creditosEnAtraso240Dias,
	SUM(monto_adeudado) as monto_adeudado,
	SUM(case when monto_atraso is not null then monto_adeudado else 0 end) as monto_atraso,
	((SUM(case when monto_atraso is not null then monto_adeudado else 0 end) * 100 )/ SUM(monto_adeudado)) as porcentajeAdeudo
	--round(((SUM(case when dias_de_atraso >= 300 then 1 else 0 end )*100.00)/count(*)),2) as porcentajeAdeudo
	from cobranza
	group by CodRegion, CodCoord
) as tmp on tmp.CodCoord=tep.codcoord and tmp.CodRegion=tep.codregion