declare 
@numcredito		as varchar(9),
@rpu			as varchar(12),
@dias			as int,
@adeudo			as money

SET @numcredito=NULL
  set transaction isolation level read uncommitted
  select top 1 @numcredito=NumCredito
  from gestioninterna
  where tipogestion='6' and importevencido=0 and diasvencido=0
  

while @numcredito is not null 
begin  
	select @dias=datediff(dd,MIN(fecha),getdate())  
	from det_amortizacion  
	where estatus not in ('14','18') and solicitudscc=@numcredito


	select @adeudo=SUM(pagodec)  
	from det_amortizacion  
	where estatus not in ('14','18') and solicitudscc=@numcredito
	
	if @dias=0 
	begin 
		set @dias=1
	end 
	print 'procesando '
	print @numcredito
	update gestioninterna
	set importevencido=@adeudo , diasvencido=@dias
	where NumCredito=@numcredito and tipogestion='6'
	

	SET @numcredito=NULL	
	set @dias=0
	set @adeudo=0
	select top 1 @numcredito=NumCredito
	from gestioninterna
	where tipogestion='6' and importevencido=0 and diasvencido=0

END
	