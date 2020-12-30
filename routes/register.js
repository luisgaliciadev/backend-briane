'use strict'

var express = require('express');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');

//////////////////////////////////////////////////////////////////////////////////
// Client

// Register Client
app.post('/client', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;
    var idUser = body.ID_USER;
    var codClient = body.COD_CLIENT;
    var dsClient = body.DS_CLIENT;
    var email = body.EMAIL;
    var phone = body.PHONE;
    var contact = body.CONTACT;
    var idType = body.ID_TYPE;
    var idTypeClient = body.ID_TYPE_CLIENT;
    var params = `${idUser}, '${codClient}','${dsClient}' , '${email}', '${phone}', '${contact}', ${idType}, ${idTypeClient}`;
    var request = new mssql.Request();
    var lsql = `EXEC REGISTER_CLIENT ${params}`;  
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var clientRegister = result.recordset;
            if (clientRegister.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Cliente no registrado.'
                });
            } else {
                if (clientRegister[0].ID_CLIENT === 0) {
                    return res.status(400).send({
                        ok: true,                             
                        message: clientRegister[0].MESSAGE
                    });
                } else {
                    return res.status(200).send({
                        ok: true,                             
                        client: clientRegister[0]
                    });
                }
            }
        }
    });
});
// End Register Client

// Update Client
app.put('/client', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var body = req.body;
    var idClient = body.ID_CLIENT;
    var idUser = body.ID_USER;
    var codClient = body.COD_CLIENT;
    var dsClient = body.DS_CLIENT;
    var email = body.EMAIL;
    var phone = body.PHONE;
    var contact = body.CONTACT;
    var idType = body.ID_TYPE;
    var idTypeClient = body.ID_TYPE_CLIENT;
    var params = `${idClient}, ${idUser}, '${codClient}','${dsClient}' , '${email}', '${phone}', '${contact}', ${idType}, ${idTypeClient}`;
    var request = new mssql.Request();
    var lsql = `EXEC UPDATE_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var clientUpdate = result.recordset;
            if (clientUpdate.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Cliente no registrado.'
                });
            } else {
                if (clientUpdate[0].ID_CLIENT === 0) {
                    return res.status(400).send({
                        ok: true,                             
                        message: clientUpdate[0].MESSAGE
                    });
                } else {
                    return res.status(200).send({
                        ok: true,                             
                        client: clientUpdate[0]
                    });
                }
            }
        }
    });
});
// End Update Client

// Delete Client
app.delete('/client/:id', (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`; 
    var lsql = `EXEC DELETE_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {   
            var clientDeleted = result.recordset;
            if (clientDeleted.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Cliente no registrado.'
                });
            } else {
                return res.status(200).send({
                    ok: true,
                    client: clientDeleted[0]
                });
            }
        }
    });
});
// End Delete Client

// Get Clients
app.get('/clients/:search/:idUser', (req, res, next ) => {
    var search = req.params.search;
    var idUser = req.params.idUser;
    var params = `${idUser}, '${search}'`;
    var lsql = `EXEC GET_CLIENTS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var clients = result.recordset;
            
            return res.status(200).send({
                clients: clients
            });
        }
    });
});
// End Get Clients

// Get Client
app.get('/client/:id/:idUser', (req, res, next ) => {
    var id = req.params.id;
    var idUser = req.params.idUser;
    var params = `${id}, ${idUser}`; 
    var lsql = `EXEC GET_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var client = result.recordset;
            if (client.length === 0) {
                return  res.status(400).send({
                    ok: true, 
                    message: 'Cliente no registrado.'
                }); 
            } else {
                return res.status(200).send({
                    ok: true,
                    client: client[0]
                });  
            }
        }
    });
});
// End Get Client

// Get Type Id Client
app.get('/idtypeclient', (req, res, next ) => {
    var lsql = `SELECT * FROM ID_TYPE_CLIENT`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) {
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var ID_TYPE_CLIENT = result.recordset;            
            return res.status(200).send({
                ID_TYPE_CLIENT: ID_TYPE_CLIENT
            });
        }
    });
});
// End Get Type Id Client

// Get Type Client
app.get('/typeclient', (req, res, next ) => {
    var lsql = `SELECT * FROM TYPE_CLIENT`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var TYPE_CLIENT = result.recordset;            
            return res.status(200).send({
                TYPE_CLIENT: TYPE_CLIENT
            });
        }
    });
});
// End Get Type Client

// Register Address Client
app.post('/address', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var body = req.body;
    var idClient = body.ID_CLIENT;
    var dsAddress = body.DS_ADDRESS_CLIENT;
    var address = body.ADDRESS;    
    var idDistrito = body.ID_DISTRITO;
    var fgPrincipal = body.FG_PRINCIPAL;
    var params = `${idClient},'${dsAddress}' , '${address}', ${idDistrito}, ${fgPrincipal}`;
    var request = new mssql.Request();
    var lsql = `EXEC REGISTER_ADDRESS_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {   
            var addressRegister = result.recordset;
            if (addressRegister.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Dirección no registrada.'
                });
            } else {
                return res.status(200).send({
                    ok: true,
                    address: addressRegister[0]
                });
            }
        }
    });
});
// End Register Address Client

