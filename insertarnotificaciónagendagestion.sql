/* query que inserta notificaciones a la agenda de gestion */

INSERT INTO [SIRCANAC].[dbo].[gestioninterna]
           ([rpu]
           ,[fechagestion]
           ,[tipogestion]
           ,[diasvencido]
           ,[importevencido]
           ,[fechapromesa]
           ,[resp1]
           ,[resp2]
           ,[resp2otra]
           ,[resp3]
           ,[resp4]
           ,[comentario]
           ,[moratorios]
           ,[iva]
           ,[gestor]
           ,[NumCredito])
		 	select
           '144120601069'
           ,'20160824'
           ,6
           ,(select datediff(dd,MIN(fecha),getdate())  from det_amortizacion  where estatus not in ('14','18')and rpu='144120601069')
           ,(select SUM(pagodec)  from det_amortizacion  where estatus not in ('14','18')and rpu='144120601069')
           ,NULL
           ,''
           ,''
           ,''
           ,''
           ,''
           ,'ENVIADA POR LA GERENCIA DE FINANZAS'
           ,0
           ,0
           ,'FINANZAS'
           ,NULL
GO


