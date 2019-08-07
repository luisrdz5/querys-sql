

/*
inicializar tablas 

*/

/*


tabla donde estan los passwords para la app 
zonaSSH 



truncate table tblCobrosDirectos
truncate table tblCargosE19
truncate table tblAdeudosDocumentados

update vcreditos
set estatus = 0, mensaje = NULL, fechaproceso = NULL
where estatus not in ('0')
*/




--creditos a procesar 	
	select *
	from vcreditos
	where estatus in ('0')
	
/*
Obtener informacion de creditos procesados 

select * from tblCobrosDirectos where RPU = '331001038024'
select * from tblCargosE19 where RPU = '331001038024'
select * from tblAdeudosDocumentados where RPU = '331001038024'

*/

select * from tblCobrosDirectos where RPU = '052140405388'
select * from tblCargosE19 where RPU = '052140405388'
select * from tblAdeudosDocumentados where RPU = '052140405388'