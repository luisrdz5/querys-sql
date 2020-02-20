	
	
select 
	region, 
	SUM([montoTotalAdeudado]) as total_monto_adeudado, 
	SUM([montoAtraso]) as monto_en_atraso  , 
	((SUM([montoAtraso]) * 100)/SUM(montoTotalAdeudado)) as porcentaje_por_region
from porcentajesZonas
group by region