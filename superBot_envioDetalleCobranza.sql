USE [SOF_SircaNac]
GO
/****** Object:  StoredProcedure [dbo].[superBot_envioDetalleCobranza]    Script Date: 11/27/2019 18:17:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[superBot_envioDetalleCobranza] (@ID INT, @DESTINATARIOS VARCHAR(500))
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
	SET @SUBJECT = '[SUPER BOT] Detalle de Aplicación de Lotes de cobranza cargada a SIRCA (Errores Arqueo)'
	
	
		DECLARE @Column1Name VARCHAR(255)
	DECLARE @Query VARCHAR(2048)
	SET @Column1Name = '[sep=,' + CHAR(13) + CHAR(10) + 'Region]'
	SET @Query = 'SELECT  
      a.Division
      ,a.RPU
      ,a.Mot
      ,a.Descripcion
      ,a.Suf
      ,a.FechaFac
      ,a.FechaVen
      ,a.Importe
      ,a.Estatus
      ,a.FechaPago
      ,a.AñoFac
      ,a.MesFac
      ,a.numcredito
      ,a.producto
      ,c.Descripcion
  FROM [SOF_SircaNac].[HISTORICO].[ARQUEO] a
  join [SOF_SircaNac].[dbo].[Catalogo_Estatus_Arqueo] c on c.id_procesado=a.procesado
  where IdctrlArqueo='''+ convert(varchar,@ID) +'''
  and procesado in ("2","3","4","5","6","8","10") '

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
