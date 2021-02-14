'use strict'
var express = require('express');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());
var mdAuthenticattion = require('../middlewares/authenticated');
var nodemailer = require('nodemailer');

// // Get Vijes conductores 
// app.post('/viajes', (req, res) => {
//     var body = req.body;
//     var dni = body.DNI;    
//     var desde = body.DESDE;
//     var hasta = body.HASTA;    
//     var params = `'${dni}', '${desde}', '${hasta}'`;
//     var request = new mssql.Request();
//     var lsql = `EXEC SP_GET_VIAJES_COMISION_CONDUCTOR ${params}`;
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

// Get Vijes-horas-comision conductores 
app.get('/viajeshorascomision/:desde/:hasta/:dni/:search/:zona', mdAuthenticattion.verificarToken, (req, res) => {
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var dni = req.params.dni;  
    var search = req.params.search;
    var zona = req.params.zona;
    var params = `'${desde}', '${hasta}', '${dni}', '${search}', ${zona}`;
    var request = new mssql.Request();
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_VIAJES_COMISION_CONDUCTOR ${params}`;
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viajes = result.recordset;
            var comisionTotalViajes = 0;
            viajes.forEach(function (viaje) {
                comisionTotalViajes = comisionTotalViajes + viaje.ComisionImporte;
            });
            return res.status(200).send({
                ok: true, 
                cantHorasProducidas: 0,
                cantHorasApagar: 0,
                comisionTotalHoras: 0,
                comisionTotalViajes: parseFloat(comisionTotalViajes.toString()).toFixed(2),
                horasProducidas: 0,
                horasPagar: 0,
                viajes
            });                       
        }
    });
});
// End Vijes-horas-comision conductores 

// Get Vijes conductores 
app.get('/viajeshoras/:desde/:hasta/:dni/:search/:zona', (req, res) => {
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var dni = req.params.dni;  
    var search = req.params.search;
    var zona = req.params.zona;
    var params = `'${desde}', '${hasta}', '${dni}', '${search}', ${zona}`;
    var request = new mssql.Request();
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_VIAJES_CONDUCTOR ${params}`;   
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viajes = result.recordset;
            var comisionTotalViajes = 0;
            viajes.forEach(function (viaje) {
                comisionTotalViajes = comisionTotalViajes + viaje.TARIFA;
            });
            return res.status(200).send({
                ok: true, 
                cantHorasProducidas: 0,
                cantHorasApagar: 0,
                comisionTotalHoras: 0,
                comisionTotalViajes: parseFloat(comisionTotalViajes.toString()).toFixed(2),
                horasProducidas: 0,
                horasPagar: 0,
                viajes
            });                       
        }
    });
});
// End Vijes conductores 

// // Get Vijes conductores 
// app.get('/viajeshoras/:desde/:hasta/:dni/:search/:zona', (req, res) => {
//     var desde = req.params.desde;
//     var hasta = req.params.hasta;
//     var dni = req.params.dni;  
//     var search = req.params.search;
//     var zona = req.params.zona;
//     var params = `'${desde}', '${hasta}', '${dni}', '${search}', ${zona}`;
//     var request = new mssql.Request();
//     var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_VIAJES_CONDUCTOR ${params}`;   
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var viajes = result.recordset;
//             if (viajes) {
//                 params = `'${desde}', '${hasta}', '${dni}', ${zona}`;
//                 request = new mssql.Request();
//                 lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_VIAJES_CONDUCTOR_TARIFA ${params}`;
//                 request.query(lsql, (err, result) => {
//                     if (err) { 
//                         return res.status(500).send({
//                             ok: false,
//                             message: 'Error en la petición.',
//                             error: err
//                         });
//                     } else {
//                         var viajesTarifa = result.recordset;
//                         var cantHorasProducidas = 0;
//                         var cantHorasApagar = 0;
//                         var comisionTotalHoras = 0;
//                         var comisionTotalViajes = 0;
//                         viajesTarifa.forEach(function (viaje) { 
//                             cantHorasProducidas = cantHorasProducidas + viaje.CANTIDAD_HORAS_PRODUCIDAS;
//                             cantHorasApagar = cantHorasApagar + viaje.CANTIDAD_HORAS_PAGAR;
//                             comisionTotalHoras = comisionTotalHoras + viaje.COMISION_HORAS;
//                             comisionTotalViajes = comisionTotalViajes + viaje.COMISION_VIAJES;
//                         });

//                         request = new mssql.Request();
//                         lsql = `SELECT FE_SUPERVAN.DBO.FN_FORMATO_HORA(${cantHorasProducidas}) AS HORAS_PRODUCIDAS, FE_SUPERVAN.DBO.FN_FORMATO_HORA(${cantHorasApagar}) AS HORAS_PAGAR `;
//                         request.query(lsql, (err, result) => {
//                             if (err) { 
//                                 return res.status(500).send({
//                                     ok: false,
//                                     message: 'Error en la petición.',
//                                     error: err
//                                 });
//                             } else {
//                                 var horas = result.recordset[0];
//                                 return res.status(200).send({
//                                     ok: true, 
//                                     cantHorasProducidas: parseFloat(cantHorasProducidas.toString()).toFixed(2),
//                                     cantHorasApagar: parseFloat(cantHorasApagar.toString()).toFixed(2),
//                                     comisionTotalHoras: parseFloat(comisionTotalHoras.toString()).toFixed(2),
//                                     comisionTotalViajes: parseFloat(comisionTotalViajes.toString()).toFixed(2),
//                                     horasProducidas: horas.HORAS_PRODUCIDAS,
//                                     horasPagar: horas.HORAS_PAGAR,
//                                     viajes
//                                 });          
//                             }
//                         }); 
//                     }
//                 });
//             }         
//         }
//     });
// });
// // End Vijes conductores

