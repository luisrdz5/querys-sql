select '2018-12-01 01:00:00.000',* 
from pagos
where FINSERT  > convert(date,'20181130') and finsert < convert(date,'20181201')
order by FINSERT desc

update pagos 
set FINSERT='2018-12-01 01:00:00.000'
where FINSERT  > convert(date,'20181130') and finsert < convert(date,'20181201')
and id='51672000'

select *
from pagos
where FINSERT='2018-12-01 01:00:00.000'