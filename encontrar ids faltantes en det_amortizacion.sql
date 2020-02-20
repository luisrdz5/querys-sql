    Select 
	       d.solicitudscc,
		   d.pagare,
		   AñoMes = Convert(varchar(6),d.fecha,112),
		   d.fecha,
		   d.IDRegistroSicom,
		   Importe = (d.ImporteOpFin + d.InteresOpFin + d.IVAOpFin)
	  From dbo.det_amortizacion d With(Nolock)
	       Inner Join dbo.creditos c On c.NumCredito = d.solicitudscc And c.TipoCredito In ('PA','CV')
	 Where ISNULL(d.IDRegistroSicom,0) = 0
	   And d.estatus = 14