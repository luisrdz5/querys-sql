	select *
	from RegistrosSicomOK
	where Numcredito='919132101'
	order by FechaPago desc
	
	
	
	
	select *
	from RegistrosSicomOK
	where id in (
	'59432875',
	'59433075'
	)
	/*
	update RegistrosSicomOK
	set Error=0, Procesado=1
	where id in (
	'59432875',
	'59433075'
	)
	*/
	
	select *
	from pagos 
	where IDRegistroSicom in (
	'59432875',
	'59433075'
	)
	
	
	

BEGIN TRANSACTION 	
	EXEC spAplicaPagoRegistrosSicomOK '59432331','708190800493','919156731','20191105','20191201', 0
COMMIT
BEGIN TRANSACTION 
	EXEC spAplicaPagoRegistrosSicomOK '59433075','596070803232','904536258','20190910','20191220', 0
COMMIT

