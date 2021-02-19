'use strict'

var express = require('express');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));
var mdAuthenticattion = require('../middlewares/authenticated');

// Get Orden servicio
app.get('/os/:idUser',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idUser = req.params.idUser;
    var params =  `${idUser}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OS_GUIA ${params}`;
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

// Get Orden servicio all
app.get('/osall/:idUser',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idUser = req.params.idUser;
    var params =  `${idUser}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_ORDENES_SERVICIOS ${params}`;
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
// End Get orden servicio all

// Get Orden servicio confirmadas
app.get('/osPlanificacion',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    //var idUser = req.params.idUser;
    //var params =  `${idUser}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OS_CONFIRMADAS`;
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
// End Get orden servicio confirmadas

// Get Ordenes servicio planificacion
app.get('/osPlanificaciones/:desde/:hasta/:idZona',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var idZona = req.params.idZona;
    var params =  `'${desde}','${hasta}',${idZona}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OS_PLANIFICACION_DEMANDA ${params}`;
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
            var demandas = [];
            var totalViajesEstimados = 0;
            var totalViajesRealizados = 0;
            var i = 0;
            if (ordenesServicio.length > 0) {
                ordenesServicio.forEach(function (orden) {
                    if (orden.VIAJES_ESTIMADOS) {
                        totalViajesEstimados = totalViajesEstimados +  orden.VIAJES_ESTIMADOS;
                    }
                    let guiasTotal = 0
                    if (orden.CANTIDAD_GUIAS_TOTAL) {
                        guiasTotal = orden.CANTIDAD_GUIAS_TOTAL
                    }
                    guiasTotal = guiasTotal + orden.CANTIDAD_GUIAS_TOTAL_PLANIFICADAS;
                    let cantViajes = orden.VIAJES_ESTIMADOS - guiasTotal;
                    if (cantViajes > 0) {
                        let j;
                        for (j = 0; j < cantViajes; j++) {
                            i++;
                            demandas.push({
                                id: i,
                                idOrdenServicio: orden.ID_ORDEN_SERVICIO,
                                ordenServicio: orden.CORRELATIVO,
                                origen: orden.DS_ORI_DEST,
                                destino: orden.DESTINO,
                                producto: orden.DS_PRODUCTO,
                                ruc: orden.RUC,
                                razonSocial: orden.RAZON_SOCIAL,
                                viajesEstimados: orden.VIAJES_ESTIMADOS,
                                viajesRealizados: orden.CANTIDAD_GUIAS_TOTAL,
                                seleccion : false
                            });
                        }
                    }
                });
                return res.status(200).send({
                    ok: true,
                    demandas,
                    totalOrdenes: ordenesServicio.length,
                    totalViajesEstimados,
                    totalViajesRealizados,
                    totalViajesDemanda: i
                });
            } else {
                return res.status(200).send({
                    ok: true,
                    demandas
                });
            }
        }
    });
});
// End Get Ordenes servicio planificacion

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
    if (NRO_PERMISO === '') {
        NRO_PERMISO = '-';
    }
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
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_GUIA ${params}`;
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

// Asingnar guia
app.put('/asignarGuia', mdAuthenticattion.verificarToken, (req, res) => {
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
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_ASIGNAR_GUIA ${params}`;
    // return;
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guia = result.recordset[0];
            var idGuia = guia.ID_GUIA;
            if (guia.ID_GUIA === 0) {
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
app.delete('/guia/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idGuia = req.params.id;
    var params =  `${idGuia}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.DELETE_GUIA ${params}`;
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
                                            var turno1 = 0;
                                            var turno2 = 0;
                                            var turno3 = 0;                                            
                                            if (resultado) {
                                                if(resultado.TURNO1) {
                                                    turno1 = resultado.TURNO1;
                                                }
                                                if(resultado.TURNO2) {
                                                    turno2 = resultado.TURNO2;
                                                }
                                                if(resultado.TURNO3) {
                                                    turno3 = resultado.TURNO3;
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
                                        }
                                        if (zona == 3) {                                            
                                            const resultado = diasTurnoProductividad.find( viajes => 
                                            viajes.PLACA_TRACTO === diasProd.PLACA_TRACTO && viajes.NOMBRE_CONDUCTOR === diasProd.NOMBRE_CONDUCTOR && viajes.FH_GUIA === dia.FECHA 
                                            );                                            
                                            var turno1 = 0
                                            var turno2 = 0                                          
                                            if (resultado) {
                                                if(resultado.DIA) {
                                                    turno1 = resultado.DIA;
                                                }
                                                if(resultado.NOCHE) {
                                                    turno2 = resultado.NOCHE;
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
                                        }
                                        if (zona == 4) {                                        
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
                                        }
                                    });
                                });
                                return res.status(200).send({
                                    ok: true,                                    
                                    idZona: zona,
                                    dias,
                                    diasProductividad
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

// Register report OP
app.post('/reportop/:semana/:year/:zona/:idUser', mdAuthenticattion.verificarToken, (req, res) => {    
    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var idUser = req.params.idUser;
    var body = req.body;

    // return res.status(200).send({
    //     ok: true,                             
    //     body
    // });

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
            var params =  `${semana}, ${year}, ${zona}, '${fhDesde}', '${fhHasta}', ${cantRegistros}, ${idUser}`;             
            lsql = `EXEC FE_SUPERVAN.DBO.SP_REG_REPORT_PRODUCTIVIDAD ${params}`;  
            var request = new mssql.Request();
            request.query(lsql, (err, result) => {
                if (err) { 
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                } else {
                    var report = result.recordset[0];  
                    var idReportOp = report.ID_REPORT_PRO_OP;
                    if (report) {    
                        if (report.ID_VIATICO == 0) {
                            return res.status(400).send({
                                ok: true,                             
                                message: report.MESSAGE
                            });
                        }
                                          
                        var diasProdTurno = [];
                        var i = 0;
                        var fecha, turno1, turno2, turno3, motivo1, motivo2, motivo3;
                        var arrayFecha;
                        body.forEach(function (diasProd) { 
                            i = 0;
                            for (i = 0; i < 7; i++) {
                                switch(i) {
                                    case 0:
                                        if (zona == 1) {
                                            arrayFecha = diasProd.dia1.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia1.turno1;
                                            turno2 = diasProd.dia1.turno2;
                                            turno3 = diasProd.dia1.turno3;
                                            motivo1 = diasProd.dia1.motivo1;
                                            motivo2 = diasProd.dia1.motivo2;
                                            motivo3 = diasProd.dia1.motivo3;
                                        }
                                        if (zona == 2) {
                                            arrayFecha = diasProd.dia1.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia1.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia1.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }
                                        if (zona == 3) {
                                            arrayFecha = diasProd.dia1.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia1.turno1;
                                            turno2 = diasProd.dia1.turno2;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia1.motivo1;
                                            motivo2 = diasProd.dia1.motivo2;
                                            motivo3 = 0;
                                        } 
                                        if (zona == 4) {
                                            arrayFecha = diasProd.dia1.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia1.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia1.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }                           
                                    break;  
                                    case 1:
                                        if (zona == 1) {
                                            arrayFecha = diasProd.dia2.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia2.turno1;
                                            turno2 = diasProd.dia2.turno2;
                                            turno3 = diasProd.dia2.turno3;
                                            motivo1 = diasProd.dia2.motivo1;
                                            motivo2 = diasProd.dia2.motivo2;
                                            motivo3 = diasProd.dia2.motivo3;
                                        }                            
                                        if (zona == 2) {
                                            arrayFecha = diasProd.dia2.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia2.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia2.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                        if (zona == 3) {
                                            arrayFecha = diasProd.dia2.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia2.turno1;
                                            turno2 = diasProd.dia2.turno2;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia2.motivo1;
                                            motivo2 = diasProd.dia2.motivo2;
                                            motivo3 = 0;
                                        }
                                        if (zona == 4) {
                                            arrayFecha = diasProd.dia2.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia2.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia2.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }   
                                    break;                              
                                    case 2:
                                        if (zona == 1) {
                                            arrayFecha = diasProd.dia3.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia3.turno1;
                                            turno2 = diasProd.dia3.turno2;
                                            turno3 = diasProd.dia3.turno3;
                                            motivo1 = diasProd.dia3.motivo1;
                                            motivo2 = diasProd.dia3.motivo2;
                                            motivo3 = diasProd.dia3.motivo3;
                                        }                                
                                        if (zona == 2) {
                                            arrayFecha = diasProd.dia3.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia3.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia3.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                        if (zona == 3) {
                                            arrayFecha = diasProd.dia3.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia3.turno1;
                                            turno2 = diasProd.dia3.turno2;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia3.motivo1;
                                            motivo2 = diasProd.dia3.motivo2;
                                            motivo3 = 0;
                                        }
                                        if (zona == 4) {
                                            arrayFecha = diasProd.dia3.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia3.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia3.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                    break;
                                    case 3:
                                        if (zona == 1) {
                                            arrayFecha = diasProd.dia4.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia4.turno1;
                                            turno2 = diasProd.dia4.turno2;
                                            turno3 = diasProd.dia4.turno3;
                                            motivo1 = diasProd.dia4.motivo1;
                                            motivo2 = diasProd.dia4.motivo2;
                                            motivo3 = diasProd.dia4.motivo3;
                                        }
                                        if (zona == 2) {
                                            arrayFecha = diasProd.dia4.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia4.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia4.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                        if (zona == 3) {
                                            arrayFecha = diasProd.dia4.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia4.turno1;
                                            turno2 = diasProd.dia4.turno2;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia4.motivo1;
                                            motivo2 = diasProd.dia4.motivo2;
                                            motivo3 = 0;
                                        }
                                        if (zona == 4) {
                                            arrayFecha = diasProd.dia4.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia4.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia4.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }   
                                    break;
                                    case 4:
                                        if (zona == 1) {
                                            arrayFecha = diasProd.dia5.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia5.turno1;
                                            turno2 = diasProd.dia5.turno2;
                                            turno3 = diasProd.dia5.turno3;
                                            motivo1 = diasProd.dia5.motivo1;
                                            motivo2 = diasProd.dia5.motivo2;
                                            motivo3 = diasProd.dia5.motivo3;
                                        }
                                        if (zona == 2) {
                                            arrayFecha = diasProd.dia5.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia5.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia5.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                        if (zona == 3) {
                                            arrayFecha = diasProd.dia5.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia5.turno1;
                                            turno2 = diasProd.dia5.turno2;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia5.motivo1;
                                            motivo2 = diasProd.dia5.motivo2;
                                            motivo3 = 0;
                                        }
                                        if (zona == 4) {
                                            arrayFecha = diasProd.dia5.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia5.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia5.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                    break;                            
                                    case 5:
                                        if (zona == 1) {
                                            arrayFecha = diasProd.dia6.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia6.turno1;
                                            turno2 = diasProd.dia6.turno2;
                                            turno3 = diasProd.dia6.turno3;
                                            motivo1 = diasProd.dia6.motivo1;
                                            motivo2 = diasProd.dia6.motivo2;
                                            motivo3 = diasProd.dia6.motivo3;
                                        }
                                        if (zona == 2) {
                                            arrayFecha = diasProd.dia6.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia6.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia6.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                        if (zona == 3) {
                                            arrayFecha = diasProd.dia6.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia6.turno1;
                                            turno2 = diasProd.dia6.turno2;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia6.motivo1;
                                            motivo2 = diasProd.dia6.motivo2;
                                            motivo3 = 0;
                                        }
                                        if (zona == 4) {
                                            arrayFecha = diasProd.dia6.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia6.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia6.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                    break;
                                    case 6:
                                        if (zona == 1) {
                                            arrayFecha = diasProd.dia7.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia7.turno1;
                                            turno2 = diasProd.dia7.turno2;
                                            turno3 = diasProd.dia7.turno3;
                                            motivo1 = diasProd.dia7.motivo1;
                                            motivo2 = diasProd.dia7.motivo2;
                                            motivo3 = diasProd.dia7.motivo3;
                                        }
                                        if (zona == 2) {
                                            arrayFecha = diasProd.dia7.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia7.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia7.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }    
                                        if (zona == 3) {
                                            arrayFecha = diasProd.dia7.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia7.turno1;
                                            turno2 = diasProd.dia7.turno2;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia7.motivo1;
                                            motivo2 = diasProd.dia7.motivo2;
                                            motivo3 = 0;
                                        }
                                        if (zona == 4) {
                                            arrayFecha = diasProd.dia7.fecha.split('/');
                                            fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                            turno1 = diasProd.dia7.turno1;
                                            turno2 = 0;
                                            turno3 = 0;
                                            motivo1 = diasProd.dia7.motivo1;
                                            motivo2 = 0;
                                            motivo3 = 0;
                                        }   
                                    break;
                                }
                                diasProdTurno.push({
                                    ID_CONDUCTOR: diasProd.ID_CONDUCTOR2,
                                    ID_TRACTO: diasProd.ID_TRACTO,
                                    ANIO: diasProd.ANIO,
                                    NRO_SEMANA: diasProd.NRO_SEMANA,
                                    ID_ZONA : zona,
                                    FECHA: fecha,
                                    TURNO1: turno1,
                                    TURNO2: turno2,
                                    TURNO3: turno3,
                                    MOTIVO1: motivo1,
                                    MOTIVO2: motivo2,
                                    MOTIVO3: motivo3,
                                    ID_REPORT_PRO_OP: idReportOp
                                });
                            }
                        });
                        var params = [];
                        diasProdTurno.forEach(function (diasProd) {
                            var idConductor = diasProd.ID_CONDUCTOR;
                            var idTracto = diasProd.ID_TRACTO;
                            var anio = diasProd.ANIO;
                            var nroSemana = diasProd.NRO_SEMANA;
                            var fecha = diasProd.FECHA;
                            var turno1 = diasProd.TURNO1;
                            var turno2 = diasProd.TURNO2;
                            var turno3 = diasProd.TURNO3;
                            var motivo1 = diasProd.MOTIVO1;
                            var motivo2 = diasProd.MOTIVO2;
                            var motivo3 = diasProd.MOTIVO3;    
                            var idZona = diasProd.ID_ZONA;
                            var idReport = diasProd.ID_REPORT_PRO_OP;
                            params = params + ',' + '\n' + `(${idConductor}, ${idTracto} , ${anio}, ${nroSemana}, '${fecha}', ${turno1}, ${turno2}, ${turno3}, ${motivo1}, ${motivo2}, ${motivo3}, ${idZona}, ${idReport}, ${idUser})`;
                        });
                        params = params.substring(1);
                        var lsql = `INSERT INTO FE_SUPERVAN.DBO.OP_DETA_REPORT_PRODUCTIVIDAD (ID_CONDUCTOR,ID_TRACTO,ANIO,NRO_SEMANA,FECHA,TURNO1,TURNO2,TURNO3,MOTIVO1,MOTIVO2,MOTIVO3,ID_ZONA,ID_REPORT_PRO_OP,ID_USUARIO_BS) 
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
                                var reportOp = result.rowsAffected[0];
                                return res.status(200).send({
                                    ok: true,                             
                                    reportOp
                                });
                            }
                        }); 
                    }
                }
            });
        }
    });    
});
// En Register report OP


// Register nuevos viajes report OP
app.post('/reportopviajes/:semana/:year/:zona/:idUser/:idReportOp', mdAuthenticattion.verificarToken, (req, res) => {    
    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var idUser = req.params.idUser;
    var idReportOp = req.params.idReportOp;
    var body = req.body;

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
            // var params =  `${semana}, ${year}, ${zona}, '${fhDesde}', '${fhHasta}', ${cantRegistros}, ${idUser}`;
            
            var diasProdTurno = [];
            var i = 0;
            var fecha, turno1, turno2, turno3, motivo1, motivo2, motivo3;
            var arrayFecha;
            body.forEach(function (diasProd) { 
                i = 0;
                for (i = 0; i < 7; i++) {
                    switch(i) {
                        case 0:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia1.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia1.turno1;
                                turno2 = diasProd.dia1.turno2;
                                turno3 = diasProd.dia1.turno3;
                                motivo1 = diasProd.dia1.motivo1;
                                motivo2 = diasProd.dia1.motivo2;
                                motivo3 = diasProd.dia1.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia1.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia1.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia1.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }
                            if (zona == 3) {
                                arrayFecha = diasProd.dia1.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia1.turno1;
                                turno2 = diasProd.dia1.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia1.motivo1;
                                motivo2 = diasProd.dia1.motivo2;
                                motivo3 = 0;
                            }   
                            if (zona == 4) {
                                arrayFecha = diasProd.dia1.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia1.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia1.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }                         
                        break;  
                        case 1:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia2.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia2.turno1;
                                turno2 = diasProd.dia2.turno2;
                                turno3 = diasProd.dia2.turno3;
                                motivo1 = diasProd.dia2.motivo1;
                                motivo2 = diasProd.dia2.motivo2;
                                motivo3 = diasProd.dia2.motivo3;
                            }                            
                            if (zona == 2) {
                                arrayFecha = diasProd.dia2.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia2.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia2.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia2.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia2.turno1;
                                turno2 = diasProd.dia2.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia2.motivo1;
                                motivo2 = diasProd.dia2.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia2.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia2.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia2.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            } 
                        break;                              
                        case 2:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia3.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia3.turno1;
                                turno2 = diasProd.dia3.turno2;
                                turno3 = diasProd.dia3.turno3;
                                motivo1 = diasProd.dia3.motivo1;
                                motivo2 = diasProd.dia3.motivo2;
                                motivo3 = diasProd.dia3.motivo3;
                            }                                
                            if (zona == 2) {
                                arrayFecha = diasProd.dia3.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia3.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia3.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia3.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia3.turno1;
                                turno2 = diasProd.dia3.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia3.motivo1;
                                motivo2 = diasProd.dia3.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia3.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia3.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia3.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            } 
                        break;
                        case 3:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia4.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia4.turno1;
                                turno2 = diasProd.dia4.turno2;
                                turno3 = diasProd.dia4.turno3;
                                motivo1 = diasProd.dia4.motivo1;
                                motivo2 = diasProd.dia4.motivo2;
                                motivo3 = diasProd.dia4.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia4.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia4.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia4.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia4.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia4.turno1;
                                turno2 = diasProd.dia4.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia4.motivo1;
                                motivo2 = diasProd.dia4.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia4.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia4.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia4.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                        break;
                        case 4:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia5.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia5.turno1;
                                turno2 = diasProd.dia5.turno2;
                                turno3 = diasProd.dia5.turno3;
                                motivo1 = diasProd.dia5.motivo1;
                                motivo2 = diasProd.dia5.motivo2;
                                motivo3 = diasProd.dia5.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia5.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia5.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia5.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia5.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia5.turno1;
                                turno2 = diasProd.dia5.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia5.motivo1;
                                motivo2 = diasProd.dia5.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia5.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia5.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia5.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                        break;                            
                        case 5:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia6.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia6.turno1;
                                turno2 = diasProd.dia6.turno2;
                                turno3 = diasProd.dia6.turno3;
                                motivo1 = diasProd.dia6.motivo1;
                                motivo2 = diasProd.dia6.motivo2;
                                motivo3 = diasProd.dia6.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia6.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia6.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia6.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia6.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia6.turno1;
                                turno2 = diasProd.dia6.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia6.motivo1;
                                motivo2 = diasProd.dia6.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia6.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia6.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia6.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                        break;
                        case 6:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia7.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia7.turno1;
                                turno2 = diasProd.dia7.turno2;
                                turno3 = diasProd.dia7.turno3;
                                motivo1 = diasProd.dia7.motivo1;
                                motivo2 = diasProd.dia7.motivo2;
                                motivo3 = diasProd.dia7.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia7.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia7.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia7.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia7.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia7.turno1;
                                turno2 = diasProd.dia7.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia7.motivo1;
                                motivo2 = diasProd.dia7.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia7.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia7.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia7.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                        break;
                    }
                    diasProdTurno.push({
                        ID_CONDUCTOR: diasProd.ID_CONDUCTOR2,
                        ID_TRACTO: diasProd.ID_TRACTO,
                        ANIO: diasProd.ANIO,
                        NRO_SEMANA: diasProd.NRO_SEMANA,
                        ID_ZONA : zona,
                        FECHA: fecha,
                        TURNO1: turno1,
                        TURNO2: turno2,
                        TURNO3: turno3,
                        MOTIVO1: motivo1,
                        MOTIVO2: motivo2,
                        MOTIVO3: motivo3,
                        ID_REPORT_PRO_OP: idReportOp
                    });
                }
            });
            var params = [];
            diasProdTurno.forEach(function (diasProd) {
                var idConductor = diasProd.ID_CONDUCTOR;
                var idTracto = diasProd.ID_TRACTO;
                var anio = diasProd.ANIO;
                var nroSemana = diasProd.NRO_SEMANA;
                var fecha = diasProd.FECHA;
                var turno1 = diasProd.TURNO1;
                var turno2 = diasProd.TURNO2;
                var turno3 = diasProd.TURNO3;
                var motivo1 = diasProd.MOTIVO1;
                var motivo2 = diasProd.MOTIVO2;
                var motivo3 = diasProd.MOTIVO3;    
                var idZona = diasProd.ID_ZONA;
                var idReport = diasProd.ID_REPORT_PRO_OP;
                params = params + ',' + '\n' + `(${idConductor}, ${idTracto} , ${anio}, ${nroSemana}, '${fecha}', ${turno1}, ${turno2}, ${turno3}, ${motivo1}, ${motivo2}, ${motivo3}, ${idZona}, ${idReport}, ${idUser})`;
            });
            params = params.substring(1);
            var lsql = `INSERT INTO FE_SUPERVAN.DBO.OP_DETA_REPORT_PRODUCTIVIDAD (ID_CONDUCTOR,ID_TRACTO,ANIO,NRO_SEMANA,FECHA,TURNO1,TURNO2,TURNO3,MOTIVO1,MOTIVO2,MOTIVO3,ID_ZONA,ID_REPORT_PRO_OP,ID_USUARIO_BS) 
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
                    var reportOp = result.rowsAffected[0];
                    // updateCantRegReportOp(idReportOp, idUser);
                    return res.status(200).send({
                        ok: true,                             
                        reportOp,
                        body
                    });
                }
            });     
        }
    });    
});
// End Register nuevos viajes report OP

// Actualizar cantidad de registros report OP
function updateCantRegReportOp(idReportOp, idUser) {
    var params = `${idReportOp}, ${idUser}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_CANT_REG_REPORT_OP ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            console.log(err)
        } else {
            // console.log(result)
        }
    });      
}
// fin Actualizar cantidad de registros report OP

// Update deta report OP
app.put('/reportop/:semana/:year/:zona/:id/:nroDia/:idUser', mdAuthenticattion.verificarToken, (req, res) => {
    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var idReportOp = req.params.id;
    var idUser = req.params.idUser;
    var i = parseInt(req.params.nroDia);
    var body = req.body;
    var diasProdTurno = [];
    var fecha, turno1, turno2, turno3, motivo1, motivo2, motivo3;
    var arrayFecha;
    var diasProd = [];
    diasProd = body;    
    switch(i) {
        case 0:
            if (zona == 1) {
                arrayFecha = diasProd.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia1.turno1;
                turno2 = diasProd.dia1.turno2;
                turno3 = diasProd.dia1.turno3;
                motivo1 = diasProd.dia1.motivo1;
                motivo2 = diasProd.dia1.motivo2;
                motivo3 = diasProd.dia1.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia1.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia1.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }
            if (zona == 3) {
                arrayFecha = diasProd.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia1.turno1;
                turno2 = diasProd.dia1.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia1.motivo1;
                motivo2 = diasProd.dia1.motivo2;
                motivo3 = 0;
            }    
            if (zona == 4) {
                arrayFecha = diasProd.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia1.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia1.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }                        
        break;  
        case 1:
            if (zona == 1) {
                arrayFecha = diasProd.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia2.turno1;
                turno2 = diasProd.dia2.turno2;
                turno3 = diasProd.dia2.turno3;
                motivo1 = diasProd.dia2.motivo1;
                motivo2 = diasProd.dia2.motivo2;
                motivo3 = diasProd.dia2.motivo3;
            }                            
            if (zona == 2) {
                arrayFecha = diasProd.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia2.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia2.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia2.turno1;
                turno2 = diasProd.dia2.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia2.motivo1;
                motivo2 = diasProd.dia2.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia2.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia2.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
        break;                              
        case 2:
            if (zona == 1) {
                arrayFecha = diasProd.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia3.turno1;
                turno2 = diasProd.dia3.turno2;
                turno3 = diasProd.dia3.turno3;
                motivo1 = diasProd.dia3.motivo1;
                motivo2 = diasProd.dia3.motivo2;
                motivo3 = diasProd.dia3.motivo3;
            }                                
            if (zona == 2) {
                arrayFecha = diasProd.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia3.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia3.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia3.turno1;
                turno2 = diasProd.dia3.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia3.motivo1;
                motivo2 = diasProd.dia3.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia3.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia3.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
        break;
        case 3:
            if (zona == 1) {
                arrayFecha = diasProd.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia4.turno1;
                turno2 = diasProd.dia4.turno2;
                turno3 = diasProd.dia4.turno3;
                motivo1 = diasProd.dia4.motivo1;
                motivo2 = diasProd.dia4.motivo2;
                motivo3 = diasProd.dia4.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia4.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia4.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia4.turno1;
                turno2 = diasProd.dia4.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia4.motivo1;
                motivo2 = diasProd.dia4.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia4.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia4.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }  
        break;
        case 4:
            if (zona == 1) {
                arrayFecha = diasProd.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia5.turno1;
                turno2 = diasProd.dia5.turno2;
                turno3 = diasProd.dia5.turno3;
                motivo1 = diasProd.dia5.motivo1;
                motivo2 = diasProd.dia5.motivo2;
                motivo3 = diasProd.dia5.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia5.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia5.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia5.turno1;
                turno2 = diasProd.dia5.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia5.motivo1;
                motivo2 = diasProd.dia5.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia5.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia5.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }  
        break;                            
        case 5:
            if (zona == 1) {
                arrayFecha = diasProd.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia6.turno1;
                turno2 = diasProd.dia6.turno2;
                turno3 = diasProd.dia6.turno3;
                motivo1 = diasProd.dia6.motivo1;
                motivo2 = diasProd.dia6.motivo2;
                motivo3 = diasProd.dia6.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia6.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia6.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia6.turno1;
                turno2 = diasProd.dia6.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia6.motivo1;
                motivo2 = diasProd.dia6.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia6.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia6.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }
        break;
        case 6:
            if (zona == 1) {
                arrayFecha = diasProd.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia7.turno1;
                turno2 = diasProd.dia7.turno2;
                turno3 = diasProd.dia7.turno3;
                motivo1 = diasProd.dia7.motivo1;
                motivo2 = diasProd.dia7.motivo2;
                motivo3 = diasProd.dia7.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia7.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia7.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia7.turno1;
                turno2 = diasProd.dia7.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia7.motivo1;
                motivo2 = diasProd.dia7.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia7.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia7.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }  
        break;
    }
    diasProdTurno.push({
        ID_CONDUCTOR: diasProd.ID_CONDUCTOR,
        ID_TRACTO: diasProd.ID_VEHICULO,
        ANIO: diasProd.ANIO,
        NRO_SEMANA: diasProd.NRO_SEMANA,
        ID_ZONA : zona,
        FECHA: fecha,
        TURNO1: turno1,
        TURNO2: turno2,
        TURNO3: turno3,
        MOTIVO1: motivo1,
        MOTIVO2: motivo2,
        MOTIVO3: motivo3,
        ID_REPORT_PRO_OP: idReportOp
    });
    diasProdTurno = diasProdTurno[0];
    var params = `${diasProdTurno.ID_CONDUCTOR},${diasProdTurno.ID_TRACTO},${diasProdTurno.ANIO},${diasProdTurno.NRO_SEMANA},'${diasProdTurno.FECHA}',${diasProdTurno.TURNO1},${diasProdTurno.TURNO2},${diasProdTurno.TURNO3}, ${diasProdTurno.MOTIVO1}, ${diasProdTurno.MOTIVO2}, ${diasProdTurno.MOTIVO3}, ${diasProdTurno.ID_ZONA}, ${diasProdTurno.ID_REPORT_PRO_OP}, ${idUser}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_OP_DETA_REPORT_PRODUCTIVIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaProductividad = result.recordset;
            return res.status(200).send({
                ok: true,
                detaProductividad,
                params
            });
        }
    });                      
});
// End Update deta report OP

// Delete deta report OP
app.put('/detareportop/:semana/:year/:zona/:id/:nroDia/:idUser', mdAuthenticattion.verificarToken, (req, res) => {
    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var idReportOp = req.params.id;
    var idUser = req.params.idUser;
    var i = parseInt(req.params.nroDia);
    var body = req.body;
    var diasProdTurno = [];
    var fecha, turno1, turno2, turno3, motivo1, motivo2, motivo3;
    var arrayFecha;
    var diasProd = [];
    diasProd = body;    
    switch(i) {
        case 0:
            if (zona == 1) {
                arrayFecha = diasProd.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia1.turno1;
                turno2 = diasProd.dia1.turno2;
                turno3 = diasProd.dia1.turno3;
                motivo1 = diasProd.dia1.motivo1;
                motivo2 = diasProd.dia1.motivo2;
                motivo3 = diasProd.dia1.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia1.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia1.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }
            if (zona == 3) {
                arrayFecha = diasProd.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia1.turno1;
                turno2 = diasProd.dia1.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia1.motivo1;
                motivo2 = diasProd.dia1.motivo2;
                motivo3 = 0;
            } 
            if (zona == 4) {
                arrayFecha = diasProd.dia1.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia1.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia1.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }                           
        break;  
        case 1:
            if (zona == 1) {
                arrayFecha = diasProd.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia2.turno1;
                turno2 = diasProd.dia2.turno2;
                turno3 = diasProd.dia2.turno3;
                motivo1 = diasProd.dia2.motivo1;
                motivo2 = diasProd.dia2.motivo2;
                motivo3 = diasProd.dia2.motivo3;
            }                            
            if (zona == 2) {
                arrayFecha = diasProd.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia2.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia2.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia2.turno1;
                turno2 = diasProd.dia2.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia2.motivo1;
                motivo2 = diasProd.dia2.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia2.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia2.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia2.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }  
        break;                              
        case 2:
            if (zona == 1) {
                arrayFecha = diasProd.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia3.turno1;
                turno2 = diasProd.dia3.turno2;
                turno3 = diasProd.dia3.turno3;
                motivo1 = diasProd.dia3.motivo1;
                motivo2 = diasProd.dia3.motivo2;
                motivo3 = diasProd.dia3.motivo3;
            }                                
            if (zona == 2) {
                arrayFecha = diasProd.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia3.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia3.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia3.turno1;
                turno2 = diasProd.dia3.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia3.motivo1;
                motivo2 = diasProd.dia3.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia3.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia3.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia3.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            } 
        break;
        case 3:
            if (zona == 1) {
                arrayFecha = diasProd.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia4.turno1;
                turno2 = diasProd.dia4.turno2;
                turno3 = diasProd.dia4.turno3;
                motivo1 = diasProd.dia4.motivo1;
                motivo2 = diasProd.dia4.motivo2;
                motivo3 = diasProd.dia4.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia4.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia4.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia4.turno1;
                turno2 = diasProd.dia4.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia4.motivo1;
                motivo2 = diasProd.dia4.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia4.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia4.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia4.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }  
        break;
        case 4:
            if (zona == 1) {
                arrayFecha = diasProd.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia5.turno1;
                turno2 = diasProd.dia5.turno2;
                turno3 = diasProd.dia5.turno3;
                motivo1 = diasProd.dia5.motivo1;
                motivo2 = diasProd.dia5.motivo2;
                motivo3 = diasProd.dia5.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia5.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia5.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia5.turno1;
                turno2 = diasProd.dia5.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia5.motivo1;
                motivo2 = diasProd.dia5.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia5.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia5.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia5.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }   
        break;                            
        case 5:
            if (zona == 1) {
                arrayFecha = diasProd.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia6.turno1;
                turno2 = diasProd.dia6.turno2;
                turno3 = diasProd.dia6.turno3;
                motivo1 = diasProd.dia6.motivo1;
                motivo2 = diasProd.dia6.motivo2;
                motivo3 = diasProd.dia6.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia6.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia6.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia6.turno1;
                turno2 = diasProd.dia6.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia6.motivo1;
                motivo2 = diasProd.dia6.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia6.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia6.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia6.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }   
        break;
        case 6:
            if (zona == 1) {
                arrayFecha = diasProd.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia7.turno1;
                turno2 = diasProd.dia7.turno2;
                turno3 = diasProd.dia7.turno3;
                motivo1 = diasProd.dia7.motivo1;
                motivo2 = diasProd.dia7.motivo2;
                motivo3 = diasProd.dia7.motivo3;
            }
            if (zona == 2) {
                arrayFecha = diasProd.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia7.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia7.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }    
            if (zona == 3) {
                arrayFecha = diasProd.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia7.turno1;
                turno2 = diasProd.dia7.turno2;
                turno3 = 0;
                motivo1 = diasProd.dia7.motivo1;
                motivo2 = diasProd.dia7.motivo2;
                motivo3 = 0;
            }
            if (zona == 4) {
                arrayFecha = diasProd.dia7.fecha.split('/');
                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                turno1 = diasProd.dia7.turno1;
                turno2 = 0;
                turno3 = 0;
                motivo1 = diasProd.dia7.motivo1;
                motivo2 = 0;
                motivo3 = 0;
            }   
        break;
    }
    diasProdTurno.push({
        ID_CONDUCTOR: diasProd.ID_CONDUCTOR,
        ID_TRACTO: diasProd.ID_VEHICULO,
        ANIO: diasProd.ANIO,
        NRO_SEMANA: diasProd.NRO_SEMANA,
        ID_ZONA : zona,
        FECHA: fecha,
        TURNO1: turno1,
        TURNO2: turno2,
        TURNO3: turno3,
        MOTIVO1: motivo1,
        MOTIVO2: motivo2,
        MOTIVO3: motivo3,
        ID_REPORT_PRO_OP: idReportOp
    });
    diasProdTurno = diasProdTurno[0];
    var params = `${diasProdTurno.ID_CONDUCTOR},${diasProdTurno.ID_TRACTO},${diasProdTurno.ANIO},${diasProdTurno.NRO_SEMANA},'${diasProdTurno.FECHA}',${diasProdTurno.TURNO1},${diasProdTurno.TURNO2},${diasProdTurno.TURNO3}, ${diasProdTurno.MOTIVO1}, ${diasProdTurno.MOTIVO2}, ${diasProdTurno.MOTIVO3}, ${diasProdTurno.ID_ZONA}, ${diasProdTurno.ID_REPORT_PRO_OP}, ${idUser}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_DELETE_OP_DETA_REPORT_PRODUCTIVIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaProductividad = result.recordset;
            return res.status(200).send({
                ok: true,
                detaProductividad,
                params
            });
        }
    });                      
});
// End Delete deta report OP


// Update deta report pro nuevos
app.put('/reportopdeta/:semana/:year/:zona/:idReportOp/:idUser',mdAuthenticattion.verificarToken, (req, res) => {    
    var semana = req.params.semana;
    var year = req.params.year;
    var zona = req.params.zona;
    var idUser = req.params.idUser;
    var idReportOp = req.params.idReportOp;
    var body = req.body;

    // return res.status(200).send({
    //     ok: true,  
    //     body                          
    // });

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
            // var params =  `${semana}, ${year}, ${zona}, '${fhDesde}', '${fhHasta}', ${cantRegistros}, ${idUser}`;
            
            var diasProdTurno = [];
            var i = 0;
            var fecha, turno1, turno2, turno3, motivo1, motivo2, motivo3;
            var arrayFecha;
            body.forEach(function (diasProd) { 
                i = 0;
                for (i = 0; i < 7; i++) {
                    switch(i) {
                        case 0:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia1.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia1.turno1;
                                turno2 = diasProd.dia1.turno2;
                                turno3 = diasProd.dia1.turno3;
                                motivo1 = diasProd.dia1.motivo1;
                                motivo2 = diasProd.dia1.motivo2;
                                motivo3 = diasProd.dia1.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia1.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia1.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia1.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }
                            if (zona == 3) {
                                arrayFecha = diasProd.dia1.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia1.turno1;
                                turno2 = diasProd.dia1.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia1.motivo1;
                                motivo2 = diasProd.dia1.motivo2;
                                motivo3 = 0;
                            }  
                            if (zona == 4) {
                                arrayFecha = diasProd.dia1.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia1.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia1.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }                          
                        break;  
                        case 1:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia2.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia2.turno1;
                                turno2 = diasProd.dia2.turno2;
                                turno3 = diasProd.dia2.turno3;
                                motivo1 = diasProd.dia2.motivo1;
                                motivo2 = diasProd.dia2.motivo2;
                                motivo3 = diasProd.dia2.motivo3;
                            }                            
                            if (zona == 2) {
                                arrayFecha = diasProd.dia2.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia2.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia2.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia2.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia2.turno1;
                                turno2 = diasProd.dia2.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia2.motivo1;
                                motivo2 = diasProd.dia2.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia2.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia2.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia2.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }  
                        break;                              
                        case 2:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia3.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia3.turno1;
                                turno2 = diasProd.dia3.turno2;
                                turno3 = diasProd.dia3.turno3;
                                motivo1 = diasProd.dia3.motivo1;
                                motivo2 = diasProd.dia3.motivo2;
                                motivo3 = diasProd.dia3.motivo3;
                            }                                
                            if (zona == 2) {
                                arrayFecha = diasProd.dia3.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia3.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia3.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia3.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia3.turno1;
                                turno2 = diasProd.dia3.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia3.motivo1;
                                motivo2 = diasProd.dia3.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia3.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia3.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia3.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }  
                        break;
                        case 3:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia4.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia4.turno1;
                                turno2 = diasProd.dia4.turno2;
                                turno3 = diasProd.dia4.turno3;
                                motivo1 = diasProd.dia4.motivo1;
                                motivo2 = diasProd.dia4.motivo2;
                                motivo3 = diasProd.dia4.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia4.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia4.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia4.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia4.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia4.turno1;
                                turno2 = diasProd.dia4.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia4.motivo1;
                                motivo2 = diasProd.dia4.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia4.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia4.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia4.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }   
                        break;
                        case 4:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia5.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia5.turno1;
                                turno2 = diasProd.dia5.turno2;
                                turno3 = diasProd.dia5.turno3;
                                motivo1 = diasProd.dia5.motivo1;
                                motivo2 = diasProd.dia5.motivo2;
                                motivo3 = diasProd.dia5.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia5.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia5.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia5.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia5.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia5.turno1;
                                turno2 = diasProd.dia5.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia5.motivo1;
                                motivo2 = diasProd.dia5.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia5.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia5.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia5.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }     
                        break;                            
                        case 5:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia6.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia6.turno1;
                                turno2 = diasProd.dia6.turno2;
                                turno3 = diasProd.dia6.turno3;
                                motivo1 = diasProd.dia6.motivo1;
                                motivo2 = diasProd.dia6.motivo2;
                                motivo3 = diasProd.dia6.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia6.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia6.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia6.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia6.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia6.turno1;
                                turno2 = diasProd.dia6.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia6.motivo1;
                                motivo2 = diasProd.dia6.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia6.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia6.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia6.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }  
                        break;
                        case 6:
                            if (zona == 1) {
                                arrayFecha = diasProd.dia7.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia7.turno1;
                                turno2 = diasProd.dia7.turno2;
                                turno3 = diasProd.dia7.turno3;
                                motivo1 = diasProd.dia7.motivo1;
                                motivo2 = diasProd.dia7.motivo2;
                                motivo3 = diasProd.dia7.motivo3;
                            }
                            if (zona == 2) {
                                arrayFecha = diasProd.dia7.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia7.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia7.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                            if (zona == 3) {
                                arrayFecha = diasProd.dia7.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia7.turno1;
                                turno2 = diasProd.dia7.turno2;
                                turno3 = 0;
                                motivo1 = diasProd.dia7.motivo1;
                                motivo2 = diasProd.dia7.motivo2;
                                motivo3 = 0;
                            }
                            if (zona == 4) {
                                arrayFecha = diasProd.dia7.fecha.split('/');
                                fecha = arrayFecha[2] + '-' + arrayFecha[1] + '-' + arrayFecha[0];
                                turno1 = diasProd.dia7.turno1;
                                turno2 = 0;
                                turno3 = 0;
                                motivo1 = diasProd.dia7.motivo1;
                                motivo2 = 0;
                                motivo3 = 0;
                            }    
                        break;
                    }
                    diasProdTurno.push({
                        ID_CONDUCTOR: diasProd.ID_CONDUCTOR,
                        ID_TRACTO: diasProd.ID_VEHICULO,
                        ANIO: diasProd.ANIO,
                        NRO_SEMANA: diasProd.NRO_SEMANA,
                        ID_ZONA : zona,
                        FECHA: fecha,
                        TURNO1: turno1,
                        TURNO2: turno2,
                        TURNO3: turno3,
                        MOTIVO1: motivo1,
                        MOTIVO2: motivo2,
                        MOTIVO3: motivo3,
                        ID_REPORT_PRO_OP: idReportOp
                    });
                }
            });
           
            var params ='';
            diasProdTurno.forEach(function (diasProd) {
                var idConductor = diasProd.ID_CONDUCTOR;
                var idTracto = diasProd.ID_TRACTO;
                var anio = diasProd.ANIO;
                var nroSemana = diasProd.NRO_SEMANA;
                var fecha = diasProd.FECHA;
                var turno1 = diasProd.TURNO1;
                var turno2 = diasProd.TURNO2;
                var turno3 = diasProd.TURNO3;
                var motivo1 = diasProd.MOTIVO1;
                var motivo2 = diasProd.MOTIVO2;
                var motivo3 = diasProd.MOTIVO3;    
                var idZona = diasProd.ID_ZONA;
                var idReport = diasProd.ID_REPORT_PRO_OP;
                // params = `${idConductor}, ${idTracto} , ${anio}, ${nroSemana}, '${fecha}', ${turno1}, ${turno2}, ${turno3}, ${motivo1}, ${motivo2}, ${motivo3}, ${idZona}, ${idReport}, ${idUser}`;
                params = params  + '\n' + `EXEC FE_SUPERVAN.DBO.SP_UPDATE_OP_DETA_REPORT_PRODUCTIVIDAD_NUEVOS ${idConductor}, ${idTracto} , ${anio}, ${nroSemana}, '${fecha}', ${turno1}, ${turno2}, ${turno3}, ${motivo1}, ${motivo2}, ${motivo3}, ${idZona}, ${idReport}, ${idUser}`;
                // actualizarDetareportOp(params)
            });
            var lsql = `${params}
            SELECT ${cantRegistros} as registrosAct`;
            var request = new mssql.Request();
            request.query(lsql, (err, result) => {
                if (err) { 
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                } else {
                    var updateDeta = result.recordset[0];  
                    return res.status(200).send({
                        ok: true,                             
                        cantRegistros,
                        updateDeta
                    });
                }
            });     
            // return res.status(200).send({
            //     ok: true,                             
            //     cantRegistros
            // });
        }
    });    
});
// End Update deta report pro nuevos

// Aprobar Reporte OP
app.put('/aprobarrepportop/:id/:user/:idZona', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var id = req.params.id;
    var user = req.params.user;
    var idZona = req.params.idZona;
    var params =  `${id}, ${user}, ${idZona} `;
    var lsql = `FE_SUPERVAN.DBO.SP_APROBAR_REPORTE_PROD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var reporteProOp = result.recordset[0];
            if(!reporteProOp) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existen registros para anular.'
                });
            }
            if(reporteProOp.MESSAGE) {
                return res.status(400).send({
                    ok: true,
                    message: reporteProOp.MESSAGE
                });
            }      
            return res.status(200).send({
                ok: true,
                reporteProOp
            });
        }
    });  
});
// End Aprobar Reporte OP

