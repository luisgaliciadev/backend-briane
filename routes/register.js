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
    console.log(params);
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
    console.log(idDistrito);
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

module.exports = app;
