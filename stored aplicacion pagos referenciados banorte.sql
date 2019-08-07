declare 
 @rpu				varchar(12)    
,@numcredito		numeric(10,0)    
,@referencia		varchar(17)    
,@importe			numeric(8,2)    
,@pagare			int    
,@tipoPago			varchar(2)    
,@fechaee			varchar(12)
,@id_edocuenta		int 
,@idcconcepto		int 
,@lineaconcepto		varchar(255)

-- inicializo variables 

SET @rpu = NULL
SET @numcredito = NULL 
SET @referencia = NULL
SET @importe = NULL
SET @pagare = NULL
SET @tipoPago = NULL
SET @fechaee = NULL
SET @id_edocuenta = NULL
SET @idcconcepto = NULL
SET @lineaconcepto = NULL

-- Se obtiene la primera referencia a procesar 

Select top 1
	   @id_edocuenta = c.idedocuenta_mov,
	   @idcconcepto = c.id,
	   @numcredito=LEFT(RIGHT(LTRIM(RTRIM(c.CConcepto)), 17), 9),
	   @referencia= RIGHT(LTRIM(RTRIM(c.CConcepto)), 17),
	   @lineaconcepto = c.CConcepto,
	   @importe = m.importe,
	   @fechaee = m.fechaoperacion
  From dbo.EdoCuenta_CConcepto c
       Join dbo.EdoCuenta_Mov m On m.ID = c.IdEdoCuenta_Mov
 Where  c.CConcepto Like '%PAGO DETALLE%' and c.estatus='Pendiente'


print @rpu
print @numcredito 
print @referencia 
print  convert (int,@importe )
print @pagare
print @tipoPago 
print @fechaee 
print @id_edocuenta 
print @idcconcepto
print @lineaconcepto





















select 
top 1
@rpu=con.rpu, 
@numcredito=LEFT(RIGHT(LTRIM(RTRIM(c.CConcepto)), 17), 9),
@referencia= RIGHT(LTRIM(RTRIM(c.CConcepto)), 17),
@importe= e.Importe,
@pagare = det.pagare,
@tipoPago = case when det.pagare > 0 then 'P' else 'A' END,
@fechaee = convert(varchar,e.FechaOperacion, 112)
from EdoCuenta_Mov e
join EdoCuenta_CConcepto c on c.IdEdoCuenta_Mov=e.ID
join convenios con on con.credito= LEFT(RIGHT(LTRIM(RTRIM(c.CConcepto)), 17), 9) and (con.referencia=RIGHT(LTRIM(RTRIM(c.CConcepto)), 17) or con.referparcialidad = RIGHT(LTRIM(RTRIM(c.CConcepto)), 17))
join det_convenio det on det.credito = con.credito and det.rpu = con.rpu 
where RIGHT(LTRIM(RTRIM(c.CConcepto)), 17)='91914261328800152' and det.estatus not in ('14')
order by fecha asc
   And c.CConcepto Like '%PAGO DETALLE%'


-- se verifica si es liquidacion anticipada


-- se verifica si es convenio

-- se verifica si es refrencia manual creada por CMU




-- si no se puede se  colocara se marca con error 


-- se escribe un log  

-- se marcan como procesadas las referencias afectadas
