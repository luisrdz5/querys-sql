DECLARE 
 @RPU					VARCHAR(12)    
,@NUMCREDITO			NUMERIC(10,0)    
,@NUMCREDITOBANDERA		NUMERIC(10,0)   
,@NUMCREDITOBANDERA2	NUMERIC(10,0) 
,@REFERENCIA			VARCHAR(17)    
,@IMPORTE				NUMERIC(8,2)    
,@PAGARE				INT    
,@TIPOPAGO				VARCHAR(2)    
,@FECHAEE				VARCHAR(12)
,@ID_EDOCUENTA			INT 
,@IDCCONCEPTO			INT 
,@LINEACONCEPTO			VARCHAR(255)
,@PROCESADO				INT
,@TEXTOPROCESO			VARCHAR(100)
,@STATUSANTERIOR		VARCHAR(100)
,@STATUSFINAL			VARCHAR(100)
,@RESPUESTASTORED		VARCHAR(100)
,@TIPOCONVENIO			INT
,@ESTADOLIQUIDACION		INT
,@IDMANUAL				INT
,@MESFACT				VARCHAR(2)
,@YFACT					VARCHAR(2)
,@YEAR					VARCHAR(4)=NULL
,@USER					VARCHAR(100)
,@INDICE				VARCHAR(2)
,@RES					VARCHAR(MAX)= NULL
,@TEXT					VARCHAR(MAX)= NULL
,@ESCONVENIO			varchar(9) = NULL
,@SUMCONVENIO			NUMERIC(8,2) = 0

-- INICIALIZO VARIABLES 

SET @RPU = NULL
SET @NUMCREDITO = NULL 
SET @NUMCREDITOBANDERA = NULL 
SET @NUMCREDITOBANDERA2 = NULL 
SET @REFERENCIA = NULL
SET @IMPORTE = NULL
SET @PAGARE = NULL
SET @TIPOPAGO = NULL
SET @FECHAEE = NULL
SET @ID_EDOCUENTA = NULL
SET @IDCCONCEPTO = NULL
SET @LINEACONCEPTO = NULL
SET @PROCESADO	 = 0
SET @ESTADOLIQUIDACION = 0
SET @TIPOCONVENIO= 0
SET @STATUSANTERIOR = NULL 
SET @STATUSFINAL = NULL
SET @RESPUESTASTORED = NULL
SET @MESFACT = NULL
SET @YFACT= NULL
SET @USER =NULL
SET @INDICE = NULL
SET @YEAR =NULL
SET @RES = NULL 

-- SE OBTIENE LA PRIMERA REFERENCIA A PROCESAR 

SELECT TOP 1
	   @ID_EDOCUENTA = C.IDEDOCUENTA_MOV,
	   @IDCCONCEPTO = C.ID,
	   @NUMCREDITO=LEFT(RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17), 9),
	   @REFERENCIA= RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17),
	   @LINEACONCEPTO = C.CCONCEPTO,
	   @IMPORTE = M.IMPORTE,
	   @FECHAEE = M.FECHAOPERACION
FROM DBO.EDOCUENTA_CCONCEPTO C
JOIN DBO.EDOCUENTA_MOV M ON M.ID = C.IDEDOCUENTA_MOV
WHERE  C.CCONCEPTO LIKE '%PAGO DETALLE%' AND C.ESTATUS='PENDIENTE'

IF @NUMCREDITO IS NULL
BEGIN
	PRINT 'NO SE ENCONTRO NINGUNA REFERENCIA PARA PROCESAR'
END

-- declaro tabla temporal para guardar resultados de storeds 
		IF OBJECT_ID('tempdb..#t') IS NOT NULL
		BEGIN
			DROP TABLE #t
		END
		ELSE 
		BEGIN
			create table  #t ( indice int, resultado VARCHAR(MAX) )
		END