// Update Address Client
app.put('/addressupdate/:id/', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var id = req.params.id;
    var body = req.body;
    var dsAddressClient = body.DS_ADDRESS_CLIENT;
    var address = body.ADDRESS;    
    var idDistrito = body.idDistrito;   
    var params = `${id},'${dsAddressClient}' , '${address}', ${idDistrito}`;
    var request = new mssql.Request();
    var lsql = `EXEC UPDATE_ADDRESS_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var addressUpdated = result.recordset;
            if (addressUpdated.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Sucursal no registrada.'
                });
            } else {
                return res.status(200).send({
                    ok: true,                             
                    address: addressUpdated[0]
                });
               
            }
        }
    });
});
// End Update Address Client

// Gets Address Clients
app.get('/address/:id', (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`;
    var lsql = `EXEC GETS_ADDRESS_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var address = result.recordset;
            return res.status(200).send({
                address: address
            });
        }
    });
});
// End Gets Address Clients

// Get Address Client
app.get('/address/:id/:idClient', (req, res, next ) => {
    var id = req.params.id;
    var idClient = req.params.idClient;
    var params = `${id}, ${idClient}`; 
    var lsql = `EXEC GET_ADDRESS_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var address = result.recordset;
            var address = result.recordset;
            if (address.length === 0) {
                return res.status(200).send({
                    ok: true,
                    message: 'La sucursal no esta registrada.'
                });
            } else {
                return res.status(200).send({
                    ok: true,
                    address: address[0]
                });
            }
        }
    });
});
// End Get Address Client

// Default Address
app.put('/defaultaddress/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var id = req.params.id;
    var params = `${id}`;
    var request = new mssql.Request();
    var lsql = `EXEC DEFAULT_ADDRESS_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var addressUpdated = result.recordset;
            if (addressUpdated.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Sucursal no registrada.'
                });
            } else {              
                return res.status(200).send({
                    ok: true,
                    address: addressUpdated[0]
                });               
            }
        }
    });
});
// End Default Address

// Delete Address
app.delete('/address/:id',mdAuthenticattion.verificarToken, (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`;
    var lsql = `EXEC DELETE_ADDRESS_CLIENT ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var addressDeleted = result.recordset;
            if (addressDeleted[0].ID_ADDRESS_CLIENT === 0) {
                return res.status(400).send({
                    ok: true,
                    message: addressDeleted[0].MESSAGE
                });
            } else {
                return res.status(200).send({
                    ok: true,                             
                    address: addressDeleted[0]
                });
            }
        }
    });
});
// End Delete Address

// Clints
//////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////
// Denuncias

// Register Denuncia
app.post('/denuncia', (req, res, next ) => {
    var body = req.body; 
    var TITULO = body.titulo.toUpperCase();
    var DESCRIPCION = body.descripcion;
    var FG_EMPLEADO = body.FG_EMPLEADO;
    var FG_ANONIMATO = body.FG_ANONIMATO;
    var NOMBRES = body.nombres;
    var APELLIDOS = body.apellidos;
    var TELEFONO = body.telefono;
    var CORREO = body.correo;
    var HORA_CONTACTO = body.horaContacto;
    var PERSONAS_INVOLUCRADAS = body.personasInvolucradas;
    var ARCHIVO1 = body.archivo1;
    var ARCHIVO2 = body.archivo2;
    var ARCHIVO3 = body.archivo3;

    var params = `'${TITULO}', '${DESCRIPCION}', ${FG_EMPLEADO}, ${FG_ANONIMATO}, '${NOMBRES}', '${APELLIDOS}', '${TELEFONO}', '${CORREO}', '${HORA_CONTACTO}', '${PERSONAS_INVOLUCRADAS}'`;
       
    var lsql = `EXEC REGISTER_DENUNCIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var denunciaRegister = result.recordset;

            if (denunciaRegister[0].ID_DENUNCIA ===0) {
                return res.status(400).send({
                    ok: true,
                    message: denunciaRegister[0].MESSAGE
                });
            } else {
                return res.status(200).send({
                    ok: true,
                    denuncia: denunciaRegister[0]
                });
            }
        }
    });
});
// End Register Denuncia

