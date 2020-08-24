-- Query para obtener creditos con mas amortizaciones en sac que en sirca 
--10811
--10807
--10146
select 
	(select 
	CASE 
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DA' THEN 'DA - BAJA CALIFORNIA'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DB' THEN 'DB - NOROESTE'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DC' THEN 'DC - NORTE'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DD' THEN 'DD - GOLFO NORTE'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DF' THEN 'DF - CENTRO OCCID'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DG' THEN 'DG - CENTRO SUR'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DJ' THEN 'DJ - ORIENTE'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DK' THEN 'DK - SURESTE'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DL' THEN 'DL - VALLE MEXICO NORTE'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DM' THEN 'DM - VALLE MEXICO CENTRO '
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DN' THEN 'DN - VALLE MEXICO SUR'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DP' THEN 'DP - BAJIO'	
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DU' THEN 'DU - GOLFO CENTRO'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DV' THEN 'DV - CENTRO ORIENTE'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DW' THEN 'DW - PENINSULAR'
		WHEN SUBSTRING(NUMCUENTA, 3,2) = 'DX' THEN 'DX  - JALISCO'
		ELSE 'none'
		END
	AS 	DIVISION
	from clientes 
	where rpu=c.rpu),
	c.rpu as  RPU,
	(select SUM(saldo)
	from det_amortizacion 
	where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is not null) as IMPORTE
from creditos c
where tipocredito in ('AA', 'RF') 
and 
	estatusCredito not in ('8','9','20','24','25','92') 
and 
	(select COUNT(estatus)
	from det_amortizacion
	where solicitudscc =c.numcredito and estatus <> 14) > 
	(select sum(isnull(estatusopfin,1))
	from det_amortizacion
	where solicitudscc =c.numcredito and estatusopfin is null)
and
	(select SUM(saldo)
	from det_amortizacion
	where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is null) is not null
and
	(select SUM(saldo)
	from det_amortizacion
	where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is not null) > 0
order by 
	(select SUM(saldo)
	from det_amortizacion
	where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is not null)  asc





















/*
(select sum(isnull(estatusopfin,1))
from det_amortizacion
where solicitudscc =c.numcredito and estatusopfin is null) as "amortizaciones restantes del credito",
(select COUNT(estatus)
from det_amortizacion
where solicitudscc =c.numcredito and estatus <> 14) as restan_sirca,
(select COUNT(*)
from det_amortizacion
where solicitudscc =c.numcredito and estatus <> 14 and estatusopfin is not null) as "amortizaciones pagadas en sac y no en sirca",
*/