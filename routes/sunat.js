'use strict'

var express = require('express');
//var mongoosePaginate = require('mongoose-pagination');

// var excel = require('node-excel-export');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
// var http = require('http');
// var path = require('path');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

// var mdAuthenticattion = require('../middlewares/authenticated');

// Post Data ruc sunat
app.post('/consultaruc/:ruc', (req, res, next ) => {
    var ruc = req.params.ruc;
    const request = require('request').defaults({jar: true});
    const cheerio = require('cheerio');
    const clean   = str => str.replace(/\s+/g, ' ');
    const urlCode = 'http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/captcha?accion=random';
    const urlPost = 'http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias';

    request(urlCode, (err, response, code)=> {
        const formData = {
            nroRuc:ruc, 
            accion:'consPorRuc', 
            numRnd: code
        };
        request.post({url:urlPost, form: formData}, (err, response, body)=>{
            if (err) {
                res.status(500).send({
                    ok: false,
                    message: 'Error en la peticion.',
                    err: err
                });
            } else {
                if (response.statusCode == 200) {
                    const $ = cheerio.load(body);
                    const $table = $(".form-table").eq(2);
                    var text = '';
                    $table.find('tr').each((i, el) => {
                    const a = $(el).find('td[colspan=1]');
                    const b = $(el).find('td[colspan=3]');
                    text = text + ' ' + clean(a.text()) + clean(b.text())
                    });
                    if (text.length < 300 ) {
                        res.status(200).send({
                            ok: true,
                            message: 'Datos del RUC no encontrados.'
                        });
                    } else {
                        var iRuc = text.search("RUC: ");
                        var ifRuc = text.search(" -");
                        var RUC = text.slice(iRuc,ifRuc);
                        RUC = RUC.substr(5,12);

                        var iRs = text.search("- ");
                        var ifRs = text.search(" Tipo Contribuyente:");
                        var RAZON_SOCIAL = text.slice(iRs,ifRs);
                        RAZON_SOCIAL = RAZON_SOCIAL.substr(2,250);

                        var iNc = text.search("Nombre Comercial: ");
                        var ifNc = text.search(" Fecha de Inscripción:");
                        var NOMBRE_COMERCIAL = text.slice(iNc,ifNc);
                        NOMBRE_COMERCIAL = NOMBRE_COMERCIAL.substr(18,250);

                        var iEc = text.search("Estado del Contribuyente: ");
                        var ifEc = text.search("  Condición del Contribuyente:");
                        var ESTADO = text.slice(iEc,ifEc);
                        ESTADO = ESTADO.substr(26,6);

                        var iCc = text.search("Condición del Contribuyente: ");
                        var ifCc = text.search(" Dirección del Domicilio Fiscal:");
                        var CONDICION = text.slice(iCc,ifCc);
                        CONDICION = CONDICION.substr(29,6);

                        var iDc = text.search("Dirección del Domicilio Fiscal:");
                        var ifDc = text.search(" Sistema de Emisión de Comprobante:");
                        var DIRECCION = text.slice(iDc,ifDc);
                        DIRECCION = DIRECCION.substr(31,250);

                        var direccion = DIRECCION.split('-');
                        var pProvincia = direccion.length - 2;
                        var pDistrito = direccion.length - 1;

                        var PROVINCIA = (direccion[pProvincia].substr(1,100)).trim();
                        var DISTRITO = direccion[pDistrito].substr(1,100);

                        var params = `'${DISTRITO}', '${PROVINCIA}'`;
                        var request = new mssql.Request();
                        var lsql = `EXEC GET_UBIGEO ${params}`;
                    
                        var request = new mssql.Request();
                        request.query(lsql, (err, result) => {
                            if (err) { 
                                return res.status(500).send({
                                    ok: false,
                                    message: 'Error en la petición.',
                                    error: err
                                });
                            } else {
                                var ubigeo = result.recordset;

                                if (ubigeo.length === 0) {
                                    var COD_UBIGEO = '150101';
                                    var ID_DISTRITO = '1250'; 
                                    var ID_PROVINCIA = '129'; 
                                    var ID_DEPARTAMENTO = '16'; 
                                    var DEPARTAMENTO = '';
                                } else {
                                    var COD_UBIGEO = ubigeo[0].COD_UBIGEO;
                                    var ID_DISTRITO = ubigeo[0].ID_DISTRITO; 
                                    var ID_PROVINCIA = ubigeo[0].ID_PROVINCIA; 
                                    var ID_DEPARTAMENTO = ubigeo[0].ID_DEPARTAMENTO; 
                                    var DEPARTAMENTO = ubigeo[0].DS_DEPARTAMENTO; 
                                }
                                return res.status(200).send({
                                    ok: true,
                                    ok: true,
                                    RUC: RUC,
                                    RAZON_SOCIAL: RAZON_SOCIAL,
                                    NOMBRE_COMERCIAL: NOMBRE_COMERCIAL,
                                    ESTADO: ESTADO,
                                    CONDICION: CONDICION,
                                    DIRECCION: DIRECCION,
                                    DEPARTAMENTO: DEPARTAMENTO,
                                    PROVINCIA: PROVINCIA,
                                    DISTRITO: DISTRITO,
                                    COD_UBIGEO: COD_UBIGEO,
                                    ID_DISTRITO: ID_DISTRITO ,
                                    ID_PROVINCIA: ID_PROVINCIA,
                                    ID_DEPARTAMENTO: ID_DEPARTAMENTO
                                });
                            }
                        });
                    }
                } else {
                    res.status(200).send({
                        ok: true,
                        message: 'Tiempo de respuesta agotado, intente de nuevo.'
                    });
                }
            }
        });
    });
});