// Get Denuncias
app.get('/denuncias/:search', (req, res, next ) => {
    var search = req.params.search;
    var params = `'${search}'`;
    var lsql = `EXEC GET_DENUNCIAS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var denuncias = result.recordset;
            
            return res.status(200).send({
                denuncias
            });
        }
    });
});
// End Get Denuncias

// Get Denuncia
app.get('/verdenuncia/:id', (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`; 
    var lsql = `EXEC GET_DENUNCIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var denuncia = result.recordset;
            if (denuncia.length === 0) {
                return  res.status(400).send({
                    ok: true, 
                    message: 'Denuncia no registrada.'
                }); 
            } else {
                return res.status(200).send({
                    ok: true,
                    denuncia: denuncia[0]
                });  
            }
        }
    });
});
// End Get Denuncia

// Delete Denuncia
app.delete('/denuncia/:id',mdAuthenticattion.verificarToken, (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`; 
    var lsql = `EXEC DELETE_DENUNCIA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {   
            var denunciaDeleted = result.recordset;
            if (denunciaDeleted.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Denuncia no registrada.'
                });
            } else {
                return res.status(200).send({
                    ok: true,
                    denuncia: denunciaDeleted[0]
                });
            }
        }
    });
});
// End Delete Denuncia

// Denuncias
/////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////
// REGISTER

// Get Clientes
app.get('/cliente/:ruc',mdAuthenticattion.verificarToken, (req, res, next ) => {
    var ruc = req.params.ruc;
    var params = `'${ruc}'`; 
    var lsql = `EXEC GET_CLIENTE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var cliente = result.recordset[0];
            if (!cliente) {
                return  res.status(400).send({
                    ok: true, 
                    message: 'Cliente no registrado.'
                }); 
            } else {
                return res.status(200).send({
                    ok: true,
                    cliente
                });  
            }
        }
    });
});
// End Get Clientes

// Get Dia feriado
app.get('/diasferiado', (req, res, next ) => {
    // var dia = req.params.dia;
    // var params = `'${dia}'`; 
    var lsql = `SELECT * FROM FE_SUPERVAN.DBO.DIAS_FERIADOS`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var diasFeriado = result.recordset;
            return res.status(200).send({
                ok: true,
                diasFeriado
            });
        }
    });
});
// End Get Dia feriado

// Get CLASIFICACION_DOCUMENTOS_BRIANE
app.get('/clasificaciondocbriane', (req, res, next ) => {
    var lsql = `EXEC GET_CLASIFICACION_DOCUMENTOS_BRIANE`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var clasificacionDocumentos = result.recordset;
            return res.status(200).send({
                ok: true,
                clasificacionDocumentos
            });
        }
    });
});
// End Get CLASIFICACION_DOCUMENTOS_BRIANE

// Get CATEGORIA_DOCUMENTOS_BRIANE
app.get('/categoriadocbriane/:idClasificacion', (req, res, next ) => {
    var idClasificacion = req.params.idClasificacion;
    var params = `'${idClasificacion}'`; 
    var lsql = `EXEC GET_CATEGORIA_DOCUMENTOS_BRIANE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var categoriaDocumenos = result.recordset;
            return res.status(200).send({
                ok: true,
                categoriaDocumenos
            });
        }
    });
});
// End Get CATEGORIA_DOCUMENTOS_BRIANE

// Get AREA_BRIANE
app.get('/areasbriane', (req, res, next ) => {
    var lsql = `EXEC GET_AREA_BRIANE`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var areasBriane = result.recordset;
            return res.status(200).send({
                ok: true,
                areasBriane
            });
        }
    });
});
// End Get AREA_BRIANE

// Get DOCUMENTOS_BRIANE
app.get('/documentosbriane/:idClasificacion/:idCategoria/:idArea', (req, res, next ) => {
    var idClasificacion = req.params.idClasificacion;
    var idCategoria = req.params.idCategoria;
    var idArea = req.params.idArea;
    var params = `${idClasificacion},${idCategoria},${idArea}`; 
    var lsql = `EXEC GET_DOCUMENTOS_BRIANE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentosBriane = result.recordset;
            return res.status(200).send({
                ok: true,
                documentosBriane
            });
        }
    });
});
// End Get DOCUMENTOS_BRIANE

// Get EMPLEADOS GENESYS
app.get('/empleadosrrhhgenesys/:fechaContrato',mdAuthenticattion.verificarToken, (req, res, next ) => {
    var fechaContrato = req.params.fechaContrato;
    var params = `'${fechaContrato}'`; 
    var lsql = `EXEC GET_PERSONAL_RRHH_GENESYS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var empleados = result.recordset;
            return res.status(200).send({
                ok: true,
                empleados
            });
        }
    });
});
// End Get DOCUMENTOS_BRIANE

// Gets EMPLEADOS GENESYS BAJAS
app.get('/empleadosrrhhgenesysbajas/:fechaContrato',mdAuthenticattion.verificarToken, (req, res, next ) => {
    var fechaContrato = req.params.fechaContrato;
    var params = `'${fechaContrato}'`; 
    var lsql = `EXEC GET_PERSONAL_RRHH_GENESYS_BAJAS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var empleados = result.recordset;
            return res.status(200).send({
                ok: true,
                empleados
            });
        }
    });
});
// End Get EMPLEADOS GENESYS BAJAS

