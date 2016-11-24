INSERT INTO [SIRCANAC].[dbo].[historicocartera_Netro]
           ([codRegion]
           ,[codCoord]
           ,[cartera]
           ,[rpu]
           ,[credito]
           ,[zona]
           ,[agencia]
           ,[estatus]
           ,[vtonumamortizacion]
           ,[vtoadeudo]
           ,[vtodias]
           ,[id_coordinacion])
		select 
			[codRegion]
           ,[codCoord]
           ,[cartera]
           ,[rpu]
           ,[credito]
           ,[zona]
           ,[agencia]
           ,[estatus]
           ,[vtonumamortizacion]
           ,[vtoadeudo]
           ,[vtodias]
           ,[id_coordinacion]
		from  LNK26.sircanac.dbo.historicocartera_Netro
		where  cartera = '201610' 


