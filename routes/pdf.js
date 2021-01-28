'use strict'

var express = require('express');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var pdf = require('html-pdf');
var app = express();
const path = require('path');
const fs = require('fs');

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());
var mdAuthenticattion = require('../middlewares/authenticated');


// ////////////////////////////////////////////////////////////////////////////////////////////////
// Conductores

// Generar pdf comprobantes viaticos
app.put('/movilidadcond/:idViatico/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {
  var idViatico = req.params.idViatico;
  var idUser = req.params.idUser;
  var params =  `${idViatico}, ${idUser}`;
  var lsql = `EXEC FE_SUPERVAN.DBO.SP_GEN_REC_VIATICOS ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
      return res.status(500).send({
        ok: false,
        message: 'Error en la petición.',
        error: err
      });
    } else {
      var viatico = result.recordset[0];
      if (!viatico.ID_VIATICO) {
        return res.status(400).send({
            ok: true,
            message: viatico.MESSAGE
        });    
      }
      params =  `${idViatico}`;
      var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIEW_OP_PLANILLA_VIATICO ${params}`;
      var request = new mssql.Request();
      request.query(lsql, (err, result) => {
        if (err) { 
          return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
          });
        } else {
          var conductores = result.recordset;
          if (conductores.length == 0) {
            return res.status(400).send({
                ok: true,
                message: 'No existen registros.'
            });    
          }        
          var cantConductores = conductores.length;
          var razonSocial = conductores[0].NOMBRE_EMPRESA;
          var ruc = conductores[0].RUC_EMPRESA;
          var periodo = conductores[0].PERIODO;
          var css = '';
          var contenido = '';
          var nombreDoc = '';
          var nroPlanilla = '';
          var nroSemana = conductores[0].NRO_SEMANA;
          var year = conductores[0].ANIO;
          var fhEmision = conductores[0].FH_EMISION;     
          var firmaConductor; 
          var firmaAutorizado = `http://localhost:3000/api/image/firma_viaticos/autorizado.PNG`;
          var firmaTesoreria = `http://localhost:3000/api/image/firma_viaticos/tesoreria.PNG`;
          var firmaRevisado = `http://localhost:3000/api/image/firma_viaticos/revisado.PNG`;   
          lsql = `SELECT '_' + REPLACE(DIA, '/', '_') AS DIA,DIA AS FECHA, NRO_SEMANA, ANIO,NOMBRE_DIA 
                    FROM VIEW_DIAS WHERE (NRO_SEMANA = ${nroSemana}) AND (ANIO = ${year})`;
          request = new mssql.Request();
          request.query(lsql, (err, result) => {
            if (err) { 
              return res.status(500).send({
                  ok: false,
                  message: 'Error en la petición.',
                  error: err
              });
            } else {
              var dias = result.recordset;
              lsql = `EXEC FE_SUPERVAN.DBO.SP_VIEW_OP_DETA_PLANILLA_VIATICO ${params}`;
              request = new mssql.Request();
              request.query(lsql, (err, result) => {
                if (err) { 
                  return res.status(500).send({
                    ok: false,
                    message: 'Error en la petición.',
                    error: err
                  });
                } else {
                  var viaticos = result.recordset;
            
                  var detalles = [];
                  var i = 0;
                  var tablaDetalle = '';
                  var totalMonto = 0;
                
                  conductores.forEach(function (conductor) {
                    i++;
                    tablaDetalle = '';
                    totalMonto = 0;
                    var ruta = '';
                    var unidad = ''
                    var arrayRutaPlaca = [];
                    dias.forEach(function (dia) {                  
                      const resultado = viaticos.find( datos => 
                        datos.NOMBRE_APELLIDO === conductor.NOMBRE_APELLIDO && datos.FECHA === dia.FECHA 
                      );
                     
                      if(resultado.RUTA) {
                        arrayRutaPlaca = resultado.RUTA.split('|');
                        ruta = arrayRutaPlaca[0];
                        unidad = arrayRutaPlaca[1];
                      } else {
                      }

                      detalles.push({  
                        fecha: resultado.FECHA,      
                        dni: resultado.IDENTIFICACION,
                        dia: resultado.DIA,
                        mes: resultado.MES,
                        anio: resultado.ANIO,
                        motivo : 'Movilidad',
                        destino: ruta,
                        viaje: 1,
                        pago: resultado.TOTAL,
                        placa: unidad,
                        cc: '100100003'                               
                      });             
                      var detalle = detalles.find( deta =>                       
                        deta.dni === conductor.IDENTIFICACION && deta.fecha == dia.FECHA                        
                      );                      
                      if (detalle) {
                        let dni = detalle.dni;  
                        let dia = detalle.dia;  
                        let mes = detalle.mes;  
                        let anio = detalle.anio;  
                        let motivo = detalle.motivo;                         
                        let destino = detalle.destino;  
                        let viaje = detalle.viaje;  
                        let pago = detalle.pago;  
                        let placa = detalle.placa;  
                        let cc = detalle.cc;                        
                        if (pago > 0) {
                          totalMonto = totalMonto + pago;
                          tablaDetalle = tablaDetalle + '\n' + `
                          <tr>                   
                            <td>${dia}</td>
                            <td>${mes}</td>
                            <td>${anio}</td>
                            <td>${motivo}</td>
                            <td>${destino}</td> 
                            <td>${viaje}</td>
                            <td>S/. ${pago}</td>
                            <td>${placa}</td>
                            <td>${cc}</td>
                          </tr>`;
                        } 
                      }                      
                    });
                    // nombreDoc = conductor.ID_VIATICO + '-' + conductor.IDENTIFICACION;
                    nombreDoc = conductor.IDENTIFICACION + '-' + conductor.NRO_RECIBO;
                    nroPlanilla = conductor.NRO_RECIBO;
                    css = `
                    .table-dt {
                      border-collapse: collapse;
                      border: 1px solid;
                      border-top: 0px solid;
                      width: 100%;
                      font-size: 12px;
                    }
                    .table-dt td  {  
                      border: 1px solid;
                      border-top: 0px solid;
                      text-align:center;
                    }

                    .table-dt thead td  {  
                      font-weight: bold;
                      background: #AEAEAE;
                    }
                    
                    .table-firma {
                      border-collapse: collapse;
                      border: 0px solid;
                      border-top: 0px solid;
                      width: 100%;
                    }
                    .table-firma td  {  
                      border: 0px solid;
                      border-top: 0px solid;
                      text-align:center;
                    }

                    html {
                      width: 725px;
                      margin: 1rem;
                      padding: 1rem;
                    }
                    `;                    
                    firmaConductor = `http://localhost:3000/api/image/firma_conductor/${conductor.IDENTIFICACION}.PNG`;
                    contenido = `
                    <html>
                      <head>
                        <style>
                          ${css}
                        </style>
                        <meta charset="utf8">
                        <title>PLANILLA POR GASTOS DE MOVILIDAD - POR TRABAJADOR</title>
                        <div style="border: 1px solid;">
                          <div>
                            <h4 align="center" style="border-bottom: 1px solid; margin-top:0px;">PLANILLA POR GASTOS DE MOVILIDAD - POR TRABAJADOR</h4>
                          </div>
                          <table style="border-collapse: collapse; margin-left: 20px; margin-bottom: 20px">
                            <tr>
                              <td style="width:90px">Número (*):</td>
                              <td style="border: 1px solid;">${nroPlanilla}</td>
                            </tr>
                            <tr>
                              <td>Razon Social:</td>
                              <td style="border: 1px solid;">${razonSocial}</td>            
                            </tr>
                            <tr>
                              <td>RUC:</td>
                              <td style="border: 1px solid;">${ruc}</td>            
                            </tr>
                          </table>
                          <table style="border-collapse: collapse; float: right; margin-top: -90px; margin-right: 20px">
                            <tr>
                              <td>Fecha de Emisión:</td>
                              <td style="border: 1px solid;">${fhEmision}</td>
                            </tr>
                            <tr>
                              <td>Periodo:</td>
                              <td style="border: 1px solid;">${periodo}</td>            
                            </tr>
                          </table>
                        </div>
                        <div style="border: 1px solid; border-top: 0px;">
                          <table style="border-collapse: collapse; margin-left: 20px; margin-bottom: 20px;">
                            <tr>
                              <td>Datos del TRabajador (**):</td>
                              <td></td>
                            </tr>
                            <tr>
                              <td>Nombres y Apellidos:</td>
                              <td style="border: 1px solid;">${conductor.NOMBRE_APELLIDO}</td>            
                            </tr>
                            <tr>
                              <td>D.N.I.:</td>
                              <td style="border: 1px solid;">${conductor.IDENTIFICACION}</td>            
                            </tr>
                          </table>
                        </div>
                      </head>
                      <body>
                        <table class="table-dt"  style="border-collapse: collapse;" border="1">
                          <thead>
                            <tr>            
                              <td colspan="3">Fecha del Gasto (**):</td>          
                              <td colspan="2">Desplazamiento</td> 
                              <td colspan="2">Monto gastado por (**)</td>
                              <td style="border-bottom: 0px;"></td>
                              <td style="border-bottom: 0px;"></td>      
                            </tr>
                            <tr>
                              <td>Día</td>
                              <td>Mes</td>
                              <td>Año</td> 
                              <td>Motivo</td> 
                              <td>Destino</td>  
                              <td>Viaje</td>
                              <td>Día</td>
                              <td>Unidad de Gestión</td>
                              <td>Centro de Costo</td>                             
                            </tr>
                          </thead>
                          <tbody>
                              ${tablaDetalle}
                              <td style="border-color: transparent"></td>
                              <td style="border-color: transparent"></td>
                              <td style="border-color: transparent"></td> 
                              <td style="border-color: transparent"></td> 
                              <td style="border-color: transparent"></td>  
                              <td style="border-color: transparent; border-right: 1px solid"></td>
                              <td>S/. ${totalMonto}</td>
                              <td style="border-color: transparent"></td>
                              <td style="border-color: transparent"></td>
                          </tbody>
                        </table>
                        
                        
                        <div style="margin-top: 40px">
                          <table class="table-firma"  style="border-collapse: collapse;">
                            <tr>            
                              <td><img src="${firmaConductor}" style="height: 65px; width: 70px; margin-bottom:0px;"></td>  
                              <td><img src="${firmaTesoreria}" style="height: 65px; width: 70px;"></td>      
                            </tr>
                            <tr>            
                              <td>_____________________</td>  
                              <td>_____________________</td>      
                            </tr>
                            <tr>            
                              <td>Firma del Trabajador</td>
                              <td>Tesoreria</td>        
                            </tr>
                            
                            <tr style="height: 50px">            
                              <td></td>  
                              <td></td>      
                            </tr> 

                            <tr>            
                              <td><img src="${firmaRevisado}" style="height: 65px; width: 70px;"></td>  
                              <td><img src="${firmaAutorizado}" style="height: 65px; width: 70px;"></td>      
                            </tr>                       

                            <tr>            
                              <td>_____________________</td>  
                              <td>_____________________</td>      
                            </tr>
                            <tr>            
                              <td>Revisado por</td>
                              <td>Validado por</td>        
                            </tr>
                          </table>
                        </div>
                      
                        <div style="border-top: 3px solid; margin-top: 5px;">
                          <p style="font-size: 12px;">
                            Base Legal: Inciso a1) del artículo 37° del TUO de la Ley del Impuesto a la Renta e inciso v) del artículo 21° del Reglamento de la ley del impuesto a la Renta.
                          </p

                          <p  style="font-size: 12px;">
                            (*)  Numeración de la planilla
                          </p>

                          <p  style="font-size: 12px;">
                            (**) La falta de algunos de estos datos inhabilita la planilla para la sustentación del gasto que corresponda a tal desplazamiento.
                          </p>
                        </div>
                        
                      </body>
                    </html>`;
                    // if (i==1) {
                      crearPdf(contenido,nombreDoc);
                    // }
                    
                  });
                  
                  return res.status(200).send({
                    ok: true,
                    message: 'Se han generado '+ i + ' comprobantes.'      
                  });
                }              
              });
            }
          });
        }
      });
    }
  });
});
// // Fin Generar pdf comprobantes viaticos