// Delete Report OP
app.delete('/reportop/:id/:user', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var id = req.params.id;
    var user = req.params.user;
    var params =  `${id}, ${user} `;
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_REPORT_OP ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var reportOp = result.recordset[0];
            if(!reportOp) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existen registros de viaticos para anular.'
                });
            }
            if(reportOp.MESSAGE) {
                return res.status(400).send({
                    ok: true,
                    message: reportOp.MESSAGE
                });
            }      
            return res.status(200).send({
                ok: true,
                reportOp
            });
        }
    });  
});
// End Delete Report OP

// Get Get deta report productividad
app.get('/detareportprodop/:semana/:year/:id',mdAuthenticattion.verificarToken, (req, res, next ) => {
    var semana = req.params.semana;
    var year = req.params.year;
    var id = req.params.id;
    var params =  `${id}`;   
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_DETA_REPORT_PRODUCTIVIDAD ${params}`;
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
                var zona = diasProductividad[0].ID_ZONA;
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
                        var lsql = `EXEC FE_SUPERVAN.DBO.SP_DETA_REPORT_PRO_TURNO ${params}`;
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
                                        if (zona == 1) {
                                            const resultado = diasTurnoProductividad.find( viajes => 
                                                viajes.PLACA_TRACTO === diasProd.PLACA_TRACTO && viajes.NOMBRE_CONDUCTOR === diasProd.NOMBRE_CONDUCTOR && viajes.FECHA === dia.FECHA 
                                            );                                     
                                            var turno1 = 0;
                                            var turno2 = 0;
                                            var turno3 = 0;  
                                            var motivo1 = 0;
                                            var motivo2 = 0;
                                            var motivo3 = 0;
                                            if (resultado) {
                                                motivo1 = resultado.MOTIVO1;
                                                motivo2 = resultado.MOTIVO2;
                                                motivo3 = resultado.MOTIVO3;
                                                if(resultado.TURNO1) {
                                                    turno1 = resultado.TURNO1;
                                                    
                                                }
                                                if(resultado.TURNO2) {
                                                    turno2 = resultado.TURNO2;
                                                    motivo2 = resultado.MOTIVO3;
                                                }
                                                if(resultado.TURNO3) {
                                                    turno3 = resultado.TURNO3;
                                                    motivo3 = resultado.MOTIVO3;
                                                }
                                                turnos = {
                                                    fecha: dia.FECHA,
                                                    turno1,
                                                    turno2,
                                                    turno3,
                                                    motivo1,
                                                    motivo2,
                                                    motivo3
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
                                        }  
                                        if (zona == 2) {                                        
                                            const resultado = diasTurnoProductividad.find( viajes => 
                                                viajes.PLACA_TRACTO === diasProd.PLACA_TRACTO && viajes.NOMBRE_CONDUCTOR === diasProd.NOMBRE_CONDUCTOR && viajes.FECHA === dia.FECHA 
                                            );                                      
                                            var turno1 = 0;
                                            var motivo1 = 0;
                                            if (resultado) {
                                                motivo1 = resultado.MOTIVO1;
                                                if (resultado.TURNO1) {
                                                    turno1 = resultado.TURNO1;
                                                }
                                                turnos = {
                                                    fecha: dia.FECHA,
                                                    turno1,                                         
                                                    motivo1                                                 
                                                };
                                            } else {
                                                turnos = {
                                                    fecha: dia.FECHA,
                                                    turno1,                                         
                                                    motivo1: 0                                                  
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
                                        }
                                        if (zona == 3) {                                            
                                            const resultado = diasTurnoProductividad.find( viajes => 
                                            viajes.PLACA_TRACTO === diasProd.PLACA_TRACTO && viajes.NOMBRE_CONDUCTOR === diasProd.NOMBRE_CONDUCTOR && viajes.FECHA === dia.FECHA 
                                            );                                            
                                            var turno1 = 0;
                                            var turno2 = 0;
                                            var motivo1 = 0;
                                            var motivo2 = 0;                                 
                                            if (resultado) {
                                                motivo1 = resultado.MOTIVO1;
                                                motivo2 = resultado.MOTIVO2;
                                                if(resultado.TURNO1) {
                                                    turno1 = resultado.TURNO1;
                                                }
                                                if(resultado.TURNO2) {
                                                    turno2 = resultado.TURNO2;
                                                }                                                
                                                turnos = {
                                                    fecha: dia.FECHA,
                                                    turno1,
                                                    turno2,                                            
                                                    motivo1,
                                                    motivo2                                                  
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
                                        }  
                                        if (zona == 4) {                                        
                                            const resultado = diasTurnoProductividad.find( viajes => 
                                                viajes.PLACA_TRACTO === diasProd.PLACA_TRACTO && viajes.NOMBRE_CONDUCTOR === diasProd.NOMBRE_CONDUCTOR && viajes.FECHA === dia.FECHA 
                                            );                                      
                                            var turno1 = 0;
                                            var motivo1 = 0;
                                            if (resultado) {
                                                motivo1 = resultado.MOTIVO1;
                                                if (resultado.TURNO1) {
                                                    turno1 = resultado.TURNO1;
                                                }
                                                turnos = {
                                                    fecha: dia.FECHA,
                                                    turno1,                                         
                                                    motivo1                                                 
                                                };
                                            } else {
                                                turnos = {
                                                    fecha: dia.FECHA,
                                                    turno1,                                         
                                                    motivo1: 0                                                  
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
                                        }
                                    });
                                });
                                return res.status(200).send({
                                    ok: true,                                    
                                    idZona: zona,
                                    dias,
                                    diasProductividad
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
// End Get deta report productividad

// Get reports productividad
app.get('/reportspro/:desde/:hasta/:search',mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var search = req.params.search;
    var params =  `'${desde}', '${hasta}', '${search}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_REPORTS_PRODUCTIVIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var reportspro = result.recordset;     
            return res.status(200).send({
                ok: true,
                reportspro: reportspro
            });
        }
    });  
});
// End reports productividad