// Get Vijes-tarifa conductores 
app.get('/viajestarifa/:desde/:hasta/:dni/:search/:zona', (req, res) => {
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var dni = req.params.dni;  
    var search = req.params.search;
    var zona = req.params.zona;
    var params = `'${desde}', '${hasta}', '${dni}', ${zona}`;
    var request = new mssql.Request();
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_VIAJES_CONDUCTOR_TARIFA ${params}`;
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

// Register Viatico
app.post('/viatico/:semana/:year/:zona/:montoTotal/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body; 
    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var montoTotal = req.params.montoTotal;
    var idUser = req.params.idUser;
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
            var arrayFhdesde = dias[0].FECHA.split('/');
            var arrayFhhasta = dias[6].FECHA.split('/');
            var fhDesde = arrayFhdesde[2] + '-' + arrayFhdesde[1] + '-' + arrayFhdesde[0];
            var fhHasta = arrayFhhasta[2] + '-' + arrayFhhasta[1] + '-' + arrayFhhasta[0];
            var cantRegistros = body.length;
            var params =  `${semana}, ${year}, ${zona}, '${fhDesde}', '${fhHasta}', ${montoTotal}, ${cantRegistros}, ${idUser}`;
            var lsql = `EXEC FE_SUPERVAN.DBO.SP_REGISTER_VIATICO ${params}`;    
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
                    var ID_VIATICO = viatico.ID_VIATICO;
                    if (ID_VIATICO == 0 ) {
                        return res.status(400).send({
                            ok: true,                             
                            message: viatico.MESSAGE
                        });
                    }
                    var viaticos = [];            
                    var i = 0;
                    var j = -1;                    
                    dias.forEach(function (dia) {
                        i++;
                        j = -1;                         
                        body.forEach(function (viatico) {
                            var turno1, turno2, turno3, check1 , check2, check3, fgViaje1, fgViaje2, fgViaje3;
                            if (i==1) {    
                                turno1 = viatico.dia1.turno1;
                                turno2 = viatico.dia1.turno2;
                                turno3 = viatico.dia1.turno3;
                                check1 = viatico.dia1.check1;
                                check2 = viatico.dia1.check2;
                                check3 = viatico.dia1.check3;
                                fgViaje1 = viatico.dia1.fgViaje1;
                                fgViaje2 = viatico.dia1.fgViaje2;
                                fgViaje3 = viatico.dia1.fgViaje3;
                            }
                            if (i==2) {    
                                turno1 = viatico.dia2.turno1;
                                turno2 = viatico.dia2.turno2;
                                turno3 = viatico.dia2.turno3;
                                check1 = viatico.dia2.check1;
                                check2 = viatico.dia2.check2;
                                check3 = viatico.dia2.check3;
                                fgViaje1 = viatico.dia2.fgViaje1;
                                fgViaje2 = viatico.dia2.fgViaje2;
                                fgViaje3 = viatico.dia2.fgViaje3;
                            }
                            if (i==3) {    
                                turno1 = viatico.dia3.turno1;
                                turno2 = viatico.dia3.turno2;
                                turno3 = viatico.dia3.turno3;
                                check1 = viatico.dia3.check1;
                                check2 = viatico.dia3.check2;
                                check3 = viatico.dia3.check3;
                                fgViaje1 = viatico.dia3.fgViaje1;
                                fgViaje2 = viatico.dia3.fgViaje2;
                                fgViaje3 = viatico.dia3.fgViaje3;
                            }
                            if (i==4) {    
                                turno1 = viatico.dia4.turno1;
                                turno2 = viatico.dia4.turno2;
                                turno3 = viatico.dia4.turno3;
                                check1 = viatico.dia4.check1;
                                check2 = viatico.dia4.check2;
                                check3 = viatico.dia4.check3;
                                fgViaje1 = viatico.dia4.fgViaje1;
                                fgViaje2 = viatico.dia4.fgViaje2;
                                fgViaje3 = viatico.dia4.fgViaje3;
                            }
                            if (i==5) {    
                                turno1 = viatico.dia5.turno1;
                                turno2 = viatico.dia5.turno2;
                                turno3 = viatico.dia5.turno3;
                                check1 = viatico.dia5.check1;
                                check2 = viatico.dia5.check2;
                                check3 = viatico.dia5.check3;
                                fgViaje1 = viatico.dia5.fgViaje1;
                                fgViaje2 = viatico.dia5.fgViaje2;
                                fgViaje3 = viatico.dia5.fgViaje3;
                            }
                            if (i==6) {    
                                turno1 = viatico.dia6.turno1;
                                turno2 = viatico.dia6.turno2;
                                turno3 = viatico.dia6.turno3;
                                check1 = viatico.dia6.check1;
                                check2 = viatico.dia6.check2;
                                check3 = viatico.dia6.check3;
                                fgViaje1 = viatico.dia6.fgViaje1;
                                fgViaje2 = viatico.dia6.fgViaje2;
                                fgViaje3 = viatico.dia6.fgViaje3;
                            }
                            if (i==7) {    
                                turno1 = viatico.dia7.turno1;
                                turno2 = viatico.dia7.turno2;
                                turno3 = viatico.dia7.turno3;
                                check1 = viatico.dia7.check1;
                                check2 = viatico.dia7.check2;
                                check3 = viatico.dia7.check3;
                                fgViaje1 = viatico.dia7.fgViaje1;
                                fgViaje2 = viatico.dia7.fgViaje2;
                                fgViaje3 = viatico.dia7.fgViaje3;
                            }                                
                            viaticos.push({
                                ID_VIATICO: 0,
                                ID_CONDUCTOR: viatico.ID_CONDUCTOR,
                                FECHA: dia.FECHA,
                                TURNO1: turno1,
                                TURNO2: turno2,
                                TURNO3: turno3,
                                CHECK1: check1,
                                CHECK2: check2,
                                CHECK3: check3,
                                FG_VIAJE1: fgViaje1,
                                FG_VIAJE2: fgViaje2,
                                FG_VIAJE3: fgViaje3,
                                REINTEGRO: viatico.REINTEGRO,   
                                TOTAL: viatico.TOTAL                             
                            });
                        });
                    });
                    params = [];
                    viaticos.forEach(function (viatico) {
                        var idViatico = ID_VIATICO;
                        var idConductor = viatico.ID_CONDUCTOR;
                        var arrayFecha = viatico.FECHA.split('/');
                        var fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                        var turno1 = viatico.TURNO1;
                        var turno2 = viatico.TURNO2;
                        var turno3 = viatico.TURNO3;
                        var check1 = viatico.CHECK1;
                        var check2 = viatico.CHECK2;
                        var check3 = viatico.CHECK3;
                        var fgViaje1 = viatico.FG_VIAJE1;
                        var fgViaje2 = viatico.FG_VIAJE2;
                        var fgViaje3 = viatico.FG_VIAJE3;
                        var reintegro = viatico.REINTEGRO;
                        var total = viatico.TOTAL;
                        if (check1) {
                            check1 = 1;
                        } else {
                            check1 = 0;
                        }
                        if (check2) {
                            check2 = 1;
                        } else {
                            check2 = 0;
                        }
                        if (check3) {
                            check3 = 1;
                        } else {
                            check3 = 0;
                        }
                        params = params + ',' + '\n' + `(${idViatico}, ${idConductor} , '${fecha}', ${turno1}, ${turno2}, ${turno3}, ${check1}, ${check2}, ${check3},${reintegro}, ${total}, ${idUser}, ${fgViaje1}, ${fgViaje2}, ${fgViaje3})`;
                    });

                    params = params.substring(1);
                    var lsql = `INSERT INTO FE_SUPERVAN.DBO.OP_DETA_VIATICOS_CONDUCTOR (ID_VIATICO,ID_CONDUCTOR,FECHA,TURNO1,TURNO2,TURNO3,CHECK1,CHECK2,CHECK3,REINTEGRO,TOTAL,ID_USUARIO_BS,FG_VIAJE1,FG_VIAJE2,FG_VIAJE3) 
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
                            var detaViaticos = result.rowsAffected[0];
                            return res.status(200).send({
                                ok: true,                             
                                viatico,
                                detaViaticos,
                                body,
                                viaticos
                            });
                        }
                    }); 
                }
            });
        }
    });
});
// End Register Viatico

// Update Viatico
app.put('/viatico/:semana/:year/:zona/:montoTotal/:id/:nroDia/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body; 
    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var montoTotal = req.params.montoTotal;
    var idViatico = req.params.id;
    var idUser = req.params.idUser;
    var i = parseInt(req.params.nroDia);
    var params =  `${idViatico}, ${montoTotal}, ${idUser}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_VIATICO_CONDUCTOR ${params}`;   
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viaticos = result.recordset[0];
            var viatico = body;
            var detaViaticos = [];  
            var fecha, turno1, turno2, turno3, check1 , check2, check3, arrayFecha;
            if (i==1) {               
                arrayFecha = viatico.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = viatico.dia1.turno1;
                turno2 = viatico.dia1.turno2;
                turno3 = viatico.dia1.turno3;
                check1 = viatico.dia1.check1;
                check2 = viatico.dia1.check2;
                check3 = viatico.dia1.check3;
            }
            if (i==2) {    
                arrayFecha = viatico.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = viatico.dia2.turno1;
                turno2 = viatico.dia2.turno2;
                turno3 = viatico.dia2.turno3;
                check1 = viatico.dia2.check1;
                check2 = viatico.dia2.check2;
                check3 = viatico.dia2.check3;
            }
            if (i==3) {   
                arrayFecha = viatico.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = viatico.dia3.turno1;
                turno2 = viatico.dia3.turno2;
                turno3 = viatico.dia3.turno3;
                check1 = viatico.dia3.check1;
                check2 = viatico.dia3.check2;
                check3 = viatico.dia3.check3;
            }
            if (i==4) {   
                arrayFecha = viatico.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0]; 
                turno1 = viatico.dia4.turno1;
                turno2 = viatico.dia4.turno2;
                turno3 = viatico.dia4.turno3;
                check1 = viatico.dia4.check1;
                check2 = viatico.dia4.check2;
                check3 = viatico.dia4.check3;
            }
            if (i==5) {    
                arrayFecha = viatico.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = viatico.dia5.turno1;
                turno2 = viatico.dia5.turno2;
                turno3 = viatico.dia5.turno3;
                check1 = viatico.dia5.check1;
                check2 = viatico.dia5.check2;
                check3 = viatico.dia5.check3;
            }
            if (i==6) {    
                arrayFecha = viatico.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = viatico.dia6.turno1;
                turno2 = viatico.dia6.turno2;
                turno3 = viatico.dia6.turno3;
                check1 = viatico.dia6.check1;
                check2 = viatico.dia6.check2;
                check3 = viatico.dia6.check3;
            }
            if (i==7) {    
                arrayFecha = viatico.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = viatico.dia7.turno1;
                turno2 = viatico.dia7.turno2;
                turno3 = viatico.dia7.turno3;
                check1 = viatico.dia7.check1;
                check2 = viatico.dia7.check2;
                check3 = viatico.dia7.check3;
            }                                
            detaViaticos.push({
                ID_VIATICO: 0,
                ID_CONDUCTOR: viatico.ID_CONDUCTOR,
                FECHA: fecha,
                TURNO1: turno1,
                TURNO2: turno2,
                TURNO3: turno3,
                CHECK1: check1,
                CHECK2: check2,
                CHECK3: check3,
                REINTEGRO: viatico.REINTEGRO,   
                TOTAL: viatico.TOTAL                             
            });
            var idConductor = detaViaticos[0].ID_CONDUCTOR;
            var fecha = detaViaticos[0].FECHA;
            var turno1 = detaViaticos[0].TURNO1;
            var turno2 = detaViaticos[0].TURNO2;
            var turno3 = detaViaticos[0].TURNO3;
            var check1 = detaViaticos[0].CHECK1;
            var check2 = detaViaticos[0].CHECK2;
            var check3 = detaViaticos[0].CHECK3;
            var reintegro = detaViaticos[0].REINTEGRO;
            var total = detaViaticos[0].TOTAL;
            if (check1) {
                check1 = 1;
            } else {
                check1 = 0;
            }
            if (check2) {
                check2 = 1;
            } else {
                check2 = 0;
            }
            if (check3) {
                check3 = 1;
            } else {
                check3 = 0;
            }
            params =  `${idViatico}, ${idConductor} , '${fecha}', ${turno1}, ${turno2}, ${turno3}, ${check1}, ${check2}, ${check3},${reintegro}, ${total}, ${idUser}`;
            lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_DETA_VIATICOS_CONDUCTOR ${params}`; 
            var request = new mssql.Request();
            request.query(lsql, (err, result) => {
                if (err) { 
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                } else {
                    var detaViatico = result.recordset[0];
                    return res.status(200).send({
                        ok: true,                             
                        detaViatico
                    });
                }
            });
        }
    });
});
// End Update Viatico

// Get Viaticos
app.get('/viaticos/:desde/:hasta/:search',mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var search = req.params.search;
    var params =  `'${desde}', '${hasta}', '${search}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_VIATICOS ${params}`;
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
            return res.status(200).send({
                ok: true,
                viaticos
            });
        }
    });  
});
// End Get Viaticos

