/****** Script for SelectTopNRows command from SSMS  ******/
SELECT COUNT(*)
--, fechaliquidacion
--,(select min(FVencimientoOpFin) from det_amortizacion where solicitudscc=a.numcredito and RAPOpFin = 1)
--,DATEDIFF(dd,fechaliquidacion,(select min(FVencimientoOpFin) from det_amortizacion where solicitudscc=a.numcredito and RAPOpFin = 1))
  FROM [SircaNac].[dbo].[tmpLAJul2019] a 
  where tipocredito not in (
  'RF','AA'
  )
  order by DATEDIFF(dd,fechaliquidacion,(select min(FVencimientoOpFin) from det_amortizacion where solicitudscc=a.numcredito and RAPOpFin = 1)) DESC
  
  
  
  
  SELECT 
  a.numcredito, a.tipocredito, a.fechaliquidacion ,d.fechavencimiento
  , DATEDIFF(dd,fechaliquidacion,d.fechavencimiento)
--  sum(case when )) < -240 then 1 else 0 end)
 -- ,sum(case when (DATEDIFF(dd,fechaliquidacion,(select min(FVencimientoOpFin) from det_amortizacion where solicitudscc=a.numcredito and RAPOpFin = 1))) > -240 and (DATEDIFF(dd,fechaliquidacion,(select min(FVencimientoOpFin) from det_amortizacion where solicitudscc=a.numcredito and RAPOpFin = 1))) <= -120  then 1 else 0 end)
  FROM [SircaNac].[dbo].[tmpLAJul2019] a 
  join (
  select solicitudscc, min(FVencimientoOpFin) as fechavencimiento from det_amortizacion where RAPOpFin = 1 group by solicitudscc
  )as d  on d.solicitudscc = a.numcredito
  where tipocredito not in (
  'RF','AA'
  )
  order by DATEDIFF(dd,fechaliquidacion,d.fechavencimiento) desc
  
  
  
  
    SELECT 
  sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-240 then 1 else 0 end ) as "menos de -240 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-240 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-120 then 1 else 0 end ) as "mas de -240 y menos de -120 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-120 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-90 then 1 else 0 end ) as "mas de -120 y menos de -90 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-90 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-60 then 1 else 0 end ) as "mas de -90 y menos de -60 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-60 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-30 then 1 else 0 end ) as "mas de -60 y menos de -30 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-30 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=0 then 1 else 0 end ) as "mas de -30 y menos de -0 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >0 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=30 then 1 else 0 end ) as "mas de 0 y menos de 30 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >30 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=60 then 1 else 0 end ) as "mas de 30 y menos de 60 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >60 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=90 then 1 else 0 end ) as "mas de 60 y menos de 90 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >90 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=120 then 1 else 0 end ) as "mas de 90 y menos de 120 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >120 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=240 then 1 else 0 end ) as "mas de 120 y menos de 240 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >240  then 1 else 0 end )      as "mas de 240"
  FROM [SircaNac].[dbo].[tmpLAJul2019] a 
  join (
  select solicitudscc, min(FVencimientoOpFin) as fechavencimiento from det_amortizacion where RAPOpFin = 1 group by solicitudscc
  )as d  on d.solicitudscc = a.numcredito
  where tipocredito not in ('RF','AA')
  
  
  
  
  
  
  
      SELECT 
    tipocredito,
  sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-240 then 1 else 0 end ) as "mas de 240 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-240 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-120 then 1 else 0 end ) as "mas de 240 y menos de 120 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-120 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-90 then 1 else 0 end ) as "mas de 120 y menos de 90 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-90 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=-30 then 1 else 0 end ) as "mas de 90 y menos de 30"
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >-30 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=0 then 1 else 0 end ) as "mas de 30 y menos de 0 "
  ,sum(case when ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) >0 and ISNULL(DATEDIFF(dd,fechaliquidacion,d.fechavencimiento),0) <=30 then 1 else 0 end ) as "0 a 30 dias antes del vencimiento"
  FROM [SircaNac].[dbo].[tmpLAJul2019] a 
  join (
  select solicitudscc, min(FVencimientoOpFin) as fechavencimiento from det_amortizacion where RAPOpFin = 1 group by solicitudscc
  )as d  on d.solicitudscc = a.numcredito
  where tipocredito not in ('RF','AA')
  group by tipocredito