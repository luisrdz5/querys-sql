select cl.codRegion ,cl.codCoord,  COUNT(*) "llamadas telefonicas", YEAR(fechagestion) año, MONTH(fechagestion) mes
from gestioninterna g
join clientes cl on cl.RPU=g.RPU
where fechagestion > '20160601'
group by cl.codRegion,cl.codCoord, YEAR(fechagestion), MONTH(fechagestion)



