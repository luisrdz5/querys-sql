/****** Script for SelectTopNRows command from SSMS  ******/
SELECT a.IdCtrlArqueo,c.Archivo,sum(Importe), a.Descripcion
  FROM [SOF_SircaNac].[HISTORICO].[ARQUEO] a
  join [SOF_SircaNac].[dbo].[Control_ARQUEO] c on c.ID=a.IdCtrlArqueo
  where Descripcion = 'PFAEE' and a.IdCtrlArqueo not in ('26')
  group by c.Archivo, a.Descripcion, a.IdCtrlArqueo
  order by IdCtrlArqueo