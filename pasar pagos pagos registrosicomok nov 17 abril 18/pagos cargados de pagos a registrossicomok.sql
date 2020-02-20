-- query modificado por luis para conjuntar los pagos en la tabla pagos en uno solo 
Drop Table #RegSicomOk2
Select rs.*
  Into #RegSicomOk2
  From SircaNac.dbo.RegistrosSicomOK rs With(Nolock)
       Inner Join SircaNac.dbo.creditos c On c.NumCredito = rs.Numcredito And c.TipoCredito != 'LD'
 Where CONVERT(varchar(6),rs.FechaPago,112) Between '201711' And '201804'
   And IsNull(rs.Archivo,'') != 'CuentaRAP'
   And (rs.Error = 0)

Drop Table #Pago2
;With PagosRAP2
As
(
	Select p.id,
		   p.NumCredito
	  From SircaNac.dbo.pagos p
	 Where Convert(varchar,p.FechaVenci,112) = Convert(varchar,p.FechaPago,112)
	   And Convert(varchar,p.FechaVenci,112) = Convert(varchar,p.FechaFac,112)
	   And CONVERT(varchar(6),p.FechaPago,112) Between '201711' And '201804'
)
Select p.numcredito,p.rpu,  p.Fechafac, p.fechavenci,p.fechapago, sum(p.importe) as importe,p.idregistrosicom, p.estatus, p.mesfactorigen, p.anofactorigen, NULL as procesado
  Into #Pago2
  From SircaNac.dbo.pagos p With(Nolock)
       Inner Join SircaNac.dbo.creditos c With(Nolock) On c.NumCredito = p.NumCredito And c.TipoCredito != 'LD'
 Where CONVERT(varchar(6),p.FechaPago,112) Between '201711' And '201804'
   And Not Exists (Select 1 From PagosRAP2 r Where r.NumCredito = p.NumCredito And r.id = p.id)
   group by p.numcredito,p.rpu,  p.Fechafac, p.fechavenci,p.fechapago,p.idregistrosicom, p.estatus, p.mesfactorigen, p.anofactorigen
   
   
   
   -- obtengo diferencias entre bd's 
   
   select COUNT(*), SUM(importe)
   from #pago2
   
   select COUNT(*), SUM(importe)
   from #RegSicomOk2
   
   
   select top 100 *
   from #pago2
   
   
   
   INSERT INTO [SircaNac].[dbo].[RegistrosSicomOK]
              ([IDCargaDiariaFecha]
           ,[Archivo]
           ,[RPU]
           ,[Numcredito]
           ,[Producto]
           ,[FechaFactura]
           ,[FechaPago]
           ,[FechaVencimiento]
           ,[importe]
           ,[Estatus]
           ,[AnoFact]
           ,[MesFact]
           ,[Error]
           ,[TipoCred]
           ,[EsPagoFin]
           ,[FechaArchivo]
           ,[FechaProceso]
           ,[Procesado]
           ,[fecha]
           ,[EstatusFechaEnvio]
           ,[FechaLlegada]
           ,[FechaPagoCFE]
           ,[PagoDeMas]
           ,[PagoEliminado]
           ,[AppBusquedaPago]
           ,[estatusSicom]
           ,[motivo]
           ,[stsenergia])
           
   select  c.ID
   , c.Archivo
   ,p.rpu
   , p.numcredito
   ,(select tipocredito from creditos where NumCredito=p.numcredito)
   ,p.fechafac
   ,p.fechapago
   ,p.fechavenci
   ,p.Importe
   ,'01' as estatus
   ,p.anofactorigen
   ,p.mesfactorigen
   ,0 as error
   ,'N' as tipocred
   ,0 as espagofin
   ,c.Fecha as FechaArchivo
   ,GETDATE() as FechaProceso
   ,1 as procesado
   ,GETDATE() as Fecha
   ,NULL as [EstatusFechaEnvio]
   ,NULL as FechaLlegada
   ,NULL as [FechaPagoCFE]
   ,NULL as [PagoDeMas]
   ,NULL as [PagoEliminado]
   ,NULL as [AppBusquedaPago]
   ,NULL as [estatusSicom]
   ,NULL as [motivo]
   ,NULL as [stsenergia]
   from #Pago2 p
   left join #RegSicomOk2 r on r.id=p.idregistrosicom
   left join CargaDiariaFecha c on 
			convert(varchar,c.credito)=convert(varchar,p.numcredito)
			and convert(varchar,c.fechapago,112)=convert(varchar,p.fechapago ,112)
			and convert(varchar,c.fechafactura,112)=convert(varchar,p.fechafac,112) 
			and convert(varchar,c.fechavencimiento,112)=convert(varchar,p.fechavenci,112)	
			and convert(money,c.Importe)=convert(money,p.importe)
   where p.idregistrosicom = 0 and c.Archivo is not null
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   select  p.*
   from #Pago2 p
   left join #RegSicomOk2 r on r.id=p.idregistrosicom	
   where p.idregistrosicom = 0
   
   
   
   select  c.*, p.*
   from #Pago2 p
   left join #RegSicomOk2 r on r.id=p.idregistrosicom
   left join CargaDiariaFecha c on 
			convert(varchar,c.credito)=convert(varchar,p.numcredito)
			and convert(varchar,c.fechapago,112)=convert(varchar,p.fechapago ,112)
			and convert(varchar,c.fechafactura,112)=convert(varchar,p.fechafac,112) 
			and convert(varchar,c.fechavencimiento,112)=convert(varchar,p.fechavenci,112)			
   where p.idregistrosicom = 0
   
   
   --176
     select  c.ID,p.*
   from #Pago2 p
   left join #RegSicomOk2 r on r.id=p.idregistrosicom
   left join CargaDiariaFecha c on 
			convert(varchar,c.credito)=convert(varchar,p.numcredito)
			and convert(varchar,c.fechapago,112)=convert(varchar,p.fechapago ,112)
			and convert(varchar,c.fechafactura,112)=convert(varchar,p.fechafac,112) 
			and convert(varchar,c.fechavencimiento,112)=convert(varchar,p.fechavenci,112)	
			and convert(money,c.Importe)=convert(money,p.importe)
   where p.idregistrosicom = 0 and c.Archivo is not null
   
   
   
   
   
   select p.* --COUNT(*), SUM(p.importe)
   from #Pago2 p
   left join #RegSicomOk2 r on
			r.numcredito=p.numcredito 
			--and r.id=p.idregistrosicom 
			--and r.importe=p.importe
			and r.fechapago=p.fechapago
			and r.fechafactura=p.fechafac
			and r.fechavencimiento=p.fechavenci
   where r.id is null
   
   
   select COUNT(*), SUM(r.importe)
   from #RegSicomOk2 r
   left join #Pago2 p on r.id=p.idregistrosicom
   where p.idregistrosicom is null
   
    --Siendo mas estrictos
      
      
    select r.*
   from #RegSicomOk2 r
   left join #Pago2 p on 
		r.numcredito=p.numcredito
		--and r.id=p.idregistrosicom
		--and r.importe=p.importe
		and r.fechapago=p.fechapago
		and r.fechafactura=p.fechafac
		and r.fechavencimiento=p.fechavenci
   where p.idregistrosicom is null
   order by numcredito


