USE [SIRCANAC]
GO

/****** Object:  StoredProcedure [dbo].[sp_adeudoVencido5]    Script Date: 09/22/2016 17:24:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_adeudoVencido5]
	-- Add the parameters for the stored procedure here
	@credito int,
	@rpu varchar (12),
	@adeudo money OUTPUT,
	@numamor int OUTPUT,
	@capital money OUTPUT,
	@interes money OUTPUT,
	@ivainteres money OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*MODIFICACION PARA QUE SUME EL SALDO Y NO LOS VENCIDOS - 19-MAYO-2014*/
	DECLARE @vencido money,
	@totalcapital money
	/*FIN MODIFICACION PARA QUE SUME EL SALDO Y NO LOS VENCIDOS - 19-MAYO-2014*/
	select @adeudo=sum(saldo), @numamor=count(*),
		   @totalcapital=sum(capital),@interes=sum(interes),
           @ivainteres=sum(ivainteres)
    from det_amortizacion 
	where rpu=@rpu and solicitudscc=@credito
	--and estatus in ('16','19','17') and saldo=pagored 
	and estatus in ('16','19') and saldo=pagored 

	/*MODIFICACION PARA QUE SUME EL SALDO Y NO LOS VENCIDOS - 19-MAYO-2014*/
	select @vencido=sum(saldo) from det_amortizacion 
	where rpu=@rpu and solicitudscc=@credito
	--and estatus in ('16','19','17') and saldo<>pagored
	and estatus in ('16','19') and saldo<>pagored

	SET @capital=@totalcapital

	if @vencido>0 begin
	SET @capital=@totalcapital+@vencido
	 end
	/*FIN MODIFICACION PARA QUE SUME EL SALDO Y NO LOS VENCIDOS - 19-MAYO-2014*/
END
/*Edgar*/


GO