// Get monedas
app.get('/monedas',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_MONEDAS`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var monedas = result.recordset;
            return res.status(200).send({
                ok: true,
                monedas
            });
        }
    });
});
// End Get monedas

// Get tipo cobros ordenes servicio
app.get('/tipocobrosos',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_TIPO_COBROS_OS`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var tipoCobrosOs = result.recordset;
            return res.status(200).send({
                ok: true,
                tipoCobrosOs
            });
        }
    });
});
// End Get tipo cobros ordenes servicio


// Get clientes proveedores
app.get('/clientes',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_CLIENTES_PROVEEDORES`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var clientes = result.recordset;
            return res.status(200).send({
                ok: true,
                clientes
            });
        }
    });
});
// End Get clientes proveedores

// Get origenes-destinos
app.get('/origenesdestinos/:fgDestino',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var fgDestino = req.params.fgDestino;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_ORIGENES_DESTINOS ${fgDestino}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var origenesDestinos = result.recordset;
            return res.status(200).send({
                ok: true,
                origenesDestinos
            });
        }
    });
});
// End Get origenes-destinos

// Get tipo de carga
app.get('/tipocargas',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_TIPO_CARGAS`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var tipoCargas = result.recordset;
            return res.status(200).send({
                ok: true,
                tipoCargas
            });
        }
    });
});
// End Get tipo carga

// Get productos
app.get('/productos',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_PRODUCTOS`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var productos = result.recordset;
            return res.status(200).send({
                ok: true,
                productos
            });
        }
    });
});
// End Get productos

// Register ruta
app.post('/ruta', (req, res, next ) => {
    var body = req.body;   
    let horaInicio = body.HORA_INICIO.substring(0,2) + ':' + body.HORA_INICIO.substring(2);
    let horaFin = body.HORA_FIN.substring(0,2) + ':' + body.HORA_FIN.substring(2);
    let idaHoras = body.IDA_HORAS.substring(0,2) + ':' + body.IDA_HORAS.substring(2);
    let retornoHoras = body.RETORNO_HORAS.substring(0,2) + ':' + body.RETORNO_HORAS.substring(2);
    let origenHoras = body.ORIGEN_HORAS.substring(0,2) + ':' + body.ORIGEN_HORAS.substring(2);
    let destinoHoras = body.DESTINO_HORAS.substring(0,2) + ':' + body.DESTINO_HORAS.substring(2);
    // let leadtimeHoras = body.LEADTIME_HORAS.substring(0,2) + ':' + body.LEADTIME_HORAS.substring(2);  

    var params = `'${body.DS_RUTA.toUpperCase()}',${body.ID_MONEDA},${body.TARIFA},${body.ID_ORIGEN},${body.ID_DESTINO},${body.ID_CLIENTE},${body.ID_TIPO_CARGA},${body.ID_PRODUCTO},'${body.OBSERVACION.toUpperCase()}',${body.ID_USUARIO},${body.ID_TIPO_COBRO_OS},'${horaInicio}','${horaFin}',${body.KM},'${idaHoras}','${retornoHoras}','${origenHoras}','${destinoHoras}','${body.LEADTIME_HORAS}',${body.LEADTIME_DIAS},${body.COSTO_ESTIBA},${body.PEAJES},${body.COMBUSTIBLE_GLNS},${body.REDIMIENTO_KM_GLNS}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_REGISTER_RUTA ${params}`;
    var request = new mssql.Request();
    request.query(lsql,  (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var ruta = result.recordset[0];
            if (!ruta.ID_RUTA) {
                return res.status(400).send({
                    ok: false,
                    message: ruta.MESSAGE
                });
            }
            
            // Registrar detalles tipo carga
            params = [];
            body.DETA_TIPO_CARGAS.forEach(function (detalle) {                
                params = params + ',' + '\n' + `(${detalle.ID_TIPO_CARGA},${ruta.ID_RUTA})`;
            });
            params = params.substring(1);
            var lsql = `INSERT INTO FE_SUPERVAN.DBO.OP_DETA_RUTA_TIPO_CARGA (ID_TIPO_CARGA,ID_RUTA) 
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
                    var cantDetaTipoCargas = result.rowsAffected[0];
                    if (!cantDetaTipoCargas) {
                        return res.status(500).send({
                            ok: false,
                            message: 'Error en la petición. No pudieron registrar los tipo de cargas relacionados.',
                            error: err
                        });
                    }
                    // Registrar deta ruta productos
                    params = [];
                    body.DETA_PRODUCTOS.forEach(function (detalle) {                
                        params = params + ',' + '\n' + `(${detalle.ID_PRODUCTO},${ruta.ID_RUTA})`;
                    });
                    params = params.substring(1);
                    var lsql = `INSERT INTO FE_SUPERVAN.DBO.OP_DETA_RUTA_PRODUCTO (ID_PRODUCTO,ID_RUTA) 
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
                            var cantDetaProductos = result.rowsAffected[0];
                            if (!cantDetaProductos) {
                                return res.status(500).send({
                                    ok: false,
                                    message: 'Error en la petición. No pudieron registrar los productos relacionados.',
                                    error: err
                                });
                            }
                            return res.status(200).send({
                                ok: true,
                                ruta
                            });
                        }
                    });  
                    
                }
            });
        }
    });
});
// End Register ruta

// Get ruta
app.get('/ruta/:idRuta',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var idRuta = req.params.idRuta;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_RUTA ${idRuta}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var ruta = result.recordset[0];
            if (!ruta) {
                return res.status(400).send({
                    ok: false,
                    message: 'No existe la ruta.'
                });
            }
            return res.status(200).send({
                ok: true,
                ruta
            });
        }
    });
});
// End Get ruta

// Get deta ruta tipo cargas
app.get('/detarutatipocargas/:idRuta',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var idRuta = req.params.idRuta;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_DETA_RUTA_TIPO_CARGAS ${idRuta}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaTipoCargas = result.recordset;
            return res.status(200).send({
                ok: true,
                detaTipoCargas
            });
        }
    });
});
// End Get deta ruta tipo cargas

// Get deta ruta productos
app.get('/detarutaproductos/:idRuta',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var idRuta = req.params.idRuta;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_DETA_RUTA_PRODUCTOS ${idRuta}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaProductos = result.recordset;
            return res.status(200).send({
                ok: true,
                detaProductos
            });
        }
    });
});
// End Get deta ruta productos

// Get rutas
app.get('/rutas/:search',mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var search = req.params.search;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_RUTAS '${search}'`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var rutas = result.recordset;
            return res.status(200).send({
                ok: true,
                rutas
            });
        }
    });
});
// End Get rutas

