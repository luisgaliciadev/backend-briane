'use strict'

var express = require('express');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');

//////////////////////////////////////////////////////////////////////////////////////////////////
// SUCURSALES

// Get Departamentos
app.get('/departamentos', (req, res, next ) => {
    var lsql = "EXEC GETS_DEPARTAMENTOS"
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var departamentos = result.recordset;            
            return res.status(200).send({
                departamentos: departamentos
            });
        }
    });
});
// End Get Departamentos

// Gets Provincias
app.get('/provincias/:id', (req, res, next ) => {
    var id = req.params.id;  
    var params = `${id}`;     
    var lsql = `EXEC GETS_PROVINCIAS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var provincias = result.recordset;
            return res.status(200).send({
                provincias: provincias
            });
        }
    });
});
// End Gets Provincias

// Gets Distritos
app.get('/distritos/:id', (req, res, next ) => {
    var id = req.params.id;  
    var params = `${id}`;     
    var lsql = `EXEC GETS_DISTRITOS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var distritos = result.recordset;
            return res.status(200).send({
                distritos: distritos
            });
        }
    });
});
// End Get Distritos

// Register Address
app.post('/', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;    
    var id_company_user = body.ID_COMPANY_USER;
    var ds_address_company = body.DS_ADDRESS_COMPANY;      
    var address = body.ADDRESS;    
    var id_distrito = body.ID_DISTRITO;
    var fg_principal = body.FG_PRINCIPAL;
    var params = `${id_company_user},'${ds_address_company}' , '${address}', ${id_distrito}, ${fg_principal}`;
    var request = new mssql.Request();
    var lsql = `EXEC REGISTER_ADDRESS_COMPANY ${params}`;
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
                    message: 'Empresa no registrada.'
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
// End Register Address

// Gets Address
app.get('/:id', (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`;
    var lsql = `EXEC GETS_ADDRESS_COMPANY ${params}`;
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
// End Gets Address

// Get Address
app.get('/:id/:idUser', (req, res, next ) => {
    var id = req.params.id;
    var idUser = req.params.idUser;   
    var params = `${id}, ${idUser}`;     
    var lsql = `EXEC GET_ADDRESS_COMPANY ${params}`;
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
// End Get Address

// Update Address
app.put('/update/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var id = req.params.id;
    var body = req.body;
    var ds_address_company = body.DS_ADDRESS_COMPANY;
    var address = body.ADDRESS;    
    var id_distrito = body.idDistrito;   
    var params = `${id}, '${ds_address_company}' , '${address}', ${id_distrito}`;
    var request = new mssql.Request();
    var lsql = `EXEC UPDATE_ADDRESS_COMPANY ${params}`;
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
// End Update Address

// Default Address
app.put('/defaultaddress/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {    
    var id = req.params.id;
    var params = `${id}`;  
    var request = new mssql.Request();
    var lsql = `EXEC DEFAULT_ADDRESS_COMPANY ${params}`;
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
app.delete('/:id',mdAuthenticattion.verificarToken, (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`;
    var lsql = `EXEC DELETE_ADDRESS_COMPANY ${params}`
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
            if (addressDeleted[0].ID_ADDRESS_COMPANY === 0) {
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

// END PETICIONES PARA SUCURSALES
//////////////////////////////////////////////////////////////////////////////////////////////////

module.exports = app;
