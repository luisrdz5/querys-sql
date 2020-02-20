--obtenemos usuarios peef duplicados y los metemos a tabla temporal tmp

select  usuario ,Password,Nombre
into #tmp
from usuarios_peef_clientes
group by usuario ,Password,Nombre
having COUNT(*) > 1 

-- eliminamos usuarios peef duplicados 

delete
from usuarios_peef_clientes
where usuario in (
select  usuario
from usuarios_peef_clientes
group by usuario ,Password,Nombre
having COUNT(*) > 1 
)


-- reinsertamos usuarios desde la tabla tmp

INSERT INTO [SircaNac].[dbo].[usuarios_peef_clientes]
           ([Usuario]
           ,[Password]
           ,[Nombre]
           ,[correoElectronico]
           ,[Region]
           ,[ZONA]
           ,[email])
select  usuario ,Password,Nombre
,NULL as correoElectronico
,NULL as Region
,NULL as ZONA
,NULL as email
from #tmp