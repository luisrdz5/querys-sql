Declare @x Int = 1
WHILE 1 = @x
BEGIN

WAITFOR DELAY '00:00:10 '; --Tiempo de Espera HH-MM
--WAITFOR TIME '10:58'; --Hora de Ejecución

Declare @NumCredito varchar(100) = ''
    Set @NumCredito = IsNull((Select Top 1 cp.NumCredito From dbo.CobranzaPendiente cp Where cp.procesado Is Null),'')
-->>Valida si existe algúno de los JOBs de Cobranza se esté ejecutando
IF Not Exists(Select 1 
				From msdb.dbo.sysjobs j 
					 Inner Join msdb.dbo.sysjobactivity a On a.job_id = j.job_id 
			   Where J.name In ('Paso 3.0 leer extractores (cobranza por sql )' ,'Paso 2.1 leer extractores (spAsignaCreditoCargaDiaria)')
				 And A.run_requested_date Is Not Null
				 And A.stop_execution_date Is Null
				 And Convert(varchar(6),A.start_execution_date,112) >= '201701')
BEGIN
	-->>Valida si existe algún crédito por procesar por algún SP de Cobranza
	IF Not Exists (Select 1 From CargaDiariaFecha cdf Where cdf.Listo = 2 And cdf.Error = 0)
	   And Not Exists (Select 1 From RegistrosSicomOK rs Where rs.Procesado = 0 And Error = 0)
	   And @NumCredito <> ''
	BEGIN
		print 'Ejecutando '+@NumCredito
		Exec dbo.SPAPLICARARQUEO @NumCredito;
		Update dbo.CobranzaPendiente
		   Set procesado = 1
		 Where NumCredito = @NumCredito
		   And procesado Is Null
	
	END
	
	IF @NumCredito = ''
    BEGIN
		SET @x = 0
		BREAK;
    END
END

END