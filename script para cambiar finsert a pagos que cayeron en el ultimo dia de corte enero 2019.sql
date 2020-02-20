select '2019-01-01 01:00:00.000', p.FINSERT,* 
from pagos p
where p.FINSERT  > convert(date,'20181228') and p.finsert < convert(date,'20190101')
order by p.FINSERT desc

update pagos 
set FINSERT='2019-01-01 01:00:00.000'
where FINSERT  > convert(date,'20181228') and finsert < convert(date,'20190101')


select *
from pagos
where FINSERT='2019-01-01 01:00:00.000'