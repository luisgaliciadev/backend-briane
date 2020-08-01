'use strict'

var express = require('express');

// bcryptjs
var bcrypt = require('bcryptjs');

// jwt
var jwt = require('jsonwebtoken');

var excel = require('node-excel-export');

var async = require("async");

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var http = require('http');
var path = require('path');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');

// // Get Vijes conductores 
// app.post('/viajes', (req, res) => {
//     var body = req.body;
//     var dni = body.DNI;    
//     var desde = body.DESDE;
//     var hasta = body.HASTA;   
    
//     var params = `'${dni}', '${desde}', '${hasta}'`;
//     var request = new mssql.Request();
//     var lsql = `EXEC SP_GET_VIAJES_CONDUCTORES ${params}`;
//     // console.log(lsql);
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var viajes = result.recordset;
//             return res.status(200).send({
//                 ok: true,                                   
//                 viajes                                 
//             });           
//         }
//     });
// });
// // End Vijes conductores 

// Get Orden servicio
app.get('/os/:idUser',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idUser = req.params.idUser;
    var params =  `${idUser}`;
    var lsql = `EXEC GET_OS_GUIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var ordenesServicio = result.recordset;
            return res.status(200).send({
                ok: true,
                ordenesServicio
            });
        }
    });
});
// End Get orden servicio

// Get Vehiculo
app.get('/vehiculo/:placa/:tipo', (req, res, next ) => {   
    var placa = req.params.placa;
    var tipo = req.params.tipo;
    var params =  `'${placa}', ${tipo}`;
    var lsql = `EXEC GET_VEHICULO ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var vehiculo = result.recordset[0];
            if (!vehiculo) {
                return res.status(400).send({
                    ok: true,
                    message: 'La placa del vehiculo no existe.'
                });    
            }         
            return res.status(200).send({
                ok: true,
                vehiculo
            });
        }
    });
});
// End Get vehiculo

// Register guia
app.post('/guia', mdAuthenticattion.verificarToken, (req, res) => {
    var body = req.body;
    var CORRELATIVO = body.CORRELATIVO;
    var FECHA = body.FECHA;
    var FECHA_HORA_FIN = body.FECHA_HORA_FIN;
    var FH_TRASLADO = body.FH_TRASLADO;
    var ID_CONDUCTOR = body.ID_CONDUCTOR;
    var ID_ORDEN_SERVICIO = body.ID_ORDEN_SERVICIO;
    var ID_REMOLQUE = body.ID_REMOLQUE;
    var ID_TRACTO = body.ID_TRACTO;
    var NRO_GUIA_CLIENTE = body.NRO_GUIA_CLIENTE;
    var NRO_PERMISO = body.NRO_PERMISO;
    var OBSERVACION = body.OBSERVACION;
    var PESO_BRUTO = body.PESO_BRUTO;
    var PESO_NETO = body.PESO_NETO;
    var PESO_TARA = body.PESO_TARA;
    var SERIAL = body.SERIAL;
    var TIEMPO_VIAJE = body.TIEMPO_VIAJE;
    var ID_USUARIO_BS = body.ID_USUARIO_BS;
    var ID_EMPRESA = body.ID_EMPRESA;
    var TIPO_EMPRESA = body.TIPO_EMPRESA;
    var params = `'${CORRELATIVO}','${FECHA}','${FECHA_HORA_FIN}','${FH_TRASLADO}',${ID_CONDUCTOR},${ID_ORDEN_SERVICIO},${ID_REMOLQUE},${ID_TRACTO},'${NRO_GUIA_CLIENTE}','${NRO_PERMISO}','${OBSERVACION}',${PESO_BRUTO},${PESO_NETO},${PESO_TARA},'${SERIAL}',${TIEMPO_VIAJE},${ID_USUARIO_BS},${ID_EMPRESA},'${TIPO_EMPRESA}'`;
    var request = new mssql.Request();
    var lsql = `EXEC FE_SUPERVAN.DBO.REGISTER_GUIA ${params}`;
    // var lsql = `EXEC FE_SUPERVAN_PRUEBA.DBO.REGISTER_GUIA ${params}`;
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guia = result.recordset[0];
            if (guia.ID_GUIA == 0) {
                return res.status(400).send({
                    ok: true,
                    message: guia.MESSAGE
                });    
            }     
            return res.status(200).send({
                ok: true,                                   
                guia                                 
            });      
        }
    });
});
// Register guia

