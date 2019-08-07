--14782
SELECT a.*
FROM [SOF_SircaNac].[HISTORICO].[ARQUEO] a
left join SircaNac.dbo.pagos p on (p.NumCredito=a.numcredito or Convert(numeric(30,0),p.RPU)=Convert(numeric(30,0),a.RPU) ) and a.FechaPago=p.FechaPago
where IdCtrlArqueo in ('3','4','9','11','12')
and a.numcredito not in ('000000000')
and p.FechaPago is null
and a.Importe > 0
and a.numcredito not in 
(
select numcredito
from sircanac.dbo.creditos
where eSTATUSCREDITO  IN (8,9,25,92)
)
order by a.Importe DESC





select *
from SircaNac.dbo.pagos p 
where 
Rpu='259991000996'
--NumCredito='919214728'
order by Fechapago desc

SELECT *
FROM [SOF_SircaNac].[HISTORICO].[ARQUEO] a
where IdCtrlArqueo in ('3','4','9','11','12')
and a.numcredito not in ('000000000')