// Get Viatico
app.get('/viatico/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idViatico = req.params.id;
    var params =  `${idViatico}`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_VIATICO ${params}`;
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
            if(!viatico) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe el registro de viáticos'
                });
            }          
            return res.status(200).send({
                ok: true,
                viatico
            });
        }
    });  
});
// End Get Viatico

// Delete viatico
app.delete('/viatico/:id/:user', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var id = req.params.id;
    var user = req.params.user;
    var params =  `${id}, ${user} `;
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_VIATICOS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viaticos = result.recordset[0];
            if(!viaticos) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existen registros de viaticos para anular.'
                });
            }
            if(viaticos.MESSAGE) {
                return res.status(400).send({
                    ok: true,
                    message: viaticos.MESSAGE
                });
            }      
            return res.status(200).send({
                ok: true,
                viaticos
            });
        }
    });  
});
// End Delete viaticos

// Aprobar viatico
app.put('/aprobarviatico/:id/:user', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var id = req.params.id;
    var user = req.params.user;
    var params =  `${id}, ${user} `;
    var lsql = `FE_SUPERVAN.DBO.SP_APROBAR_VIATICOS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viaticos = result.recordset[0];
            if(!viaticos) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existen registros de viaticos para anular.'
                });
            }
            if(viaticos.MESSAGE) {
                return res.status(400).send({
                    ok: true,
                    message: viaticos.MESSAGE
                });
            }      
            return res.status(200).send({
                ok: true,
                viaticos
            });
        }
    });  
});
// End Aprobar viaticos

// Get deta viaticos
app.get('/detaviaticos/:semana/:year/:id/:idConductor', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var semana = req.params.semana;
    var year = req.params.year;
    var idViatico = req.params.id;
    var idConductor = req.params.idConductor;
    var params =  `${idViatico}, ${idConductor}`;  
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_OP_DETA_VIATICOS_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var diasViaticos = result.recordset;

            if (diasViaticos) {
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
                        params =  `${idViatico}, ${idConductor}`;  
                        var lsql = `EXEC FE_SUPERVAN.DBO.SP_OP_DETA_VIATICOS_CONDUCTOR_TURNO ${params}`;
                        var request = new mssql.Request();
                        request.query(lsql, (err, result) => {
                            if (err) { 
                                return res.status(500).send({
                                    ok: false,
                                    message: 'Error en la petición.',
                                    error: err
                                });
                            } else {
                                var diasTurnoViatico = result.recordset;                                
                                var i = -1;
                                var j = -1;
                                var turnos = [];
                                dias.forEach(function (dia) {
                                    i++;                                
                                    j = -1;                                    
                                    diasViaticos.forEach(function (diasViatico) {
                                        j++;                                       
                                        const resultado = diasTurnoViatico.find( viatico => 
                                            viatico.NOMBRE_APELLIDO === diasViatico.NOMBRE_APELLIDO && viatico.FECHA === dia.FECHA 
                                        );                                      
                                        var turno1 = 0;
                                        var turno2 = 0;
                                        var turno3 = 0; 
                                        var check1 = false; 
                                        var check2= false;
                                        var check3 = false; 
                                        var fgViaje1 = 0; 
                                        var fgViaje2 = 0; 
                                        var fgViaje3 = 0;                                  
                                        if (resultado) {
                                            turno1 = resultado.TURNO1;
                                            turno2 = resultado.TURNO2;
                                            turno3 = resultado.TURNO3; 
                                            check1 = resultado.CHECK1; 
                                            check2 = resultado.CHECK2;
                                            check3 = resultado.CHECK3;
                                            fgViaje1 = resultado.FG_VIAJE1; 
                                            fgViaje2 = resultado.FG_VIAJE2;
                                            fgViaje3 = resultado.FG_VIAJE3;                                        
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1,
                                                turno2,
                                                turno3,
                                                check1,
                                                check2,
                                                check3,
                                                fgViaje1,
                                                fgViaje2,
                                                fgViaje3                                                    
                                            };
                                        } else {
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1: 0,
                                                turno2: 0,
                                                turno3: 0,
                                                check1: false,
                                                check2: false,
                                                check3: false,
                                                fgViaje1,
                                                fgViaje2,
                                                fgViaje3                                                    
                                            };
                                        }
                                        if (i==0) {                                           
                                            diasViaticos[j].dia1 = turnos;
                                        }
                                        if (i==1) {                                            
                                            diasViaticos[j].dia2 = turnos;
                                        }
                                        if (i==2) {                                           
                                            diasViaticos[j].dia3 = turnos;
                                        }
                                        if (i==3) {                                           
                                            diasViaticos[j].dia4 = turnos;
                                        }
                                        if (i==4) {                                         
                                        diasViaticos[j].dia5 = turnos;
                                        }
                                        if (i==5) {                                      
                                        diasViaticos[j].dia6 = turnos;
                                        }
                                        if (i==6) {
                                        diasViaticos[j].dia7 = turnos;
                                        }
                                    });
                                });
                                return res.status(200).send({
                                    ok: true,                           
                                    dias,
                                    diasViaticos: diasViaticos
                                });
                            }
                        }); 
                    }
                });
            } else {
                return res.status(400).send({
                    ok: true,
                    message: 'No existen registros.'
                });
            }
        }
    });
});
// End Get Detaviaticos

