/*
Calculo los pagos procesados y los que no que fueron insertados en la tabla de arqueo


*/

SELECT 
COUNT(*) as "Total Enviados",
SUM(Importe) as "Importe Total",
sum(case when procesado= 1  then 1 else 0 end ) as "Enviados a Aplicar",
sum(case when procesado= 1  then importe else 0 end ) as "Importe Enviados a Aplicar",
sum(case when procesado= 2  then 1 else 0 end ) as "No tiene numero de credito",
sum(case when procesado= 2  then importe else 0 end ) as "Importe No tiene numero de credito",
sum(case when procesado= 3  then 1 else 0 end ) as "fecha facturacion invalida",
sum(case when procesado= 3  then Importe else 0 end ) as "importe fecha facturacion invalida",
sum(case when procesado= 4  then 1 else 0 end ) as "importe cero",
sum(case when procesado= 4  then Importe  else 0 end ) as "importe pagos con importe cero",
sum(case when procesado= 5 and Estatus = '91' then 1 else 0 end ) as "prepagos",
sum(case when procesado= 5 and Estatus = '91' then Importe else 0 end ) as "Importe prepagos",
sum(case when procesado= 5 and Estatus = '00' then 1 else 0 end ) as "estatus 0",
sum(case when procesado= 5 and Estatus = '00' then Importe else 0 end ) as "Importe estatus 0",
sum(case when procesado= 5 and Estatus = '02' then 1 else 0 end ) as "estatus 2",
sum(case when procesado= 5 and Estatus = '02' then Importe else 0 end ) as "Importe estatus 2",
sum(case when procesado= 5 and Estatus not in ('02','91','00') then 1 else 0 end ) as "estatus desconocidos",
sum(case when procesado= 5 and Estatus not in ('02','91','00') then Importe else 0 end ) as "Importe estatus desconocidos",
sum(case when procesado= 6  then 1 else 0 end ) as "Fecha Vencimiento Invalida",
sum(case when procesado= 6  then Importe else 0 end ) as "Importe Fecha Vencimiento Invalida"
FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]
where IdCtrlArqueo in ('27')

/*
Se obtienen las estadisticas de aplicacion de los pagos en registrossicomok

*/
set transaction isolation level read uncommitted
SELECT   
r.Error
, cat.Descripción
, SUM(r.importe)
, COUNT(*) 
, r.Procesado
FROM [SOF_SircaNac].[HISTORICO].[ARQUEO] a
join SircaNac.dbo.CargaDiariaFecha c on c.IdArqueo=a.IdArqueo
left join SircaNac.dbo.RegistrosSicomOK r on r.IDCargaDiariaFecha=c.ID
left join SircaNac.dbo.Catalogo_Errores cat on cat.Error=r.Error
where IdCtrlArqueo in ('27')
group by r.Error, cat.Descripción,  r.Procesado















/* Se obtienen aplicaciones en sirca deben coincidir */ 

select *
from  SircaNac.dbo.pagos 
where FINSERT > '20190625' and StoreusadoSQL='spAplicaPagoRegistrosSicomOK'






/*
select procesado, COUNT(*)
FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]
where IdCtrlArqueo = '18'
group by procesado

*/