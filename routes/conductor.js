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

// Get Vijes conductores 
app.post('/viajes', (req, res) => {
    var body = req.body;
    var dni = body.DNI;    
    var desde = body.DESDE;
    var hasta = body.HASTA;   
    
    var params = `'${dni}', '${desde}', '${hasta}'`;
    var request = new mssql.Request();
    var lsql = `EXEC SP_GET_VIAJES_CONDUCTORES ${params}`;
    // console.log(lsql);
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viajes = result.recordset;
            return res.status(200).send({
                ok: true,                                   
                viajes                                 
            });           
        }
    });
});
// End Vijes conductores 

// Get Zonas Conductor
app.get('/zonas', (req, res, next ) => {   
    var lsql = `EXEC GET_ZONAS_CONDUCTOR`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var zonasConductor = result.recordset;            
            return res.status(200).send({
                ok: true,
                zonasConductor
            });
        }
    });
});
// End Zonas Conductor

// Get Conductor
app.get('/:id', (req, res, next ) => {
    var id = req.params.id;
    var params = `'${id}'`;
    var lsql = `EXEC GET_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var conductor = result.recordset;
            if (conductor.length === 0) {
                return  res.status(400).send({
                    ok: true, 
                    message: 'Conductor no registrado.'
                }); 
            } else {
                return res.status(200).send({
                    ok: true,
                    conductor: conductor[0]
                });
            }
        }
    });
});
// End Get Conductor

// Get Datos semana
app.get('/datosemana/:dia', (req, res, next ) => {
    var dia = req.params.dia;
    var params = `'${dia}'`;
    var lsql = `EXEC GET_DATOS_SEMANA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var datosSemana = result.recordset;            
            return res.status(200).send({
                ok: true,
                datosSemana: datosSemana[0]
            });
            
        }
    });
});
// End Get Datos semana

// Get Dias Semanas
app.get('/diasemana/:desde/:hasta', (req, res, next ) => {
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var params = `'${desde}', '${hasta}'`;
    var lsql = `EXEC GET_DIAS_SEMANA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var diasSemana = result.recordset;            
            return res.status(200).send({
                ok: true,
                diasSemana
            });
            
        }
    });
});
// End Get Dias Semanas

// Get Tarifas viaticos
app.get('/tarifasviatico/:zona', (req, res, next ) => {
    var zona = req.params.zona;
    var params = `'${zona}'`;
    var lsql = `EXEC GET_TARIFA_VIATICOS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var tarifas = result.recordset;            
            return res.status(200).send({
                ok: true,
                tarifas: tarifas[0]
            });
            
        }
    });
});
// End Get Tarifas viaticos

// Register Viatico
app.post('/viatico', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;   
    var params = '';
    var values = [];
    body.forEach(function (viatico) {
        var idZona = viatico.ID_ZONA;
        var idConductor = viatico.ID_CONDUCTOR;
        var fhDesde = viatico.FH_DESDE;
        var fhHasta = viatico.FH_HASTA;
        var nroSemana = viatico.NRO_SEMANA;
        var fhDia = viatico.FH_DIA;
        var arrayFhDia = fhDia.split("/");
        fhDia = arrayFhDia[2] + '-' + arrayFhDia[1] + '-' + arrayFhDia[0];
        var monto1 = viatico.MONTO1;
        var monto2 = viatico.MONTO2;
        var monto3 = viatico.MONTO3;
        var montoTotal = viatico.MONTO_TOTAL;   
        params = params + ',' + '\n' + `(${idZona}, '${idConductor}' , '${fhDesde}', '${fhHasta}', '${nroSemana}', '${fhDia}', ${monto1}, ${monto2}, ${monto3}, ${montoTotal})`;
        values.push([params]);
    });

    params = params.substring(1);
    var lsql = `INSERT INTO VIATICOS_CONDUCTOR (ID_ZONA,ID_CONDUCTOR,FH_DESDE,FH_HASTA,NRO_SEMANA,FH_DIA,MONTO1,MONTO2,MONTO3,MONTO_TOTAL) 
    VALUES ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viaticos = result.rowsAffected[0];
            return res.status(200).send({
                ok: true,                             
                viaticos
            });
        }
    }); 
});
// End Register Viatico

// Verificar Viatico
app.get('/verificarviatico/:idConductor/:dia', (req, res, next ) => {       
    var idConductor = req.params.idConductor;
    var dia = req.params.dia;
    var params =  `'${idConductor}', '${dia}'`;
    var lsql = `REGISTER_VIATICO ${params}`;
    console.log(lsql);
    console.log(lsql);
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var idViatico = result.recordset[0].ID_VIATICO;            
            return res.status(200).send({
                ok: true,
                idViatico
            });
        }
    });  
});
// End Verificar Viatico

module.exports = app;