// Get report productividad conductor
app.get('/productividad/:semana/:year/:zona', mdAuthenticattion.verificarToken, (req, res, next ) => {

    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var params =  `${semana},${year},${zona}`;   
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_DETA_REPORT_PRODUCTIVIDAD_CONDUCTOR ${params}`;
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
            if (diasProductividad) {
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
                        var lsql = `EXEC FE_SUPERVAN.DBO.SP_DETA_REPORT_PRO_TURNO_CONDUCTOR ${params}`;
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
                                var i = -1;
                                var j = -1;
                                var turnos = [];
                                dias.forEach(function (dia) {
                                    i++;                                
                                    j = -1;                                    
                                    diasProductividad.forEach(function (diasProd) {
                                        j++;                                       
                                        const resultado = diasTurnoProductividad.find( viajes => 
                                            viajes.NOMBRE_APELLIDO === diasProd.NOMBRE_APELLIDO && viajes.FECHA === dia.FECHA 
                                        );
                                        var turno1 = 0;
                                        var turno2 = 0;
                                        var turno3 = 0; 
                                        var check1 = false; 
                                        var check2= false;
                                        var check3 = false;
                                        var fgViaje1 = false; 
                                        var fgViaje2 = false;
                                        var fgViaje3 = false;                                         
                                        if (resultado) {
                                            turno1 = resultado.TURNO1;
                                            turno2 = resultado.TURNO2;
                                            turno3 = resultado.TURNO3;

                                            fgViaje1 = resultado.FG_VIAJE1;
                                            fgViaje2 = resultado.FG_VIAJE2;
                                            fgViaje3 = resultado.FG_VIAJE3;
                                            
                                            if(fgViaje1 > 0) {
                                                check1 = 1;
                                            } else {
                                                check1 = resultado.CHECK1; 
                                            }

                                            if(fgViaje2 > 0) {
                                                check2 = 1;
                                            } else {
                                                check2 = resultado.CHECK2; 
                                            }

                                            if(fgViaje3 > 0) {
                                                check3 = 1;
                                            } else {
                                                check3 = resultado.CHECK3; 
                                            }

                                            if(resultado.CHECK1 == 1) {
                                                fgViaje1 = 1
                                            }

                                            if(resultado.CHECK2 == 1) {
                                                fgViaje2 = 1
                                            }

                                            if(resultado.CHECK3 == 1) {
                                                fgViaje3 = 1
                                            }
         
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1,
                                                turno2,
                                                turno3,
                                                check1,
                                                check2,
                                                check3,
                                                fgViaje1,
                                                fgViaje2,
                                                fgViaje3                                                    
                                            };
                                        } else {
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1: 0,
                                                turno2: 0,
                                                turno3: 0,
                                                check1,
                                                check2,
                                                check3,
                                                fgViaje1,
                                                fgViaje2,
                                                fgViaje3                                                      
                                            };
                                        }
                                        if (i==0) {                                           
                                            diasProductividad[j].dia1 = turnos;
                                        }
                                        if (i==1) {                                            
                                            diasProductividad[j].dia2 = turnos;
                                        }
                                        if (i==2) {                                           
                                            diasProductividad[j].dia3 = turnos;
                                        }
                                        if (i==3) {                                           
                                            diasProductividad[j].dia4 = turnos;
                                        }
                                        if (i==4) {                                         
                                        diasProductividad[j].dia5 = turnos;
                                        }
                                        if (i==5) {                                      
                                        diasProductividad[j].dia6 = turnos;
                                        }
                                        if (i==6) {
                                        diasProductividad[j].dia7 = turnos;
                                        }
                                        diasProductividad[j].REINTEGRO = 0;
                                        diasProductividad[j].TOTAL = 0;
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
            } else {
                return res.status(400).send({
                    ok: true,
                    message: 'No existen registros.'
                });
            }
        }
    });
});
// End Get productividad

// Get resumen viaticos
app.get('/resumenviaticos/:id',mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idViatico = req.params.id;
    var params =  `${idViatico}`;
    var lsql = `FE_SUPERVAN.DBO.SP_PLANILLA_VIATICOS_RESUMEN ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viaticosResumen = result.recordset;            
            return res.status(200).send({
                ok: true,
                viaticosResumen
            });
        }
    });  
});
// End Get resumen viaticos

// Get resumen viaticos por conductor
app.get('/resumenviaticosporconductor/:idConductor/:desde/:hasta',mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idConductor = req.params.idConductor;
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var params =  `'${idConductor}', '${desde}', '${hasta}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_VIEW_OP_PLANILLA_VIATICO_POR_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viaticosResumen = result.recordset;            
            return res.status(200).send({
                ok: true,
                viaticosResumen
            });
        }
    });  
});
// End Get resumen viaticos por conductor

// Get resumen viaticos por conductor
app.get('/detaviaticoporconductor/:idViatico/:idConductor',mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idViatico = req.params.idViatico;
    var idConductor = req.params.idConductor;
    var params =  `${idViatico}, '${idConductor}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_DETA_VIATICO_POR_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detalleViatico = result.recordset;            
            return res.status(200).send({
                ok: true,
                detalleViatico
            });
        }
    });  
});
// End Get resumen viaticos por conductor

// Register peaje
app.post('/peaje', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;
    var peaje = body.peaje;
    var detaPeaje = body.detaPeaje;
    var params =  `${peaje.ID_ORDEN_SERVICIO},${peaje.CANT_REGISTROS},${peaje.MONTO_TOTAL},${peaje.ID_USUARIO_BS},'${peaje.OBSERVACION}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_PEAJE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajeRegistrado = result.recordset[0];
            var idPeaje = peajeRegistrado.ID_PEAJE;
            if (peajeRegistrado) {
                if (!idPeaje) {
                    return res.status(400).send({
                        ok: false,
                        message: peajeRegistrado.MESSAGE,
                        error: err
                    });
                }
                params = [];
                detaPeaje.forEach(function (detalle) {
                    var arrayFecha = detalle.fecha.split('-');
                    var fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0]; 
                    params = params + ',' + '\n' + `(${idPeaje},${detalle.idConductor},${detalle.monto},'${detalle.fecha}')`;
                });
                params = params.substring(1);
                var lsql = `INSERT INTO FE_SUPERVAN.DBO.OP_DETA_PEAJES (ID_PEAJE,ID_CONDCUTOR,MONTO,FECHA) 
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
                        var cantDetaPeajes = result.rowsAffected[0];
                        params = peajeRegistrado.ID_PEAJE;
                        var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIEW_OP_DETA_PEAJES ${params}`;
                        var request = new mssql.Request();
                        request.query(lsql, async (err, result) => {
                            if (err) { 
                                return res.status(500).send({
                                    ok: false,
                                    message: 'Error en la petición.',
                                    error: err
                                });
                            } else {
                                var detaPeajes = result.recordset;
                                var detalle = '';
                                detaPeajes.forEach(function (deta) {
                                    detalle = detalle + '\n' + `
                                    <tr>                   
                                        <td>${deta.ITEMS}</td>
                                        <td>${deta.NOMBRE_APELLIDO}</td>
                                        <td>${deta.IDENTIFICACION}</td>
                                        <td>${deta.MONTO}</td>
                                        <td>${deta.FH_PEAJE}</td> 
                                    </tr>`;
                                });

                                var css = `
                                .table-peaje {
                                    border-collapse: collapse;
                                    border: 1px solid;
                                    width: 500px;
                                }
                
                                .table-peaje td  {  
                                    border: 1px solid;
                                    text-align:center;
                                }
                
                                .table-detalle {
                                    border-collapse: collapse;
                                    border: 1px solid;
                                    width: 100%
                                }
                
                                .table-detalle td {  
                                    border: 1px solid;
                                    text-align:center;
                                }
                
                                .table-detalle thead td {  
                                    font-weight: bold;
                                    background: #AEAEAE;
                                }
                                `;
                
                                var contentHtml = `
                                <style>
                                    ${css}
                                </style>
                                <div>
                                    <h2>Se ha generado una solicitud de gastos operativos</h2>
                                    <h4>Información de la solicitud:</h4>
                                    <table class="table-peaje"">
                                        <tr>
                                            <td>Nro. Solicitud:</td>
                                            <td>${peajeRegistrado.ID_PEAJE}</td>
                                        </tr>
                                        <tr>
                                            <td>Fecha Solicitud:</td>
                                            <td>${peajeRegistrado.FECHA}</td>
                                        </tr>
                                        <tr>
                                            <td>Monto Total S/:</td>
                                            <td>${peajeRegistrado.MONTO_TOTAL}</td>
                                        </tr>
                                        <tr>
                                            <td>Nro. Orden de Servicio:</td>
                                            <td>${peajeRegistrado.CORRELATIVO}</td>
                                        </tr>
                                        <tr>
                                            <td>Cliente:</td>
                                            <td>${peajeRegistrado.RAZON_SOCIAL}</td>
                                        </tr>
                                        <tr>
                                            <td>Ruta:</td>
                                            <td>${peajeRegistrado.ORIGEN} - ${peajeRegistrado.DESTINO}</td>
                                        </tr>
                                    </table>
                                    
                                    <p>${peajeRegistrado.OBSERVACION}</p>

                                    <hr>
                                    <h4>Detalles de la solicitud</h4>
                                    <table class="table-detalle">
                                        <thead>
                                            <tr>            
                                                <td>Item</td>          
                                                <td>Conductor</td> 
                                                <td>DNI</td>
                                                <td>Monto S/</td>
                                                <td>Fecha</td>      
                                            </tr>
                                        </thead>
                                        <tbody>
                                            ${detalle}
                                        </tbody>
                                    </table>
                                </div>
                                `;

                                // Enviar correo
                                const transporter = nodemailer.createTransport({
                                    host: 'briane.pe',
                                    port: 465,
                                    auth: {
                                        user: 'briane.smart@briane.pe',
                                        pass: 'Brian@2020'
                                    },
                                });            
                                var infoMail = '';
                                var datosEnvio = {
                                    from: "BRIANE SMART <briane.smart@briane.pe>",
                                    // to: 'luis.galicia@supervan.pe,galicialuis@hotmail.es,luisgalic@gmail.com',
                                    to: 'carlos.inocente@supervan.pe;reyza.narciso@supervan.pe;gabriela.napa@supervan.pe',
                                    // cc: 'luisgalic@gmail.com',
                                    cc: 'marlon.gutierrez@supervan.pe;gerty.guanilo@supervan.pe;freddy.herrera@supervan.pe',
                                    bcc: 'briane.smart@briane.pe',
                                    subject: 'Notificaciones BRIANE SMART',
                                    html: contentHtml
                                }
                                transporter.sendMail(datosEnvio, function(error, info){
                                    if (error) {
                                        console.log('error:', error);
                                    } else {
                                        infoMail = info.messageId
                                    }
                                });
                                // // FIN ENVIAR CORREO
                                // ////////////////////////////////////////////////////////////
                                
                                return res.status(200).send({
                                    ok: true,                             
                                    peajeRegistrado,
                                    cantDetaPeajes,
                                    infoMail: infoMail
                                });
                            }
                        });
                    }
                });
            } else {
                return res.status(400).send({
                    ok: false,
                    message: 'Error en el registro de peaje'
                });      
            }
        }
    });  
});
// End Register peaje

// Get peajes
app.get('/peajes/:desde/:hasta/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var search = req.params.search;
    var params =  `'${desde}','${hasta}','${search}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_VIEW_OP_PEAJES_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajes = result.recordset;   
            return res.status(200).send({
                ok: true,
                peajes
            });
        }
    });  
});
// End Get peajes