// Update ruta
app.put('/ruta', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var body = req.body;   
    let horaInicio = body.HORA_INICIO.substring(0,2) + ':' + body.HORA_INICIO.substring(2);
    let horaFin = body.HORA_FIN.substring(0,2) + ':' + body.HORA_FIN.substring(2);
    let idaHoras = body.IDA_HORAS.substring(0,2) + ':' + body.IDA_HORAS.substring(2);
    let retornoHoras = body.RETORNO_HORAS.substring(0,2) + ':' + body.RETORNO_HORAS.substring(2);
    let origenHoras = body.ORIGEN_HORAS.substring(0,2) + ':' + body.ORIGEN_HORAS.substring(2);
    let destinoHoras = body.DESTINO_HORAS.substring(0,2) + ':' + body.DESTINO_HORAS.substring(2);     
    var params = `${body.ID_RUTA},'${body.DS_RUTA.toUpperCase()}',${body.ID_MONEDA},${body.TARIFA},${body.ID_ORIGEN},${body.ID_DESTINO},${body.ID_CLIENTE},${body.ID_TIPO_CARGA},${body.ID_PRODUCTO},'${body.OBSERVACION.toUpperCase()}',${body.ID_USUARIO},${body.ID_TIPO_COBRO_OS},'${horaInicio}','${horaFin}',${body.KM},'${idaHoras}','${retornoHoras}','${origenHoras}','${destinoHoras}','${body.LEADTIME_HORAS}',${body.LEADTIME_DIAS},${body.COSTO_ESTIBA},${body.PEAJES},${body.COMBUSTIBLE_GLNS},${body.REDIMIENTO_KM_GLNS}`;
    // var params = `${body.ID_RUTA},'${body.DS_RUTA.toUpperCase()}',${body.ID_MONEDA},${body.TARIFA},${body.ID_ORIGEN},${body.ID_DESTINO},${body.ID_CLIENTE},${body.ID_TIPO_CARGA},${body.ID_PRODUCTO},'${body.OBSERVACION.toUpperCase()}',${body.ID_USUARIO}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_RUTA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var ruta = result.recordset[0];
            if (!ruta) {
                return res.status(400).send({
                    ok: false,
                    message: 'No existe la ruta.'
                });
            }     

            if (!ruta.ID_RUTA) {
                return res.status(400).send({
                    ok: false,
                    message: ruta.MESSAGE
                });
            }        
            return res.status(200).send({
                ok: true,
                ruta
            });  
        }
    });
});
// End Update ruta

