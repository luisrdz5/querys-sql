truncate Table porcentajesZonasPorDistribuidor

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
	(select SUM(isnull(pagodec,0)) from det_amortizacion where solicitudscc=c.NumCredito and estatus in ('17','19') and datediff(dd,isnull(fecha,GETDATE()),getdate())>= 240) as monto_atraso,
	(select top 1 p.Proveedor
		from LINK41.FIDE.dbo.LC l With(Nolock) 
		Inner Join LINK41.FIDE.dbo.Prov p With(Nolock) On p.Proveedor = l.Acreedor   
		where  l.LineaCredito = c.NumSolicitud) as distribuidor,
	(select top 1 p.Nombre
		from LINK41.FIDE.dbo.LC l With(Nolock) 
		Inner Join LINK41.FIDE.dbo.Prov p With(Nolock) On p.Proveedor = l.Acreedor   
		where  l.LineaCredito = c.NumSolicitud) as nombredistribuidor
	from creditos c
	where c.tipocredito in ('PA','FV') and c.estatusCredito not in ('8','9')	
)
	
	INSERT INTO [SircaNac].[dbo].[porcentajesZonasPorDistribuidor]
           ([cve_Region]
           ,[cve_zona]
           ,[region]
           ,[zona]
           ,[codregion]
           ,[codcoord]
           ,[nombreRegion]
           ,[nombreCoord]
           ,[id_coordinacion]
           ,[distribuidor]
           ,[nombredistribuidor]
           ,[montoTotalAdeudado]
           ,[montoAtraso]
           ,[porcentajeAdeudo]
           ,[fechaUltimaModificacion])
	
	
	SELECT 
	tep.*
	, tmp.distribuidor
	, tmp.nombredistribuidor
	, tmp.monto_adeudado as montoTotalAdeudado
	, tmp.monto_atraso as montoAtraso
	, tmp.porcentajeAdeudo as porcentajeAdeudo
	, GETDATE() as fechaUltimaModificacion
FROM SircaNac.dbo.tabla_eqv_paeeem tep 
left join (
	select 
	distribuidor,
	nombredistribuidor,
	CodRegion, 
	CodCoord, 
	SUM(monto_adeudado) as monto_adeudado,
	SUM(case when monto_atraso is not null then monto_adeudado else 0 end) as monto_atraso,
	((SUM(case when monto_atraso is not null then monto_adeudado else 0 end) * 100 )/ SUM(monto_adeudado)) as porcentajeAdeudo
	from cobranza
	group by 	
	distribuidor,
	nombredistribuidor,
	CodRegion, 
	CodCoord
) as tmp on tmp.CodCoord=tep.codcoord and tmp.CodRegion=tep.codregion