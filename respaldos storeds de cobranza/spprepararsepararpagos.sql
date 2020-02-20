USE [SircaNac]
GO

/****** Object:  StoredProcedure [dbo].[spPrepararSepararPagos]    Script Date: 06/27/2019 11:51:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[spPrepararSepararPagos]  
as begin  
declare @FechaLote  datetime,@fl2 datetime  
 SET @FechaLote = NULL-- solo pasan los sin errores y que credito diferente de ceros  
  
 IF @FechaLote IS NULL -- Para priorizar los pagos RAP. By EMIM. 25 Feb 2014 a las 16:00 hrs.  
    SELECT top 1 @FechaLote = Fecha FROM CargaDiariaFecha WITH(nolock) WHERE Listo = 3 AND  Archivo LIKE '%RAP%' AND error =0 AND CREDITO != '0000000000'  
  
 if DATEPART(hour,getdate()) between  7  and  14  
    select top 1 @FechaLote = Fecha FROM CargaDiariaFecha WITH(nolock) WHERE Listo = 3 and  FechaPago > GETDATE() -4 and error =0  and CREDITO != '0000000000'   
   
 IF   @FechaLote IS NULL  
    select top 1 @FechaLote =Fecha FROM CargaDiariaFecha WITH(nolock)  WHERE Listo = 3  and error=0  and CREDITO != '0000000000'   
   
 select fechalote=@fechalote 
 
  while  @FechaLote is not NULL--while  
  BEGIN  
 BEGIN TRANSACTION  
select fechalote=@fechalote   
     insert RegistrosSicomOK(IDCargaDiariaFecha,   
        Archivo,      
        RPU,       
        Numcredito,     
        Producto,     
        FechaFactura,    
        FechaPago,     
        FechaVencimiento,   
        importe,      
        Estatus,      
        AnoFact,      
        MesFact,      
        Error,      
        TipoCred,  
        EsPagoFin,     
        FechaArchivo, fecha)  
  SELECT ID, Archivo, RPU, Credito, Producto, FechaFactura, FechaPago, FechaVencimiento, Importe,      
   Estatus, AnoFact, MesFact, Error, TipoCred, EsPagoFin, FechaArchivo,Fecha  
  FROM CargaDiariaFecha WITH(ROWLOCK)           
  WHERE Listo=3   
    AND CREDITO != '0000000000'   
    AND Error  =  0  
     AND Fecha = @FechaLote    
    -- and  estatus = '01'
 --select rowcout=@@ROWCOUNT  
       
  --    SELECT ID, Archivo, RPU, Credito, Producto, FechaFactura, FechaPago, FechaVencimiento, Importe,      
  -- Estatus, AnoFact, MesFact, Error, TipoCred, EsPagoFin, FechaArchivo,Fecha  
  --FROM CargaDiariaFecha           
  --WHERE Listo=3   
  --  AND CREDITO != '0000000000'   
  --  AND Error  =  0  
  --   AND Fecha = @FechaLote    
       
     delete RegistrosSicomOK where estatus <> '01'  AND Fecha = @FechaLote  
  UPDATE  CargaDiariaFecha WITH(ROWLOCK)  set Listo=4 WHERE Listo=3 and @FechaLote = Fecha and CREDITO != '0000000000' and error =0  
  -- se regresan a 2 para que  se rebusque el numero de credito  
  --UPDATE  CargaDiariaFecha set Listo=2,Cuenta = isnull(Cuenta,0) + 1 WHERE Listo=3 and @FechaLote = Fecha and CREDITO = '0000000000' and error =0 and Cuenta <= 1000  
        -- se pasa a 4 si dio 1000 vueltas   
  UPDATE  CargaDiariaFecha WITH(ROWLOCK)  set Listo=4,Cuenta = isnull(Cuenta,0) + 1, ERROR =110 WHERE Listo=3 and @FechaLote = Fecha and CREDITO = '0000000000' and error =0 --and Cuenta > 10  -- no se encontro el numero de credito  
 COMMIT  
 SET @fl2=@FechaLote  
  SET @FechaLote = NULL-- solo pasan los sin errores y que credito diferente de ceros  
  
 IF @FechaLote IS NULL -- Para priorizar los pagos RAP. By EMIM. 25 Feb 2014 a las 16:00 hrs.  
    SELECT top 1 @FechaLote = Fecha FROM CargaDiariaFecha WITH(noLOCK) WHERE Listo = 3 AND  Archivo LIKE '%RAP%' AND error =0 AND CREDITO != '0000000000'  
  
 if DATEPART(hour,getdate()) between  7  and  14  
    select @FechaLote = Fecha FROM CargaDiariaFecha WITH(noLOCK) WHERE Listo = 3 and  FechaPago > GETDATE() -4 and error =0  and CREDITO != '0000000000'   
   
 IF   @FechaLote IS NULL  
    select @FechaLote = Fecha FROM CargaDiariaFecha WITH(noLOCK)  WHERE Listo = 3  and error=0  and CREDITO != '0000000000'   
     END  
     -- alter table RegistrosSicomOK add  fecha datetime  
--UPDATE  CargaDiariaFecha set Listo=2,Cuenta = isnull(Cuenta,0) + 1 WHERE Listo=3  and CREDITO = '0000000000' and error =0 and Cuenta <= 1000  
end  
-- rollback
GO


