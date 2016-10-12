select *
from coordinaciones
where codRegion in ('VN','VC','VS')
order by codregion


select top 100 *
from usuarios_final
where codRegion in ('VN','VC','VS')

/*

-- query para updatear los clientes 
update clientes set codregion='MV', codcoord='VC' where codregion='VC' and codcoord='CH' 
update clientes set codregion='MV', codcoord='VC' where codregion='VC' and codcoord='PO' 
update clientes set codregion='MV', codcoord='NR' where codregion='VN' and codcoord='TL' 
update clientes set codregion='MV', codcoord='NR' where codregion='VN' and codcoord='CI' 
update clientes set codregion='MV', codcoord='NR' where codregion='VN' and codcoord='EC' 
update clientes set codregion='MV', codcoord='NR' where codregion='VN' and codcoord='NC' 
update clientes set codregion='MV', codcoord='TO' where codregion='VS' and codcoord='AT' 
update clientes set codregion='MV', codcoord='VC' where codregion='VS' and codcoord='IZ' 
update clientes set codregion='MV', codcoord='TO' where codregion='VS' and codcoord='TO' 
update clientes set codregion='MV', codcoord='VC' where codregion='VS' and codcoord='UN' 


--query para updatear los creditos   -- aunque aun no funciona  
update creditos set codregion='MV',codcoord='VC',  id_coordinacion='112' where codregion='VC'  and codcoord='CH'
update creditos set codregion='MV',codcoord='VC',  id_coordinacion='112' where codregion='VC'  and codcoord='PO'
update creditos set codregion='MV',codcoord='NR',  id_coordinacion='115' where codregion='VN'  and codcoord='TL'
update creditos set codregion='MV',codcoord='NR',  id_coordinacion='115' where codregion='VN'  and codcoord='CI'
update creditos set codregion='MV',codcoord='NR',  id_coordinacion='115' where codregion='VN'  and codcoord='EC'
update creditos set codregion='MV',codcoord='NR',  id_coordinacion='115' where codregion='VN'  and codcoord='NC'
update creditos set codregion='MV',codcoord='TO',  id_coordinacion='119' where codregion='VS'  and codcoord='AT'
update creditos set codregion='MV',codcoord='VC',  id_coordinacion='112' where codregion='VS'  and codcoord='IZ'
update creditos set codregion='MV',codcoord='TO',  id_coordinacion='119' where codregion='VS'  and codcoord='TO'
update creditos set codregion='MV',codcoord='VC',  id_coordinacion='112' where codregion='VS'  and codcoord='UN'


--query para updatear los usuarios 
update usuarios_final set codregion='MV'  , codcoord='VC' where codregion='VC' and codcoord='CH' 
update usuarios_final set codregion='MV'  , codcoord='VC' where codregion='VC' and codcoord='PO' 
update usuarios_final set codregion='MV'  , codcoord='NR' where codregion='VN' and codcoord='TL' 
update usuarios_final set codregion='MV'  , codcoord='NR' where codregion='VN' and codcoord='CI' 
update usuarios_final set codregion='MV'  , codcoord='NR' where codregion='VN' and codcoord='EC' 
update usuarios_final set codregion='MV'  , codcoord='NR' where codregion='VN' and codcoord='NC' 
update usuarios_final set codregion='MV'  , codcoord='TO' where codregion='VS' and codcoord='AT' 
update usuarios_final set codregion='MV'  , codcoord='VC' where codregion='VS' and codcoord='IZ' 
update usuarios_final set codregion='MV'  , codcoord='TO' where codregion='VS' and codcoord='TO' 
update usuarios_final set codregion='MV'  , codcoord='VC' where codregion='VS' and codcoord='UN' 


-- query para updatear la tabla de zonas ( se ocupa para los cambios de rpu )
update zonas set codregion='MV', codcoord='VC' where codregion='VC' and codcoord='CH' 
update zonas set codregion='MV', codcoord='VC' where codregion='VC' and codcoord='PO' 
update zonas set codregion='MV', codcoord='NR' where codregion='VN' and codcoord='TL' 
update zonas set codregion='MV', codcoord='NR' where codregion='VN' and codcoord='CI' 
update zonas set codregion='MV', codcoord='NR' where codregion='VN' and codcoord='EC' 
update zonas set codregion='MV', codcoord='NR' where codregion='VN' and codcoord='NC' 
update zonas set codregion='MV', codcoord='TO' where codregion='VS' and codcoord='AT' 
update zonas set codregion='MV', codcoord='VC' where codregion='VS' and codcoord='IZ' 
update zonas set codregion='MV', codcoord='TO' where codregion='VS' and codcoord='TO' 
update zonas set codregion='MV', codcoord='VC' where codregion='VS' and codcoord='UN' 





*/


select *
from coordinaciones where codRegion='MV'

select top 10 *
from creditos
where codRegion in ('VN','VC','VS')

select *
from zonas
where codRegion in ('VN','VC','VS')
where codregion='VC' and codcoord='CH' 