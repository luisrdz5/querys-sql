INSERT INTO [SircaNac].[dbo].[pagos]
           ([NumCredito]
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
           ,[tipopago])
     select NumCredito,Rpu,
     (select isnull(max(numpago),0)+1 from pagos where Numcredito=r.Numcredito and NumPago is not null) as NumPago,
     FechaFactura,FechaVencimiento,Importe,'01' as estatus,FechaPago,MesFact,
     AnoFact,0.00,'AplicacionPagosCFE',GETDATE(),'lrodriguez','AplicacionPagosCFE','AplicacionPagosCFE',ID,AnoFact+MesFact as fecfac,MesFact,AnoFact,NULL
	 from RegistrosSicomOK r
	 where id in (
		'58795578',
		'58812645',
		'58812644',
		'58812646',
		'58812643',
		'58659304',
		'58659305'
	 )
	 
	 
	 exec FIDEArreglaPagos '911955778'
	 exec FIDEArreglaPagos '903719126'
	 
	 

