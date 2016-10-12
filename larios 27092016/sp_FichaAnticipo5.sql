USE [SIRCANAC]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_FichaAnticipo5]
	@credito int,
	@rpu varchar (12),
	@referencia varchar (17) OUTPUT,
	@anticipo money OUTPUT,
    @fechavigencia smalldatetime OUTPUT,
    @lugar varchar(50) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT @anticipo=CEILING(anticipo),@fechavigencia=fechavigencia,
			@referencia=referencia,@lugar=lugar
      from convenios 
     where rpu=@rpu and credito=@credito
END
GO