// Post Data ruc sunat
app.get('/consultaruc/:ruc', (req, res, next ) => {
    var ruc = req.params.ruc;
    const request = require('request').defaults({jar: true});
    const cheerio = require('cheerio');
    const clean   = str => str.replace(/\s+/g, ' ');
    const urlCode = 'http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/captcha?accion=random';
    const urlPost = 'http://e-consultaruc.sunat.gob.pe/cl-ti-itmrconsruc/jcrS00Alias';

    request(urlCode, (err, response, code)=> {
        const formData = {
            nroRuc:ruc, 
            accion:'consPorRuc', 
            numRnd: code
        };
        request.post({url:urlPost, form: formData}, (err, response, body)=>{
            if (err) {
                res.status(500).send({
                    ok: false,
                    message: 'Error en la peticion.',
                    err: err
                });
            } else {
                if (response.statusCode == 200) {
                    const $ = cheerio.load(body);
                    const $table = $(".form-table").eq(2);
                    var text = '';
                    $table.find('tr').each((i, el) => {
                    const a = $(el).find('td[colspan=1]');
                    const b = $(el).find('td[colspan=3]');
                    text = text + ' ' + clean(a.text()) + clean(b.text())
                    });
                    if (text.length < 300 ) {
                        res.status(200).send({
                            ok: true,
                            message: 'Datos del RUC no encontrados.'
                        });
                    } else {
                        var iRuc = text.search("RUC: ");
                        var ifRuc = text.search(" -");
                        var RUC = text.slice(iRuc,ifRuc);
                        RUC = RUC.substr(5,12);

                        var iRs = text.search("- ");
                        var ifRs = text.search(" Tipo Contribuyente:");
                        var RAZON_SOCIAL = text.slice(iRs,ifRs);
                        RAZON_SOCIAL = RAZON_SOCIAL.substr(2,250);

                        var iNc = text.search("Nombre Comercial: ");
                        var ifNc = text.search(" Fecha de Inscripción:");
                        var NOMBRE_COMERCIAL = text.slice(iNc,ifNc);
                        NOMBRE_COMERCIAL = NOMBRE_COMERCIAL.substr(18,250);

                        var iEc = text.search("Estado del Contribuyente: ");
                        var ifEc = text.search("  Condición del Contribuyente:");
                        var ESTADO = text.slice(iEc,ifEc);
                        ESTADO = ESTADO.substr(26,6);

                        var iCc = text.search("Condición del Contribuyente: ");
                        var ifCc = text.search(" Dirección del Domicilio Fiscal:");
                        var CONDICION = text.slice(iCc,ifCc);
                        CONDICION = CONDICION.substr(29,6);

                        var iDc = text.search("Dirección del Domicilio Fiscal:");
                        var ifDc = text.search(" Sistema de Emisión de Comprobante:");
                        var DIRECCION = text.slice(iDc,ifDc);
                        DIRECCION = DIRECCION.substr(31,250);

                        var direccion = DIRECCION.split('-');
                        var pProvincia = direccion.length - 2;
                        var pDistrito = direccion.length - 1;

                        var PROVINCIA = (direccion[pProvincia].substr(1,100)).trim();
                        var DISTRITO = direccion[pDistrito].substr(1,100);

                        var params = `'${DISTRITO}', '${PROVINCIA}'`;
                        var request = new mssql.Request();
                        var lsql = `EXEC GET_UBIGEO ${params}`;
                    
                        var request = new mssql.Request();
                        request.query(lsql, (err, result) => {
                            if (err) { 
                                return res.status(500).send({
                                    ok: false,
                                    message: 'Error en la petición.',
                                    error: err
                                });
                            } else {
                                var ubigeo = result.recordset;

                                if (ubigeo.length === 0) {
                                    var COD_UBIGEO = '150101';
                                    var ID_DISTRITO = '1250'; 
                                    var ID_PROVINCIA = '129'; 
                                    var ID_DEPARTAMENTO = '16'; 
                                    var DEPARTAMENTO = '';
                                } else {
                                    var COD_UBIGEO = ubigeo[0].COD_UBIGEO;
                                    var ID_DISTRITO = ubigeo[0].ID_DISTRITO; 
                                    var ID_PROVINCIA = ubigeo[0].ID_PROVINCIA; 
                                    var ID_DEPARTAMENTO = ubigeo[0].ID_DEPARTAMENTO; 
                                    var DEPARTAMENTO = ubigeo[0].DS_DEPARTAMENTO; 
                                }
                                return res.status(200).send({
                                    ok: true,
                                    ok: true,
                                    RUC: RUC,
                                    RAZON_SOCIAL: RAZON_SOCIAL,
                                    NOMBRE_COMERCIAL: NOMBRE_COMERCIAL,
                                    ESTADO: ESTADO,
                                    CONDICION: CONDICION,
                                    DIRECCION: DIRECCION,
                                    DEPARTAMENTO: DEPARTAMENTO,
                                    PROVINCIA: PROVINCIA,
                                    DISTRITO: DISTRITO,
                                    COD_UBIGEO: COD_UBIGEO,
                                    ID_DISTRITO: ID_DISTRITO ,
                                    ID_PROVINCIA: ID_PROVINCIA,
                                    ID_DEPARTAMENTO: ID_DEPARTAMENTO
                                });
                            }
                        });
                    }
                } else {
                    res.status(200).send({
                        ok: true,
                        message: 'Tiempo de respuesta agotado, intente de nuevo.'
                    });
                }
            }
        });
    });
});
module.exports = app;
