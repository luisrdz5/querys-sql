CREATE procedure [dbo].[sp_CapturaPagoConvenio]      
 @rpu varchar(12)      
,@numcredito numeric(10,0)      
,@referencia varchar(17)      
,@importe numeric(8,2)      
,@pagare int      
,@tipoPago varchar(2)      
,@fechaee datetime      
      
AS      
Begin       
 SET NOCOUNT ON;        
       
 declare @fechaultimopagoC date      
 ,@resto numeric(8,2)      
 ,@tipoconvenio int      
 ,@saldoconv numeric(8,2)      
 ,@mesfact int      
 ,@aniofact int      
 ,@fecha date      
 ,@saldo numeric(8,2)      
 ,@interes numeric(8,2)      
 ,@ivainteres numeric(8,2)      
 ,@estatus int      
 ,@amortVencidas varchar(500)   
 ,@tipo_convenio int /*MLD*/     
       
BEGIN TRANSACTION -- O solo BEGIN TRAN    
 BEGIN TRY       
 if @tipoPago = 'A'      
  select @fechaultimopagoC=fechaultimopago,@resto=anticipo,@tipoconvenio=tipoconvenio,@amortVencidas=amortVencidas       
  from convenios c inner join det_convenio d on c.rpu=d.rpu and c.credito=d.credito       
  where c.rpu = @rpu and c.credito= @numcredito and c.estatus in (0,1,2) and d.pagare=@pagare and d.fechapago is null       
  and referencia = @referencia and d.importe=@importe      
 else      
  select @fechaultimopagoC=fechaultimopago,@resto=amorconvenida,@tipoconvenio=tipoconvenio,@amortVencidas=amortVencidas       
  from convenios c inner join det_convenio d on c.rpu=d.rpu and c.credito=d.credito       
  where c.rpu = @rpu and c.credito= @numcredito and c.estatus in (0,1,2) and d.pagare=@pagare and d.fechapago is null       
  and referparcialidad = @referencia and d.importe=@importe      
       
 if @fechaultimopagoC is null select 0 estatus,'Verifique la referencia y/o Importe del pago' mensaje      
 else      
  begin      
  update det_convenio set estatus=14, fechapago=@fechaee,importepago=importe       
  where rpu =@rpu and credito=@numcredito and estatus<>18 and pagare=@pagare      
       
 if @tipoPago = 'P'      
  set @rpu = isnull((select rpu_d from solicitudese19 where numerocredito=@numcredito and rpuoriginal=@rpu and estatus='A'),@rpu)      
       
 if @tipoconvenio = 2 or @tipoconvenio = 4      
  begin      
  while @resto > 0      
   begin      
   select top 1 @mesfact=month(fecha),@aniofact=year(fecha),@fecha=fecha,@saldo=saldo,@estatus=estatus,      
   @interes=interes,@ivainteres=ivainteres      
   from det_amortizacion where rpu =@rpu and solicitudscc=@numcredito and saldo>0 and estatus in(15,17,19) order by pagare      
       
   if @fecha < @fechaultimopagoC set @saldoconv = @saldo      
   else       
    begin      
    set @saldoconv = @saldo - @interes - @ivainteres      
    end      
          
   if @saldoconv>@resto       
    begin      
    set @importe = @resto      
    set @resto = 0      
    set @saldo = @saldo - @importe      
    end      
   else      
    begin      
    set @importe=@saldoconv      
    set @resto = @resto - @importe      
    set @saldo = 0      
    set @estatus=14        
    end      
              
   if @resto<=5       
    begin      
    set @importe=@importe+@resto      
    set @resto=0          
    end      
          
   if @saldo = 0 and @fecha > @fechaultimopagoC      
    update det_amortizacion set saldo=@saldo,estatus=@estatus,pagodec=capital,      
    interesHistorico=interes,IvaInteresHistorico=ivainteres,interes = 0,ivainteres = 0      
    where rpu=@rpu and solicitudscc=@numcredito and fecha=@fecha and estatus in(15,17,19)      
   else      
    update det_amortizacion set saldo=@saldo,estatus=@estatus       
    where rpu=@rpu and solicitudscc=@numcredito and fecha=@fecha and estatus in(15,17,19)          
              
   insert into pagos (NumCredito,Rpu,FechaFac,FechaVenci,Importe,Estatus,FechaPago,aniofact,mesfact,extemporaneo,NumPago)       
   values (@numcredito,@rpu,@fechaee,@fechaee,@importe,1,@fechaee,@aniofact,@mesfact,0,(select max(NumPago) + 1 from pagos where rpu =@rpu and NumCredito=@numcredito))      
      
   if not exists(select * from det_amortizacion where rpu =@rpu and solicitudscc=@numcredito and saldo>0 and estatus in(15,17,19))  
   set @resto = 0  
   end      
  end      
 else      
  begin      
  DECLARE @lstDato varchar(20)      
  DECLARE @lnuPosComa int       
  WHILE  LEN(@amortVencidas)> 0      
   BEGIN      
   SET @lnuPosComa = CHARINDEX(',',@amortVencidas)      
   IF ( @lnuPosComa=0 )      
    BEGIN      
    SET @lstDato = @amortVencidas      
    SET @amortVencidas = ''      
    END      
   ELSE      
    BEGIN      
    SET @lstDato = Left( @amortVencidas,@lnuPosComa - 1)      
    SET @amortVencidas = right( @amortVencidas , LEN(@amortVencidas) -(@lnuPosComa) )      
    END      
             
   set @mesfact = RIGHT(@lstDato,LEN(@lstDato) - 4)      
   set @aniofact = LEFT(@lstDato,4)      
             
   select top 1 @fecha=fecha,@saldo=saldo,@estatus=estatus,      
   @interes=interes,@ivainteres=ivainteres from det_amortizacion       
   where rpu=@rpu and solicitudscc=@numcredito and month(fecha)=@mesfact and year(fecha)=@aniofact      
   and estatus in (15,17,19) and saldo>0      
          
   set @saldoconv = @saldo      
          
   if @fecha is not null      
    begin      
    if @saldoconv>@resto       
     begin      
     set @importe = @resto      
     set @resto = 0      
     set @saldo = @saldo - @importe      
     end      
    else      
     begin      
     set @importe=@saldoconv      
     set @resto = @resto - @importe      
     set @saldo = 0      
     set @estatus=14        
     end      
               
    if @resto<=5       
     begin      
     set @importe=@importe+@resto      
     set @resto=0          
     end      
           
    update det_amortizacion set saldo=@saldo,estatus=@estatus       
    where rpu=@rpu and solicitudscc=@numcredito and fecha=@fecha and estatus in(15,17,19)          
           
    --select @numcredito,@rpu,@fechaee,@fechaee,@importe,1,@fechaee,@aniofact,@mesfact,0,(select max(NumPago) + 1 from pagos where rpu =@rpu and NumCredito=@numcredito)      
           
    insert into pagos (NumCredito,Rpu,FechaFac,FechaVenci,Importe,Estatus,FechaPago,aniofact,mesfact,extemporaneo,NumPago)       
    values (@numcredito,@rpu,@fechaee,@fechaee,@importe,1,@fechaee,@aniofact,@mesfact,0,(select max(NumPago) + 1 from pagos where rpu =@rpu and NumCredito=@numcredito))      
    end      
   END      
  end      
        
  if @pagare = 0      
   begin      
   update convenios set estatus=1 where rpu =@rpu and credito=@numcredito and estatus=0      
   update creditos set numConvenio = isnull(numConvenio,0) + 1 where rpu =@rpu and NumCredito = @numcredito      
   end      
        
  if @pagare = (select max(pagare) from det_convenio where rpu=@rpu and credito=@numcredito and estatus<>18)      
   begin      
   update convenios set estatus=3 where rpu=@rpu and credito=@numcredito and estatus=2          
   update creditos set convenio=0 where NumCredito=@numcredito    /*MLD*/  
         
   insert into convenioshistorico (tipoconvenio,fechasol,rpu,credito,estatus,adeudo,usuariosol,referencia,fechavigencia,capital,      
   interes,ivadeinteres,moratorio,ivamoratorio,cargos,capitalxd,ivaxd,interesxd,saldoinsolutola,anticipo,fechaultimopago,      
   amorconvenida,numpagos, lugar,folio,referparcialidad,cargovigente,amortVencidas,totalmoratorio)      
   select tipoconvenio,fechasol,rpu,credito,estatus,adeudo,usuariosol,referencia,fechavigencia,capital,interes,ivadeinteres,      
   moratorio,ivamoratorio,cargos,capitalxd,ivaxd,interesxd,saldoinsolutola,anticipo,fechaultimopago,amorconvenida,numpagos,      
   lugar,folio,referparcialidad,cargovigente,amortVencidas,totalmoratorio from convenios where rpu=@rpu and credito = @numcredito      
       
   insert into det_conveniohistorico(folio,rpu,credito,pagare,fecha,importe,estatus,importepago,fechapago,enviolyf,IdCargaDiariaFechaRAP)      
   select folio,rpu,credito,pagare,fecha,importe,estatus,importepago,fechapago,enviolyf,IdCargaDiariaFechaRAP       
   from det_convenio where rpu=@rpu and credito = @numcredito      
         
   if not exists(select * from convenios where rpu=@rpu and estatus<3)    
   update clientes set bconvenio=0 where rpu=@rpu      
     
   select @tipo_convenio = (select tipoconvenio from convenios where rpu=@rpu and credito=@numcredito) /*MLD*/  
   if @tipo_convenio <> 1  
    begin   
    delete from convenios where rpu=@rpu and credito = @numcredito    
    delete from det_convenio where rpu=@rpu and credito = @numcredito      
    end     
    /*MLD*/  
   end      
        
  exec FIDEArreglaPagos @numcredito,'sircaCodigo'      
  select 1 estatus,'El pago se grabó correctamente' mensaje      
 end      
  
--COMMIT TRANSACTION    
END TRY  
BEGIN CATCH   
 IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION;  
 select 0 estatus,'No se pudo concluir, vuelva a intentarlo' mensaje      
END CATCH    
  
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION  
end