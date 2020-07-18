'use strict'

var express = require('express');

// bcryptjs
var bcrypt = require('bcryptjs');

// jwt
var jwt = require('jsonwebtoken');

var excel = require('node-excel-export');

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
    var lsql = `EXEC FE_SUPERVAN_PRUEBA.DBO.REGISTER_GUIA ${params}`;
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
    var lsql = `EXEC FE_SUPERVAN_PRUEBA.DBO.UPDATE_GUIA ${params}`;
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

// Get guia
app.delete('/guia/:id/', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idGuia = req.params.id;
    var params =  `${idGuia}`;
    var lsql = `EXEC FE_SUPERVAN_PRUEBA.DBO.DELETE_GUIA ${params}`;
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



module.exports = app;
