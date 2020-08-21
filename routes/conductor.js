'use strict'
var express = require('express');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
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
            if (viajes) {
                params = `'${desde}', '${hasta}', '${dni}', ${zona}`;
                request = new mssql.Request();
                lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_VIAJES_CONDUCTOR_TARIFA ${params}`;
                request.query(lsql, (err, result) => {
                    if (err) { 
                        return res.status(500).send({
                            ok: false,
                            message: 'Error en la petición.',
                            error: err
                        });
                    } else {
                        var viajesTarifa = result.recordset;
                        var cantHorasProducidas = 0;
                        var cantHorasApagar = 0;
                        var comisionTotalHoras = 0;
                        var comisionTotalViajes = 0;
                        viajesTarifa.forEach(function (viaje) { 
                            cantHorasProducidas = cantHorasProducidas + viaje.CANTIDAD_HORAS_PRODUCIDAS;
                            cantHorasApagar = cantHorasApagar + viaje.CANTIDAD_HORAS_PAGAR;
                            comisionTotalHoras = comisionTotalHoras + viaje.COMISION_HORAS;
                            comisionTotalViajes = comisionTotalViajes + viaje.COMISION_VIAJES;
                        });

                        request = new mssql.Request();
                        lsql = `SELECT FE_SUPERVAN.DBO.FN_FORMATO_HORA(${cantHorasProducidas}) AS HORAS_PRODUCIDAS, FE_SUPERVAN.DBO.FN_FORMATO_HORA(${cantHorasApagar}) AS HORAS_PAGAR `;
                        request.query(lsql, (err, result) => {
                            if (err) { 
                                return res.status(500).send({
                                    ok: false,
                                    message: 'Error en la petición.',
                                    error: err
                                });
                            } else {
                                var horas = result.recordset[0];
                                return res.status(200).send({
                                    ok: true, 
                                    cantHorasProducidas: parseFloat(cantHorasProducidas.toString()).toFixed(2),
                                    cantHorasApagar: parseFloat(cantHorasApagar.toString()).toFixed(2),
                                    comisionTotalHoras: parseFloat(comisionTotalHoras.toString()).toFixed(2),
                                    comisionTotalViajes: parseFloat(comisionTotalViajes.toString()).toFixed(2),
                                    horasProducidas: horas.HORAS_PRODUCIDAS,
                                    horasPagar: horas.HORAS_PAGAR,
                                    viajes
                                });          
                            }
                        }); 
                    }
                });
            }         
        }
    });
});
// End Vijes conductores 

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
                            var turno1, turno2, turno3, check1 , check2, check3;
                            if (i==1) {    
                                turno1 = viatico.dia1.turno1;
                                turno2 = viatico.dia1.turno2;
                                turno3 = viatico.dia1.turno3;
                                check1 = viatico.dia1.check1;
                                check2 = viatico.dia1.check2;
                                check3 = viatico.dia1.check3;
                            }
                            if (i==2) {    
                                turno1 = viatico.dia2.turno1;
                                turno2 = viatico.dia2.turno2;
                                turno3 = viatico.dia2.turno3;
                                check1 = viatico.dia2.check1;
                                check2 = viatico.dia2.check2;
                                check3 = viatico.dia2.check3;
                            }
                            if (i==3) {    
                                turno1 = viatico.dia3.turno1;
                                turno2 = viatico.dia3.turno2;
                                turno3 = viatico.dia3.turno3;
                                check1 = viatico.dia3.check1;
                                check2 = viatico.dia3.check2;
                                check3 = viatico.dia3.check3;
                            }
                            if (i==4) {    
                                turno1 = viatico.dia4.turno1;
                                turno2 = viatico.dia4.turno2;
                                turno3 = viatico.dia4.turno3;
                                check1 = viatico.dia4.check1;
                                check2 = viatico.dia4.check2;
                                check3 = viatico.dia4.check3;
                            }
                            if (i==5) {    
                                turno1 = viatico.dia5.turno1;
                                turno2 = viatico.dia5.turno2;
                                turno3 = viatico.dia5.turno3;
                                check1 = viatico.dia5.check1;
                                check2 = viatico.dia5.check2;
                                check3 = viatico.dia5.check3;
                            }
                            if (i==6) {    
                                turno1 = viatico.dia6.turno1;
                                turno2 = viatico.dia6.turno2;
                                turno3 = viatico.dia6.turno3;
                                check1 = viatico.dia6.check1;
                                check2 = viatico.dia6.check2;
                                check3 = viatico.dia6.check3;
                            }
                            if (i==7) {    
                                turno1 = viatico.dia7.turno1;
                                turno2 = viatico.dia7.turno2;
                                turno3 = viatico.dia7.turno3;
                                check1 = viatico.dia7.check1;
                                check2 = viatico.dia7.check2;
                                check3 = viatico.dia7.check3;
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
                        params = params + ',' + '\n' + `(${idViatico}, ${idConductor} , '${fecha}', ${turno1}, ${turno2}, ${turno3}, ${check1}, ${check2}, ${check3},${reintegro}, ${total}, ${idUser})`;
                    });

                    params = params.substring(1);
                    var lsql = `INSERT INTO FE_SUPERVAN.DBO.OP_DETA_VIATICOS_CONDUCTOR (ID_VIATICO,ID_CONDUCTOR,FECHA,TURNO1,TURNO2,TURNO3,CHECK1,CHECK2,CHECK3,REINTEGRO,TOTAL,ID_USUARIO_BS) 
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
            // console.log(lsql);
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
                    message: 'No existe el registro de viaticos'
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
                                        if (resultado) {
                                            turno1 = resultado.TURNO1;
                                            turno2 = resultado.TURNO2;
                                            turno3 = resultado.TURNO3; 
                                            check1 = resultado.CHECK1; 
                                            check2 = resultado.CHECK2;
                                            check3 = resultado.CHECK3;                                        
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1,
                                                turno2,
                                                turno3,
                                                check1,
                                                check2,
                                                check3                                                    
                                            };
                                        } else {
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1: 0,
                                                turno2: 0,
                                                turno3: 0,
                                                check1: false,
                                                check2: false,
                                                check3: false                                                    
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
                                        if (resultado) {
                                            turno1 = resultado.TURNO1;
                                            turno2 = resultado.TURNO2;
                                            turno3 = resultado.TURNO3; 
                                            check1 = resultado.CHECK1; 
                                            check2 = resultado.CHECK2;
                                            check3 = resultado.CHECK3;                                          
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1,
                                                turno2,
                                                turno3,
                                                check1,
                                                check2,
                                                check3                                                    
                                            };
                                        } else {
                                            turnos = {
                                                fecha: dia.FECHA,
                                                turno1: 0,
                                                turno2: 0,
                                                turno3: 0,
                                                check1: false,
                                                check2: false,
                                                check3: false                                                    
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

module.exports = app;


