from bs4 import BeautifulSoup
import urllib2 
import requests
import urlparse
import csv

matrizUsuarios = [
    ["JDJRCRPU","jose63122428.","CR","1"],
    ["GAVAOJ","crsgvo","SR", "2"],
    ["LMBCR","QAZWSX123","NO","3"],
    ["ISSCRTX","zonatlaxcala","CR","4"],
    ["HJCRA","ialvani2","NO","5"],
    ["SSNO01","SSNO01","NO","6"],
    ["SLGNAA","g2A7A1","BC","7"],
    ["jack","jack","MT","8"],
    ["MEZURC","tamara04","MT","9"],
    ["RPCCOZM","RPCCOZM16","CO","12"],
    ["MYFLORA","Myflora07","GN","13"],
    ["FLACRPU","FERled01","CR","14"],
    ["VELAPSI","VELAPSI","BC","15"],
    ["CALLLOHIR","calllohir","MT","17"],
    ["ASRFID","ASR01","MT","18"],
    ["RGFRAG","RGFRAG.","MT","19"]
]
usuario = "JDJRCRPU"
password = "jose63122428."
region = "CR"
baseURL = "http://10.55.210.38/sircanac_v4/"

Pages = [
"administracion/grabaDatosCliente.php",
"administracion/modificaDatosCliente.php",
"administracion/pideDatosCliente.php",
"CLMcreditos/datosConvenio.php",
"CLMcreditos/datosCredito.php",
"CLMcreditos/detallepagos.php",
"CLMcreditos/historicoMovtoe19.php",
"CLMcreditos/pagosoriginalesCFE.php",
"CLMcreditos/ConsultaClientes.php",
"CLMcreditos/creditosCliente.php",
"index.php",
"CLMcreditos/pagosAnticipados.php",
"CLMcreditos/SolicitudesPagoAnticipado.php",
"CLMcreditos/calculopagoanticipadoespecial.php",
"CLMcreditos/edocuentacredito.php",
"CLMcreditos/generapagosoriginalesCFE.php",
"CLMcreditos/datosCredito_pdf.php",
"CLMcreditos/datosCredito_pdf_firma.php",
"CLMcreditos/PdfOficiopagoAnticipadoEspe.php",
"CLMcreditos/BuscaClientePorRN.php",
"CLMcreditos/ClienteCreditos.php",
"CLMcreditos/SeleccionarAmortizacionesMoratorias.php",
"CLMcreditos/validaSeleccion.php",
"CLMcreditos/generaPDFMoritarios.php",
"CLMcreditos/grabaSolFIDEespe.php",
"CLMcreditos/solicitudPdteLiqAnticipada.php",
"CLMcreditos/filtroRefereFide.php",
"CLMcreditos/reportesolicitudespa.php",
"CLMcreditos/CapturaMovimientosRPU.php",
"CLMcreditos/movtoCapturaReferenciaLA.php",
"CLMcreditos/movtoCambioDomws.php",
"CLMcreditos/grabaDomicilio.php",
"CLMcreditos/PDFcartaCambioDom.php",
"CLMcreditos/validaRPUCFE.php",
"CLMcreditos/movtoCorreccionCargosws.php",
"CLMcreditos/movtoCambioDomwsdf.php",
"CLMcreditos/PassCambioDom.php",
"CLMcreditos/movtoCambioDomwsdd.php",
"CLMcreditos/SolicitudesPagoAnticipado_Finalizar.php",
"CLMcreditos/RecepcionMovimientosCFE.php",
"CLMcreditos/RecibioCambioDom.php",
"CLMcreditos/RecibioReferenciaPA.php",
"CLMcreditos/RecibioCorreccionCargos.php",
"CLMcreditos/RecibioCambioDomdf.php",
"CLMcreditos/RecibioCambioDomdd.php",
"CLMcreditos/liquidacionventanilla.php",
"CLMcreditos/listatraspasosorigen.php",
"CLMcreditos/SeleccionaReactivacion.php",
"CLMcreditos/reactivacioncargos.php",
"CLMcreditos/reactivaciondeudor.php",
"CLMcreditos/vertraspasodestino.php",
"CLMcreditos/checatraspaso.php",
"CLMcreditos/detalletraspaso.php",
"CLMcreditos/ValidaMovimientosRPU.php",
"CLMcreditos/ValidaCambioDom.php",
"CLMcreditos/ValidaReferenciaPA.php",
"CLMcreditos/ValidaCambioDomdf.php",
"CLMcreditos/pideDatosClienteAut.php",
"administracion/pideDatosCliente2.php",
"administracion/modificaDatosClientes.php",
"CLMcreditos/creditosDudosos.php",
"CLMcreditos/CancelaMovimientosRPU.php",
"CLMcreditos/solicitudesautomaticas.php",
"CLMcreditos/RecibioCambioDomdd.php",
"CLMcreditos/Excepciones.php",
"CLMcreditos/Excepcionesliq.php",
"gestion/ConsultaClientesConvenio.php",
"gestion/ConsultaClientesConvenioEspecial.php",
"gestion/creditosClienteConvenioEspecial.php",
"gestion/convenio5(RAP).php",
"gestion/creditosClienteConvenio.php",
"gestion/convenioCE.php",
"gestion/convenioRAP3.php",
"gestion/convenioRAP.php",
"gestion/convenio4.php",
"gestion/calculaAmortizacionRAP5.php",
"gestion/calculaAmortizacion4.php",
"gestion/calculaAmortizacionRAP3.php",
"gestion/calculaAmortizacionRAP.php",
"gestion/fichadeposito.php",
"clases/calculoReferencia.php",
"gestion/vistaImpreConvenioCARGOEXTRA_1.php",
"gestion/vistaImpreConvenioESPECIAL_5.php",
"gestion/vistaImpreConvenioRAP.php",
"gestion/vistaImpreConvenioRAP3.php",
"gestion/vistaImpreConvenioRAPCONTRASPASO_3.php",
"gestion/vistaImpreConvenioRAPDEVENGADO_4.php",
"gestion/generaTAconvenioCE.php",
"gestion/pagoanticipoconvenio.php",
"gestion/detalleconveniopago.php",
"gestion/capturapagoConvenio.php",
"gestion/pendientesImpresionConvenios.php",
"gestion/previoimpreconvenioTD.php",
"gestion/vistaImpreConvenioTD.php",
"gestion/previoimpreconvenioRAP.php",
"gestion/vistaImpreConvenioRAP.php",
"gestion/impresionConvenioRAP3.php",
"gestion/vistaImpreConvenioRAP3.php",
"gestion/fichadepositoparcialidades.php",
"gestion/imprimeconvenio1.php",
"gestion/convenio1vistaimp.php",
"gestion/cancelacionconvenio.php",
"CLMcreditos/seguimientoNoFacturado.php",
"CLMcreditos/CreditosNoFacturados.php",
"gestion/filtroRecupera.php",
"gestion/filtroCobranzaNac.php",
"gestion/Rep_RecuperacionZona.php",
"gestion/Rep_RecuperacionNac.php",
"gestion/combo_capturaGestionLlamada.php",
"gestion/GestionLlamada.php",
"gestion/generacionPDFCartas.php",
"gestion/getzona.php",
"gestion/sepomexppal.php",
"gestion/rpuencuestaCobranza.php",
"gestion/generaExcelGestion.php",
"gestion/pideDatosAvalNotificacion.php",
"gestion/validaCartasEspeciales.php",
"gestion/generacionPDFCartasEspecial.php",
"gestion/estadodeCuenta.php",
"gestion/historicoGestion.php",
"reportes/reportegestion.php",
"reportes/ajax_coord_rezago.php",
"reportes/reportegestioncsv.php",
"reportes/ReporteLiqAntPorCerrar.php",
"reportes/genereLiqAntPorCerrarExcel.php",
"reportes/ReporteLiqAntPorCerrar_det.php",
"reportes/genereLiqAntPorCerrar_detExcel.php",
"reportes/ajax_coord.php",
"reportes/filtroComparativo.php",
"reportes/reporteComparativo.php",
"reportes/reporteDetalleComparativo.php",
"reportes/generaComparaDetExcel.php",
"reportes/generaComparativoExcel.php",
"reportes/filtroCartera.php",
"reportes/reporteCarteraCoord.php",
"reportes/reporteDetCarteraAgencia.php",
"reportes/filtroRezagos.php",
"reportes/reporteRezagos.php",
"reportes/filtroIndiceAtencion.php",
"reportes/reporteIndiceAtencion.php",
"reportes/filtroTiposMovimiento.php",
"reportes/reporteDetalleTipoMovto1.php",
"reportes/reporteDetalleTipoMovto2.php",
"reportes/reporteDetalleTipoMovto3.php",
"reportes/reporteDetalleTipoMovto4.php",
"reportes/reporteDetalleTipoMovto5.php",
"reportes/filtroCreditos.php",
"reportes/todasreg.php",
"reportes/reporteCreditos.php",
"reportes/reporteCobranzaRegional.php",
"reportes/reporteDetCarteraCre.php",
"reportes/generaDetCarteraExcelAgencia.php",
"reportes/generaDetCarteraCredExcel.php",
"reportes/generaDetCarteraExcel.php",
"reportes/filtroCobranza.php",
"reportes/reporteCobranza.php",
"reportes/reporteFechaActualizacion.php",
"reportes/ReporteRecuperacion.php",
"reportes/post-xmlReporteRecuperacionExcel.php",
"reportes/post-xmlReporteRecuperaciondetalletotalcreditosExcel.php",
"reportes/post-xmlReporteRecuperacion.php",
"reportes/ReporteRecuperaciondetalle.php",
"reportes/ReporteIndiceCarteraVencida.php",
"reportes/post-xmlReporteIndiceCarteraVencidaExcel.php",
"reportes/post-xmlReporteIndiceCarteraVencida.php",
"reportes/ReporteIndiceCarteraVencidaGlobal.php",
"reportes/quebrantos2.php",
"reportes/reportee19.php",
"reportes/reportee19csv.php",
"administracion/catalogo_perfiles.php",
"administracion/catalogo_opcperfil.php",
"administracion/catusuarios.php",
"CLMcreditos/AgregaModiPagos.php",
"administracion/filtrorechazo.php",
"administracion/usuarios_v.php",
"appPagosRechazados.php",
"appAplicaPagos.php",
"ppVerPagosRechazados.php"
] 

