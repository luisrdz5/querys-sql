--Query para obtener pagos a los cuales no se les pudo poner numero de credito y no tienen error en cargadiariafecha
select TOP 10000 CRE.NUMCREDITO, CRE.PagoFijo, cre.ultimaamortizacion ,cre.tipocredito, c.Importe as "importe cargadiariafecha", C.*
from CargaDiariaFecha c
JOIN creditos CRE ON CRE.RPU=C.RPU  AND CRE.tipocredito in ('FV','PA','CV') AND (C.IMPORTE = CRE.PagoFijo OR C.IMPORTE = CRE.ultimaamortizacion)
WHERE ERROR=0 AND Credito='0000000000'


--Query para obtener pagos a los cuales no se les pudo poner numero de credito y no tienen error en cargadiariafecha y no coincide ningun monto de pago 
select TOP 10000 CRE.NUMCREDITO, CRE.PagoFijo, cre.ultimaamortizacion ,cre.tipocredito, c.Importe as "importe cargadiariafecha", C.*
from CargaDiariaFecha c
JOIN creditos CRE ON CRE.RPU=C.RPU  AND CRE.tipocredito in ('FV','PA','CV') AND nOT (C.IMPORTE = CRE.PagoFijo OR C.IMPORTE = CRE.ultimaamortizacion)
WHERE ERROR=0 AND Credito='0000000000'



-- updateo de creditos agregandoles numero de credito y regresandolos al listo = 2 

update c
set c.credito = CRE.NUMCREDITO, listo=3
from CargaDiariaFecha c
JOIN creditos CRE ON CRE.RPU=C.RPU  AND CRE.tipocredito in ('FV','PA','CV') AND (C.IMPORTE = CRE.PagoFijo OR C.IMPORTE = CRE.ultimaamortizacion)
WHERE ERROR=0 AND Credito='0000000000'







select TOP 10000 CRE.NUMCREDITO, CRE.PagoFijo, cre.ultimaamortizacion ,cre.tipocredito, c.Importe as "importe cargadiariafecha", C.*
