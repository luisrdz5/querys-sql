/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *

  FROM [SircaNac].[dbo].[clientes]
  where nombre='QUIMICA ESPECIALIZADA DARR SA'
  
  /****** Script for SelectTopNRows command from SSMS  ******/
SELECT COUNT(*)
  FROM [SircaNac].[dbo].clientes_lechon
  
  /*  

  
  
  
  update cl
  set cl.nombre = cll.nombre
  from clientes cl 
  join [SircaNac].[dbo].clientes_lechon cll on cl.RPU=cll.rpu 
  
  */