// Get guia
app.get('/guia/:id/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idGuia = req.params.id;
    var idUser = req.params.idUser;
    var params =  `${idGuia}, ${idUser}`;
    var lsql = `EXEC GET_GUIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guia = result.recordset[0];
            if (!guia) {
                return res.status(400).send({
                    ok: true,
                    message: 'La guia no existe.'
                });    
            }         
            return res.status(200).send({
                ok: true,
                guia
            });
        }
    });
});
// End Get guia

// Update guia
app.put('/guia', mdAuthenticattion.verificarToken, (req, res) => {
    var body = req.body;
    var ID_GUIA = body.ID_GUIA
    var CORRELATIVO = body.CORRELATIVO;
    var FECHA = body.FECHA;
    var FECHA_HORA_FIN = body.FECHA_HORA_FIN;
    var FH_TRASLADO = body.FH_TRASLADO;
    var ID_CONDUCTOR = body.ID_CONDUCTOR;
    var ID_ORDEN_SERVICIO = body.ID_ORDEN_SERVICIO;
    var ID_REMOLQUE = body.ID_REMOLQUE;
    var ID_TRACTO = body.ID_TRACTO;
    var NRO_GUIA_CLIENTE = body.NRO_GUIA_CLIENTE;
    var NRO_PERMISO = body.NRO_PERMISO;
    var OBSERVACION = body.OBSERVACION;
    var PESO_BRUTO = body.PESO_BRUTO;
    var PESO_NETO = body.PESO_NETO;
    var PESO_TARA = body.PESO_TARA;
    var SERIAL = body.SERIAL;
    var TIEMPO_VIAJE = body.TIEMPO_VIAJE;
    var ID_USUARIO_BS = body.ID_USUARIO_BS;
    var params = `'${CORRELATIVO}','${FECHA}','${FECHA_HORA_FIN}','${FH_TRASLADO}',${ID_CONDUCTOR},${ID_ORDEN_SERVICIO},${ID_REMOLQUE},${ID_TRACTO},'${NRO_GUIA_CLIENTE}','${NRO_PERMISO}','${OBSERVACION}',${PESO_BRUTO},${PESO_NETO},${PESO_TARA},'${SERIAL}',${TIEMPO_VIAJE},${ID_USUARIO_BS},${ID_GUIA}`;
    var request = new mssql.Request();
    var lsql = `EXEC FE_SUPERVAN.DBO.UPDATE_GUIA ${params}`;
    // var lsql = `EXEC FE_SUPERVAN_PRUEBA.DBO.UPDATE_GUIA ${params}`;
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guia = result.recordset[0];
            if (!guia) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe la guia.'
                });    
            }     
            return res.status(200).send({
                ok: true,                                   
                guia                                 
            });      
        }
    });
});
// Update guia

// Get guias
app.get('/guias/:idUser/:search/:desde/:hasta', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idUser = req.params.idUser;
    var search = req.params.search;
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var params =  `${idUser},'${search}','${desde}','${hasta}'`;
    var lsql = `EXEC GET_GUIAS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guias = result.recordset;  
            return res.status(200).send({
                ok: true,
                guias
            });
        }
    });
});
// End Get guias

// Delete guia
app.delete('/guia/:id/', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idGuia = req.params.id;
    var params =  `${idGuia}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.DELETE_GUIA ${params}`;
    // var lsql = `EXEC FE_SUPERVAN_PRUEBA.DBO.DELETE_GUIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guia = result.recordset[0];
            if (!guia) {
                return res.status(400).send({
                    ok: true,
                    message: 'La guia no existe.'
                });    
            }         
            return res.status(200).send({
                ok: true,
                guia
            });
        }
    });
});
// End Delete guia

// Get years
app.get('/years', (req, res, next ) => {   
    var lsql = `SELECT * FROM VIEW_YEARS`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var years = result.recordset;   
            return res.status(200).send({
                ok: true,
                years
            });
        }
    });
});
// End Get years

