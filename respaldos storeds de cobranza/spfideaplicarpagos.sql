USE [SircaNac]
GO

/****** Object:  StoredProcedure [dbo].[spFideAplicarPago]    Script Date: 07/01/2019 13:38:50 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

/*        
select * into pagos20100816 from pagos        
go        spFideAplicarPago 
        
select * into det_amortizacion20100816 from det_amortizacion        
go        
*/        
CREATE  PROCEDURE [dbo].[spFideAplicarPago](@numcredito numeric(10,0),@FechaPago datetime,@fechafac datetime, @fechavenci datetime, @Importe money,@anofact int ,@mesfact int, @tipopago int=NULL )        
AS BEGIN        
  DECLARE         
    @Pagare int,        
    @Saldo  Numeric(10,2),    
    @NumPago int,  
    @ORIGEN  VARCHAR(20)   
      
   select  @ORIGEN='SPFide_'+    convert(varchar(20),getdate(),112)     
           
  SET @Pagare  = NULL        
  set @NumPago = NULL    
    
  SELECT @Pagare =min(pagare) FROM det_amortizacion with(nolock) WHERE saldo >0 and solicitudscc = @NumCredito        
  SELECT @NumPago = ISNULL((SELECT MAX(NumPAgo)+1  from  Pagos with(rowlock) where NumCredito=@NumCredito ),0)   
  delete top(1) Pagos where estatus=0 and  NumCredito=@NumCredito and NumPago <=@Pagare and fechapago is null  
    
  WHILE @Importe > 0 AND @Pagare is not null        
  BEGIN        
    SELECT @Saldo = Saldo  from det_amortizacion with(nolock)where saldo >0 and solicitudscc=@NumCredito and @Pagare=Pagare        
    IF @Saldo > @Importe        
    BEGIN      
      BEGIN TRANSACTION     
      UPDATE det_amortizacion with(rowlock) set   Estatus='19', Saldo = Saldo - @Importe where saldo >0 and solicitudscc=@NumCredito and @Pagare=Pagare        
              
      INSERT Pagos with(rowlock)(NumCredito, RPU, NumPago, FEchaFac, FEchaVenci,Importe,estatus, FechaPago, mesfact, aniofact,extemporaneo,Origen,MesFactOrigen,AnoFactOrigen,tipopago)        
      SELECT solicitudscc,         
             RPU,        
             NumPago  =  @NumPago,        
             FechaFact = convert(datetime,convert(varchar,Year(@fechafac))+ right('0'+convert(varchar,month(@fechafac)),2) +right('0'+convert(varchar,day(@fechafac)),2)),        
             @fechavenci,        
             @importe,        
             1,        
             @fechaPAgo,        
             month(fecha),        
             Year(fecha),        
             0,  
             @origen,  
              --modificado por LARG 08032016 para agregar el cero al mes fac
              --@mesfact
              RIGHT('00' + Ltrim(Rtrim(@mesfact)),2)
             ,@anofact
             ,@tipopago
               
        FROM det_amortizacion with(rowlock)        
       WHERE solicitudscc=@NumCredito and @Pagare=Pagare        
       COMMIT
          
      SET @Importe = 0        
    END ELSE        
    IF @Saldo <= @Importe        
    BEGIN    
    BEGIN TRANSACTION     
      UPDATE det_amortizacion with(rowlock) set  Estatus='14', Saldo =0 where saldo >0 and solicitudscc=@NumCredito and @Pagare=Pagare        
      INSERT Pagos with(rowlock)(NumCredito, RPU, NumPago, FEchaFac, FEchaVenci,Importe,estatus, FechaPAgo, mesfact, aniofact,extemporaneo,origen,MesFactOrigen,AnoFactOrigen,tipopago)        
       SELECT solicitudscc,         
              RPU,        
              NumPago  =  @numpago,        
              FechaFact = convert(datetime,convert(varchar,Year(@fechafac))+ right('0'+convert(varchar,month(@fechafac)),2) +right('0'+convert(varchar,day(@fechafac)),2)),          
              @fechavenci,        
              @Saldo,        
              1,        
              @fechaPAgo,        
              month(fecha),        
              Year(fecha),        
              0,  
              @origen, 
              --modificado por LARG 08032016 para agregar el cero al mes fac
              --@mesfact
              RIGHT('00' + Ltrim(Rtrim(@mesfact)),2)
              ,@anofact
              ,@tipopago
                   
         FROM det_amortizacion with(nolock)        
        WHERE solicitudscc=@NumCredito and @Pagare=Pagare        
       COMMIT
       set @importe=@importe -@saldo  
    END        
    SET @Pagare = NULL        
    SELECT @Pagare =min(pagare) FROM det_amortizacion with(nolock) WHERE saldo >0 and solicitudscc = @NumCredito        
        select @numpago = @numpago + 1        
  END   -- while    
    
    --EXEC FIDEArreglaPagos @numcredito
    
  /*
  IF @IMPORTE <>0       
    SELECT 'SOBRO'+CONVERT(VARCHAR,@IMPORTE) +' NUMCREDITO '+ CONVERT(VARCHAR,@NUMCREDITO)      
    */
END        
  
--ALTER TABLE det_amortizacion ADD Origen VARCHAR(20)        
GO


