-- =============================================    
-- Author:  <Author,,Name>    
-- Create date: <Create Date,,>    
-- Description: <Description,,>    
-- =============================================    
--http://www.asiahorre.com/sircanac/verificaacceso.php?nick=HERPAA&idRegional=NO     
-- exec [nsp_InsertatmpAgendaGestion] HERPAA,'NO','GY','201402',''    
    
-- select * from historicocartera_Netro where codregion='NO'    
CREATE PROCEDURE [dbo].[nsp_InsertatmpAgendaGestion](    
@usuario varchar(20),    
@region varchar(2),    
@coord varchar(2),    
@cartera varchar(6),    
@rpu varchar(12),  
@origen varchar(2) --mld    
)    
AS    
 SET NOCOUNT ON;  
--select * from historicocartera_Netro A    
--  inner join clientes b on a.rpu = b.RPU and a.codRegion = b.codRegion and a.codCoord = b.codCoord and     
--  inner join estatuscliente c on b.Estatus = c.IdEstatus and b.provenergia = c.ProvEnergia and     
--  inner join estatusgestoria d on b.EstatusGestion = d.idgestoria    
--  --inner join creditos f on a.rpu = f.RPU    
--  left join gestioninterna g on a.rpu = g.rpu    
--  AND    
-- A.RPU='525070104577' AND A.CARTERA='201402' AND  A.USUARIO ='HERPAA'    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
--Valida que el usuario se encuentre en la tabla. Si está entonces borra todos los registros de la tabla que tengan relación con el     
if exists(select 1 from tmpAgendaGestion where usuario = @usuario)    
begin    
  delete from tmpAgendaGestion where usuario = @usuario    
    
--En caso de que el RPU insertado este vacío, entonces se hace una inserción de todos los RPU en la tabla    
  if Len(isnull(@rpu,''))=0    
  begin    
  insert into tmpAgendaGestion(    
  usuario,    
  RPU,    
  NumCredito,  
  Nombre,    
  NumCuenta,    
  --ProdCred,    
  Direccion,    
  Colonia,    
  CP,    
  Descripcion,    
  DescGestoria,    
  Telefono,    
  Telcel,    
  TelTrab,    
  TelRef,    
  VtoDias,    
  VtoAdeudo,    
  FechaPromesa,    
  Estatus,    
  Amort,    
  Llamadas,  
  origen    
  )    
  select @usuario,a.rpu,cr.numCredito,b.Nombre,b.NumCuenta,    
  --ProdCred=f.TipoCredito+CONVERT(varchar(10),f.NumCredito),    
  b.Direccion,b.Colonia,b.CP,c.Descripcion,d.descgestoria,b.Telefono,b.TelCel,b.TelTrab,b.TelRef,MAX(a.vtodias),    
  SUM(a.vtoadeudo),B.fechapromesa as fechapromesa,B.EstatusGestion,MIN(a.vtonumamortizacion),(select COUNT(g.rpu) from gestioninterna g where a.rpu = g.rpu),    
  cr.origen  ---mld  
  from historicocartera_Netro a WITH (NOLOCK)   
  inner join clientes b WITH (NOLOCK) on a.rpu = b.RPU and a.codRegion = b.codRegion and a.codCoord = b.codCoord    
  inner join estatuscliente c WITH (NOLOCK) on b.Estatus = c.IdEstatus and b.provenergia = c.ProvEnergia    
  inner join estatusgestoria d WITH (NOLOCK) on b.EstatusGestion = d.idgestoria   
  inner join creditos cr WITH (NOLOCK) on cr.RPU = a.rpu and a.credito = cr.NumCredito    
  --inner join creditos f on a.rpu = f.RPU    
  --left join gestioninterna g on a.rpu = g.rpu    
  where a.codRegion=@region and --a.codCoord in (@coord)   
  a.codCoord = case when @coord = '0' then (a.codCoord) else (@coord) end  
  and a.cartera =@cartera  and a.vtodias >30  
  and cr.origen = (CASE WHEN @origen = 0 THEN cr.origen ELSE (@origen) END)    
  group by     
  --a.vtodias,    
  a.rpu,b.Nombre,    
  b.NumCuenta,    
  --f.TipoCredito,f.NumCredito,    
  b.Direccion,b.Colonia,b.CP,c.Descripcion,d.descgestoria,b.Telefono,b.TelCel,b.TelTrab,b.TelRef,    
  --a.vtoadeudo,    
  B.EstatusGestion, B.FechaPromesa,cr.origen,cr.numCredito    
   end    