// Get motivos no op
app.get('/motivonoop', (req, res, next ) => {   
    var lsql = `SELECT * FROM VIEW_OP_MOTIVO_NO_OPERATIVIDAD`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var motivos = result.recordset;   
            return res.status(200).send({
                ok: true,
                motivos
            });
        }
    });
});
// End Get motivos no op

// // Get productividad
// app.get('/productividadop/:tipo/:semana/:year/:desde/:hasta',mdAuthenticattion.verificarToken, (req, res, next ) => {
//     var tipo = req.params.tipo;
//     var semana = req.params.semana;
//     var year = req.params.year;
//     var desde = req.params.desde;
//     var hasta = req.params.hasta;
//     var params =  `${tipo},${semana},${year},'${desde}','${hasta}'`;   
//     var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIAJES_DIA_TURNO_TOTAL ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var productividad = result.recordset;   
//             return res.status(200).send({
//                 ok: true,
//                 productividad
//             });
//         }
//     });
// });
// // End Get productividad

// Get dias productividad
app.get('/diasproductividadop/:semana/:year/:zona',mdAuthenticattion.verificarToken, (req, res, next ) => {
    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var params =  `${semana},${year},${zona}`;   
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIAJES_DIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var diasProductividad = result.recordset;
            var lsql = `SELECT '_' + REPLACE(DIA, '/', '_') AS DIA,DIA AS FECHA, NRO_SEMANA, ANIO,NOMBRE_DIA 
            FROM VIEW_DIAS WHERE (NRO_SEMANA = ${semana}) AND (ANIO = ${year})`;
            var request = new mssql.Request();
            request.query(lsql, (err, result) => {
                if (err) { 
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                } else {
                    var dias = result.recordset;
                    var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIAJES_TURNO_DIA ${params}`;
                    var request = new mssql.Request();
                    request.query(lsql, (err, result) => {
                        if (err) { 
                            return res.status(500).send({
                                ok: false,
                                message: 'Error en la petición.',
                                error: err
                            });
                        } else {
                            var diasTurnoProductividad = result.recordset;
                            // console.log('cantidad registros:', diasTurnoProductividad.length);
                            var i = -1;
                            var j = -1;
                            var turnos = [];
                            dias.forEach(function (dia) {
                                i++;
                               
                                j = -1; 
                                diasProductividad.forEach(function (diasProd) {
                                    j++;

                                    if (zona == 1) {
                                        const resultado = diasTurnoProductividad.find( viajes => 
                                            viajes.PLACA_TRACTO === diasProd.PLACA_TRACTO && viajes.NOMBRE_CONDUCTOR === diasProd.NOMBRE_CONDUCTOR && viajes.FH_GUIA === dia.FECHA 
                                        );
                                        
                                        var turno1 = 0
                                        var turno2 = 0
                                        var turno3 = 0
                                        
                                        if (resultado) {

                                            if(resultado.TURNO1) {
                                                turno1 = resultado.TURNO1
                                            }

                                            if(resultado.TURNO2) {
                                                turno2 = resultado.TURNO2
                                            }
                                            if(resultado.TURNO3) {
                                                turno3 = resultado.TURNO3
                                            }

                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1,
                                                turno2,
                                                turno3,
                                                motivo1: 0,
                                                motivo2: 0,
                                                motivo3: 0
                                            };
                                        } else {
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1: 0,
                                                turno2: 0,
                                                turno3: 0,
                                                motivo1: 0,
                                                motivo2: 0,
                                                motivo3: 0
                                            };
                                        }

                                        if (i==0) {
                                            // console.log(j);
                                            diasProductividad[j].dia1 = turnos;
                                        }

                                        if (i==1) {
                                            // console.log(j);
                                            diasProductividad[j].dia2 = turnos;
                                        }

                                        if (i==2) {
                                            // console.log(j);
                                            diasProductividad[j].dia3 = turnos;
                                        }

                                        if (i==3) {
                                            // console.log(j);
                                            diasProductividad[j].dia4 = turnos;
                                        }

                                        if (i==4) {
                                            // console.log(j);
                                        diasProductividad[j].dia5 = turnos;
                                        }

                                        if (i==5) {
                                            // console.log(j);
                                        diasProductividad[j].dia6 = turnos;
                                        }

                                        if (i==6) {
                                        diasProductividad[j].dia7 = turnos;
                                        }
                                        // console.log(j)
                                    }  

                                    if (zona == 2) {
                                       
                                        const resultado = diasTurnoProductividad.find( viajes => 
                                            viajes.PLACA_TRACTO === diasProd.PLACA_TRACTO && viajes.NOMBRE_CONDUCTOR === diasProd.NOMBRE_CONDUCTOR && viajes.FH_GUIA === dia.FECHA 
                                        );
                                        
                                        var turno1 = 0

                                        if (resultado) {

                                            if (resultado.VIAJES) {
                                               turno1 = resultado.VIAJES
                                            }

                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1,                                         
                                                motivo1: 0                                                  
                                            };

                                        } else {
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1,                                         
                                                motivo1: 0                                                  
                                            };
                                        }                                       
                                        
                                        if (i==0) {
                                            // console.log(i);
                                            diasProductividad[j].dia1 = turnos;
                                        }

                                        if (i==1) {
                                            // console.log(i);
                                            diasProductividad[j].dia2 = turnos;
                                        }

                                        if (i==2) {
                                            // console.log(i);
                                            diasProductividad[j].dia3 = turnos;
                                        }

                                        if (i==3) {
                                            // console.log(i);
                                            diasProductividad[j].dia4 = turnos;
                                        }

                                        if (i==4) {
                                            // console.log(i);
                                            diasProductividad[j].dia5 = turnos;
                                        }

                                        if (i==5) {
                                            // console.log(i);
                                            diasProductividad[j].dia6 = turnos;
                                        }

                                        if (i==6) {
                                            // console.log(i);
                                            diasProductividad[j].dia7 = turnos;
                                        }
                                    }

                                    if (zona == 3) {
                                        
                                        const resultado = diasTurnoProductividad.find( viajes => 
                                            viajes.PLACA_TRACTO === diasProd.PLACA_TRACTO && viajes.NOMBRE_CONDUCTOR === diasProd.NOMBRE_CONDUCTOR && viajes.FH_GUIA === dia.FECHA 
                                        );
                                        
                                        var turno1 = 0
                                        var turno2 = 0
                                        // console.log(resultado);
                                        if (resultado) {

                                            if(resultado.DIA) {
                                                turno1 = resultado.DIA
                                            }

                                            if(resultado.NOCHE) {
                                                turno2 = resultado.NOCHE
                                            }
                                               
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1,
                                                turno2,                                            
                                                motivo1: 0,
                                                motivo2: 0                                                   
                                            };
                                        } else {
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1: 0,
                                                turno2: 0,                                                   
                                                motivo1: 0,
                                                motivo2: 0                                                   
                                            };
                                        }

                                        if (i==0) {
                                            // console.log(j);
                                            diasProductividad[j].dia1 = turnos;
                                        }

                                        if (i==1) {
                                            // console.log(j);
                                            diasProductividad[j].dia2 = turnos;
                                        }

                                        if (i==2) {
                                            // console.log(j);
                                            diasProductividad[j].dia3 = turnos;
                                        }

                                        if (i==3) {
                                            // console.log(j);
                                            diasProductividad[j].dia4 = turnos;
                                        }

                                        if (i==4) {
                                            // console.log(j);
                                        diasProductividad[j].dia5 = turnos;
                                        }

                                        if (i==5) {
                                            // console.log(j);
                                        diasProductividad[j].dia6 = turnos;
                                        }

                                        if (i==6) {
                                        diasProductividad[j].dia7 = turnos;
                                        }
                                        // console.log(j)
                                    }  
                                });
                            });

                            return res.status(200).send({
                                ok: true,
                                // diasTurnoProductividad,
                                idZona: zona,
                                dias,
                                diasProductividad: diasProductividad
                            });
                        }
                    });            
                }
            });
        }
    });
});
// End Get productividad

async function viajesTurno(parametros) {
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIAJES_TURNO_DIA ${parametros}`;
    var request = new mssql.Request();
    let response = await request.query(lsql);
    var viajesTurno = response.recordset;
    // console.log('viajesTurno: ', viajesTurno);
    return viajesTurno;
}

module.exports = app;