// Delete ruta
app.delete('/ruta/:idRuta/:idUsuario', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var idRuta = req.params.idRuta;  
    var idUsuario = req.params.idUsuario;    
    var params = `${idRuta},${idUsuario}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_DELETE_RUTA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var ruta = result.recordset[0];
            if (!ruta) {
                return res.status(400).send({
                    ok: false,
                    message: 'No existe la ruta.'
                });
            }     

            if (!ruta.ID_RUTA) {
                return res.status(400).send({
                    ok: false,
                    message: ruta.MESSAGE
                });
            }        
            return res.status(200).send({
                ok: true,
                ruta
            });  
        }
    });
});
// End Delete ruta

// Register deta ruta tipo carga
app.post('/detarutatipocarga/:idTipoCarga/:idRuta/:idUsuario', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var idTipoCarga = req.params.idTipoCarga;  
    var idRuta = req.params.idRuta;  
    var idUsuario = req.params.idUsuario;    
    var params = `${idTipoCarga},${idRuta},${idUsuario}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_REGISTER_OP_DETA__RUTA_TIPO_CARGA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaRutaTipoCarga = result.recordset[0];
            return res.status(200).send({
                ok: true,
                detaRutaTipoCarga
            });  
        }
    });
});
// End register deta ruta tipo carga

// Register deta ruta producto
app.post('/detarutaproducto/:idProducto/:idRuta/:idUsuario', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var idProducto = req.params.idProducto;  
    var idRuta = req.params.idRuta;  
    var idUsuario = req.params.idUsuario;    
    var params = `${idProducto},${idRuta},${idUsuario}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_REGISTER_OP_DETA_RUTA_PRODUCTO ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaRutaProducto = result.recordset[0];
            return res.status(200).send({
                ok: true,
                detaRutaProducto
            });  
        }
    });
});
// End register deta ruta tipo carga

// Delete deta ruta tipo carga
app.delete('/detarutatipocarga/:idDeta/:idUsuario', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var idDeta = req.params.idDeta;  
    var idUsuario = req.params.idUsuario;    
    var params = `${idDeta},${idUsuario}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_DELETE_OP_DETA_RUTA_TIPO_CARGA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaRutaTipoCarga = result.recordset[0];
            return res.status(200).send({
                ok: true,
                detaRutaTipoCarga
            });  
        }
    });
});
// End delete deta ruta tipo carga


// Delete deta ruta producto
app.delete('/detarutaproducto/:idDeta/:idUsuario', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var idDeta = req.params.idDeta;  
    var idUsuario = req.params.idUsuario;    
    var params = `${idDeta},${idUsuario}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_DELETE_OP_DETA_RUTA_PRODUCTO ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var detaRutaProducto = result.recordset[0];
            return res.status(200).send({
                ok: true,
                detaRutaProducto
            });  
        }
    });
});
// End delete deta ruta producto

// Aprobar ruta
app.put('/aprobarRuta/:idRuta/:idUsuario', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var idRuta = req.params.idRuta;  
    var idUsuario = req.params.idUsuario;    
    var params = `${idRuta},${idUsuario}`;
    var lsql = `EXEC FE_SUPERVAN.DBO.SP_APROBAR_RUTA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var ruta = result.recordset[0];
            if (!ruta) {
                return res.status(400).send({
                    ok: false,
                    message: 'No existe la ruta.'
                });
            }     

            if (!ruta.ID_RUTA) {
                return res.status(400).send({
                    ok: false,
                    message: ruta.MESSAGE
                });
            }        
            return res.status(200).send({
                ok: true,
                ruta
            });  
        }
    });
});
// End Aprobar ruta

// Register documentos conductores
app.post('/documentoConductor', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `'${body.nombreDocumento.toUpperCase()}',${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_OP_DOCUMENTOS_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documento = result.recordset[0];  
            var idDocumento =  documento.ID_DOCUMENTO;

            if (!idDocumento) {
                return res.status(400).send({
                    ok: false,
                    message: documento.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documento
            });
        }
    });  
});
// End Get documentos conductores

// Update documentos conductores
app.put('/documentoConductor', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idDocumento},'${body.nombreDocumento.toUpperCase()}',${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_UPDATE_OP_DOCUMENTOS_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documento = result.recordset[0];
            var idDocumento =  documento.ID_DOCUMENTO;
            if (!idDocumento) {
                return res.status(400).send({
                    ok: false,
                    message: documento.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documento
            });
        }
    });  
});
// End Get documentos conductores

// Delete documentos conductores
app.delete('/documentoConductor/:idDoc/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var idDoc = req.params.idDoc;  
    var idUser = req.params.idUser; 
    var params = `${idDoc},${idUser}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_OP_DOCUMENTOS_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documento = result.recordset[0];  
            var idDocumento =  documento.ID_DOCUMENTO;
            if (!idDocumento) {
                return res.status(400).send({
                    ok: false,
                    message: documento.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documento
            });
        }
    });  
});
// End delete documentos conductores

