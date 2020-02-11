/****** Script for SelectTopNRows command from SSMS  ******/
SELECT r.*, p.Importe, p.idregistrosicom
  FROM [SircaNac].[dbo].[RegistrosSicomOK] r
  join [SircaNac].[dbo].pagos p on p.numcredito=r.Numcredito and p.fechapago=r.FechaPago and p.Importe=r.importe
  where fecha > '20191014' and p.IDRegistroSicom=0
  
  
  update p
  set  p.IDRegistroSicom= r.ID 
  from [SircaNac].[dbo].pagos p
  join [SircaNac].[dbo].[RegistrosSicomOK] r on p.numcredito=r.Numcredito and p.fechapago=r.FechaPago and p.Importe=r.importe
   where r.fecha > '20191014' and p.IDRegistroSicom=0