// Get peaje
app.get('/peaje/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idPeaje = req.params.id;
    var params =  `${idPeaje}`;
    var lsql = `FE_SUPERVAN.DBO.SP_PEAJES_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peaje = result.recordset[0];
            // var idPeaje = 
            if (peaje) {
                var lsql = `FE_SUPERVAN.DBO.SP_DETA_PEAJES ${params}`;
                var request = new mssql.Request();
                request.query(lsql, (err, result) => {
                    if (err) { 
                        return res.status(500).send({
                            ok: false,
                            message: 'Error en la petición.',
                            error: err
                        });
                    } else {
                        var detaPeajes = result.recordset;
                        return res.status(200).send({
                            ok: true,
                            peaje,
                            detaPeajes
                        });
                    }
                });
            } else {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe el registro de peaje.',
                });
            }  
        }
    });  
});
// End Get peaje

// Get peajes saldos
app.get('/peajesaldos/:desde/:hasta/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var search = req.params.search;
    var params =  `'${desde}','${hasta}','${search}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_VIEW_OP_DETA_PEAJES_SALDOS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajeSaldos = result.recordset;   
            return res.status(200).send({
                ok: true,
                peajeSaldos
            });
        }
    });  
});
// End Get peajes saldos

// Update peaje
app.put('/peaje', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;
    var peaje = body.peaje;
    var params =  `${peaje.ID_PEAJE},${peaje.ID_ORDEN_SERVICIO},${peaje.CANT_REGISTROS},${peaje.MONTO_TOTAL},'${peaje.OBSERVACION}',${peaje.ID_USUARIO_BS}`;
    var lsql = `FE_SUPERVAN.DBO.SP_UPDATE_PEAJES_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peaje = result.recordset[0];
            if (!peaje) {
                return res.status(400).send({
                    ok: false,
                    message: 'No existe el registro de peaje.'
                });  
            }
            if (peaje) {
                var idPeaje = peaje.ID_PEAJE;
                if (!idPeaje) {
                    return res.status(400).send({
                        ok: false,
                        message: peaje.MESSAGE
                    });  
                }
                return res.status(200).send({
                    ok: true,                             
                    peaje
                });
            }
        }
    });  
});
// End Update peaje

// Register deta peaje
app.post('/detapeaje', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;
    var peaje = body;
    var params =  `${peaje.idPeaje},${peaje.idConductor},${peaje.monto},'${peaje.fecha}','${peaje.idUser}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_DETA_PEAJE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaPeaje = result.recordset[0];
            var idDetaPeaje = detaPeaje.ID_DETA_PEAJE;
            if (!idDetaPeaje) {
                return res.status(400).send({
                    ok: true,
                    message: detaPeaje.MESSAGE
                }); 
            }
            return res.status(200).send({
                ok: true,                             
                detaPeaje
            });
        }
    });  
});
// End Register deta peaje

// Delete deta peajes
app.delete('/detapeajes/:idPeaje/:idDeta/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idPeaje = req.params.idPeaje;
    var idDeta = req.params.idDeta;
    var idUser = req.params.idUser;
    var params =  `${idPeaje},${idDeta},${idUser}`;
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_DETA_PEAJE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaPeaje = result.recordset[0];
            if (detaPeaje) {
                var idDetaPeaje = detaPeaje.ID_DETA_PEAJE;
                if (!idDetaPeaje) {
                    return res.status(400).send({
                        ok: true,
                        message: detaPeaje.MESSAGE
                    }); 
                }
                return res.status(200).send({
                    ok: true,
                    detaPeaje
                });
            } else {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe registro del detalle de peaje.',
                }); 
            }
        }
    });  
});
// End Delete deta peajes

// Delete  peajes
app.delete('/peaje/:idPeaje/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idPeaje = req.params.idPeaje;
    var idUser = req.params.idUser;
    var params =  `${idPeaje},${idUser}`;
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_PEAJES_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peaje = result.recordset[0];
            if (peaje) {
                var idPeaje = peaje.ID_PEAJE;
                if (!idPeaje) {
                    return res.status(400).send({
                        ok: true,
                        message: peaje.MESSAGE
                    }); 
                }
                return res.status(200).send({
                    ok: true,
                    peaje
                });
            } else {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe el registro de peaje.',
                }); 
            }
        }
    });  
});
// End Delete peajes

// Register peaje factura
app.post('/peajefact', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;
    var factura = body;
    if (factura.idTipoDoc === 1) {
        var arrayNroDoc = factura.numero.split('-');
        var nroDoc = arrayNroDoc[0].toUpperCase() + '-' + arrayNroDoc[1].padStart(8 , 0)    
    } else {
        var nroDoc = factura.numero.padStart(8 , 0) 
    }
    var params =  `${factura.idPeaje},${factura.idDetallePeaje},'${nroDoc}',${factura.monto},'${factura.fecha}',${factura.idGuia},${factura.idUser},${factura.idTipoDoc},${factura.idConceptoGastosOp}`;
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_RELACION_PEAJE_FACTURA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajeFactura = result.recordset[0];
            if (peajeFactura) {
                var idRelacionPeajes = peajeFactura.ID_RELACION_PEAJES;
                if (!idRelacionPeajes) {
                    return res.status(400).send({
                        ok: false,                             
                        message: peajeFactura.MESSAGE
                    });
                }
                return res.status(200).send({
                    ok: true,                             
                    peajeFactura
                });
            }
        }
    });  
});
// End Register peaje factura

