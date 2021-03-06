/*
Calculo los pagos procesados y los que no que fueron insertados en la tabla de arqueo


*/

SELECT 
sum(case when procesado= 1  then 1 else 0 end ) as "Enviados a Aplicar",
sum(case when procesado= 1  then importe else 0 end ) as "Importe Enviados a Aplicar",
sum(case when procesado= 2  then 1 else 0 end ) as "No tiene numero de credito",
sum(case when procesado= 2  then importe else 0 end ) as "Importe No tiene numero de credito",
sum(case when procesado= 3  then 1 else 0 end ) as "fecha facturacion invalida",
sum(case when procesado= 3  then Importe else 0 end ) as "importe fecha facturacion invalida",
sum(case when procesado= 4  then 1 else 0 end ) as "importe cero",
sum(case when procesado= 4  then Importe  else 0 end ) as "importe pagos con importe cero",
sum(case when procesado= 5  then 1 else 0 end ) as "estatus diferente a 1",
sum(case when procesado= 5  then Importe else 0 end ) as "Importe estatus diferente a 1"
FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]
where IdCtrlArqueo = '18'

/*
Se obtienen las estadisticasz de aplicacion de los pagos en registrossicomok

*/

SELECT   r.Error, cat.Descripción, SUM(r.importe), COUNT(*) 
FROM [SOF_SircaNac].[HISTORICO].[ARQUEO] a
join SircaNac.dbo.CargaDiariaFecha c on c.IdArqueo=a.IdArqueo
left join SircaNac.dbo.RegistrosSicomOK r on r.IDCargaDiariaFecha=c.ID
left join SircaNac.dbo.Catalogo_Errores cat on cat.Error=r.Error
where IdCtrlArqueo = '18'
group by r.Error, cat.Descripción







/*
select procesado, COUNT(*)
FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]
where IdCtrlArqueo = '18'
group by procesado

*/