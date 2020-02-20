update  c
set c.codregion=cl.codRegion, c.codcoord=cl.codCoord
FROM Sircanac.dbo.creditos c WITH (NOLOCK)
LEFT JOIN SircaNac.dbo.clientes cl WITH (NOLOCK) ON cl.RPU = c.RPU
WHERE c.TipoCredito = 'PA' AND (c.CodCoord Is Null Or c.CodRegion Is Null) 