USE [FIDE]
GO
/****** Object:  StoredProcedure [dbo].[spRepBuroCreditoCARTERAAplicacionVersion14]    Script Date: 02/19/2020 13:35:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                  
                
                  
ALTER PROCEDURE [dbo].[spRepBuroCreditoCARTERAAplicacionVersion14]                  
                  
                  
                  
AS BEGIN                  
SET NOCOUNT ON                
               
DECLARE                  
  @Cliente     varchar(10),                  
  @Nombres     varchar(100),                  
  @ApellidoPaterno   varchar(100),                  
  @ApellidoMaterno   varchar(100),                  
  @RFC      varchar(15),                  
  @Sexo      varchar(20),                  
  @Direccion    varchar(100),           
  @Direccion1    varchar(100),          
  @Poblacion    varchar(100),                  
  @Estado     varchar(30),                  
  @CodigoPostal    varchar(15),                  
  @Cuenta     varchar(20),                  
  @TipoMoneda    varchar(10),                  
  @CantidadAmortizaciones varchar(10),--int,                  
  @TipoAmortizaciones  varchar(20),                  
  @FechaEmision    datetime,                  
  @Mensualidad    money,                  
  @UltimoCobro    datetime,                  
  @UltDisposicion   datetime,                  
  @ImporteDisposicion  money,                  
  @SaldoPendiente   money,                  
  @SaldoVencido    money,                  
  @AmortMasAntigua   datetime,                  
  @AntiguedadSaldo   int,    --CAMBIOS 09/01/14 GEOVANNI - SE CAMBIO DE VARCHAR(10) A INT  
  @DiasVencimiento	int,            
                  
  @D      varchar(5),                    
  @Suma      money,                  
  @SumaSaldoVencido   money,                  
  @SumaSaldoPendiente    money,                  
  @Nombre1     varchar(50),                  
  @Nombre2     varchar(50),                  
  @Fecha     datetime,                  
  @TotalSegmentos   int,              
  @Programa varchar(10),     
  
  @primer_nombre		varchar(26),
 @segundo_nombre	varchar(26),
 @fechanacimiento	datetime,
 @NacionalidaAcreditado varchar(2),
 @Colonia				varchar(40),
 @Ciudad2				varchar(40),
 @OrigenDomicilio		varchar(2),
 @OrigenRazonSocial     varchar(2),
 @limiteCredito				varchar(9),
 @fechaPrimerIncumplimiento	datetime,
 @saldoInsoluto				varchar(10),
 @montoUltimoPago			varchar(9),
 @plazoMeses				VARCHAR(2)
  
  
           
                  
 if not exists(select * from sysobjects o join sys.indexes i on o.id=i.Object_id where i.name='NumCredito' and o.name='RepBuroCreditoFijoVersion14')                  
   CREATE INDEX NumCredito on RepBuroCreditoFijoVersion14(NumCredito)                   
                  
 if not exists(select * from sysobjects o join sys.indexes i on o.id=i.Object_id where i.name='NumCredito' and o.name='RepBuroCreditoFijoPatronversion14')                  
   CREATE INDEX NumCredito on RepBuroCreditoFijoPatronversion14(NumCredito)                   
                  
                  
 DELETE RepBuroCreditoFijoVersion14                   
  WHERE RepBuroCreditoFijoVersion14.NumCredito                   
    NOT IN(SELECT RepBuroCreditoFijoPatronversion14.NumCredito                   
             FROM RepBuroCreditoFijoPatronversion14                  
            WHERE RepBuroCreditoFijoPatronversion14.NumCredito= RepBuroCreditoFijoVersion14.NumCredito)                  
                  
  set concat_null_yields_null OFF                  
  create table #r (id int identity(1,1) not NULL PRIMARY KEY, datos varchar(MAX) null)                  
                  
 SELECT @Fecha = (SELECT TOP 1 isnull(FechaReporte,getdate()) FROM RepBuroCreditoFijoVersion14)                           
  SELECT @Suma = 0.0, @SumaSaldoVencido = 0.0,  @SumaSaldoPendiente = 0.0                  
  INSERT #r (Datos)                  
  SELECT  'INTF14TF15180001FIDE            '                  
       + '  '--Indica el Número de Ciclo                  
       +CONVERT(varchar,   dbo.fnLlenarceros(DAY(@Fecha),2)     )                  
       +CONVERT(varchar,   dbo.fnLlenarceros(MONTH(@Fecha),2)   )                  
       +CONVERT(varchar,   YEAR(@Fecha)                         )                  
       +'0000000000'+dbo.fnrellenarTexto ('','',98)                  
                  
    --CAMBIOS 09/01/14 GEOVANNI - SE AGREGO LEFT JOIN LC              
  DECLARE crTextoBuro CURSOR FOR                  
    SELECT ISNULL(rbcf.NumCliente,''), ISNULL(rbcf.Nombres,''), ISNULL(rbcf.ApellidoPaterno,''), ISNULL(rbcf.ApellidoMaterno,'NO PROPORCIONADO'), ISNULL(SUBSTRING(rbcf.RFC,1,10),''), ISNULL(rbcf.Sexo,''), ISNULL(rbcf.Direccion,''),      
    ISNULL(RTRIM(rbcf.Direccion1),''), ISNULL(RTrim(rbcf.Delegacion),''),                   
         ISNULL(rbcf.Estado,''), ISNULL(rbcf.CodigoPostal,''), ISNULL(rbcf.NumCredito,''), ISNULL(rbcf.TipoMoneda,''), ISNULL(rbcf.CantidadAmortizaciones,''),  ISNULL(rbcf.TipoAmortizaciones,''),  FechaEmision,                    
           isnull(rbcf.Cuotafija,0), isnull(rbcf.UltimoCobro,0),  isnull(rbcf.UltDisposicion,0),  isnull(rbcf.ImporteDisposicion,0),  isnull(rbcf.SaldoPendiente,0),  isnull(rbcf.SaldoVencido,0),  AmortMasAntigua,                    
           isnull(rbcf.AntiguedadSaldo,0), FechaReporte, isnull(rbcf.SaldoPendiente,0), isnull(rbcf.SaldoVencido,0), isnull(l.Programa,''),
isnull(rbcf.Primer_Nombre,''),
isnull(rbcf.Segundo_Nombre,''),
isnull(rbcf.FechaNacimiento,''),
isnull(rbcf.NacionalidaAcreditado,''),
isnull(rbcf.Colonia,''),
isnull(rbcf.Ciudad,''),
isnull(rbcf.OrigenDomicilio,''),
isnull(rbcf.OrigenRazonSocial,''),
isnull(rbcf.limiteCredito,''),
isnull(rbcf.fechaPrimerIncumplimiento,''),
isnull(rbcf.saldoInsoluto,''),
isnull(rbcf.montoUltimoPago,''),
isnull(rbcf.plazoMeses,'')         
      FROM RepBuroCreditoFijoVersion14 rbcf              
      LEFT JOIN LC l ON l.DigitoVerificador=rbcf.NumCredito                  
           
                  
                  
  OPEN crTextoBuro                  
  FETCH NEXT FROM crTextoBuro INTO @Cliente, @Nombres, @ApellidoPaterno, @ApellidoMaterno, @RFC, @Sexo, @Direccion,@Direccion1,                 
                               @Poblacion, @Estado, @CodigoPostal, @Cuenta, @TipoMoneda, @CantidadAmortizaciones, @TipoAmortizaciones, @FechaEmision,                  
                               @Mensualidad, @UltimoCobro, @UltDisposicion, @ImporteDisposicion,  @SaldoPendiente, @SaldoVencido, @AmortMasAntigua,                   
                               @AntiguedadSaldo, @Fecha, @SumaSaldoPendiente, @SumaSaldoVencido, @Programa,
                               @Primer_Nombre,@Segundo_Nombre,@FechaNacimiento,@NacionalidaAcreditado,@Colonia,
							   @Ciudad2,@OrigenDomicilio,@OrigenRazonSocial,@limiteCredito,@fechaPrimerIncumplimiento,
							   @saldoInsoluto,@montoUltimoPago,@plazoMeses              
  WHILE @@FETCH_STATUS <> -1 AND @@Error = 0                   
  BEGIN                  
    IF @@FETCH_STATUS <> -2                   
    BEGIN                  
         IF @Mensualidad > isnull(@SaldoPendiente,0) Select @Mensualidad=isnull(@SaldoPendiente,0)                  
   IF @UltimoCobro > @Fecha Select @UltimoCobro = @Fecha                  
  
          
      select @Nombre1= case  when len(@Nombres)>=26 or  len(@Nombres)<=40       
  then SUBSTRING(@Nombres,1,26)     
   end,    
   @Nombre2=case    when len(@Nombres)>26    then SUBSTRING(@Nombres,27,52)    
   end    
IF @AntiguedadSaldo > 0 
BEGIN 
	IF @AntiguedadSaldo > 999 
	BEGIN
		SET @DiasVencimiento= 999
	END
	ELSE
	BEGIN
		SET @DiasVencimiento=@AntiguedadSaldo
	END
END
ELSE 
BEGIN
	SET @DiasVencimiento=0
END 
                    
IF @Programa='PFAEE'              
BEGIN              
 SET @D = '01'              
END              
ELSE              
 BEGIN              
  IF @AntiguedadSaldo BETWEEN 1 AND 29              
  BEGIN              
   SET @D='02'              
  END              
  ELSE IF @AntiguedadSaldo BETWEEN 30 AND 59              
  BEGIN              
   SET @D='03'              
  END              
  ELSE IF @AntiguedadSaldo BETWEEN 60 AND 89              
  BEGIN              
   SET @D='04'              
  END              
  ELSE IF @AntiguedadSaldo BETWEEN 90 AND 119              
  BEGIN              
   SET @D='05'              
  END              
  ELSE IF @AntiguedadSaldo BETWEEN 120 AND 179              
  BEGIN              
   SET @D='07'              
  END              
  ELSE IF @AntiguedadSaldo >= 180              
  BEGIN              
   SET @D='96'              
  END              
  ELSE IF @AntiguedadSaldo <1              
  BEGIN              
   SET @D='01'              
  END              
                
  ELSE           BEGIN              
    SET @D='00'               
   END              
 END              
                        
       INSERT #r (Datos)                          
       SELECT 'PN'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@ApellidoPaterno),2)   )                  
       +@ApellidoPaterno+'00'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@ApellidoMaterno),2)   )                  
       +@ApellidoMaterno+'02'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@Primer_Nombre),2)           )                  
       +@Primer_Nombre+'03'
	   +CASE WHEN ISNULL(@Segundo_Nombre,'') = '00'            
		THEN '00'
		ELSE                                             
			CONVERT(varchar,   dbo.FnLlenarceros(LEN(@Segundo_Nombre),2))                   
			+ISNULL(@Segundo_Nombre,'')
        END
       +'0408'
       +CONVERT(varchar,   dbo.FnLlenarceros(DAY(@FechaNacimiento),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@FechaNacimiento),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@FechaNacimiento),4))   
       +'05'                  
       +CONVERT(varchar,dbo.FnLlenarceros(LEN(@RFC),2) +@RFC)
       +'08'
       +CONVERT(varchar,dbo.FnLlenarceros(LEN(@NacionalidaAcreditado),2))
       +@NacionalidaAcreditado
       +'1201'
       + @Sexo                         
       +'PA'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@Direccion),2)        )                  
       +@Direccion  
       +'01'                
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@Colonia),2)        ) 
       +@Colonia        
       +'02'                
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@Poblacion),2)        )                  
       +@Poblacion
       +'03'                
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@Ciudad2),2)        )                  
       +@Ciudad2       
       +'04'             
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@Estado),2)        )                  
       +@Estado                  
       +'05'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@CodigoPostal),2)      )                  
       +CONVERT(varchar,   @CodigoPostal      )    
       +'12'             
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@OrigenDomicilio),2)        )                  
       +@OrigenDomicilio                      
       +'PE'                  
       +'24TRABAJADOR INDEPENDIENTE'
       +'1802MX'                  
       +'TL02'+'TL0110'+'TF15180001'+'0204FIDE'                  
    +'04'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@Cuenta),2)      )                  
       +@Cuenta
       --Se Realizo Actualizacion del campo Tipo de Responsabilidad-- hay que validarlo 25042017                  
       +'0501I'+'0601I'+'0702FI'+'0802'+                  
       +@TipoMoneda                  
       +'10'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@CantidadAmortizaciones),2)      )                  
       +CONVERT(varchar,   @CantidadAmortizaciones                                )                  
       +'1101'                  
       +CASE @TipoAmortizaciones                  
         WHEN 'MENSUAL' THEN 'M'                  
         WHEN 'BIMESTRAL' THEN 'B'                  
  WHEN 'CATORCENAL' THEN 'K'                   
         ELSE 'M' END                  
       +'12'                   
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN( RTRIM(LTRIM(STR(@Mensualidad)))  ),2)      )                  
       + RTRIM(LTRIM(STR(@Mensualidad)))                  
       +'1308'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(DAY(@FechaEmision),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@FechaEmision),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@FechaEmision),4)      )                  
                         
       +CASE WHEN IsNull(@UltimoCobro,0) = 0  
             THEN '1408'                  
           +CONVERT(varchar,   dbo.FnLlenarceros(DAY(@UltDisposicion),2)      )                  
      +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@UltDisposicion),2)      )                  
      +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@UltDisposicion),4)      )               
             ELSE '1408'                  
                  +CONVERT(varchar,   dbo.FnLlenarceros(DAY(@UltimoCobro),2)      )                  
                  +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@UltimoCobro),2)      )                  
                  +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@UltimoCobro),4)      )                  
             END                  
       --+CASE WHEN @FechaEmision = @UltDisposicion   
       +CASE WHEN IsNull(@UltimoCobro,0) = 0             
    THEN '1508'                   
      +CONVERT(varchar,   dbo.FnLlenarceros(DAY(@UltDisposicion),2)      )                  
      +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@UltDisposicion),2)      )                  
      +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@UltDisposicion),4)      )                    
    ELSE '1508'                   
      +CONVERT(varchar,   dbo.FnLlenarceros(DAY(@UltimoCobro),2)      )                  
      +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@UltimoCobro),2)      )                  
      +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@UltimoCobro),4)      )                  
    END    

       --//Fecha de Cierre    
       +Case When IsNull(@SaldoVencido,0) = 0     
              And IsNull(@SaldoPendiente,0) = 0     
              And Convert(varchar,@D) = '01'    
              And @Mensualidad = 0    
              And @UltimoCobro Is Not Null    
             Then '1608'    
                  +CONVERT(varchar,dbo.FnLlenarceros(DAY(@UltimoCobro),2))                  
                  +CONVERT(varchar,dbo.FnLlenarceros(MONTH(@UltimoCobro),2))                  
                  +CONVERT(varchar,dbo.FnLlenarceros(YEAR(@UltimoCobro),4))  Else '' End    
       --//           
       +'1708'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(DAY(@Fecha),2)      )                  
 +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@Fecha),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@Fecha),4)      )                  
       +'21'                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(  RTRIM(LTRIM(STR(@ImporteDisposicion))) ),2)      )                  
       +RTRIM(LTRIM(STR(@ImporteDisposicion)))                  
                    
/*SE MODIFICO EL 4FEB2001 */                   
    +CASE WHEN @SaldoPendiente < @Mensualidad                  
