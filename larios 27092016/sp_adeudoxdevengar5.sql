USE [SIRCANAC]
GO

/****** Object:  StoredProcedure [dbo].[sp_adeudoxdevengar5]    Script Date: 09/27/2016 11:43:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_adeudoxdevengar5]  
 -- Add the parameters for the stored procedure here  
 @credito int,  
 @rpu varchar (12),  
 @fecha date,  
 --@numamorxd int OUTPUT,    
 @capitalxd money OUTPUT,  
 @interesxd money OUTPUT,  
 @ivainteresxd money OUTPUT  
AS  
BEGIN  
DECLARE @primeraamor int;  
DECLARE @totalamor int;  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
 --SELECT @primeraamor = min(pagare),@numamorxd=count(*)  
 --from det_amortizacion   
 --where rpu=@rpu and solicitudscc=@credito  
 --and estatus in (15,17)   
 --antes solo traia el 17 pero se necesita cobrar todo el adeudo este o no facturado o vencido   
 --daniel sepulveda 8 octubre 2012    
 --se regreso para que solo lea el 17 porque lo que esta facturado y vencido se cobra ya en el convenio y lo esta sumando dos veces julio 2014 zaidy o  
  
  
--set @totalamor=@plazo+@primeraamor-1;  
  
SELECT @capitalxd = case when sum(saldo)-sum(ivainteres)-sum(interes) is null then 0 else sum(saldo)-sum(ivainteres)-sum(interes) end,  
@interesxd=sum(interes),  
@ivainteresxd=sum(ivainteres)  
 from det_amortizacion   
 where rpu=@rpu and solicitudscc=@credito  
 and estatus in (15,17) and fecha <= @fecha  
 --and (pagare >=@primeraamor and pagare <=@totalamor)  
 --antes solo traia el 17 pero se necesita cobrar todo el adeudo este o no facturado o vencido   
 --daniel sepulveda 8 octubre 2012   
 --se regreso para que solo lea el 17 porque lo que esta facturado y vencido se cobra ya en el convenio y lo esta sumando dos veces julio 2014 zaidy o  
  
  
/*set @capitalxd += (select sum(saldo)-sum(ivainteres)-sum(interes)  
 from det_amortizacion   
 where rpu=@rpu and solicitudscc=@credito  
 and estatus in (15,17)  and fecha > @fecha */
 
 --120816 MLD cuando no encuentra ninguna amortizacion me trae valor null, lo que hace que la suma sea null, por eso le puse el case
 set @capitalxd += (select case when sum(saldo)-sum(ivainteres)-sum(interes) is null then 0 else sum(saldo)-sum(ivainteres)-sum(interes) end as capitalxd
 from det_amortizacion   
 where rpu=@rpu and solicitudscc=@credito 
 and estatus in (15,17) and fecha > @fecha 


 --and pagare > @totalamor  
 )  
 ---antes solo traia el 17 pero se necesita cobrar todo el adeudo este o no facturado o vencido  
 --daniel sepulveda 8 octubre 2012   
 --se regreso para que solo lea el 17 porque lo que esta facturado y vencido se cobra ya en el convenio y lo esta sumando dos veces julio 2014 zaidy o  
  
END  
-- select * from estatus  
--Edgar

GO