// Register peaje factura app
app.post('/peajefactapp', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;
    var factura = body;
    if (factura.idTipoDoc === 1) {
        var arrayNroDoc = factura.numero.split('-');
        var nroDoc = arrayNroDoc[0].toUpperCase() + '-' + arrayNroDoc[1].padStart(8 , 0)    
    } else {
        var nroDoc = factura.numero.padStart(8 , 0) 
    }
    var params =  `0,0,'${nroDoc}',${factura.monto},'${factura.fecha}',${factura.idGuia},${factura.idUser},${factura.idTipoDoc},'${factura.dni}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_RELACION_PEAJE_FACTURA_APP ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajeFactura = result.recordset[0];
            if (peajeFactura) {
                var idRelacionPeajes = peajeFactura.ID_RELACION_PEAJES;
                if (!idRelacionPeajes) {
                    return res.status(400).send({
                        ok: false,                             
                        message: peajeFactura.MESSAGE
                    });
                }
                return res.status(200).send({
                    ok: true,                             
                    peajeFactura
                });
            }
        }
    });  
});
// End Register peaje factura app

// Get peajes facturas
app.get('/peajefact/:idDeta', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idDeta = req.params.idDeta;
    var params =  `${idDeta}`;
    var lsql = `FE_SUPERVAN.DBO.SP_OP_RELACION_PEAJE_FACTURAS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajesFacturas = result.recordset;   
            return res.status(200).send({
                ok: true,
                peajesFacturas
            });
        }
    });  
});
// End Get peajes facturas

// Delete peaje factura
app.delete('/peajefact/:id/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var id = req.params.id;
    var idUser = req.params.idUser;
    var params =  `${id},${idUser}`;
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_PEAJE_FACTURA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajeFactura = result.recordset[0];
            if (peajeFactura) {
                var idRelacion = peajeFactura.ID_RELACION_PEAJES;
                if (!idRelacion) {
                    return res.status(400).send({
                        ok: true,
                        message: peajeFactura.MESSAGE
                    }); 
                }
                return res.status(200).send({
                    ok: true,
                    peajeFactura
                });
            } else {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe el registro de factura.',
                }); 
            }
        }
    });  
});
// End Delete peaje factura

// Get tipo documento peajes
app.get('/peajes/documentos', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var lsql = `FE_SUPERVAN.DBO.SP_OP_TIPO_DOC_PEAJE`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentosPeaje = result.recordset;   
            return res.status(200).send({
                ok: true,
                documentosPeaje
            });
        }
    });  
});
// End Get tipo documento peajes

// Update deta peaje 
app.put('/detapeaje/:idDeta/:valor/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idDeta = req.params.idDeta;
    var valor = req.params.valor;
    var idUser = req.params.idUser;
    var params =  `${idDeta}, ${valor},${idUser}`;
    var lsql = `FE_SUPERVAN.DBO.SP_UPDATE_DETA_PEAJES_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaPeaje = result.recordset[0]; 
            var idPeaje = detaPeaje.ID_PEAJE;
            if (!idPeaje) {
                return res.status(400).send({
                    ok: false,
                    message: detaPeaje.MESSAGE
                });
            }
        }
    });  
});
// End Update deta peaje 

// Update all deta peaje 
app.put('/alldetapeaje/:idPeaje/:valor/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idPeaje = req.params.idPeaje;
    var valor = req.params.valor;
    var idUser = req.params.idUser;
    var params =  `${idPeaje}, ${valor},${idUser}`;
    var lsql = `FE_SUPERVAN.DBO.SP_UPDATE_ALL_DETA_PEAJES_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaPeajes = result.recordset; 
            var idPeaje = detaPeajes[0].ID_PEAJE;
            if (!idPeaje) {
                return res.status(400).send({
                    ok: false,
                    message: detaPeajes[0].MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                detaPeajes
            });
        }
    });  
});
// End Update all deta peaje 

// Procesar peaje
app.put('/procesarpeaje/:id/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var id = req.params.id;
    var idUser = req.params.idUser;
    var params =  `${id},${idUser}`;
    var lsql = `FE_SUPERVAN.DBO.SP_PROCESAR_PEAJES_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, async (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajes = result.recordset;
            if (peajes.length > 0) {
                var idPeaje = peajes[0].ID_PEAJE;
                if (!idPeaje) {
                    return res.status(400).send({
                        ok: true,
                        message: peajes[0].MESSAGE
                    }); 
                }

                var detalle = '';
                peajes.forEach(function (deta) {
                    detalle = detalle + '\n' + `
                    <tr>                   
                        <td>${deta.ITEMS}</td>
                        <td>${deta.NOMBRE_APELLIDO}</td>
                        <td>${deta.IDENTIFICACION}</td>
                        <td>${deta.MONTO}</td>
                        <td>${deta.FH_PEAJE}</td> 
                    </tr>`;
                });

                var css = `
                .table-peaje {
                    border-collapse: collapse;
                    border: 1px solid;
                    width: 500px;
                }

                .table-peaje td  {  
                    border: 1px solid;
                    text-align:center;
                }

                .table-detalle {
                    border-collapse: collapse;
                    border: 1px solid;
                    width: 100%
                }

                .table-detalle td {  
                    border: 1px solid;
                    text-align:center;
                }

                .table-detalle thead td {  
                    font-weight: bold;
                    background: #AEAEAE;
                }
                `;

                var contentHtml = `
                <style>
                    ${css}
                </style>
                <div>
                    <h2>Se ha procesado una solicitud de gastos operativos</h2>
                    <h4>Información de la solicitud:</h4>
                    <table class="table-peaje"">
                        <tr>
                            <td>Nro. Solicitud:</td>
                            <td>${peajes[0].ID_PEAJE}</td>
                        </tr>
                        <tr>
                            <td>Fecha Solicitud:</td>
                            <td>${peajes[0].FH_SOLICITUD}</td>
                        </tr>
                        <tr>
                            <td>Monto Total S/:</td>
                            <td>${peajes[0].MONTO_TOTAL}</td>
                        </tr>
                        <tr>
                            <td>Nro. Orden de Servicio:</td>
                            <td>${peajes[0].CORRELATIVO}</td>
                        </tr>
                        <tr>
                            <td>Cliente:</td>
                            <td>${peajes[0].RAZON_SOCIAL}</td>
                        </tr>
                        <tr>
                            <td>Ruta:</td>
                            <td>${peajes[0].ORIGEN} - ${peajes[0].DESTINO}</td>
                        </tr>
                    </table>                  
                    <hr>
                    <h4>Se ha realizado el deposito a los siguientes conductores:</h4>
                    <table class="table-detalle">
                        <thead>
                            <tr>            
                                <td>Item</td>          
                                <td>Conductor</td> 
                                <td>DNI</td>
                                <td>Monto S/</td>
                                <td>Fecha</td>      
                            </tr>
                        </thead>
                        <tbody>
                            ${detalle}
                        </tbody>
                    </table>
                </div>
                `;
                /////////////////////////////////////////////////////////
                // Enviar correo              
                const transporter = nodemailer.createTransport({
                    host: 'briane.pe',
                    port: 465,
                    auth: {
                        user: 'briane.smart@briane.pe',
                        pass: 'Brian@2020'
                    },
                });            
                var infoMail = '';
                var datosEnvio = {
                    from: "BRIANE SMART <briane.smart@briane.pe>",
                    // to: 'luis.galicia@supervan.pe',
                    to: 'marlon.gutierrez@supervan.pe;gerty.guanilo@supervan.pe;freddy.herrera@supervan.pe',
                    // cc: 'luisgalic@gmail.com',
                    cc: 'carlos.inocente@supervan.pe;reyza.narciso@supervan.pe;gabriela.napa@supervan.pe',
                    bcc: 'briane.smart@briane.pe',
                    subject: 'Notificaciones BRIANE SMART',
                    html: contentHtml
                }
                transporter.sendMail(datosEnvio, function(error, info){
                    if (error) {
                        console.log('error:', error);
                    } else {
                        infoMail = info.messageId
                    }
                });
                // FIN ENVIAR CORREO
                ////////////////////////////////////////////////////////////
                return res.status(200).send({
                    ok: true,                     
                    peajes
                });

            } else {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe el registro de factura.',
                }); 
            }
        }
    });  
});
// End procesar peaje

// Liquidar peaje
app.put('/liquidarpeaje/:id/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var id = req.params.id;
    var idUser = req.params.idUser;
    var params =  `${id},${idUser}`;
    var lsql = `FE_SUPERVAN.DBO.SP_LIQUIDAR_PEAJES_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, async (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajes = result.recordset;
            if (peajes) {
                var idPeaje = peajes[0].ID_PEAJE;
                if (!idPeaje) {
                    return res.status(400).send({
                        ok: true,
                        message: peajes[0].MESSAGE
                    }); 
                }
                return res.status(200).send({
                    ok: true,
                    peajes
                }); 
            }
        }
    });
});