// Get report productividad
app.get('/reportprodop/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idReport = req.params.id;
    var params =  `${idReport}`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_REPORT_PRODUCTIVIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var reportProOp = result.recordset[0];  
            if(!reportProOp) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe el registro.'
                });
            }          
            return res.status(200).send({
                ok: true,
                reportProOp
            });
        }
    });  
});
// End Get report productividad

// Get validar nro guia
app.get('/nroguia/:correlativo',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var body = req.body;
    var params =  `'${correlativo}'`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_VALIDAR_NRO_GUIA ${params}`;
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
            if(!guia) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe el numero de guia.'
                });
            }
            return res.status(200).send({
                ok: true,
                guia
            });
        }
    });
});
// End Get validar nro guia

// Get validar nro guia conductor
app.get('/nroguiacond/:correlativo/:dni',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var correlativo = req.params.correlativo;
    var dni = req.params.dni;
    var params =  `'${correlativo}','${dni}'`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_VALIDAR_NRO_GUIA_CONDUCTOR ${params}`;
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
            if(!guia) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe el numero de guia.'
                });
            }
            return res.status(200).send({
                ok: true,
                guia
            });
        }
    });
});
// End Get Validar nro guia conductor

// Get guias contorl viajes
app.get('/guiascontrolviajes/:idUser/:search/:desde/:hasta/:idZona', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idUser = req.params.idUser;
    var search = req.params.search;
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var idZona = req.params.idZona;
    var params =  `${idUser},'${search}','${desde}','${hasta}',${idZona}`;
    var lsql = `EXEC GET_GUIAS_CONTROL_VIAJES ${params}`;
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

// Update fecha control guia
app.put('/fechacontrolguia', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var body = req.body;
    var params =  `'${body.idGuia}','${body.fecha}',${body.idUser},${body.nroFecha},${body.idMotivo}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_FECHA_CONTROL_GUIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guiaUpdate = result.recordset[0];
            if(guiaUpdate) {
                var idGuia = guiaUpdate.ID_GUIA;
                if (!idGuia) {
                    return res.status(400).send({
                        ok: false,
                        message: guiaUpdate.MESSAGE
                    });
                }
            }
            return res.status(200).send({
                ok: true,
                guiaUpdate
            });
        }
    });
});
// End Update fecha control guia

// Update linea fechas control guia
app.put('/lineafechacontrolguia', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var body = req.body; 
    var params =  `${body.idGuia},'${body.fhInicioViaje}','${body.fhLlegadaPc}','${body.fhIngresoPc}','${body.fhSalidaPc}','${body.fhLlegadaPd}','${body.fhIngresoPd}','${body.fhSalidaPd}','${body.fhFinViaje}','${body.idMotivo}',${body.idUser}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_LINEA_FECHA_CONTROL_GUIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guiaUpdate = result.recordset[0];
            if(guiaUpdate) {
                var idGuia = guiaUpdate.ID_GUIA;
                if (!idGuia) {
                    return res.status(400).send({
                        ok: false,
                        message: guiaUpdate.MESSAGE
                    });
                }
            }
            return res.status(200).send({
                ok: true,
                guiaUpdate
            });
        }
    });
});
// End Update linea fechas control guia