// Get documentos conductores
app.get('/documentosConductor/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_DOCUMENTOS_CONDUCTOR`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentos = result.recordset;   
            return res.status(200).send({
                ok: true,
                documentos
            });
        }
    });  
});
// End Get documentos conductores

// Register documento cliente-conductor
app.post('/documentoCliente', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idDocumento},${body.idCliente},${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_OP_RELACION_DOCUMENTOS_CLIENTE_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentoCliente = result.recordset[0];  
            var idRelacionDocCliente =  documentoCliente.ID_RELACION_DOC_CLIENTE;
            if (!idRelacionDocCliente) {
                return res.status(400).send({
                    ok: false,
                    message: documentoCliente.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documentoCliente
            });
        }
    });  
});
// End Register documento cliente

// Get relacion documentos clientes conductor
app.get('/documentosCliente/:idCliente', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var idCliente = req.params.idCliente;     
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_RELACION_DOCUMENTOS_CLIENTE_CONDUCTOR ${idCliente}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentosCliente = result.recordset;   
            return res.status(200).send({
                ok: true,
                documentosCliente
            });
        }
    });  
});
// End Get documentos clientes conductor

// Delete documento cliente conductor
app.delete('/documentoCliente/:id/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var id = req.params.id;  
    var idUser = req.params.idUser; 
    var params = `${id},${idUser}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_OP_RELACION_DOCUMENTOS_CLIENTE_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentoCliente = result.recordset[0];  
            var idRelacionDocCliente =  documentoCliente.ID_RELACION_DOC_CLIENTE;
            if (!idRelacionDocCliente) {
                return res.status(400).send({
                    ok: false,
                    message: documento.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documentoCliente
            });
        }
    });  
});
// End delete documento cliente conductor

// Get relacion documentos conductor total
app.get('/documentosConductorTotal/:idCliente/:idConductor', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var idCliente = req.params.idCliente;  
    var idConductor = req.params.idConductor; 
    var params = `${idCliente},${idConductor}`;   
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_RELACION_DOCUMENTOS_CONDUCTOR_TOTAL ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentosConductor = result.recordset;   
            return res.status(200).send({
                ok: true,
                documentosConductor
            });
        }
    });  
});
// End Get relacion documentos conductor total

// Register relación documento conductor
app.post('/documentoConductorRelacion', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idConductor},${body.idDocumento},${body.idCliente},'${body.nroDocumento}','${body.fhEmision}','${body.fhVencimiento}',${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_OP_RELACION_DOCUMENTOS_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentoConductor = result.recordset[0];  
            var idRelacionDocConductor =  documentoConductor.ID_RELACION_DOC_COND;
            if (!idRelacionDocConductor) {
                return res.status(400).send({
                    ok: false,
                    message: documentoConductor.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documentoConductor
            });
        }
    });  
});
// End Register relación documento conductor

// Update relación documento conductor
app.put('/documentoConductorRelacion', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idRelacionDocConductor},'${body.nroDocumento}','${body.fhEmision}','${body.fhVencimiento}',${body.fgActivo},${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_UPDATE_OP_RELACION_DOCUMENTOS_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentoConductor = result.recordset[0];  
            var idRelacionDocConductor =  documentoConductor.ID_RELACION_DOC_COND;
            if (!idRelacionDocConductor) {
                return res.status(400).send({
                    ok: false,
                    message: documentoConductor.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documentoConductor
            });
        }
    });  
});
// End Update relación documento conductor

// Register documentos unidad
app.post('/documentoUnidad', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `'${body.nombreDocumento.toUpperCase()}',${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_OP_DOCUMENTOS_UNIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documento = result.recordset[0];  
            var idDocumento =  documento.ID_DOCUMENTO;

            if (!idDocumento) {
                return res.status(400).send({
                    ok: false,
                    message: documento.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documento
            });
        }
    });  
});
// End Get documentos unidad

// Get documentos unidades
app.get('/documentosUnidad/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_DOCUMENTOS_UNIDAD`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentos = result.recordset;   
            return res.status(200).send({
                ok: true,
                documentos
            });
        }
    });  
});
// End Get documentos unidades

