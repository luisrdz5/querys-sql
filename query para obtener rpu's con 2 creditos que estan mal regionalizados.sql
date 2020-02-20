select  cl.rpu, cl.codregion, cl.codcoord, COUNT(*)
from creditos cl
where cl.rpu in (
	select c.rpu
	from creditos c 
	group by c.rpu 
	having COUNT(*) > 1 
	)
group by  cl.rpu, cl.codregion, cl.codcoord
having COUNT(*) = 1 
order by rpu 