// Update fechas control guia
app.put('/fechascontrolguia',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var body = req.body; 
    var params = '';
    body.forEach(function (guia) {
        params = params + ',' + '\n' + `(${guia.idGuia},'${guia.fhInicioViaje}','${guia.fhLlegadaPc}', '${guia.fhIngresoPc}','${guia.fhSalidaPc}','${guia.fhLlegadaPd}','${guia.fhIngresoPd}','${guia.fhSalidaPd}','${guia.fhFinViaje}',${guia.idMotivo})`;
    });     
    params = params.substring(1);   
    var lsql = `UPDATE A SET 
    A.FH_INICIO_VIAJE = N.FH_INICIO_VIAJE,
    A.FH_LLEGADA_PC = N.FH_LLEGADA_PC,
    A.FH_INGRESO_PC = N.FH_INGRESO_PC,
    A.FH_SALIDA_PC = N.FH_SALIDA_PC,
    A.FH_LLEGADA_PD = N.FH_LLEGADA_PD,
    A.FH_INGRESO_PD = N.FH_INGRESO_PD,
    A.FH_SALIDA_PD = N.FH_SALIDA_PD,
    A.FH_FIN_VIAJE = N.FH_FIN_VIAJE,
    A.ID_MOTIVO_OP = N.ID_MOTIVO_OP
    FROM FE_SUPERVAN.DBO.OP_GUIA_DESPACHO A JOIN 
    (VALUES ${params}) 
    N 
    (ID_GUIA,
    FH_INICIO_VIAJE,
    FH_LLEGADA_PC,
    FH_INGRESO_PC,
    FH_SALIDA_PC,
    FH_LLEGADA_PD,
    FH_INGRESO_PD,
    FH_SALIDA_PD,
    FH_FIN_VIAJE,
    ID_MOTIVO_OP) ON A.ID_GUIA = ID_GUIA`;
    return res.status(200).send({
        ok: true
    });
    
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guiaUpdate = result.recordset[0];
            if(guiaUpdate) {
                var idGuia = guiaUpdate.ID_GUIA;
                if (!idGuia) {
                    return res.status(400).send({
                        ok: false,
                        message: guiaUpdate.MESSAGE
                    });
                }
            }
            return res.status(200).send({
                ok: true,
                guiaUpdate
            });
        }
    });
});
// End Update fechas control guia

