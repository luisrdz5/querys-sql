-- busco referencias duplicadas y las inserto en tabla temporal 

SELECT [Cliente]
      ,[NombreCliente]
      ,[Proyecto]
      ,[Region]
      ,[Archivo]
      ,[Fecha]
  into #tmp 
  FROM [SircaNac].[dbo].[satreferencias]
  group by [Cliente]
      ,[NombreCliente]
      ,[Proyecto]
      ,[Region]
      ,[Archivo]
      ,[Fecha]
      having COUNT(*) >1 
      

-- elimino referencias duplicadas 
delete
from  satreferencias    
where cliente in ( 
 SELECT [Cliente]
  FROM [SircaNac].[dbo].[satreferencias]
  group by [Cliente]
      ,[NombreCliente]
      ,[Proyecto]
      ,[Region]
      ,[Archivo]
      ,[Fecha]
      having COUNT(*) >1 
)

-- reinserto referencias almacenadas en tmp 
INSERT INTO [SircaNac].[dbo].[satreferencias]
           ([Cliente]
           ,[NombreCliente]
           ,[Proyecto]
           ,[Region]
           ,[Archivo]
           ,[Fecha])
           
select [Cliente]
           ,[NombreCliente]
           ,[Proyecto]
           ,[Region]
           ,[Archivo]
           ,[Fecha]
from #tmp           