// Notificar saldos peaje
app.post('/notificarsaldos/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;
    var idUser = req.params.idUser;
    var params = '';
    var detalle = '';
    var i = 0;   
    body.forEach(function (deta) {
        i++;
        params = params + ',' + '\n' + `(${deta.idDetaPeaje}, 1)`;
        detalle = detalle + '\n' + `
        <tr>                   
            <td>${i}</td>
            <td>${deta.nroSolicitudPeaje}</td>
            <td>${deta.fechaSolicitudPeaje}</td>
            <td>${deta.nroOrdenServicio}</td>
            <td>${deta.conductor}</td>
            <td>${deta.dni}</td>
            <td>${deta.fechaPeaje}</td>
            <td>${deta.montoPeaje}</td>
            <td>${deta.saldo}</td> 
        </tr>`;
    });     
    params = params.substring(1);   
    var lsql = `UPDATE A SET A.FG_NOTIFICADO = N.valor FROM FE_SUPERVAN.DBO.OP_DETA_PEAJES A JOIN (VALUES ${params}) N (idDeta, valor) ON A.ID_DETA_PEAJE = idDeta`;
    var request = new mssql.Request();
    request.query(lsql, async (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var notificacion = result.rowsAffected[0];
            if (notificacion !== body.length) {
                return res.status(400).send({
                    ok: false,
                    message: 'No se pudo enviar la notificación.'
                });
            }
            var css = `
            .table-peaje {
                border-collapse: collapse;
                border: 1px solid;
                width: 500px;
            }
            .table-peaje td  {  
                border: 1px solid;
                text-align:center;
            }
            .table-detalle {
                border-collapse: collapse;
                border: 1px solid;
                width: 100%
            }
            .table-detalle td {  
                border: 1px solid;
                text-align:center;
            }
            .table-detalle thead td {  
                font-weight: bold;
                background: #AEAEAE;
            }
            `;

            var contentHtml = `
            <style>
                ${css}
            </style>
            <div>
                <h2>Listado de conductores con saldos de peaje</h2>           
                <table class="table-detalle">
                    <thead>
                        <tr>            
                            <td>Item</td>          
                            <td>Nro. Solicitud Peaje</td> 
                            <td>Fecha Solicitud</td>
                            <td>Nro. Orden Servicio</td>
                            <td>Conductor</td>
                            <td>DNI</td>
                            <td>Fecha Peaje</td>
                            <td>Monto S/</td>
                            <td>Saldo S/</td>        
                        </tr>
                    </thead>
                    <tbody>
                        ${detalle}
                    </tbody>
                </table>
            </div>
            `;
            /////////////////////////////////////////////////////////
            // Enviar correo              
            const transporter = nodemailer.createTransport({
                host: 'briane.pe',
                port: 465,
                auth: {
                    user: 'briane.smart@briane.pe',
                    pass: 'Brian@2020'
                },
            });            
            var infoMail = '';
            // var datosEnvio = {
            //     from: "BRIANE SMART <briane.smart@briane.pe>",
            //     to: 'luis.galicia@supervan.pe',
            //     bcc: 'briane.smart@briane.pe',
            //     subject: 'Notificaciones BRIANE SMART',
            //     html: contentHtml
            // }
            // transporter.sendMail(datosEnvio, function(error, info){
            //     if (error) {
            //         console.log('error:', error);
            //     } else {
            //         // console.log('info:', info);
            //         infoMail = info.messageId
            //     }
            // });

            var infoMail = await transporter.sendMail({
                from: "BRIANE SMART <briane.smart@briane.pe>",
                // to: 'luis.galicia@supervan.pe;',
                to: 'renzo.rodriguez@supervan.pe;richard.alfaro@supervan.pe',
                // cc: 'luisgalic@gmail.com',
                cc: 'carlos.inocente@supervan.pe;reyza.narciso@supervan.pe;gabriela.napa@supervan.pe',
                bcc: 'briane.smart@briane.pe',
                subject: 'Notificaciones BRIANE SMART',
                html: contentHtml
            });
            if (infoMail) {
                return res.status(200).send({
                    ok: true,
                    notificacion,
                    infoMail: infoMail.messageId
                });
            } else {
                return res.status(400).send({
                    ok: false,
                    message: 'No se pudo enviar la notificación.'
                });
            } 
        }
    });
});
// End notificar saldos peaje

// Get peajes descuentos
app.get('/peajesdescuentos/:desde/:hasta/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var search = req.params.search;
    var params =  `'${desde}','${hasta}','${search}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_VIEW_OP_DETA_PEAJES_DESCUENTOS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var peajeDescuentos = result.recordset;   
            return res.status(200).send({
                ok: true,
                peajeDescuentos
            });
        }
    });  
});
// End Get peajes descuentos

// Notificar saldos peaje
app.post('/descontarsaldospeajes/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;
    var idUser = req.params.idUser;
    var params = '';
    var detalle = '';
    var i = 0;   
    body.forEach(function (deta) {
        i++;
        params = params + ',' + '\n' + `(${deta.idDetaPeaje}, 1)`;
        detalle = detalle + '\n' + `
        <tr>                   
            <td>${i}</td>
            <td>${deta.nroSolicitudPeaje}</td>
            <td>${deta.fechaSolicitudPeaje}</td>
            <td>${deta.nroOrdenServicio}</td>
            <td>${deta.conductor}</td>
            <td>${deta.dni}</td>
            <td>${deta.fechaPeaje}</td>
            <td>${deta.montoPeaje}</td>
            <td>${deta.saldo}</td> 
        </tr>`;
    });     
    params = params.substring(1);   
    var lsql = `UPDATE A SET A.FG_DESCONTADO = N.valor FROM FE_SUPERVAN.DBO.OP_DETA_PEAJES A JOIN (VALUES ${params}) N (idDeta, valor) ON A.ID_DETA_PEAJE = idDeta`;
    var request = new mssql.Request();
    request.query(lsql, async (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var descuento = result.rowsAffected[0];
            if (descuento !== body.length) {
                return res.status(400).send({
                    ok: false,
                    message: 'No se pudo ralizar el descuento.'
                });
            }
            // var css = `
            // .table-peaje {
            //     border-collapse: collapse;
            //     border: 1px solid;
            //     width: 500px;
            // }
            // .table-peaje td  {  
            //     border: 1px solid;
            //     text-align:center;
            // }
            // .table-detalle {
            //     border-collapse: collapse;
            //     border: 1px solid;
            //     width: 100%
            // }
            // .table-detalle td {  
            //     border: 1px solid;
            //     text-align:center;
            // }
            // .table-detalle thead td {  
            //     font-weight: bold;
            //     background: #AEAEAE;
            // }
            // `;

            // var contentHtml = `
            // <style>
            //     ${css}
            // </style>
            // <div>
            //     <h2>Listado de conductores con saldos de peaje</h2>           
            //     <table class="table-detalle">
            //         <thead>
            //             <tr>            
            //                 <td>Item</td>          
            //                 <td>Nro. Solicitud Peaje</td> 
            //                 <td>Fecha Solicitud</td>
            //                 <td>Nro. Orden Servicio</td>
            //                 <td>Conductor</td>
            //                 <td>DNI</td>
            //                 <td>Fecha Peaje</td>
            //                 <td>Monto S/</td>
            //                 <td>Saldo S/</td>        
            //             </tr>
            //         </thead>
            //         <tbody>
            //             ${detalle}
            //         </tbody>
            //     </table>
            // </div>
            // `;
            /////////////////////////////////////////////////////////
            // Enviar correo              
            // const transporter = nodemailer.createTransport({
            //     host: 'briane.pe',
            //     port: 465,
            //     auth: {
            //         user: 'briane.smart@briane.pe',
            //         pass: 'Brian@2020'
            //     },
            // });            
            // var infoMail = '';
            // var datosEnvio = {
            //     from: "BRIANE SMART <briane.smart@briane.pe>",
            //     to: 'luis.galicia@supervan.pe',
            //     bcc: 'briane.smart@briane.pe',
            //     subject: 'Notificaciones BRIANE SMART',
            //     html: contentHtml
            // }
            // transporter.sendMail(datosEnvio, function(error, info){
            //     if (error) {
            //         console.log('error:', error);
            //     } else {
            //         // console.log('info:', info);
            //         infoMail = info.messageId
            //     }
            // });

            // var infoMail = await transporter.sendMail({
            //     from: "BRIANE SMART <briane.smart@briane.pe>",
            //     to: 'luis.galicia@supervan.pe;',
            //     // to: 'renzo.rodriguez@supervan.pe;richard.alfaro@supervan.pe',
            //     cc: 'luisgalic@gmail.com',
            //     // cc: 'carlos.inocente@supervan.pe;reyza.narciso@supervan.pe;gabriela.napa@supervan.pe',
            //     bcc: 'briane.smart@briane.pe',
            //     subject: 'Notificaciones BRIANE SMART',
            //     html: contentHtml
            // });
            // if (infoMail) {
            //     return res.status(200).send({
            //         ok: true,
            //         notificacion,
            //         infoMail: infoMail.messageId
            //     });
            // } else {
            //     return res.status(400).send({
            //         ok: false,
            //         message: 'No se pudo enviar la notificación.'
            //     });
            // }
            
            return res.status(200).send({
                ok: true,
                descuento
            });
        }
    });
});
// End notificar saldos peaje