// Get tiempo tardanza viaje
app.get('/tiempotardanzaviaje/:iniciViaje/:idTracto', mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var iniciViaje = req.params.iniciViaje;
    var idTracto = req.params.idTracto;
    var params =  `'${iniciViaje}',${idTracto}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_TIEMPO_TARDANZA_CONTROL_VIAJES ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var datosTiempo = result.recordset[0];  
            return res.status(200).send({
                ok: true,
                datosTiempo
            });
        }
    });
});
// End Get tiempo tardanza viaje

// Get unidades
app.get('/unidades/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var search = req.params.search;
    var params =  `'${search}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_VEHICULOS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var unidades = result.recordset;   
            return res.status(200).send({
                ok: true,
                unidades
            });
        }
    });  
});
// End Get unidades

// Get unidad
app.get('/unidad/:placa', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var placa = req.params.placa;
    var params =  `'${placa}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_UNIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var unidad = result.recordset[0];  
            if (!unidad) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe la placa.'
                });
            }
            return res.status(200).send({
                ok: true,
                unidad
            });
            
        }
    });  
});
// End Get unidad

// Get unidadades disponibles
app.get('/unidadesDisponibles/:idTipo', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var idTipo = req.params.idTipo;
    var params =  `'${idTipo}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_UNIDADES_DISPONIBLES ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var unidades = result.recordset;  
            return res.status(200).send({
                ok: true,
                unidades
            });
            
        }
    });  
});
// End Get unidades disponibles

