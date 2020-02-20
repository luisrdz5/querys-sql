-- SUPER-BOT 
 --ESTE ES UN BOT GENERADO PARA ENVIAR LAS ESTADISTICAS DE LA COBRANZA APLICADA EN SIRCA
 
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE 
	@ID										AS	INTEGER,
	@TOTALARQUEO							AS	INTEGER,
	@TOTALRSOK								AS	INTEGER,
	@TOTAL									AS	INTEGER,
	@TABLEHTML								NVARCHAR(MAX),
	@MENSAJE								NVARCHAR(MAX),
	@SOLICITUDESPORSTATUS					NVARCHAR(MAX),
	@SOLICITUDESPENDIENTESPORREGION			NVARCHAR(MAX),
	@SOLICITUDESPENDIENTES					INT,
	@SUBJECT								AS VARCHAR(50),
	@DESTINATARIOS							AS VARCHAR(500),
	@ARCHIVO								AS VARCHAR(500)

	SET @DESTINATARIOS = 'GERARDO.BAUTISTA@CFE.GOB.MX;LUIS.RODRIGUEZ22@CFE.GOB.MX; CLAUDIA.MEZA@CFE.GOB.MX ; ALEJANDROMURO@CFE.GOB.MX; ALVARO.MARTINEZ@CFE.GOB.MX; CARLOS.MEDINA@CFE.GOB.MX'
	SET @DESTINATARIOS = 'LUIS.RODRIGUEZ22@CFE.GOB.MX'
	SET @MENSAJE = ''
	SET @SUBJECT = '[SUPER BOT] REPORTE DE LOTES DE COBRANZA CARGADA A SIRCA'
	
	
	
	-- OBTENGO ID A PROCESAR
	
	--SET @ID = 61
	  
	SELECT  TOP 1 @ID=ID, @ARCHIVO=ARCHIVO
	FROM [SOF_SIRCANAC].[DBO].[CONTROL_ARQUEO]
	WHERE FECHAPROCESOCARGA IS NULL


	SELECT @TOTAL=isnull(COUNT(*),0)
	FROM [SOF_SIRCANAC].[DBO].[CONTROL_ARQUEO]
	WHERE ID=@ID
	

	IF(@TOTAL > 0) BEGIN
  -- OBTENGO TODOS LOS PAGOS QUE CORRESPONDEN A ESTE LOTE
  
		SELECT @TOTALARQUEO=COUNT(*)
		FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO]
		WHERE IDCTRLARQUEO = @ID AND PROCESADO= 1 
		 
		--OBTENGO SI YA TODOS LOS PAGOS FUERON PROCESADOS POR EL STORED DE ARQUEO 

		SELECT   
		@TOTALRSOK = COUNT(DISTINCT IDCARGADIARIAFECHA) 
		FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
		JOIN SIRCANAC.DBO.CARGADIARIAFECHA C ON C.IDARQUEO=A.IDARQUEO
		LEFT JOIN SIRCANAC.DBO.REGISTROSSICOMOK R ON R.IDCARGADIARIAFECHA=C.ID
		LEFT JOIN SIRCANAC.DBO.CATALOGO_ERRORES CAT ON CAT.ERROR=R.ERROR
		WHERE IDCTRLARQUEO = @ID AND R.PROCESADO = 1 


		-- SI TODO ESTA PROCESADO OBTENGO LOS DATOS 
		IF (@TOTALARQUEO=@TOTALRSOK) BEGIN
		
			-- GENERO TABLA DE 
			
			SET @SOLICITUDESPORSTATUS =  
				N'<H1>PROCESO DE ARQUEO </H1>' +  
				N'<TABLE BORDER="1">' +  
				N'<TR><TH>DESCRIPCION</TH><TH>NUMERO DE PAGOS</TH>' +  
				N'<TH>MONTO APLICADO </TH></TR>' +  
				CAST ( ( 
							SELECT 
							TD = C.DESCRIPCION,       '',
							TD = COUNT(*),       '',
							TD = '$ ' + CONVERT(VARCHAR,CAST(SUM(IMPORTE) AS MONEY),1) 
							FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
							JOIN [SOF_SIRCANAC].[DBO].[CATALOGO_ESTATUS_ARQUEO] C ON A.PROCESADO = C.ID_PROCESADO
							WHERE IDCTRLARQUEO =@ID
							GROUP BY PROCESADO , C.DESCRIPCION
							/*
							UNION
							SELECT 
							'TOTAL',
							COUNT(*),
							SUM(IMPORTE)
							FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
							WHERE IDCTRLARQUEO =@ID
							*/
						  FOR XML PATH('TR'), TYPE   
				) AS NVARCHAR(MAX) ) +  
				N'</TABLE>' ;  
	

			-- EMPIEZO A OBTENER LA ESTADISTICA DE REGISTROSICOMOK
									DROP TABLE #TMP
			
											SELECT ERROR, DESCRIPCION, IMPORTE, CANTIDAD, PROCESADO
											INTO #TMP
											FROM (
											SELECT   
											R.ERROR,
											CAT.DESCRIPCIÓN AS DESCRIPCION,
											SUM(R.IMPORTE) AS IMPORTE,
											COUNT(*) AS CANTIDAD ,
											R.PROCESADO
											FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
											JOIN SIRCANAC.DBO.CARGADIARIAFECHA C ON C.IDARQUEO=A.IDARQUEO
											LEFT JOIN SIRCANAC.DBO.REGISTROSSICOMOK R ON R.IDCARGADIARIAFECHA=C.ID
											LEFT JOIN SIRCANAC.DBO.CATALOGO_ERRORES CAT ON CAT.ERROR=R.ERROR
											WHERE IDCTRLARQUEO = @ID
											GROUP BY R.ERROR, CAT.DESCRIPCIÓN,  R.PROCESADO
											UNION 
														
											SELECT  
											'99' AS ERROR,
											'TOTAL' AS DESCRIPCION,
											SUM(R.IMPORTE) AS IMPORTE,
											COUNT(*) AS CANTIDAD,
											R.PROCESADO
											FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
											JOIN SIRCANAC.DBO.CARGADIARIAFECHA C ON C.IDARQUEO=A.IDARQUEO
											LEFT JOIN SIRCANAC.DBO.REGISTROSSICOMOK R ON R.IDCARGADIARIAFECHA=C.ID
											LEFT JOIN SIRCANAC.DBO.CATALOGO_ERRORES CAT ON CAT.ERROR=R.ERROR
											WHERE IDCTRLARQUEO = @ID
											GROUP BY R.PROCESADO ) AS TMP
			
			SET @SOLICITUDESPENDIENTESPORREGION =  ''
			
			
				SET @SOLICITUDESPENDIENTESPORREGION =  
					N'<H1>PAGOS PROCESADOS EN REGISTROSICOMOK </H1>' +  
					N'<TABLE BORDER="1">' +  
					N'<TR><TH>CODIGO ERROR</TH><TH>DESCRIPCION</TH><TH>IMPORTE</TH><TH>CANTIDAD</TH></TR>' +   
					CAST ( ( 
											SELECT   
											TD = ERROR,       '',
											TD = DESCRIPCION,       '',
											TD = '$ ' + CONVERT(VARCHAR,CAST(IMPORTE AS MONEY),1),       '',
											TD = CANTIDAD
											FROM #TMP
						 FOR XML PATH('TR'), TYPE   
					) AS NVARCHAR(MAX) ) +  
					N'</TABLE>' ;  

			

			-- ELABORO MENSAJE DEL CORREO 
				
				
			SET @MENSAJE =  
			N' BUEN DIA <BR /><BR /> '+
			N' ********************** REPORTE DE PAGOS CARGADOS EN SIRCA *********************** <BR/> <BR/>'+
			N' SE INFORMA QUE EL DIA DE HOY SE ENCONTRARON '+CONVERT(VARCHAR,@TOTALARQUEO)+ ' PAGOS A APLICAR PROVENIENTES DEL ARCHIVO '+@ARCHIVO+' <BR/>'+
			N' A CONTINUACIÓN SE MUESTRA EL RESUMEN DE LA APLICACIÓN DE LOS MISMOS:  <BR /> '+
			@SOLICITUDESPORSTATUS+
			N'<BR /> <BR /> '+
			N' A CONTINUACION SE MUESTRA LOS PAGOS APLICADOS EN SIRCA <BR /> '+
			@SOLICITUDESPENDIENTESPORREGION+
			N'<BR /> <BR /> '+
			N' QUE TENGA UN BUEN DIA <BR/> '+
			N' MENSAJE ENVIADO POR UN BOT AUTOMATICO. FAVOR DE NO CONTESTAR A ESTE CORREO '
			
			
			
			
			
			EXEC MSDB.DBO.SP_SEND_DBMAIL @PROFILE_NAME='SQL1',
			@RECIPIENTS=@DESTINATARIOS,
			@SUBJECT=@SUBJECT,
			@BODY=@MENSAJE,
			@BODY_FORMAT = 'HTML';
			
			-- SE UPDATEA [SOF_SIRCANAC].[DBO].[CONTROL_ARQUEO]			
			
			UPDATE [SOF_SIRCANAC].[DBO].[CONTROL_ARQUEO]
			SET FECHAPROCESOCARGA = GETDATE()
			WHERE ID=@ID


		END

	END
	
	    