WHILE @NUMCREDITO IS NOT NULL 
BEGIN
	PRINT 'PROCESANDO REFERENCIA: ' + @REFERENCIA
	/*
	-- VERIFICAMOS QUE NO FUE PROCESADO CON ANTERIORIDAD 
	   SELECT TOP 1
	   @STATUSANTERIOR = C.ESTATUS
	   FROM DBO.EDOCUENTA_CCONCEPTO C
	   JOIN DBO.EDOCUENTA_MOV M ON M.ID = C.IDEDOCUENTA_MOV
	   WHERE  C.CCONCEPTO LIKE '%PAGO DETALLE%' AND C.ESTATUS NOT IN ('PENDIENTE') AND M.IMPORTE = @IMPORTE AND  M.FECHAOPERACION = @FECHAEE 
	   AND  RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17) = @REFERENCIA
	   PRINT 'VERIFICANDO SI ES UNA REFERENCIA YA PROCESADA '
	   
	
	IF @STATUSANTERIOR IS NOT NULL 
	BEGIN 
		-- UPDATEAMOS TODOS LOS REGISTROS IGUALES 
		UPDATE C
		SET ESTATUS=' SE HA DETECTADO COMO UN POSIBLE PAGO DUPLICADO (SE NECESITA REVISION MANUAL)'
		FROM DBO.EDOCUENTA_CCONCEPTO C
		JOIN DBO.EDOCUENTA_MOV M ON M.ID = C.IDEDOCUENTA_MOV
		WHERE  C.CCONCEPTO LIKE '%PAGO DETALLE%' 
			AND C.ESTATUS IN ('PENDIENTE') 
			AND M.IMPORTE = @IMPORTE 
			AND M.FECHAOPERACION = @FECHAEE 
			AND RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17) = @REFERENCIA
		
		-- INICIALIZO VARIABLES 

		SET @RPU = NULL
		SET @NUMCREDITO = NULL 
		SET @NUMCREDITOBANDERA = NULL 
		SET @NUMCREDITOBANDERA2 = NULL 
		SET @REFERENCIA = NULL
		SET @IMPORTE = NULL
		SET @PAGARE = NULL
		SET @TIPOPAGO = NULL
		SET @FECHAEE = NULL
		SET @ID_EDOCUENTA = NULL
		SET @IDCCONCEPTO = NULL
		SET @LINEACONCEPTO = NULL
		SET @PROCESADO	 = 0
		SET @ESTADOLIQUIDACION = 0
		SET @TIPOCONVENIO= 0
		SET @STATUSANTERIOR = NULL 
		SET @STATUSFINAL = NULL
		SET @RESPUESTASTORED = NULL
		SET @MESFACT = NULL
		SET @YFACT= NULL
		SET @USER =NULL
		SET @INDICE = NULL
		SET @YEAR =NULL
		SET @RES = NULL 
	END
	*/
