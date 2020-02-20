CREATE PROCEDURE SPPROCESARPAGOSARQUEO2019
AS
BEGIN
DECLARE

	@IDARQUEO			AS INT,
	@NUMEROCREDITOS		AS INT,
	@IDCONTROL			AS INT
	

	SELECT @NUMEROCREDITOS = COUNT(*)
	FROM  [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
	WHERE A.PROCESADO IS NULL
	SET @IDARQUEO = NULL
	
	IF @NUMEROCREDITOS > 0
	BEGIN 
		-- ELIMINO FALSOS POSITIVOS 
		--ELIMINO LOS QUE NO SE LES PUDO ASIGNAR NUMERO DE CREDITO 
		UPDATE [SOF_SIRCANAC].[HISTORICO].[ARQUEO]
		SET PROCESADO = 1
		WHERE numcredito='000000000'
		--ELIMINO LOS QUE TIENEN FECHA FACTURACION INVALIDA 
		UPDATE [SOF_SIRCANAC].[HISTORICO].[ARQUEO]
		SET PROCESADO = 1
		WHERE FechaFac = '00000000'
		-- ELIMINO LOS QUE TIENEN IMPORTE = 0
		UPDATE [SOF_SIRCANAC].[HISTORICO].[ARQUEO]
		SET PROCESADO = 1
		WHERE Importe = 0
		-- ELIMINO LOS QUE TIENEN ESTATUS  <> 1 
		UPDATE [SOF_SIRCANAC].[HISTORICO].[ARQUEO]
		SET PROCESADO = 1
		WHERE Estatus <> '01'
		--COMENZAMOS A PROCESAR PAGOS REALES 
		SELECT TOP 1  @IDARQUEO=A.IDARQUEO
		FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
		WHERE  PROCESADO IS NULL 
		
		
		WHILE @IDARQUEO IS NOT NULL
		BEGIN
		
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
			   ,3
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
				where IDARQUEO =  @IDARQUEO and NumCredito is not null

			PRINT  'PROCESANDO EL PAGO CON ID: '+ CONVERT(VARCHAR,@IDARQUEO)
			UPDATE [SOF_SIRCANAC].[HISTORICO].[ARQUEO]
			SET PROCESADO = 1	
			WHERE IDARQUEO =  @IDARQUEO
		
			SET @IDARQUEO = NULL
			SELECT TOP 1  @IDARQUEO=A.IDARQUEO
			FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
			WHERE  PROCESADO IS NULL 	
		END 
	END 
	ELSE 
	BEGIN
		PRINT 'NO SE ENCONTRARON CREDITOS PARA PROCESAR'
	
	END
	-- VERIFICO QUE NO EXISTA NINGUN REGISTRO EN EL LOG SIN MARCAR 
	SET @IDCONTROL = NULL
	SELECT TOP 1 @IDCONTROL=ID
	FROM [SOF_SircaNac].[dbo].[Control_ARQUEO]
	WHERE ESTATUSCARGA IS NULL
	
	SET @NUMEROCREDITOS	= NULL
	IF @IDCONTROL IS NOT NULL
	BEGIN 
		SELECT @NUMEROCREDITOS = COUNT(*)
		FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO]
		WHERE IDCTRLARQUEO = @IDCONTROL AND PROCESADO IS NULL 
		IF @NUMEROCREDITOS = 0 
		BEGIN 
			UPDATE SOF_SIRCANAC.DBO.CONTROL_ARQUEO
			SET ESTATUSCARGA =  1 , FECHAPROCESOCARGA = GETDATE()
			WHERE ID = @IDCONTROL AND ESTATUSCARGA IS NULL 
			PRINT 'SE ACTUALIZO EL ID: '+ CONVERT(VARCHAR,@IDCONTROL)
		END
		ELSE
		BEGIN
			PRINT 'EXISTEN PAGOS ESISTENTES CON EL ID: '+ CONVERT(VARCHAR,@IDCONTROL)+ ' Y NO PUDO SER MODIFICADO'
		END
	END 




END
GO