// Get conductores disponibles
app.get('/conductoresDisponibles', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_CONDUCTORES_DISPONIBLES`;
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
// End Get conductores disponibles

// Get orden de servicio
app.get('/ordenServicio/:id', (req, res, next ) => {   
    var id = req.params.id;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_ORDEN_SERVICIO ${id}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var ordenServicio = result.recordset[0];
            if (!ordenServicio) {
                return res.status(400).send({
                    ok: true,
                    message: 'No existe la orden de servicio.'
                });    
            }         
            return res.status(200).send({
                ok: true,
                ordenServicio
            });
        }
    });
});
// End Get orden de servicio

// Register planificacion operaciones
app.post('/planificacionOp', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idOrdenServicio},${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_OP_PLANIFICACION ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planifiacionOp = result.recordset[0];  
            var idPlanifiacionOp =  planifiacionOp.ID_PLANIFICACION_OP;

            if (!idPlanifiacionOp) {
                return res.status(400).send({
                    ok: false,
                    message: planifiacionOp.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                planifiacionOp
            });
        }
    });  
});
// End Register planificacion operaciones

// Get planificaciones op
app.get('/planificacionesOp/:search/:desde/:hasta', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var search = req.params.search;
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var params = `${search},'${desde}','${hasta}'`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_PLANIFICACIONES ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planificaciones = result.recordset;  
            return res.status(200).send({
                ok: true,
                planificaciones
            });
        }
    });  
});
// End Get planificaciones op

// Get planificacion op
app.get('/planificacionOp/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var id = req.params.id;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_PLANIFICACION ${id}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planificacionOp = result.recordset[0];  
            if (!planificacionOp) {
                return res.status(400).send({
                    ok: false,
                    message: 'No existe el registro.'
                });
            }
            return res.status(200).send({
                ok: true,
                planificacionOp
            });
        }
    });  
});
// End Get planificacion op

// Get planificacion op deta
app.get('/planificacionDeta/:idPlanificacion',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var idPlanificacion = req.params.idPlanificacion;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GETS_PLANIFICACION_OP_DETA ${idPlanificacion}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planificacionDeta = result.recordset;
            return res.status(200).send({
                ok: true,
                planificacionDeta
            });
        }
    });
});
// End Get planificacion op deta

// Get planificaciones op deta
app.get('/planificacionesDeta/:desde/:hasta/:idZona',mdAuthenticattion.verificarToken, (req, res, next ) => {   
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var idZona = req.params.idZona;
    var params = `'${desde}','${hasta}',${idZona}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_PLANIFICACIONES_OP_DETA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planificacionesDeta = result.recordset;
            return res.status(200).send({
                ok: true,
                planificacionesDeta
            });
        }
    });
});
// End Get planificacion op deta