THEN                
       +'22'                  
       +'010'                  
     ELSE                     
       +'22'                  
       +CONVERT(varchar,  dbo.FnLlenarceros(LEN(  RTRIM(LTRIM(STR(@SaldoPendiente)))  ),2)      )                  
       +RTRIM(LTRIM(STR(@SaldoPendiente)))                  
     END
     +'23'
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(  RTRIM(LTRIM(STR(@ImporteDisposicion))) ),2)      )                  
       +RTRIM(LTRIM(STR(@ImporteDisposicion)))                    
  +'24'                  
       --revisar cuando venga null ponga 88                  
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(ISNULL(NULLIF(  RTRIM(LTRIM(STR(@SaldoVencido))) ,''),'88')),2)      )                  
       +ISNULL(RTRIM(LTRIM(STR(@SaldoVencido))),'0')                  
                         
       +'2602'                  
       +CONVERT(varchar, @D)    
       --//Clave de Observación    
       +Case When IsNull(@SaldoVencido,0) = 0     
              And IsNull(@SaldoPendiente,0) = 0     
              And Convert(varchar,@D) = '01'    
              And @Mensualidad = 0    
             Then '3002CC' Else '' End    
       --// 
       +'4308'
       +CASE WHEN Convert(varchar,@D) = '01' OR  Convert(varchar,@D) = '00'
       THEN 
       '01011900'
       ELSE   
       CONVERT(varchar,   dbo.FnLlenarceros(DAY(@fechaPrimerIncumplimiento),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@fechaPrimerIncumplimiento),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@fechaPrimerIncumplimiento),4)      )                      
       END
       +'44'   
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(ISNULL(NULLIF(  RTRIM(LTRIM(STR(@SaldoVencido))) ,''),'88')),2)      )                  
       +ISNULL(RTRIM(LTRIM(STR(@SaldoVencido))),'0')   
       +'45'   
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN( RTRIM(LTRIM(STR(@Mensualidad)))  ),2)      )                  
       + RTRIM(LTRIM(STR(@Mensualidad)))  
       +'4608'   
       +CONVERT(varchar,   dbo.FnLlenarceros(DAY(@fechaPrimerIncumplimiento),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(MONTH(@fechaPrimerIncumplimiento),2)      )                  
       +CONVERT(varchar,   dbo.FnLlenarceros(YEAR(@fechaPrimerIncumplimiento),4)      ) 
       +'47010'
       +'49'
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(convert(varchar,@DiasVencimiento)),2)        )
       +CONVERT(VARCHAR,@DiasVencimiento)    
       +'50'   
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(@plazoMeses),2)        )                  
       +CONVERT(VARCHAR,@plazoMeses) 
       +'51'
       +CONVERT(varchar,   dbo.FnLlenarceros(LEN(  RTRIM(LTRIM(STR(@ImporteDisposicion))) ),2)      )                  
       +RTRIM(LTRIM(STR(@ImporteDisposicion))) 
       +'9903FIN'                  
                  
       SELECT @SumaSaldoPendiente = @SumaSaldoPendiente + ISNULL(@SumaSaldoPendiente,0.0)                  
       SELECT @SumaSaldoVencido = @SumaSaldoVencido + ISNULL(@SumaSaldoVencido,0.0)                  
       SELECT @Suma = @SumaSaldoVencido + @SumaSaldoPendiente                  
    END                  
 FETCH NEXT FROM crTextoBuro INTO @Cliente, @Nombres, @ApellidoPaterno, @ApellidoMaterno, @RFC, @Sexo, @Direccion,@Direccion1,                
                               @Poblacion, @Estado, @CodigoPostal, @Cuenta, @TipoMoneda, @CantidadAmortizaciones, @TipoAmortizaciones, @FechaEmision,                  
        @Mensualidad, @UltimoCobro, @UltDisposicion, @ImporteDisposicion,  @SaldoPendiente, @SaldoVencido, @AmortMasAntigua,                   
                               @AntiguedadSaldo, @Fecha, @SumaSaldoPendiente, @SumaSaldoVencido, @Programa,
                               @Primer_Nombre,@Segundo_Nombre,@FechaNacimiento,@NacionalidaAcreditado,@Colonia,
							   @Ciudad2,@OrigenDomicilio,@OrigenRazonSocial,@limiteCredito,@fechaPrimerIncumplimiento,
							   @saldoInsoluto,@montoUltimoPago,@plazoMeses                               
  END                  
  CLOSE crTextoBuro                  
  DEALLOCATE crTextoBuro                  
                  
    SELECT @TotalSegmentos = COUNT(Datos)-1 FROM #r                  
                  
       INSERT #r (Datos)                   
       SELECT  'TRLR'                  
       +dbo.FnLlenarceros (RTRIM(LTRIM(STR(@SumaSaldoPendiente))),14)                  
       +dbo.FnLlenarceros (RTRIM(LTRIM(STR(@SumaSaldoVencido))),  14)                  
       +'001'                  
       +dbo.FnLlenarceros (RTRIM(LTRIM(STR(@TotalSegmentos))), 9)                  
       +dbo.FnLlenarceros (RTRIM(LTRIM(STR(@TotalSegmentos))), 9)                  
  +'000000000'                  
       +dbo.FnLlenarceros (RTRIM(LTRIM(STR(@TotalSegmentos))), 9)                  
       +'000000'                  
       +'FIDE            '                  
    +'MARIANO ESCOBEDO 420 COL ANZUREZ'                  
       +dbo.fnrellenarTexto ('','',128)                  
                  
              
                  
truncate table RepBuroCVersion14                           
                  
Insert RepBuroCVersion14                  
select datos from #r order by ID  
  
         
                   
  RETURN              
END 