#Pages = [
#"reportes/post-xmlReporteRecuperacionExcel.php",
#] 

#matrizUsuarios = [
#    ["ISSCRTX","zonatlaxcala","CR","4"],
#     ["jack","jack","MT","8"]
#]

def procesarUsuarios():
    Arreglo = []
    ArregloCompleto = []
    xlsArray = []
    URL = baseURL + "index.php"
    #URL2 =  baseURL + "verificaacceso.php?nick=" + userString + "&idRegional=" + regional + "&cmbp=1"
    URL3 =  baseURL + "bienvenida.php"
    #URL4 =  baseURL + "CLMcreditos/datosConvenio.php"
    i=0
    myFile = open('example2.csv', 'w')
    with myFile:
        writer = csv.writer(myFile)
        Header = [["Descripcion","1","2","3","4","5","6","7","8","9","12","13","14","15","17","18","19"]]
        writer.writerows(Header)
        for page in Pages:
            pagina =  baseURL + page
            #print "procesando pagina: " + pagina
            Arreglo.append(pagina)
            for usuario in matrizUsuarios:
                payload = {
                    "txtusuario": usuario[0], 
                    "txtpassword": usuario[1],
                    "aceptar_x": "si"
                }
                URL2 =  baseURL + "verificaacceso.php?nick=" +  usuario[0] + "&idRegional=" + usuario[2] + "&cmbp=1"
                #print "perfil: " + usuario[3]
                variable = evaluarPagina(pagina, payload,URL , URL2, URL3 )
                #print "variable: " + variable
                Arreglo.append(variable)
            xlsArray.append(Arreglo)
            writer.writerows(xlsArray)
            print str(xlsArray)[1:-1] 
            del xlsArray[:]
            del Arreglo[:]
        ArregloCompleto.append(xlsArray)
        #del Arreglo[:]
    print("Writing complete")



