--actualizar campos de suma det_amortizacion y registrosicomok en tabla temporal tmpcredsmotivofaltaid
update tmp
set tmp.totalregistrosok = (select SUM(pagodec) from det_amortizacion det with(nolock) where det.solicitudscc=tmp.solicitudscc and estatus='14' )
,tmp.totaldetamort = (select SUM(importe) from RegistrosSicomOK rsok with(nolock) where rsok.numcredito=tmp.solicitudscc and error=0 )
from tmpcredsmotivofaltaid tmp
join dbo.det_amortizacion d With(Nolock) On d.solicitudscc=tmp.solicitudscc and d.fecha = tmp.fecha
Inner Join dbo.creditos c On c.NumCredito = d.solicitudscc And c.TipoCredito In ('PA','CV')
Where ISNULL(d.IDRegistroSicom,0) = 0 And d.estatus = 14 
and tmp.totalregistrosok is null and tmp.totaldetamort is null 



set transaction isolation level read uncommitted 
select tmp.*
,(select SUM(pagodec) from det_amortizacion det with(nolock) where det.solicitudscc=tmp.solicitudscc and estatus='14' )
,(select SUM(importe) from RegistrosSicomOK rsok with(nolock) where rsok.numcredito=tmp.solicitudscc and error=0 )
from tmpcredsmotivofaltaid tmp
join dbo.det_amortizacion d With(Nolock) On d.solicitudscc=tmp.solicitudscc and d.fecha = tmp.fecha
Inner Join dbo.creditos c On c.NumCredito = d.solicitudscc And c.TipoCredito In ('PA','CV')
Where ISNULL(d.IDRegistroSicom,0) = 0 And d.estatus = 14 
and tmp.totalregistrosok is null and tmp.totaldetamort is null 