--En caso contrario de que el RPU insertado sea diferente de cero, entonces se hace la inserción sobre el RPU insertado    
   else    
   begin    
  insert into tmpAgendaGestion(    
  usuario,    
  RPU,    
  NumCredito,  
  Nombre,    
  NumCuenta,    
  --ProdCred,    
  Direccion,    
  Colonia,    
  CP,    
  Descripcion,    
  DescGestoria,    
  Telefono,    
  Telcel,    
  TelTrab,    
  TelRef,    
  VtoDias,    
  VtoAdeudo,    
  FechaPromesa,    
  Estatus,    
  Amort,    
  Llamadas,  
  origen      
  )    
  select @usuario,a.rpu,cr.numCredito,b.Nombre,b.NumCuenta,    
  --ProdCred=f.TipoCredito+CONVERT(varchar(10),f.NumCredito),    
  b.Direccion,b.Colonia,b.CP,c.Descripcion,d.descgestoria,b.Telefono,b.TelCel,b.TelTrab,    
  b.TelRef,MAX(a.vtodias),SUM(a.vtoadeudo),B.fechapromesa as fechapromesa,B.EstatusGestion,MIN(a.vtonumamortizacion),(select COUNT(g.rpu) from gestioninterna g where a.rpu = g.rpu),  
  cr.origen    
  from historicocartera_Netro a  WITH (NOLOCK)  
  inner join clientes b WITH (NOLOCK) on a.rpu = b.RPU and a.codRegion = b.codRegion and a.codCoord = b.codCoord    
  inner join estatuscliente c WITH (NOLOCK) on b.Estatus = c.IdEstatus and b.provenergia = c.ProvEnergia    
  inner join estatusgestoria d WITH (NOLOCK) on b.EstatusGestion = d.idgestoria    --inner join creditos f on a.rpu = f.RPU   
  inner join creditos cr WITH (NOLOCK) on cr.RPU = a.rpu and a.credito = cr.NumCredito    
  --left join gestioninterna g on a.rpu = g.rpu    
  where a.codRegion=@region and --a.codCoord in (@coord)   
  a.codCoord = case when @coord = '0' then (a.codCoord) else (@coord) end  
  and a.cartera =@cartera and a.rpu = @rpu   
  and cr.origen = (CASE WHEN @origen = 0 THEN cr.origen ELSE (@origen) END)    
  group by     
  --a.vtodias,    
  a.rpu,b.Nombre,b.NumCuenta,    
  --f.TipoCredito,f.NumCredito,    
  b.Direccion,b.Colonia,b.CP,c.Descripcion,d.descgestoria,b.Telefono,b.TelCel,b.TelTrab,b.TelRef,    
  --a.vtoadeudo,    
  B.EstatusGestion, B.FechaPromesa,cr.origen,cr.numCredito     
 end    
end    
    
--En caso contrario a que el usuario tenga algún registro en la tabla, entonces se insertan datos nuevos     
else    
BEGIN    
    
--En caso de que el RPU insertado este vacío, entonces se hace una inserción de todos los RPU en la tabla    
if Len(isnull(@rpu,''))=0    
begin    
insert into tmpAgendaGestion(    
usuario,    
RPU,    
NumCredito,  
Nombre,    
NumCuenta,    
--ProdCred,    
Direccion,    
Colonia,    
CP,    
Descripcion,    
DescGestoria,    
Telefono,    
Telcel,    
TelTrab,    
TelRef,    
VtoDias,    
VtoAdeudo,    
FechaPromesa,    
Estatus,    
Amort,    
Llamadas,  
origen     
)    
select @usuario,a.rpu,cr.numCredito,b.Nombre,b.NumCuenta,    
--ProdCred=f.TipoCredito+CONVERT(varchar(10),f.NumCredito),    
b.Direccion,b.Colonia,b.CP,c.Descripcion,d.descgestoria,b.Telefono,b.TelCel,b.TelTrab,b.TelRef,    
MAX(a.vtodias),    
SUM(a.vtoadeudo),    
b.fechapromesa as fechapromesa,B.EstatusGestion,MIN(a.vtonumamortizacion), (select COUNT(g.rpu) from gestioninterna g where a.rpu = g.rpu),  
cr.origen    
from historicocartera_Netro a  WITH (NOLOCK)  
inner join clientes b WITH (NOLOCK) on a.rpu = b.RPU and a.codRegion = b.codRegion and a.codCoord = b.codCoord    
inner join estatuscliente c WITH (NOLOCK) on b.Estatus = c.IdEstatus and b.provenergia = c.ProvEnergia    
inner join estatusgestoria d WITH (NOLOCK) on b.EstatusGestion = d.idgestoria    
inner join creditos cr WITH (NOLOCK) on cr.RPU = a.rpu and a.credito = cr.NumCredito   
--inner join creditos f on a.rpu = f.RPU    
--left join gestioninterna g on a.rpu = g.rpu    
where a.codRegion=@region and --a.codCoord in (@coord)   
a.codCoord = case when @coord = '0' then (a.codCoord) else (@coord) end  
and a.cartera = @cartera  and a.vtodias >30   
and cr.origen = (CASE WHEN @origen = 0 THEN cr.origen ELSE (@origen) END)   
group by a.rpu,b.Nombre,b.NumCuenta,    
--f.TipoCredito,f.NumCredito,    
b.Direccion,b.Colonia,b.CP,c.Descripcion,d.descgestoria,    
b.Telefono,b.TelCel,b.TelTrab,b.TelRef,    
--a.vtodias,a.vtoadeudo,    
B.EstatusGestion, b.FechaPromesa,cr.origen,cr.numCredito     
END    
    