-- SE VERIFICA SI ES LIQUIDACION ANTICIPADA
	PRINT 'VERIFICANDO SI LA REFERENCIA '+@REFERENCIA+' ES UNA LIQUIDACION ANTICIPADA '
	SELECT TOP 1 @NUMCREDITOBANDERA=NUMCREDITO , @ESTADOLIQUIDACION = ESTADO
	FROM SOLICITUDPAGOANTICIPADO
	WHERE  NUMCREDITO=@NUMCREDITO AND MONTOPAGAR = @IMPORTE AND estado = 0
	IF  @NUMCREDITOBANDERA IS NOT NULL 
	BEGIN
	-- OBTENGO EL RPU DEL CREDITO
	SELECT TOP 1 @RPU = RPU FROM creditos WHERE NumCredito=@NUMCREDITO
	
	-- EJECUTAMOS STORED DE APLICACION DE LIQUIDACIONES ANTICIPADAS 
		PRINT 'SE ESTA PROCESANDO LA (LA) CON LOS SIGUIENTES DATOS: '
		PRINT @RPU
		PRINT @NUMCREDITO
		PRINT @IMPORTE
		PRINT @FECHAEE
		
		--CREO UNA TABLA TEMPORAL PARA CACHAR EL RESULTADO DEL STORED

		INSERT INTO #t (indice,resultado)
		EXEC SP_GRABABANCO @RPU, @NUMCREDITO, @IMPORTE, @FECHAEE 
		--ASIGNANDO EL VALOR DE LA COLUMNA A LA VARIABLE.
		SELECT @INDICE = indice, @res=resultado FROM #t
		SET @STATUSFINAL = @STATUSFINAL + @res
		truncate table #t
		IF @INDICE = 1 
		BEGIN
			SET @STATUSFINAL = 'SE PROCESO CORRECTAMENTE (LA) '
		END
		ELSE 
		BEGIN
			SET @STATUSFINAL = 'EL PAGO FALLO (LA) '
		END
		SET @STATUSFINAL = @STATUSFINAL + @res
		truncate table #t
	END
	ELSE 
	BEGIN 
		-- VERIFICO SI ES CONVENIO 
		PRINT 'VERIFICANDO SI LA REFERENCIA '+@REFERENCIA+' ES UN  CONVENIO '
		SELECT TOP 1 @NUMCREDITOBANDERA=CON.CREDITO , @TIPOCONVENIO = CON.TIPOCONVENIO
		FROM CONVENIOS CON 
		WHERE  CON.CREDITO=@NUMCREDITO AND (CON.REFERENCIA=@REFERENCIA OR CON.REFERPARCIALIDAD = @REFERENCIA )
		
		/*
		
		-- VERIFICO NO HALLA SIDO APLICADO CON ANTERIORIDAD 
		
		SELECT @NUMCREDITOBANDERA2= CREDITO
		FROM det_convenio
		WHERE importepago = @IMPORTE AND fechapago = @FECHAEE
		
		IF @NUMCREDITOBANDERA2 IS NOT NULL 
		BEGIN 
			SET @NUMCREDITOBANDERA = NULL
			SET @STATUSFINAL = 'PAGO DE CONVENIO DETECTADO COMO APLICADO CON ANTERIORIDAD'
			SET @NUMCREDITOBANDERA2 = NULL
		END
		
		*/
	
		IF @NUMCREDITOBANDERA IS NOT NULL 
		BEGIN
		-- TRAEMOS DATOS NECESARIOS PARA PROCESAR CONVENIO
				SELECT 
				TOP 1
				@RPU=CON.RPU, 
				@PAGARE = DET.PAGARE,
				@TIPOPAGO = CASE WHEN DET.PAGARE > 0 THEN 'P' ELSE 'A' END
				FROM EDOCUENTA_MOV E
				JOIN EDOCUENTA_CCONCEPTO C ON C.IDEDOCUENTA_MOV=E.ID
				JOIN CONVENIOS CON ON CON.CREDITO= LEFT(RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17), 9) AND (CON.REFERENCIA=RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17) OR CON.REFERPARCIALIDAD = RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17))
				JOIN DET_CONVENIO DET ON DET.CREDITO = CON.CREDITO AND DET.RPU = CON.RPU 
				WHERE RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17)=@REFERENCIA AND DET.ESTATUS NOT IN ('14')
				ORDER BY FECHA ASC
				PRINT 'PREPARANDOSE A PROCESAR CONVENIO '	
				PRINT @RPU 
				PRINT @NUMCREDITO 
				PRINT @REFERENCIA 
				PRINT @IMPORTE  
				PRINT @PAGARE 
				PRINT @TIPOPAGO 
				PRINT @FECHAEE 
				
		-- DE ACUERDO AL TIPO DE CONVENIO SE APLICA EL STORED CORRECTO 
			IF @TIPOCONVENIO = 5 
			BEGIN
				PRINT 'PROCESANDO CONVENIO TIPO 5 CON NUMCREDITO = ' + CONVERT(VARCHAR,@NUMCREDITO)
				--CREO UNA TABLA TEMPORAL PARA CACHAR EL RESULTADO DEL STORED
				INSERT INTO #t 
				EXEC SP_CAPTURAPAGOCONVENIO_ESPECIAL @RPU, @NUMCREDITO , @REFERENCIA , @IMPORTE  , @PAGARE , @TIPOPAGO , @FECHAEE 
				SELECT top 1  @INDICE= indice, @res=resultado FROM #t
				IF @INDICE = 1 
				BEGIN
					SET @STATUSFINAL = 'SE PROCESO CORRECTAMENTE (CONVENIO ESPECIAL) '
				END
				ELSE 
				BEGIN
					SET @STATUSFINAL = 'EL PAGO FALLO! (CONVENIO ESPECIAL) '
				END
				SET @STATUSFINAL = @STATUSFINAL + @res
				truncate table #t
			END 
			ELSE 
			BEGIN 
			PRINT 'PROCESANDO CONVENIO TIPO ' + CONVERT(VARCHAR,@TIPOCONVENIO) + ' CON NUMCREDITO = ' + CONVERT(VARCHAR,@NUMCREDITO)	
				INSERT INTO #t 
				EXEC SP_CAPTURAPAGOCONVENIO @RPU, @NUMCREDITO , @REFERENCIA , @IMPORTE  , @PAGARE , @TIPOPAGO , @FECHAEE 
				SELECT top 1 @INDICE= indice, @res=resultado FROM #t
				IF @INDICE = 1 
				BEGIN
					SET @STATUSFINAL = 'SE PROCESO CORRECTAMENTE (CONVENIO ESPECIAL) '
				END
				ELSE 
				BEGIN
					SET @STATUSFINAL = 'EL PAGO FALLO! (CONVENIO ESPECIAL) '
				END
				SET @STATUSFINAL = @STATUSFINAL + @res
				truncate table #t
			END 
		END
		ELSE 
		BEGIN 
			-- SE DEBERA BUSCA EN LA TABLA DE REFERENCIAS MANUALES DE CLAUDIA  
			PRINT 'VERIFICANDO SI LA REFERENCIA '+@REFERENCIA+' ES UNA REFERENCIA MANUAL '
			SELECT @NUMCREDITOBANDERA = NUMCREDITO, @IDMANUAL = ID, @ESCONVENIO = idConvenio
			FROM EDOCUENTA_REF
			WHERE NUMCREDITO=@NUMCREDITO AND IMPORTE = @IMPORTE
			IF @NUMCREDITOBANDERA IS NOT NULL 
			BEGIN
				PRINT 'PREPARANDOSE A PROCESAR PAGO MANUAL '	
				PRINT @NUMCREDITO 
				PRINT @REFERENCIA 
				PRINT @IMPORTE   
				PRINT @FECHAEE 
				SET @MESFACT = substring(ltrim(rtrim(@FECHAEE)),5,2)
				SET @YEAR= substring(ltrim(rtrim(@FECHAEE)),1,4)
				SELECT  @USER = suser_sname()
				print @MESFACT
				PRINT @YEAR
				print @USER

				EXEC	@INDICE = [dbo].[nsp_Insert_PagoSIRCA]
						@NumeroCredito = @NUMCREDITO,
						@FechaPago = @FECHAEE,
						@FechaFac = @FECHAEE,
						@FechaVenci = @FECHAEE,
						@Importe = @IMPORTE,
						@AnioFact = @YEAR,
						@MesFact = @MESFACT,
						@Estatus = 96,
						@TipoPago = 12,
						@Archivo = N'CUENTARAP',
						@Usuario = @USER,
						@LogSQL = @RES OUTPUT
				
				INSERT INTO #T (INDICE,RESULTADO)
				SELECT	@INDICE, @RES 
				SELECT @INDICE = INDICE, @RES=RESULTADO FROM #T
				SET @STATUSFINAL = '(PAGO MANUAL PROCESADO )'
				PRINT 'RES ES : '+ CONVERT(VARCHAR(100),ISNULL(@RES,''))
				SET @STATUSFINAL = @STATUSFINAL + ISNULL(@RES,' ')
				TRUNCATE TABLE #T
				SET @RES = NULL 		
				-- Version anterior de ejecucion de stored 				
				--EXEC [nsp_Insert_PagoSIRCA] @NUMCREDITO, @FECHAEE, @FECHAEE, @FECHAEE, @IMPORTE, @YEAR ,@MESFACT, '96', '12', 'CUENTARAP' , @USER, @LogSQL = @TEXT
				-- si es un convenio aplicamos los pagos a det_convenio 
				IF @ESCONVENIO IS NOT NULL
				BEGIN
				-- SE APLICA EL IMPORTE A DET_CONVENIO 
					PRINT 'ES UN CONVENIO Y SE PROCEDE A MATAR AMORTIZACIONES CORRESPONDIENTES'
					SELECT @SUMCONVENIO = SUM(IMPORTE)
					FROM det_convenio
					WHERE CREDITO=@NUMCREDITO AND ESTATUS NOT IN ('14') AND FOLIO = @ESCONVENIO
					WHILE @SUMCONVENIO >=  @IMPORTE
					BEGIN 					
						UPDATE det_convenio
						SET ESTATUS = 14 
						WHERE CREDITO=@NUMCREDITO AND ESTATUS NOT IN ('14') AND FOLIO = @ESCONVENIO AND FECHA IN (
							SELECT TOP  1 FECHA 
							FROM det_convenio
							WHERE CREDITO=@NUMCREDITO AND ESTATUS NOT IN ('14') AND FOLIO = @ESCONVENIO 
							ORDER BY FECHA ASC
						)
						SET @SUMCONVENIO = 0
						SELECT @SUMCONVENIO = SUM(IMPORTE)
						FROM det_convenio
						WHERE CREDITO=@NUMCREDITO AND ESTATUS NOT IN ('14') AND FOLIO = @ESCONVENIO
					END 
				END								
			END 
			ELSE 
			BEGIN 
				SELECT 1
				SET @STATUSFINAL = 'NO SE PUDO PROCESAR LA REFERENCIA ' 
			END
		END
	END
	
	PRINT 'SALVANDO LOG DEL CREDITO '
	PRINT @NUMCREDITO
	PRINT 'CON EL ESTATUS FINAL '
	PRINT @STATUSFINAL
	
	-- SE COLORCA UNA MARCA DE PROCESADO O DE ERROR SEGUN SEA EL CASO
	IF @NUMCREDITO IS NOT NULL AND @STATUSFINAL IS NOT NULL
	BEGIN
		UPDATE C
		SET ESTATUS=@STATUSFINAL
		FROM DBO.EDOCUENTA_CCONCEPTO C
		JOIN DBO.EDOCUENTA_MOV M ON M.ID = C.IDEDOCUENTA_MOV
		WHERE  C.CCONCEPTO LIKE '%PAGO DETALLE%' 
			AND C.ESTATUS IN ('PENDIENTE') 
			AND M.IMPORTE = @IMPORTE 
			AND M.FECHAOPERACION = @FECHAEE 
			AND RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17) = @REFERENCIA
	END

		-- INICIALIZO VARIABLES 

		SET @RPU = NULL
		SET @NUMCREDITO = NULL 
		SET @NUMCREDITOBANDERA = NULL 
		SET @NUMCREDITOBANDERA2 = NULL 
		SET @REFERENCIA = NULL
		SET @IMPORTE = NULL
		SET @PAGARE = NULL
		SET @TIPOPAGO = NULL
		SET @FECHAEE = NULL
		SET @ID_EDOCUENTA = NULL
		SET @IDCCONCEPTO = NULL
		SET @LINEACONCEPTO = NULL
		SET @PROCESADO	 = 0
		SET @ESTADOLIQUIDACION = 0
		SET @TIPOCONVENIO= 0
		SET @STATUSANTERIOR = NULL 
		SET @STATUSFINAL = NULL
		SET @RESPUESTASTORED = NULL
		SET @MESFACT = NULL
		SET @YFACT= NULL
		SET @USER =NULL
		SET @INDICE = NULL
		SET @YEAR =NULL
		SET @RES = NULL 
		SET @ESCONVENIO = NULL

-- SE OBTIENE LA SIGUIENTE  REFERENCIA A PROCESAR 

	SELECT TOP 1
		   @ID_EDOCUENTA = C.IDEDOCUENTA_MOV,
		   @IDCCONCEPTO = C.ID,
		   @NUMCREDITO=LEFT(RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17), 9),
		   @REFERENCIA= RIGHT(LTRIM(RTRIM(C.CCONCEPTO)), 17),
		   @LINEACONCEPTO = C.CCONCEPTO,
		   @IMPORTE = M.IMPORTE,
		   @FECHAEE = M.FECHAOPERACION
	FROM DBO.EDOCUENTA_CCONCEPTO C
    JOIN DBO.EDOCUENTA_MOV M ON M.ID = C.IDEDOCUENTA_MOV
	WHERE  C.CCONCEPTO LIKE '%PAGO DETALLE%' AND C.ESTATUS='PENDIENTE'
END
		IF OBJECT_ID('tempdb..#t') IS NOT NULL
		BEGIN
			DROP TABLE #t
		END
PRINT 'SE HA TERMINADO LA EJECUCION DEL PROCESO'