// Register planificacion operaciones deta
app.post('/planificacionOpDeta', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var body = req.body;
    var params = `${body.idOrdenServicio},${body.idTracto},${body.idRemolque},${body.idConductor},${body.idUsuario},'${body.fecha}'`; 
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_OP_PLANIFICACION_DETA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planificacionDeta = result.recordset[0];  
            var idGuia =  planificacionDeta.ID_GUIA;
            if (!idGuia) {
                return res.status(400).send({
                    ok: false,
                    message: planifiacionOp.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                planificacionDeta
            });
        }
    });  
});
// End Register planificacion operaciones deta

// Delete planificacion op
app.delete('/planificacionOp/:id/:idOs/:idUsuario', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var id = req.params.id;
    var idOs = req.params.idOs;
    var idUsuario = req.params.idUsuario;
    var params = `${id},${idOs},${idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_OP_PLANIFICACION ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planifiacionOp = result.recordset[0];  
            var idPlanifiacionOp =  planifiacionOp.ID_PLANIFICACION_OP;

            if (!idPlanifiacionOp) {
                return res.status(400).send({
                    ok: false,
                    message: planifiacionOp.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                planifiacionOp
            });
        }
    });  
});
// End Delete planificacion op

// Delete planificacion op
app.delete('/planificacionOpDeta/:id/:idUsuario', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var id = req.params.id;
    var idUsuario = req.params.idUsuario;
    var params = `${id},${idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_OP_PLANIFICACION_DETA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planifiacionOpDeta = result.recordset[0];  
            var idGuia =  planifiacionOpDeta.ID_GUIA;

            if (!idGuia) {
                return res.status(400).send({
                    ok: false,
                    message: planifiacionOp.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                planifiacionOpDeta
            });
        }
    });  
});
// End Delete planificacion op