def procesoAnterior(userString, passString, regional):

    print "---------------------Script para verificacion de seguridad de sitio web sirca -----------------------------------"
    print "-    Se inicia la validacion de las paginas con el usuario:" + userString
    print "-----------------------------------------------------------------------------------------------------------------"

    URL = baseURL + "index.php"
    URL2 =  baseURL + "verificaacceso.php?nick=" + userString + "&idRegional=" + regional + "&cmbp=1"
    URL3 =  baseURL + "bienvenida.php"
    #URL4 =  baseURL + "CLMcreditos/datosConvenio.php"

    payload = {
        "txtusuario": userString, 
        "txtpassword": passString,
        "aceptar_x": "si"
    }

    #print payload
    for page in Pages:
        print "-----------------------------------------------------------------------------------------------------------------"
        pagina =  baseURL + page
        evaluarPagina(pagina, payload,URL , URL2, URL3 )
        print "-----------------------------------------------------------------------------------------------------------------"


def evaluarPagina(URL4, payload,URL , URL2, URL3):
    with requests.Session() as session:
        post = session.post(URL, data=payload)
        #print URL4
        r = session.get(URL2)
        r = session.get(URL3)
        r = session.get(URL4)
        soup = BeautifulSoup(r.content,'html.parser')
        #print r.headers
        #print soup
        for heading in soup.find_all('b'):
            respuesta=heading.text
            #print respuesta
            if respuesta == "Acceso al sistema SIRCA":
                return "regresa a index.php"
        for heading in soup.find_all('title'):
            respuesta=heading.text
            #print "titulo:"
            #print respuesta
            if respuesta == "404 Not Found":
                return "No Encuentra la pagina" 
        #detectamos errores graves de seguridad
        if ('select' in r.content) and ('from' in r.content) and ('Error:SLC' in r.content):
            return "Se encontro problema grave de seguridad sql "
            
        for heading in soup.find_all('table'):
            respuesta=heading
            #print "encontre TD " 
            #print respuesta 
            #print len(respuesta)
            if len(respuesta) > 5:
                return "Es una pagina con contenido"
                
        for heading in soup.find_all('script'):
            respuesta=heading
            #print "encontre alert " 
            #print respuesta.text.find('alert')
            #print len(respuesta)
            if respuesta.text.find('alert') == 0:
                return "Es una pagina que solo muestra un alert"
                
        for heading in soup.find_all('div'):
            respuesta=heading
            #print "encontre TD " 
            #print respuesta 
            #print len(respuesta)
            if len(respuesta) > 5:
                return "Es una pagina con contenido"    
        try:  
            r.headers['content-disposition']
        except : 
            x = 'nada'
            #print "avanzamos a la siguiente pagina"
        else:
            if r.headers['content-disposition'].find('filename=')<> -1:
                return "regresa un archivo tipo:" + r.headers['content-disposition']
                #detectamos errores graves de seguridad
        """if ('close' in r.headers['Connection']):
            print "Se cierra la pagina inmediatamente "
            return"""

#ProcesarUsuario(usuario, password,region)


procesarUsuarios()