// Get productividad conductor comsision
app.get('/conductores/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var search = req.params.search;
    var params =  `'${search}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_CONDUCTORES ${params}`;
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
            return res.status(200).send({
                ok: true,
                conductores
            });
        }
    });  
});
// End Get conductores

// Get productividad conductor comsision
app.get('/productividadComision/:desde/:hasta/:idZona', (req, res, next ) => {        
    // var productividad = `{
    //         "dni": "10091618",
    //         "conductor": "ALVAREZ TINEO RAUL ERNESTO",
    //         "_01_02_2021":{
    //             "comsision": 34,
    //             "viajes": 
    //                     [        
    //                         {
    //                             "ruta": "APMDEPSA GAMBETTA",
    //                             "viajes": 1,
    //                             "comsion": 20,
    //                             "comisionTotal": 20
    //                         },
    //                         {
    //                             "ruta": "RANSA ARGENTINAMOLITALIA ECUADOR",
    //                             "viajes": 1,
    //                             "comsion": 17,
    //                             "comisionTotal": 17
    //                         }
    //                     ]
    //         }          
    //     }`;

    // // productividad = productividad.substring(1);
    // var productividaConductor =  JSON.parse('[' + productividad + ']');
    // return res.status(200).send({
    //     productividaConductor
    // });
    
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var idZona = req.params.idZona;
    var params =  `'${desde}','${hasta}',${idZona}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_PRODUCTIVIDAD_CONDUCTOR_COMISION ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viajes = result.recordset;  
            var conductores = [];
            viajes.forEach(viaje => {
                const resultado = conductores.find( iden => iden.dni === viaje.ID_CONDUCTOR);
                if(!resultado) {
                    conductores.push({
                        id: viaje.ID_CONDUCTOR2,
                        dni: viaje.ID_CONDUCTOR,
                        nombre: viaje.NOMBRE_CONDUCTOR.toUpperCase()
                    });
                }
            });
            var lsql = `SELECT '_' + REPLACE(DIA, '/', '_') AS DIA,DIA AS FECHA FROM FE_SUPERVAN.DBO.DIAS WHERE FECHA >= '${desde}' AND FECHA <= '${hasta}'`;
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
                    var params =  `'${desde}','${hasta}'`;
                    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_OP_NO_PRODUCTIVIDAD_CONDUCTOR ${params}`;
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
                            var productividad = '';
                            var detalle = '';
                            var detalleViajes = '';
                            var arrayDetalle = [];
                            var detalleArray = '';
                            var totalComision = 0; 
                            var idMotivo = 0;
                            var motivo = '';
                            var totalViajesDia = 0;
                            var viajesTotal = 0;
                            var comisionTotalConductor = 0;

                            conductores.forEach(conductor => {
                                dias.forEach(dia => {                            
                                    viajes.forEach(viaje => {
                                        if (dia.FECHA === viaje.FH_GUIA && viaje.ID_CONDUCTOR === conductor.dni) {
                                            var comision = 0;                                           
                                            viajesTotal = viajesTotal + viaje.VIAJES;
                                            comisionTotalConductor = comisionTotalConductor + (viaje.VIAJES * comision);
                                            totalComision = totalComision + (viaje.VIAJES * comision);
                                            totalViajesDia = totalViajesDia + viaje.VIAJES;
                                            arrayDetalle.push({
                                                ruta: viaje.DS_ORI_DEST + ' - ' + viaje.DESTINO,
                                                viajes: viaje.VIAJES,
                                                comsion: viaje.COMISION,
                                                comisionTotal: viaje.VIAJES * comision
                                            });
                                            detalleArray = detalleArray +' ' + viaje.DS_ORI_DEST + '= ' + viaje.VIAJES
                                        }
                                    });                                       
                                    // arrayDetalle.forEach(detalle => { 
                                    //     totalComision = totalComision + detalle.comisionTotal
                                    //     totalViajesDia = totalViajesDia + 
                                    // });   
                                    // arrayDetalle.push({
                                    //     totalComision: totalComision
                                    // });    
                                    
                                    if (arrayDetalle.length === 0) {
                                        let arrayFechaDia = dia.FECHA.split('/');
                                        let fechaDia = arrayFechaDia[2] + '-' + arrayFechaDia[1] + '-' + arrayFechaDia[0];
                                        const resultadoMotivo = motivos.find(motivo => motivo.ID_CONDUCTOR === conductor.id && motivo.FECHA_MOTIVO  === fechaDia);
                                        if(resultadoMotivo) {                                            
                                            idMotivo = resultadoMotivo.ID_MOTIVO_NO_PROD;
                                            motivo = resultadoMotivo.DS_MOTIVO;
                                        }
                                    }

                                    if (motivo.length === 0) {
                                        idMotivo = 0;
                                        motivo = 'NO REGISTRA VIAJES';
                                    }
                                                        
                                    detalleViajes = JSON.stringify(arrayDetalle);
                                    detalle = detalle + `,
                                        "${dia.DIA}": {  
                                            "totalViajes": ${totalViajesDia},                                         
                                            "totalComision": ${totalComision},
                                            "idMotivo": ${idMotivo},
                                            "motivo": "${motivo}",
                                            "viajes": ${detalleViajes}
                                        }
                                    `;  
                                    // detalle = detalle + `,
                                    //     "${dia.DIA}": "${detalleArray}"
                                    // `;  
                                    arrayDetalle = []; 
                                    detalleArray = '';    
                                    totalComision = 0;   
                                    totalViajesDia = 0;
                                    idMotivo = 0; 
                                    motivo = '';              
                                });
                                detalle = detalle.substring(1);
                                productividad = productividad + `,{
                                    "id": "${conductor.id}",
                                    "dni": "${conductor.dni}",
                                    "conductor": "${conductor.nombre}",
                                    "viajesTotal": ${viajesTotal},
                                    "comisionTotal": ${comisionTotalConductor},
                                    ${detalle}
                                }`;
                                detalle = '';
                                totalComision = 0;
                                viajesTotal = 0;
                                comisionTotalConductor = 0;
                                detalle = detalle.substring(1);
                            });
                            productividad = productividad.substring(1);
                            var productividaConductor =  JSON.parse('[' + productividad + ']');
                            return res.status(200).send({
                                ok: true,
                                productividaConductor,
                                dias,
                                conductores
                            });


                        }
                    });
                }
            });
        }
    });  
});
// End Get conductores

// Register-Update motivo no productividad conductor
app.post('/motivoNoProductividadConductor', (req, res, next ) => {
    var body = req.body;
    var params = `${body.id},${body.idConductor},'${body.motivo.toUpperCase()}','${body.fecha}',${body.idUsuario}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_REGISTER_UPDATE_OP_NO_PRODUCTIVIDAD_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var motivo = result.recordset[0];      
            var idMotivo = motivo.ID_MOTIVO_NO_PROD     
            if (!idMotivo) {
                return res.status(400).send({
                    ok: false,
                    message: 'No se pudo enviar la notificación.'
                });  
            }

            return res.status(200).send({
                ok: true,
                motivo
            });   
        }
    });
});
// End Register-Update motivo no productividad conductor
  
module.exports = app;