--En caso contrario de que el RPU insertado sea diferente de cero, entonces se hace la inserción sobre el RPU insertado    
else    
begin    
insert into tmpAgendaGestion(    
usuario,    
RPU,    
NumCredito,  
Nombre,    
NumCuenta,    
--ProdCred,    
Direccion,    
Colonia,    
CP,    
Descripcion,    
DescGestoria,    
Telefono,    
Telcel,    
TelTrab,    
TelRef,    
VtoDias,    
VtoAdeudo,    
FechaPromesa,    
Estatus,    
Amort,    
Llamadas,  
origen      
)    
select @usuario,a.rpu,cr.numCredito,b.Nombre,b.NumCuenta,    
--ProdCred=f.TipoCredito+CONVERT(varchar(10),f.NumCredito),    
b.Direccion,b.Colonia,b.CP,c.Descripcion,d.descgestoria,b.Telefono,b.TelCel,b.TelTrab,b.TelRef,    
MAX(a.vtodias),SUM(a.vtoadeudo),    
b.fechapromesa as fechapromesa,B.EstatusGestion,MIN(a.vtonumamortizacion), (select COUNT(g.rpu) from gestioninterna g where a.rpu = g.rpu),  
cr.origen  
from historicocartera_Netro a  WITH (NOLOCK)  
inner join clientes b WITH (NOLOCK) on a.rpu = b.RPU and a.codRegion = b.codRegion and a.codCoord = b.codCoord    
inner join estatuscliente c WITH (NOLOCK) on b.Estatus = c.IdEstatus and b.provenergia = c.ProvEnergia    
inner join estatusgestoria d WITH (NOLOCK) on b.EstatusGestion = d.idgestoria    
inner join creditos cr WITH (NOLOCK) on cr.RPU = a.rpu and a.credito = cr.NumCredito   
--inner join creditos f on a.rpu = f.RPU    
--left join gestioninterna g on a.rpu = g.rpu    
where a.codRegion=@region and --a.codCoord in (@coord)   
a.codCoord = case when @coord = '0' then (a.codCoord) else (@coord) end  
and a.cartera = @cartera and a.rpu = @rpu   
and cr.origen = (CASE WHEN @origen = 0 THEN cr.origen ELSE (@origen) END)    
group by a.rpu,b.Nombre,b.NumCuenta,    
--f.TipoCredito,f.NumCredito,    
b.Direccion,b.Colonia,b.CP,c.Descripcion,d.descgestoria,b.Telefono,b.TelCel,b.TelTrab,  
b.TelRef,B.EstatusGestion, b.FechaPromesa,cr.origen,cr.numCredito     
end    
    
end    
  --delete tmpAgendaGestion -- en este se borran los que ya tienen fecha promesa posterior al dia de hoy    
  -- where rpu in ( select rpu gestioninterna where fechapromesa >GETDATE())    
  --   and usuario = @usuario    
         
         
  SELECT d.rpu  INTO #BORRAR          
    FROM tmpAgendaGestion t  WITH (NOLOCK)  
    JOIN det_amortizacion  d WITH (NOLOCK) on d.rpu=t.rpu    
   WHERE d.estatus not in (14,18) AND T.usuario=@USUARIO     
   GROUP BY d.rpu    
  HAVING max(datediff(day, d.fecha,getdate()) ) < 31    
     
 CREATE INDEX IDX_RPU ON #BORRAR(RPU)    
     
 DELETE tmpAgendaGestion WHERE RPU IN( SELECT RPU FROM #BORRAR )        
     
/*delete  tmpAgendaGestion WHERE RPU IN( SELECT RPU FROM     
 pagos where estatus='01' and fechapago >= convert(datetime,left(convert(varchar,DATEADD(month,-1,getdate()),112),6)+'01')) and usuario=@usuario    
 */    
 --create index idx_usuariorpu on tmpAgendaGestion(usuario,rpu)    
begin    
select COUNT(rpu) as total from tmpAgendaGestion  WITH (NOLOCK)  
where usuario = @usuario    
end    
  