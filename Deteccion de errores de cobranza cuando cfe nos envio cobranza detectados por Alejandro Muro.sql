

Select cd.Error, cd.listo,cd.Estatus, cd.TipoCred, count(*)
--cd.RPU,cd.Error,cd.Estatus,cd.TipoCred,cd.FechaPago,cd.AnoFact,cd.MesFact --, count(*)
,(select top 1 Descripción from SircaNac.dbo.Catalogo_Errores with(NOLOCK) where error=cd.error)
--cf.* 
From SOF_SircaNac.dbo.Copy_CobranzaCFE cf
join SircaNac.dbo.CargaDiariaFecha cd on cd.RPU=cf.RPU and cf.Importe=cd.Importe and cd.MesFact=cf.MesFact and cd.AnoFact=cf.AñoFact and cd.FechaPago=cf.FechaPago
Where cf.Id_Arqueo Is Not Null 
And cf.Id_RegistroSicomOk Is Null
And Exists (Select 1 From SircaNac.dbo.creditos c With(Nolock) Where c.RPU = cf.RPU And c.TipoCredito <> 'LD')
And cf.Importe <> 0
And 0 <> (Select COUNT(1) From SircaNac.dbo.det_amortizacion d With(Nolock) Where d.rpu = cf.RPU And d.estatus Not In (14,18))
--group by cd.RPU,cd.Error,cd.Estatus,cd.TipoCred,cd.FechaPago,cd.AnoFact,cd.MesFact
group by  cd.Error,cd.Estatus, cd.TipoCred, cd.listo
Order By COUNT(*) desc



---- obtener los creditos  error 9 estatus 01

Select cd.*
--cd.RPU,cd.Error,cd.Estatus,cd.TipoCred,cd.FechaPago,cd.AnoFact,cd.MesFact --, count(*)
,(select top 1 Descripción from SircaNac.dbo.Catalogo_Errores with(NOLOCK) where error=cd.error)
--cf.* 
From SOF_SircaNac.dbo.Copy_CobranzaCFE cf
join SircaNac.dbo.CargaDiariaFecha cd on cd.RPU=cf.RPU and cf.Importe=cd.Importe and cd.MesFact=cf.MesFact and cd.AnoFact=cf.AñoFact and cd.FechaPago=cf.FechaPago
Where cf.Id_Arqueo Is Not Null 
And cf.Id_RegistroSicomOk Is Null
And Exists (Select 1 From SircaNac.dbo.creditos c With(Nolock) Where c.RPU = cf.RPU And c.TipoCredito <> 'LD')
And cf.Importe <> 0
And 0 <> (Select COUNT(1) From SircaNac.dbo.det_amortizacion d With(Nolock) Where d.rpu = cf.RPU And d.estatus Not In (14,18))
And cd.Error=9 and cd.Estatus='01'
--group by cd.RPU,cd.Error,cd.Estatus,cd.TipoCred,cd.FechaPago,cd.AnoFact,cd.MesFact
--group by  cd.Error,cd.Estatus, cd.TipoCred
Order By cd.rpu


---- obtener los creditos  error 8 estatus 01 y listo 

Select cd.*
--cd.RPU,cd.Error,cd.Estatus,cd.TipoCred,cd.FechaPago,cd.AnoFact,cd.MesFact --, count(*)
,(select top 1 Descripción from SircaNac.dbo.Catalogo_Errores with(NOLOCK) where error=cd.error)
--cf.* 
From SOF_SircaNac.dbo.Copy_CobranzaCFE cf
join SircaNac.dbo.CargaDiariaFecha cd on cd.RPU=cf.RPU and cf.Importe=cd.Importe and cd.MesFact=cf.MesFact and cd.AnoFact=cf.AñoFact and cd.FechaPago=cf.FechaPago
Where cf.Id_Arqueo Is Not Null 
And cf.Id_RegistroSicomOk Is Null
And Exists (Select 1 From SircaNac.dbo.creditos c With(Nolock) Where c.RPU = cf.RPU And c.TipoCredito <> 'LD')
And cf.Importe <> 0
And 0 <> (Select COUNT(1) From SircaNac.dbo.det_amortizacion d With(Nolock) Where d.rpu = cf.RPU And d.estatus Not In (14,18))
And cd.Error=8 and cd.Estatus='01' and cd.Listo='5'
--group by cd.RPU,cd.Error,cd.Estatus,cd.TipoCred,cd.FechaPago,cd.AnoFact,cd.MesFact
--group by  cd.Error,cd.Estatus, cd.TipoCred
Order By cd.rpu

---- obtener los creditos  error 20 estatus 01 y listo = 5

Select cd.*
--cd.RPU,cd.Error,cd.Estatus,cd.TipoCred,cd.FechaPago,cd.AnoFact,cd.MesFact --, count(*)
,(select top 1 Descripción from SircaNac.dbo.Catalogo_Errores with(NOLOCK) where error=cd.error)
--cf.* 
From SOF_SircaNac.dbo.Copy_CobranzaCFE cf
join SircaNac.dbo.CargaDiariaFecha cd on cd.RPU=cf.RPU and cf.Importe=cd.Importe and cd.MesFact=cf.MesFact and cd.AnoFact=cf.AñoFact and cd.FechaPago=cf.FechaPago
Where cf.Id_Arqueo Is Not Null 
And cf.Id_RegistroSicomOk Is Null
And Exists (Select 1 From SircaNac.dbo.creditos c With(Nolock) Where c.RPU = cf.RPU And c.TipoCredito <> 'LD')
And cf.Importe <> 0
And 0 <> (Select COUNT(1) From SircaNac.dbo.det_amortizacion d With(Nolock) Where d.rpu = cf.RPU And d.estatus Not In (14,18))
And cd.Error=20 and cd.Estatus='01' and cd.Listo='5'
--group by cd.RPU,cd.Error,cd.Estatus,cd.TipoCred,cd.FechaPago,cd.AnoFact,cd.MesFact
--group by  cd.Error,cd.Estatus, cd.TipoCred
Order By cd.rpu