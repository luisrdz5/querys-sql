USE [SircaNac]
GO

/****** Object:  StoredProcedure [dbo].[spAplicacionRegistrosSicomOK]    Script Date: 06/27/2019 11:53:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

/*
 update RegistrosSicomOK set Error=0 , procesado=0 where IDCargaDiariaFecha ='55603181'
 update cargadiariafecha set Error=0,listo=3  where ID ='55603181'
 select * from RegistrosSicomOK where IDCargaDiariaFecha ='55603181'
 select * from pagos where IDRegistroSicom=7588951
 delete  pagos where IDRegistroSicom=7588951
 select * from det_amortizacion where rpu='184920309384'
 select * from pagos  where rpu='184920309384'
 
 exes s
 */
------------------------------------------------------------------------------------------------------
-- exec spAplicacionRegistrosSicomOK
-- rollback
--exec FIDEArreglaPagos '900782201'
CREATE procedure [dbo].[spAplicacionRegistrosSicomOK]
as begin 
SET ANSI_NULLS off
set ansi_warnings off
SET QUOTED_IDENTIFIER OFF
set nocount on
  Declare 
    @id int,
    @FechaProceso datetime,
    @TipoCred     varchar(10),
    @Estatus	  varchar(20),
    @FechaPago    datetime,
    @FechaFactura datetime,
    @fecha        datetime, 
    @Error        int,
    @RPU	      varchar(20),
    @NUMCREDITO   varchar(20),
    @Importe      money,
    @ID2          INT
    
    SELECT @ID2=0,@Error=0
    DECLARE @TransactionName varchar(20) = 'Transaction1'
    
    select @TransactionName='Transaction1'
  SET TRANSACTION ISOLATION LEVEL SERIALIZABLE -- para bloquear las tablas y no se mueva nada hasta que termine
      
  SELECT @FechaProceso=MAX(FechaProceso) 
    FROM RegistrosSicomOK 
   WHERE Procesado = 1 -- ultima ves que se proceso algo para salir si no han pasado 3 minutos
  IF ABS(DATEDIFF(SECOND, @FechaProceso, GETDATE()) ) < 30  --si no han pasado 30 segundos se sale
  BEGIN 
    SELECT TOP 1 'Esta procesando algo mas... espera a que termine:'+Archivo +' '+convert(varchar, Fechaproceso,121) + 'AHORA:'+ convert(varchar, GETDATE(),121)
      FROM RegistrosSicomOK 
     WHERE Procesado=1 
       AND Fechaproceso=@FechaProceso
    RETURN 
  END
  
  
  update RegistrosSicomOK set Procesado=1 where error!= 0  and procesado != 1-- para sacar de una ves los errores
  SELECT @ID=0,@ID2=0
  SELECT TOP 1 @ID=ID FROM RegistrosSicomOK WHERE Procesado=0  AND ERROR=0 AND ID > @ID2  and fechapago >getdate()-15 ORDER BY id --lee el que sigue 0
  if @id=0 or @id is null
  SELECT TOP 1 @ID=ID FROM RegistrosSicomOK WHERE Procesado=0  AND ERROR=0 AND ID > @ID2   ORDER BY id  --lee el que sigue 1
  while  @id is not NULL --while-
  BEGIN 
    select @Error=0,@fecha=NULL
	 SELECT @fecha        = fecha
        FROM RegistrosSicomOK where ID = @ID      
      exec spMasdeUnCreditos @fecha,null,@id  -- se cambia el credito si es necesario

	BEGIN TRANSACTION
    
    -- se checan duplicados de nuevo
    if exists(select r.rpu 
                from RegistrosSicomOK r 
                join  pagos p on p.Rpu                 = r.RPU    --- por RPU
                 and r.AnoFact  = isnull(p.AnoFactOrigen,YEAR(p.FechaFac))
                 and r.MesFact =  isnull(p.MesFactOrigen, MONTH(p.FechaFac) )
				 --and abs(r.importe -p.Importe) < 2 lo quite por que el pago puede separarse en 2 o mas
               where r.ID = @id  
                 and r.Estatus in( 0,1) -- es una factura o un pago ya existe como como pago
                 and  p.Estatus=1 )
      begin            
     
        select @Error=8
        exec spCambiaProcesadoRegistrosSicomOK @id, @error = @Error
      end
    
	if exists(select r.rpu 
                from RegistrosSicomOK r 
                join  pagos p on p.Rpu                 = r.RPU    --- por RPU
                --modificado LARG 18012016 por que no se debe calcular fecfac   
                 --and YEAR(r.FechaFactura)  = YEAR(p.FechaFac)
                 --and MONTH(r.FechaFactura) = MONTH(p.FechaFac) 
              and YEAR(r.FechaFactura)  = isnull(p.AnoFactOrigen,YEAR(p.FechaFac))
               and MONTH(r.FechaFactura) = isnull(p.MesFactOrigen, MONTH(p.FechaFac) )  
				 --and abs(r.importe -p.Importe) < 2 lo quite por que el pago puede separarse en 2 o mas
               where r.ID = @id  
                 and r.Estatus in( 0,1) -- es una factura o un pago ya existe como como pago
                 and  p.Estatus=1 )
      begin            
     
        select @Error=8
        exec spCambiaProcesadoRegistrosSicomOK @id, @error = @Error
      end
    
	
	-- se checan duplicados de nuevo
    if @Error = 0
    if exists(select r.rpu 
                from RegistrosSicomOK r 
                join pagos p on p.Rpu                 = r.RPU 
                 and YEAR(r.FechaFactura)  = YEAR(p.FechaFac)
                 and MONTH(r.FechaFactura) = MONTH(p.FechaFac) 
               where r.ID = @id  
                 and r.Estatus = 2 -- es una cancelacion factura y ya existe como  pago
                 and p.Estatus = 1 )
      begin           
        select @Error=15
        exec spCambiaProcesadoRegistrosSicomOK @id, @error = @error
      end
      
    IF EXISTS (select id from RegistrosSicomOK where ID =@id and Procesado=0 AND ERROR=0)-- PASO LA VALIDACION DE DUPLICADOS 
       and @Error=0
    BEGIN          
      --- BLANQUEO VARIABLES
      SELECT  @Error = 0, @FechaProceso = NULL, @TipoCred = '', @Estatus = '',  
              @FechaPago = NULL, @FechaFactura = NULL, @RPU = '', @NUMCREDITO = '', 
              @Importe = 0,@fecha =NULL    
      -- se le los datos del registo a variables          
      --SELECT @fecha        = fecha
      --  FROM RegistrosSicomOK where ID = @ID      -- 
      --exec spMasdeUnCreditos @fecha,null,@id  -- se cambia el credito si es necesario lo saque de la transaction pues es muy pesado su rollback 20150515 daniel sepulveda
      -- se lee de nuevo con el rpu cambiado
    
      SELECT @TipoCred     = TipoCred,
             @Estatus      = Estatus,
             @FechaPago    = FechaPago,
             @FechaFactura = FechaFactura ,
             @RPU          = RPU,
             @NUMCREDITO   = Numcredito,
             @Importe      = Importe,
             @fecha        = fecha,
             @error        = error
        FROM RegistrosSicomOK where ID = @ID
    
      IF @Error = 0
      BEGIN     
        IF  @tipocred='N' and @Estatus  = '00'  
            EXEC spAplicaFacturaRegistrosSicomOK         @ID, @RPU, @NUMCREDITO, @FechaFactura, @Error output    
        ELSE IF @tipocred='E' and @Estatus   = '01' 
			 EXEC spAplicaPagoRegistrosSicomOK          @ID, @RPU, @NUMCREDITO, @FechaFactura, @FechaPago, @Error output 
            --Modificado por solicitud de claudia el 27112015
           -- EXEC spAplicaPagoExtemporaneo                @ID, @RPU, @NUMCREDITO, @FechaFactura, @FechaPago, @Error output 
        ELSE IF  @tipocred='N' and @Estatus  = '01'  
        begin
            --select 'entre', @ID, @RPU, @NUMCREDITO, @FechaFactura, @FechaPago, @Error
            EXEC spAplicaPagoRegistrosSicomOK          @ID, @RPU, @NUMCREDITO, @FechaFactura, @FechaPago, @Error output    
        end    
        ELSE IF @tipocred='N' and @Estatus  = '02'  
            EXEC spAplicaCancelacionRegistrosSicomOK  @ID, @RPU, @NUMCREDITO, @FechaFactura, @Error output             
        ELSE 
          SELECT @Error=100 -- ALGO ESTA MAL POSIBLMENTE EL TIPOCREDITO O EL ESTATUS...    
      END
           
    END      
    
    IF @Error in(0,20)
    begin
      EXEC spCambiaProcesadoRegistrosSicomOK @id, @error = @error   -- se guarda
      
      
      COMMIT TRANSACTION    
    end   
    ELSE 
    begin
       EXEC spCambiaProcesadoRegistrosSicomOK @id, @error = @error   -- se guarda
       PRINT 'ERROR'
       PRINT @ERROR
       ROLLBACK          
       EXEC spCambiaProcesadoRegistrosSicomOK @id, @error = @error   -- se guarda
    end
    SELECT @ID2=@ID
    SELECT @id =NULL,@Error=0
    
	SELECT TOP 1 @ID=ID FROM RegistrosSicomOK WHERE Procesado=0  AND ERROR=0 AND ID > @ID2  and fechapago >getdate()-15 ORDER BY id
  if @id=0 or @id is null
    SELECT TOP 1  @ID=ID FROM RegistrosSicomOK WHERE Procesado=0 AND ERROR=0 AND ID >@ID2 ORDER BY ID -- se busca el que sigue 2   

  END -- while 
  
END


/*
declare @error int
  exec spAplicaPagoRegistrosSicomOK 1,'546940764290','900381112','2012-12-12 00:00:00.000','2012-12-31 00:00:00.000',@error output

*/

GO


