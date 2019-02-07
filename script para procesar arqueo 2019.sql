
SELECT * 
  FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]
  where IdCtrlArqueo='1'  and Estatus=1
  and FechaFac <> '00000000' and Importe> 0 





  
 iNSERT INTO [CargaDiariaFechaarqueo]  
          (  
         linea,fecha,fechaarchivo,archivo,idarqueo,listo,error  
         )  
      select  LINEA = '0000000000|'+RPU+'|'+mot+'|'+suf+'|'+fechafac+'|'+FECHAVEN+  
                       '|'+right('            '+convert(varchar,Importe),12)+  
                       '|'+ '01'+'|1|'+FECHApago+'|'+AñoFac+'|'+ MesFac+'|',  
               FECHA = GETDATE(),  
               fechaarchivo=GETDATE(),  
             ARCHIVO = 'ARQUEFIDE2019',  
             IDarqueo,0,0  
        FROM [SOF_SircaNac].[HISTORICO].[ARQUEO]  
         
WHERE  fechafac <> '000000' AND ISDATE(FECHApago) = 1 
         order by IDarqueo  