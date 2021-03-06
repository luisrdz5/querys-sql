USE [SOF_SircaNac]
GO
/****** Object:  StoredProcedure [dbo].[superBot_envioResumenCobranza]    Script Date: 11/27/2019 13:18:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[superBot_envioDetalleCobranzaRSOK] (@ID INT, @DESTINATARIOS	VARCHAR(500))
AS
BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE 
	@TOTALRSOK								AS	INTEGER,
	@TOTAL									AS	INTEGER,
	@TABLEHTML								NVARCHAR(MAX),
	@MENSAJE								NVARCHAR(MAX),
	@SOLICITUDESPORSTATUS					NVARCHAR(MAX),
	@SOLICITUDESPENDIENTESPORREGION			NVARCHAR(MAX),
	@SOLICITUDESPENDIENTES					INT,
	@SUBJECT								AS VARCHAR(150)


	SET @MENSAJE = ''
	SET @SUBJECT = '[SUPER BOT] Detalle de Aplicación de Lotes de cobranza cargada a SIRCA (Errores RegistrosSicomOk)'
	
	
		DECLARE @Column1Name VARCHAR(255)
	DECLARE @Query VARCHAR(2048)
	SET @Column1Name = '[sep=,' + CHAR(13) + CHAR(10) + 'Region]'
	SET @Query = 'SELECT   
				cat.Descripción,
				R.*
				FROM [SOF_SIRCANAC].[HISTORICO].[ARQUEO] A
				JOIN SIRCANAC.DBO.CARGADIARIAFECHA C ON C.IDARQUEO=A.IDARQUEO
				LEFT JOIN SIRCANAC.DBO.REGISTROSSICOMOK R ON R.IDCARGADIARIAFECHA=C.ID
				LEFT JOIN SIRCANAC.DBO.CATALOGO_ERRORES CAT ON CAT.ERROR=R.ERROR
				WHERE IdctrlArqueo='''+ convert(varchar,@ID) +''' and r.error=8 '
				
				
  EXEC msdb.dbo.sp_send_dbmail 
  @profile_name='sql1',  
   @recipients=@DESTINATARIOS, 
    @query = @Query ,  
    @subject= @SUBJECT,  
    @attach_query_result_as_file=1,
	@query_attachment_filename='QueryResults.csv',
	@query_result_separator=',',
	@query_result_no_padding=1,
	@query_result_width=32767  ;  
	
	
			
END