// Crear PDF
function crearPdf(content, nombreDoc){  
   pdf.create(content).toFile(`./uploads/viaticos-conductor/${nombreDoc}.pdf`, function(err, resp) {
    if (err){
      console.log(err);
    } else {
      return 1;
    }
  }); 
}
// Fin crear PDF


// Generar pdf comprobantes viaticos conductor
app.get('/pdfdetaviatico/:idViatico/:idConductor', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var idViatico = req.params.idViatico;
    var idConductor = req.params.idConductor;  
    var params =  `${idViatico}, ${idConductor}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_DETA_VIATICO_POR_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
      if (err) { 
        return res.status(500).send({
          ok: false,
          message: 'Error en la petición.',
          error: err
        });
      } else {
        var viaticos = result.recordset;
        if (viaticos.length == 0) {
          return res.status(400).send({
              ok: true,
              message: 'No existen registros.'
          });    
        }        
        var i = 0;
        var tablaDetalle = '';
        var totalMonto = 0; 
        var ruta = '';
        var unidad = ''
        var arrayRutaPlaca = [] 
        tablaDetalle = '';
        totalMonto = 0;
        
        viaticos.forEach(function (viatico) {
          i++;
          
          if (viatico.RUTA) {
            arrayRutaPlaca = viatico.RUTA.split('|');
            ruta = arrayRutaPlaca[0];
            unidad = arrayRutaPlaca[1]  
          }

          if (viatico.TOTAL > 0) {
            totalMonto = totalMonto + viatico.TOTAL;
            tablaDetalle = tablaDetalle + '\n' + `
            <tr>                   
              <td>${viatico.DIA}</td>
              <td>${viatico.MES}</td>
              <td>${viatico.ANIO}</td>
              <td>Movilidad</td>
              <td>${ruta}</td> 
              <td>1</td>
              <td>S/. ${viatico.TOTAL}</td>
              <td>${unidad}</td>
              <td>100100003</td>
            </tr>`;
          }
        });

   
            var css = `
            .table-dt {
              border-collapse: collapse;
              border: 1px solid;
              border-top: 0px solid;
              width: 100%;
              font-size: 12px;
            }
            .table-dt td  {  
              border: 1px solid;
              border-top: 0px solid;
              text-align:center;
            
            .table-dt thead td  {  
              font-weight: bold;
              background: #AEAEAE;
            }
            
            .table-firma {
              border-collapse: collapse;
              border: 0px solid;
              border-top: 0px solid;
              width: 100%;
            }
            .table-firma td  {  
              border: 0px solid;
              border-top: 0px solid;
              text-align:center;
            
            html {
              width: 725px;
              margin: 1rem;
              padding: 1rem;
            }
            `;                    
            var contenido = `
            <html>
              <head>
                <style>
                  ${css}
                </style>
                <meta charset="utf8">
                <title>PLANILLA POR GASTOS DE MOVILIDAD - POR TRABAJADOR</title>
                <div style="border: 1px solid;">
                  <div>
                    <h4 align="center" style="border-bottom: 1px solid; margin-top:0px;">PLANILLA POR GASTOS DE MOVILIDAD - POR TRABAJADOR</h4>
                  </div>
                  <table style="border-collapse: collapse; margin-left: 20px; margin-bottom: 20px">
                    <tr>
                      <td style="width: 90px">Número (*):</td>
                      <td style="border: 1px solid;">${viaticos[0].NRO_RECIBO}</td>
                    </tr>
                    <tr>
                      <td>Razon Social:</td>
                      <td style="border: 1px solid;">${viaticos[0].NOMBRE_EMPRESA}</td>            
                    </tr>
                    <tr>
                      <td>RUC:</td>
                      <td style="border: 1px solid;">${viaticos[0].RUC_EMPRESA}</td>            
                    </tr>
                  </table>
                  <table style="border-collapse: collapse; float: right; margin-top: -90px; margin-right: 20px">
                    <tr>
                      <td>Fecha de Emisión:</td>
                      <td style="border: 1px solid;">${viaticos[0].FH_EMISION}</td>
                    </tr>
                    <tr>
                      <td>Periodo:</td>
                      <td style="border: 1px solid;">${viaticos[0].MES}-${viaticos[0].ANIO}</td>            
                    </tr>
                  </table>
                </div>
                <div style="border: 1px solid; border-top: 0px;">
                  <table style="border-collapse: collapse; margin-left: 20px; margin-bottom: 20px;">
                    <tr>
                      <td>Datos del TRabajador (**):</td>
                      <td></td>
                    </tr>
                    <tr>
                      <td>Nombres y Apellidos:</td>
                      <td style="border: 1px solid;">${viaticos[0].NOMBRE_APELLIDO}</td>            
                    </tr>
                    <tr>
                      <td>D.N.I.:</td>
                      <td style="border: 1px solid;">${viaticos[0].IDENTIFICACION}</td>            
                    </tr>
                  </table>
                </div>
              </head>
              <body>
                <table class="table-dt"  style="border-collapse: collapse;" border="1">
                  <thead>
                    <tr>            
                      <td colspan="3">Fecha del Gasto (**):</td>          
                      <td colspan="2">Desplazamiento</td> 
                      <td colspan="2">Monto gastado por (**)</td>
                      <td style="border-bottom: 0px;"></td>
                      <td style="border-bottom: 0px;"></td>      
                    </tr>
                    <tr>
                      <td>Día</td>
                      <td>Mes</td>
                      <td>Año</td> 
                      <td>Motivo</td> 
                      <td>Destino</td>  
                      <td>Viaje</td>
                      <td>Día</td>
                      <td>Unidad de Gestión</td>
                      <td>Centro de Costo</td>                             
                    </tr>
                  </thead>
                  <tbody>
                      ${tablaDetalle}
                      <td style="border-color: transparent"></td>
                      <td style="border-color: transparent"></td>
                      <td style="border-color: transparent"></td> 
                      <td style="border-color: transparent"></td> 
                      <td style="border-color: transparent"></td>  
                      <td style="border-color: transparent; border-right: 1px solid"></td>
                      <td>S/. ${totalMonto}</td>
                      <td style="border-color: transparent"></td>
                      <td style="border-color: transparent"></td>
                  </tbody>
                </table>                
              </body>
            </html>`;
            var nombreDoc = viaticos[0].DIA + viaticos[0].MES + viaticos[0].ANIO + '-' + viaticos[0].IDENTIFICACION + '-' +viaticos[0].NRO_RECIBO + '.pdf';
            
            var pathImage = path.resolve(__dirname, `../uploads/viaticos-conductor/${nombreDoc}`);
            if (fs.existsSync(pathImage)){  
              return res.status(200).send({
                ok: true,
                message: 'Pdf ya existe.',
                nombreDoc 
              });
            } else {
              pdf.create(contenido).toFile(`./uploads/viaticos-conductor/${nombreDoc}`, function(err, resp) {
                if (err){
                  console.log(err);
                  return res.status(500).send({
                    ok: true,
                    error: err,
                    message: 'Error en la petición'    
                  });
                } else {
                  return res.status(200).send({
                    ok: true,
                    message: 'Pdf creado',
                    nombreDoc 
                  });
                }
              });       
            } 
      }
    });   
});
// // Fin Generar pdf comprobantes viaticos conductor

// Generar nuevo pdf comprobante viaticos conductor
app.get('/renewpdfviatico/:idViatico/:idConductor', mdAuthenticattion.verificarToken, (req, res, next ) => {
  var idViatico = req.params.idViatico;
  var idConductor = req.params.idConductor;  
  var params =  `${idViatico}, ${idConductor}`;
  var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_DETA_VIATICO_POR_CONDUCTOR ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
      return res.status(500).send({
        ok: false,
        message: 'Error en la petición.',
        error: err
      });
    } else {
      var viaticos = result.recordset;
      if (viaticos.length == 0) {
        return res.status(400).send({
            ok: true,
            message: 'No existen registros.'
        });    
      }        
      var i = 0;
      var tablaDetalle = '';
      var totalMonto = 0; 
      var ruta = '';
      var unidad = ''
      var arrayRutaPlaca = [] 
      tablaDetalle = '';
      totalMonto = 0;
      var css;
      
      viaticos.forEach(function (viatico) {
        i++;
        
        if (viatico.RUTA) {
          arrayRutaPlaca = viatico.RUTA.split('|');
          ruta = arrayRutaPlaca[0];
          unidad = arrayRutaPlaca[1]  
        }

        if (viatico.TOTAL > 0) {
          totalMonto = totalMonto + viatico.TOTAL;
          tablaDetalle = tablaDetalle + '\n' + `
          <tr>                   
            <td>${viatico.DIA}</td>
            <td>${viatico.MES}</td>
            <td>${viatico.ANIO}</td>
            <td>Movilidad</td>
            <td>${ruta}</td> 
            <td>1</td>
            <td>S/. ${viatico.TOTAL}</td>
            <td>${unidad}</td>
            <td>100100003</td>
          </tr>`;
        }
      });

 
      css = `
      .table-dt {
        border-collapse: collapse;
        border: 1px solid;
        border-top: 0px solid;
        width: 100%;
        font-size: 12px;
      }
      .table-dt td  {  
        border: 1px solid;
        border-top: 0px solid;
        text-align:center;
      }

      .table-dt thead td  {  
        font-weight: bold;
        background: #AEAEAE;
      }
      
      .table-firma {
        border-collapse: collapse;
        border: 0px solid;
        border-top: 0px solid;
        width: 100%;
      }
      .table-firma td  {  
        border: 0px solid;
        border-top: 0px solid;
        text-align:center;
      }

      html {
        width: 725px;
        margin: 1rem;
        padding: 1rem;
      }
      `;                
          var firmaConductor = `http://localhost:3000/api/image/firma_conductor/${viaticos[0].IDENTIFICACION}.PNG`;
          var firmaAutorizado = `http://localhost:3000/api/image/firma_viaticos/autorizado.PNG`;
          var firmaTesoreria = `http://localhost:3000/api/image/firma_viaticos/tesoreria.PNG`;
          var firmaRevisado = `http://localhost:3000/api/image/firma_viaticos/revisado.PNG`;
          var contenido = `
          <html>
            <head>
              <style>
                ${css}
              </style>
              <meta charset="utf8">
              <title>PLANILLA POR GASTOS DE MOVILIDAD - POR TRABAJADOR</title>
              <div style="border: 1px solid;">
                <div>
                  <h4 align="center" style="border-bottom: 1px solid; margin-top:0px;">PLANILLA POR GASTOS DE MOVILIDAD - POR TRABAJADOR</h4>
                </div>
                <table style="border-collapse: collapse; margin-left: 20px; margin-bottom: 20px">
                  <tr>
                    <td style="width:90px">Número (*):</td>
                    <td style="border: 1px solid;">${viaticos[0].NRO_RECIBO}</td>
                  </tr>
                  <tr>
                    <td>Razon Social:</td>
                    <td style="border: 1px solid;">${viaticos[0].NOMBRE_EMPRESA}</td>            
                  </tr>
                  <tr>
                    <td>RUC:</td>
                    <td style="border: 1px solid;">${viaticos[0].RUC_EMPRESA}</td>            
                  </tr>
                </table>
                <table style="border-collapse: collapse; float: right; margin-top: -90px; margin-right: 20px">
                  <tr>
                    <td>Fecha de Emisión:</td>
                    <td style="border: 1px solid;">${viaticos[0].FH_EMISION}</td>
                  </tr>
                  <tr>
                    <td>Periodo:</td>
                    <td style="border: 1px solid;">${viaticos[0].MES}-${viaticos[0].ANIO}</td>            
                  </tr>
                </table>
              </div>
              <div style="border: 1px solid; border-top: 0px;">
                <table style="border-collapse: collapse; margin-left: 20px; margin-bottom: 20px;">
                  <tr>
                    <td>Datos del TRabajador (**):</td>
                    <td></td>
                  </tr>
                  <tr>
                    <td>Nombres y Apellidos:</td>
                    <td style="border: 1px solid;">${viaticos[0].NOMBRE_APELLIDO}</td>            
                  </tr>
                  <tr>
                    <td>D.N.I.:</td>
                    <td style="border: 1px solid;">${viaticos[0].IDENTIFICACION}</td>            
                  </tr>
                </table>
              </div>
            </head>
            <body>
              <table class="table-dt"  style="border-collapse: collapse;" border="1">
                <thead>
                  <tr>            
                    <td colspan="3">Fecha del Gasto (**):</td>          
                    <td colspan="2">Desplazamiento</td> 
                    <td colspan="2">Monto gastado por (**)</td>
                    <td style="border-bottom: 0px;"></td>
                    <td style="border-bottom: 0px;"></td>      
                  </tr>
                  <tr>
                    <td>Día</td>
                    <td>Mes</td>
                    <td>Año</td> 
                    <td>Motivo</td> 
                    <td>Destino</td>  
                    <td>Viaje</td>
                    <td>Día</td>
                    <td>Unidad de Gestión</td>
                    <td>Centro de Costo</td>                             
                  </tr>
                </thead>
                <tbody>
                    ${tablaDetalle}
                    <td style="border-color: transparent"></td>
                    <td style="border-color: transparent"></td>
                    <td style="border-color: transparent"></td> 
                    <td style="border-color: transparent"></td> 
                    <td style="border-color: transparent"></td>  
                    <td style="border-color: transparent; border-right: 1px solid"></td>
                    <td>S/. ${totalMonto}</td>
                    <td style="border-color: transparent"></td>
                    <td style="border-color: transparent"></td>
                </tbody>
              </table>
              
              
              <div style="margin-top: 40px;">
                <table class="table-firma"  style="border-collapse: collapse; width: 100%;">
                  <tr>            
                    <td><img src="${firmaConductor}" style="height: 65px; width: 70px; margin-bottom:0px;"></td>  
                    <td><img src="${firmaTesoreria}" style="height: 65px; width: 70px;"></td>      
                  </tr>
                  <tr>            
                    <td>_____________________</td>  
                    <td>_____________________</td>      
                  </tr>
                  <tr>            
                    <td>Firma del Trabajador</td>
                    <td>Tesoreria</td>        
                  </tr>
                  
                  <tr style="height: 50px">            
                    <td></td>  
                    <td></td>      
                  </tr> 

                  <tr>            
                    <td><img src="${firmaRevisado}" style="height: 65px; width: 70px;"></td>  
                    <td><img src="${firmaAutorizado}" style="height: 65px; width: 70px;"></td>      
                  </tr>                       

                  <tr>            
                    <td>_____________________</td>  
                    <td>_____________________</td>      
                  </tr>
                  <tr>            
                    <td>Revisado por</td>
                    <td>Validado por</td>        
                  </tr>
                </table>
              </div>
            
              <div style="border-top: 3px solid; margin-top: 5px;">
                <p style="font-size: 12px;">
                  Base Legal: Inciso a1) del artículo 37° del TUO de la Ley del Impuesto a la Renta e inciso v) del artículo 21° del Reglamento de la ley del impuesto a la Renta.
                </p

                <p  style="font-size: 12px;">
                  (*)  Numeración de la planilla
                </p>

                <p  style="font-size: 12px;">
                  (**) La falta de algunos de estos datos inhabilita la planilla para la sustentación del gasto que corresponda a tal desplazamiento.
                </p>
              </div>
              
            </body>
          </html>`;
          var nombreDoc = viaticos[0].IDENTIFICACION + '-' +viaticos[0].NRO_RECIBO + '.pdf';
          pdf.create(contenido).toFile(`./uploads/viaticos-conductor/${nombreDoc}`, function(err, resp) {
            if (err){
              console.log(err);
              return res.status(500).send({
                ok: true,
                error: err,
                message: 'Error en la petición'    
              });
            } else {
              return res.status(200).send({
                ok: true,
                message: 'Pdf creado',
                nombreDoc 
              });
            }
          }); 
    }
  });   
});
// // Fin Generar nuevo pdf comprobante viaticos conductor

module.exports = app;




                    