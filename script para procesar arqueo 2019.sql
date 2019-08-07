
SELECT * 
  FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]
  where IdCtrlArqueo='1'  and Estatus=1
  and FechaFac <> '00000000' and Importe> 0 and NumCredito is not null

-- poner numero de credito a los pagos 

-- poner producto 






INSERT INTO [SircaNac].[dbo].[CargaDiariaFecha]
           ([Linea]
           ,[Fecha]
           ,[Archivo]
           ,[Listo]
           ,[Credito]
           ,[RPU]
           ,[Producto]
           ,[FechaFactura]
           ,[FechaVencimiento]
           ,[Importe]
           ,[Estatus]
           ,[FechaPago]
           ,[AnoFact]
           ,[MesFact]
           ,[Error]
           ,[TipoCred]
           ,[EsPagoFin]
           ,[FechaArchivo]
           ,[Cuenta]
           ,[Motivo]
           ,[FechaFactMod]
           ,[EnviadoPR])

			select 
			LINEA = '0000000000|'+RPU+'|'+mot+'|'+suf+'|'+fechafac+'|'+FECHAVEN+  
                       '|'+right('            '+convert(varchar,Importe),12)+  
                       '|'+ '01'+'|1|'+FECHApago+'|'+AñoFac+'|'+ MesFac+'|'
           ,FECHA = GETDATE()
           ,'ARQUEFIDE2019'
           ,1
           ,numcredito
           ,RPU
           ,Producto
           ,FechaFac
           ,FechaVen
           ,Importe
           ,Estatus
           ,FechaPago
           ,AñoFac
           ,MesFac
           ,0
           ,'N'
           ,0
           ,GETDATE()
           ,0
           ,mot
           ,0
           ,NULL
			FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]
			where IdCtrlArqueo='1'  and Estatus=1
			and FechaFac <> '00000000' and Importe> 0 and NumCredito is not null
           










































  
 iNSERT INTO [CargaDiariaFechaarqueo]  
          (  
         linea,fecha,fechaarchivo,archivo,idarqueo,listo,error  
         )  
      select  LINEA = '0000000000|'+RPU+'|'+mot+'|'+suf+'|'+fechafac+'|'+FECHAVEN+  
                       '|'+right('            '+convert(varchar,Importe),12)+  
                       '|'+ '01'+'|1|'+FECHApago+'|'+AñoFac+'|'+ MesFac+'|',  
               FECHA = GETDATE(),  
               fechaarchivo=GETDATE(),  
             ARCHIVO = 'ARQUEFIDE2019',  
             IDarqueo,0,0  
        FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]  
         
WHERE  fechafac <> '000000' AND ISDATE(FECHApago) = 1 
         order by IDarqueo  