// Get guia planificacion
app.get('/guiaPlanificacion/:idOrden/:idConductor', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var idOrden = req.params.idOrden;
    var idConductor = req.params.idConductor;
    var params = `${idOrden}, ${idConductor}`;
    var lsql = `FE_SUPERVAN.DBO.SP_GET_GUIA_PLANIFICACION ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var guiaPlanificacion = result.recordset[0];  
            if (!guiaPlanificacion) {
                return res.status(400).send({
                    ok: false,
                    message: 'No existen registros disponibles para este conductor.'
                });
            }
            return res.status(200).send({
                ok: true,
                guiaPlanificacion
            });
        }
    });  
});
// End Get planificacion op

// Update fechas planificacion guia
app.put('/planificacionOpGuia', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    if (body.fhFinViaje) {
        var params = `${body.idGuia},'${body.fhInicioViaje}','${body.fhLlegadaPc}','${body.fhFinViaje}',${body.idUsuario}`; 
    } else {
        var params = `${body.idGuia},'${body.fhInicioViaje}','${body.fhLlegadaPc}',null,${body.idUsuario}`; 
    }
    var lsql = `FE_SUPERVAN.DBO.SP_UPDATE_FECHAS_PLANIFICACION_GUIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var planifiacionOpGuia = result.recordset[0];  
            var idGuia =  planifiacionOpGuia.ID_GUIA;
            if (!idGuia) {
                return res.status(400).send({
                    ok: false,
                    message: planifiacionOp.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                planifiacionOpGuia
            });
        }
    });  
});
// End Update fechas planificacion guia

// Get productividad tracto tarifa
app.get('/productividadTractoTarifa/:desde/:hasta/:idZona', (req, res, next ) => {        
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var idZona = req.params.idZona;
    var params =  `'${desde}','${hasta}',${idZona}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_PRODUCTIVIDAD_TRACTO ${params}`;
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
            var tractos = [];
            viajes.forEach(viaje => {
                const resultado = tractos.find( placa => placa.placa === viaje.PLACA_TRACTO);
                if(!resultado) {
                    tractos.push({
                        id: viaje.ID_TRACTO,
                        placa: viaje.PLACA_TRACTO
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
                    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_OP_NO_PRODUCTIVIDAD_TRACTO ${params}`;
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
                            var totalTarifa = 0; 
                            var idMotivo = 0;
                            var motivo = '';
                            var totalViajesDia = 0;
                            var viajesTotal = 0;
                            var tarifaTotalTracto = 0;                            
                            tractos.forEach(tracto => {
                                dias.forEach(dia => {                            
                                    viajes.forEach(viaje => {
                                        if (dia.FECHA === viaje.FH_GUIA && viaje.PLACA_TRACTO === tracto.placa) {
                                            var tarifa = 0;
                                            tarifa = viaje.TARIFA;
                                            viajesTotal = viajesTotal + viaje.VIAJES;
                                            tarifaTotalTracto = tarifaTotalTracto + (viaje.VIAJES * tarifa * viaje.CANTIDAD);
                                            totalTarifa = totalTarifa + (viaje.VIAJES * tarifa * viaje.CANTIDAD);
                                            totalViajesDia = totalViajesDia + viaje.VIAJES;
                                            arrayDetalle.push({
                                                ruta: viaje.DS_ORI_DEST + ' - ' + viaje.DESTINO,
                                                viajes: viaje.VIAJES,
                                                comsion: viaje.TARIFA,
                                                tarifaTotal: new Intl.NumberFormat().format(parseFloat(viaje.VIAJES * tarifa * viaje.CANTIDAD).toFixed(2)) 
                                            });
                                            detalleArray = detalleArray +' ' + viaje.DS_ORI_DEST + '= ' + viaje.VIAJES        
                                        }
                                    });                                       
                                                                       
                                    if (arrayDetalle.length === 0) {
                                        let arrayFechaDia = dia.FECHA.split('/');
                                        let fechaDia = arrayFechaDia[2] + '-' + arrayFechaDia[1] + '-' + arrayFechaDia[0];
                                        const resultadoMotivo = motivos.find(motivo => motivo.ID_TRACTO === tracto.id && motivo.FECHA_MOTIVO  === fechaDia);
                                        if(resultadoMotivo) {                                           
                                            idMotivo = resultadoMotivo.ID_NO_PRODUCTIVIDAD_TRACTO;
                                            motivo = resultadoMotivo.DS_MOTIVO;
                                        }
                                    }

                                    if (motivo.length === 0) {
                                        idMotivo = 0;
                                        motivo = 'NO REGISTRA VIAJES';
                                    }
                                                        
                                    detalleViajes = JSON.stringify(arrayDetalle);
                                    totalTarifa =  new Intl.NumberFormat().format(parseFloat(totalTarifa).toFixed(2));
                                    detalle = detalle + `,
                                        "${dia.DIA}": {  
                                            "totalViajes": ${totalViajesDia},                                         
                                            "totalTarifa": "${totalTarifa}",
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
                                    totalTarifa = 0;   
                                    totalViajesDia = 0;
                                    idMotivo = 0; 
                                    motivo = '';              
                                });
                                detalle = detalle.substring(1);
                                tarifaTotalTracto = new Intl.NumberFormat().format(parseFloat(tarifaTotalTracto).toFixed(2));
                                productividad = productividad + `,{
                                    "id": "${tracto.id}",
                                    "placa": "${tracto.placa}",
                                    "viajesTotal": ${viajesTotal},
                                    "tarifaTotal": "${tarifaTotalTracto}",
                                    ${detalle}
                                }`;
                                detalle = '';
                                totalTarifa = 0;
                                viajesTotal = 0;
                                tarifaTotalTracto = 0;
                                detalle = detalle.substring(1);
                            });
                            productividad = productividad.substring(1);
                            var productividaTracto =  JSON.parse('[' + productividad + ']');
                            return res.status(200).send({
                                ok: true,
                                productividaTracto,
                                dias,
                                tractos
                            });
                        }
                    });
                }
            });
        }
    });  
});
// End Get productividad tracto tarifa

// Register-Update motivo no productividad tracto
app.post('/motivoNoProductividadTracto', (req, res, next ) => {
    var body = req.body;
    var params = `${body.id},${body.idConductor},'${body.motivo.toUpperCase()}','${body.fecha}',${body.idUsuario}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_REGISTER_UPDATE_OP_NO_PRODUCTIVIDAD_TRACTO ${params}`;
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
            var motivo = result.recordset[0];   
            var idMotivo = motivo.ID_NO_PRODUCTIVIDAD_TRACTO;    
            if (!idMotivo) {
                return res.status(400).send({
                    ok: false,
                    error: motivo.MESSAGE
                });  
            }

            return res.status(200).send({
                ok: true,
                motivo
            });   
        }
    });
});
// End Register-Update motivo no productividad tracto
  

module.exports = app;
