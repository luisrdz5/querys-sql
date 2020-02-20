DECLARE 
	@tableHTML								NVARCHAR(MAX),
	@MENSAJE								NVARCHAR(MAX),
	@SOLICITUDESPORSTATUS					NVARCHAR(MAX),
	@SOLICITUDESPENDIENTESPORREGION			NVARCHAR(MAX),
	@SOLICITUDESPENDIENTES					INT,
	@SUBJECT								AS VARCHAR(50),
	@DESTINATARIOS							AS VARCHAR(500)

	SET @DESTINATARIOS = 'gerardo.bautista@cfe.gob.mx;LUIS.RODRIGUEZ22@CFE.GOB.MX; claudia.meza@cfe.gob.mx '
	SET @MENSAJE = ''
	SET @SUBJECT = '[Servidor Sirca]Reporte Mensual de solicitudesE19'


    
SET @SOLICITUDESPORSTATUS =  
    N'<H1>SOLICITUDES POR ESTATUS </H1>' +  
    N'<table border="1">' +  
    N'<tr><th>STATUS</th><th>DESCRIPCION</th>' +  
    N'<th>TOTAL DE SOLICITUDES</th></tr>' +  
    CAST ( ( 
			select 
					td = s.estatus,       '',
					td = e.desc_estatus ,       '',
					td = COUNT(*) 
			from solicitudese19 s
			join estatusE19 e on e.estatus=s.estatus
			group by s.estatus, e.desc_estatus
              FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  




SET @SOLICITUDESPENDIENTESPORREGION =  
    N'<H1>SOLICITUDES PENDIENTES POR REGION </H1>' +  
    N'<table border="1">' +  
    N'<tr><th>CODIGO REGION</th><th>TOTAL DE SOLICITUDES</th></tr>' +   
    CAST ( ( 
				select  
					td = isnull(s.codregion,'Ninguna'),       '',
					td = COUNT(*)
				from solicitudese19 s
				join estatusE19 e on e.estatus=s.estatus
				where s.estatus not in ('A','C')
				and tipoe19 not in ('3')
				group by s.codregion
				order by  s.codregion
         FOR XML PATH('tr'), TYPE   
    ) AS NVARCHAR(MAX) ) +  
    N'</table>' ;  




select @SOLICITUDESPENDIENTES = COUNT(*) 
from solicitudese19 s
join estatusE19 e on e.estatus=s.estatus
where s.estatus not in ('A','C')
and tipoe19 not in ('3')




SET @MENSAJE =  
N' Buen Dia <br /><br /> '+
N' ********************** Reporte Mensual de Solicitudes E19 *********************** <br/> <br/>'+
N' Se informa que el dia de hoy se encontraron '+convert(varchar,@SOLICITUDESPENDIENTES)+ ' Solicitudese19 (traspasos) pendientes a continuación se muestra el detalle:  <br /><br/>'+
N' A continuacion se muestra el reporte General de solicitudes <br /> '+
@SOLICITUDESPORSTATUS+
N'<br /> <br /> '+
N' A continuacion se muestra el reporte  solicitudes pendientes por region <br /> '+
@SOLICITUDESPENDIENTESPORREGION+
N'<br /> <br /> '+
N' Se informa que los filtros utilizados para estas solicitudes son los siguientes:  <br /> '+
N'   - Que el estatus no fuera A ni C   <br /> '+
N'   - Que el tipo e19 no fuera 3   <br /> '+
N'<br /> <br /> '+
N' En un correo posterior se enviar archivo anexo con el detalle de estas solicitudes <br/> '+
N' Que tenga un Buen Dia <br/> '+
N' Mensaje enviado por un Bot automatico. Favor de no contestar a este correo '



 
 	EXEC msdb.dbo.sp_send_dbmail @profile_name='sql1',
	@recipients=@DESTINATARIOS,
	@subject=@SUBJECT,
	@body=@MENSAJE,
	@body_format = 'HTML';
	
	DECLARE @Column1Name VARCHAR(255)
	DECLARE @Query VARCHAR(2048)
	SET @Column1Name = '[sep=,' + CHAR(13) + CHAR(10) + 'Region]'
	SET @Query = 'select  s.codregion  AS ' + @Column1Name + ', s.estatus ,tipoe19, numerocredito,RpuOriginal, rpu_d,cre.tipocredito 
				from sircanac.dbo.solicitudese19 s
				join sircanac.dbo.estatusE19 e on e.estatus=s.estatus
				left join sircanac.dbo.creditos cre on convert(varchar,cre.NumCredito)=convert(varchar,s.numerocredito)
				where s.estatus not in (''A'' , ''C'')
				and tipoe19 not in (''3'')
				order by  s.codregion, s.estatus'
	
	
  EXEC msdb.dbo.sp_send_dbmail 
  @profile_name='sql1',  
   @recipients=@DESTINATARIOS, 
    @query = @Query ,  
    @subject='[Servidor Sirca]Archivo Anexo con detalle de Reporte Mensual de solicitudesE19',  
    @attach_query_result_as_file=1,
	@query_attachment_filename='QueryResults.csv',
	@query_result_separator=',',
	@query_result_no_padding=1,
	@query_result_width=32767  ;  

