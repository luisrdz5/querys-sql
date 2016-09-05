select *
from coordinaciones
where codRegion in ('VN','VC','VS')
order by codregion


select top 100 *
from usuarios_final
where codRegion in ('VN','VC','VS')

/*

-- query para updatear los clientes 

update cliente 
set codregion=''  , codcoord='' 
where codregion='' and codcoord='' 

--query para updatear los creditos   -- aunque aun no funciona  
update creditos
set id_coordinacion='', codregion='', codcoord=''
where codcoord='' and codregion='' 

--query para updatear los usuarios 

update usuarios_final 
set codregion=''  , codcoord='' 
where codregion='' and codcoord='' 



*/