// Update documentos unidad
app.put('/documentoUnidad', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idDocumento},'${body.nombreDocumento.toUpperCase()}',${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_UPDATE_OP_DOCUMENTOS_UNIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documento = result.recordset[0];
            var idDocumento =  documento.ID_DOCUMENTO;
            if (!idDocumento) {
                return res.status(400).send({
                    ok: false,
                    message: documento.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documento
            });
        }
    });  
});
// End Get documentos unidad

// Delete documentos unidad
app.delete('/documentoUnidad/:idDoc/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var idDoc = req.params.idDoc;  
    var idUser = req.params.idUser; 
    var params = `${idDoc},${idUser}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_OP_DOCUMENTOS_UNIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documento = result.recordset[0];  
            var idDocumento =  documento.ID_DOCUMENTO;
            if (!idDocumento) {
                return res.status(400).send({
                    ok: false,
                    message: documento.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documento
            });
        }
    });  
});
// End delete documentos unidad

// Register documento cliente-unidad
app.post('/documentoClienteUnidad', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idDocumento},${body.idCliente},${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_OP_RELACION_DOCUMENTOS_CLIENTE_UNIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentoClienteUnidad = result.recordset[0];  
            var idRelacionDocClienteUnidad =  documentoClienteUnidad.ID_RELACION_DOC_CLIENTE_UNIDAD;
            if (!idRelacionDocClienteUnidad) {
                return res.status(400).send({
                    ok: false,
                    message: documentoCliente.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documentoClienteUnidad
            });
        }
    });  
});
// End Register documento cliente unidad

// Get relacion documentos clientes unidad
app.get('/documentosClienteUnidad/:idCliente', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var idCliente = req.params.idCliente;     
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_RELACION_DOCUMENTOS_CLIENTE_UNIDAD ${idCliente}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentosClienteUnidad = result.recordset;   
            return res.status(200).send({
                ok: true,
                documentosClienteUnidad
            });
        }
    });  
});
// End Get documentos clientes unidad

// Delete documento cliente unidad
app.delete('/documentoClienteUnidad/:id/:idUser', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var id = req.params.id;  
    var idUser = req.params.idUser; 
    var params = `${id},${idUser}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_DELETE_OP_RELACION_DOCUMENTOS_CLIENTE_UNIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentoClienteUnidad = result.recordset[0];  
            var idRelacionDocClienteUnidad =  documentoClienteUnidad.ID_RELACION_DOC_CLIENTE_UNIDAD;
            if (!idRelacionDocClienteUnidad) {
                return res.status(400).send({
                    ok: false,
                    message: documento.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documentoClienteUnidad
            });
        }
    });  
});
// End delete documento cliente unidad

// Get relacion documentos unidad total
app.get('/documentosUnidadTotal/:idCliente/:idUnidad', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var idCliente = req.params.idCliente;  
    var idUnidad = req.params.idUnidad; 
    var params = `${idCliente},${idUnidad}`;   
    var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_RELACION_DOCUMENTOS_UNIDAD_TOTAL ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentosUnidad = result.recordset;   
            return res.status(200).send({
                ok: true,
                documentosUnidad
            });
        }
    });  
});
// End Get relacion documentos unidad total

// Register relación documento unidad
app.post('/documentoUnidadRelacion', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idUnidad},${body.idDocumento},${body.idCliente},'${body.nroDocumento}','${body.fhEmision}','${body.fhVencimiento}',${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_REGISTER_OP_RELACION_DOCUMENTOS_UNIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentosUnidad = result.recordset[0];  
            var idRelacionDocUnidad =  documentosUnidad.ID_RELACION_DOC_UNIDAD;
            if (!idRelacionDocUnidad) {
                return res.status(400).send({
                    ok: false,
                    message: documentosUnidad.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documentosUnidad
            });
        }
    });  
});
// End Register relación documento unidad

// Update relación documento unidad
app.put('/documentoUnidadRelacion', mdAuthenticattion.verificarToken, (req, res, next ) => {     
    var body = req.body;
    var params = `${body.idRelacionDocUnidad},'${body.nroDocumento}','${body.fhEmision}','${body.fhVencimiento}',${body.fgActivo},${body.idUsuario}`; 
    var lsql = `FE_SUPERVAN.DBO.SP_UPDATE_OP_RELACION_DOCUMENTOS_UNIDAD ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var documentoUnidad = result.recordset[0];  
            var idRelacionDocUnidad =  documentoUnidad.ID_RELACION_DOC_UNIDAD;
            if (!idRelacionDocUnidad) {
                return res.status(400).send({
                    ok: false,
                    message: documentoUnidad.MESSAGE
                });
            }
            return res.status(200).send({
                ok: true,
                documentoUnidad
            });
        }
    });  
});
// End Update relación documento unidad


// REGISTER
////////////////////////////////////////////////////////////////////////////////

module.exports = app;