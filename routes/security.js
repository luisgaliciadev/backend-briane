'use strict'

var express = require('express');
//var mongoosePaginate = require('mongoose-pagination');

// bcryptjs
var bcrypt = require('bcryptjs');

// jwt
var jwt = require('jsonwebtoken');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var http = require('http');
var path = require('path');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');


//////////////////////////////////////////////////////////////////////////////////////////////////
// Security

// Register Module
app.post('/module',  mdAuthenticattion.verificarToken, (req, res) => {
    var body = req.body;    
    var idModuloPrincipal = body.idModuloPrincipal;
    var idModuloSec = body.idModuloSec;
    var subMenu = body.subMenu;    
    var DS_MODULE = body.DS_MODULE;
    var URL = body.URL;
    var idTypeMenu = body.idTypeMenu;
    var ICON = body.ICON;
    if(!idModuloPrincipal && !idModuloSec){
        var ID_MODULE_SEC = 0;
    }

    if(idModuloPrincipal){
        var ID_MODULE_SEC = idModuloPrincipal;
    }

    if(idModuloSec){
        var ID_MODULE_SEC = idModuloSec;
    }

    if (!URL) {
        URL ='';
    }

    if (!subMenu) {
        subMenu = 0;
    }

    if (!ICON) {
        ICON = '';
    }   
    
    var params = `${ID_MODULE_SEC}, ${subMenu}, '${DS_MODULE}', '${URL}', ${idTypeMenu}, '${ICON}'`;
    var request = new mssql.Request();
    var lsql = `EXEC REGISTER_MODULE ${params}`;
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var moduloRegister = result.recordset;            
            return res.status(200).send({
                ok: true, 
                message: moduloRegister[0].MESSAGE,                  
                module: moduloRegister[0]                                   
            });  
        }
        
    });
});
// End Register Module

// Update Module
app.put('/module/:id',mdAuthenticattion.verificarToken,  mdAuthenticattion.verificarToken, (req, res) => {
    var id = req.params.id;
    var body = req.body;    
    var idModuloPrincipal = body.idModuloPrincipal;
    var idModuloSec = body.idModuloSec;
    var subMenu = body.subMenu;    
    var DS_MODULE = body.DS_MODULE;
    var URL = body.URL;
    var idTypeMenu = body.idTypeMenu;
    var ICON = body.ICON;

    if(!idModuloPrincipal && !idModuloSec){
        var ID_MODULE_SEC = 0;
    }

    if(idModuloPrincipal){
        var ID_MODULE_SEC = idModuloPrincipal;
    }

    if(idModuloSec){
        var ID_MODULE_SEC = idModuloSec;
    }

    if (!URL) {
        URL ='';
    }

    if (!subMenu) {
        subMenu = 0;
    }

    if (!ICON) {
        ICON = '';
    }   
    
    var params = `${id}, ${ID_MODULE_SEC}, ${subMenu}, '${DS_MODULE}', '${URL}', ${idTypeMenu}, '${ICON}'`;  
    var request = new mssql.Request();
    var lsql = `EXEC UPDATE_MODULE ${params}`;
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {            
            var moduloRegister = result.recordset;            
            return res.status(200).send({
                ok: true, 
                message: moduloRegister[0].MESSAGE,                  
                module: moduloRegister[0]                                   
            });
        }
    });
});
// End Update Module

// Gets Menu Type
app.get('/tmenu', (req, res, next ) => {
    var lsql = `EXEC GETS_TYPE_MENU`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {            
            var tmenu = result.recordset;            
            return res.status(200).send({                                          
                tmenu: tmenu                                   
            });
        }
    });
});
// End Gets Menu Type

// Gets Principal Modules
app.get('/pmodules', (req, res, next ) => {
    var lsql = `EXEC GETS_MODULES_PRINCIPAL`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var pmodules = result.recordset;            
            return res.status(200).send({                                          
                pmodules: pmodules                                   
            });
        }
    });
});
// End Gets Principal Modules

// Get Secundary Modules
app.get('/smodules', (req, res, next ) => {
    var lsql = `EXEC GETS_MODULES_SEC`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var smodules = result.recordset;
            return res.status(200).send({
                smodules: smodules
            });
        }
    });
});
// End Get Secundary Modules

// Gets All Modules
app.get('/modules/:id', (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`;
    var lsql = `EXEC GETS_ALL_MODULES ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var modules = result.recordset;
            return res.status(200).send({
                modules: modules
            });
        }
    });
});
// End Gets All Modules

// Get All Modules for Roles
app.get('/modulesroles/:id/:idRol', (req, res, next ) => {
    var id = req.params.id;
    var idRol = req.params.idRol;
    var params = `${id}, ${idRol}`;

    var lsql = `EXEC GETS_ALL_MODULES_ROLES ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var modules = result.recordset;
            return res.status(200).send({
                modules: modules
            });
        }
    });
});
// End Get All Modules for Roles

// Get Module
app.get('/module/:id', (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`;
    var lsql = `EXEC GET_MODULE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var module = result.recordset;
            return res.status(200).send({
                module: module
            });
        }
    });
});
// End Get Module

// Delete Module
app.delete('/module/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var id = req.params.id;
    var params = `${id}`;
    var lsql = `EXEC DELETE_MODULE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var moduleDeleted = result.recordset;
            return res.status(200).send({
                module: moduleDeleted
            });
        }
    });
});
// End Delete Module

// Move Module
app.put('/movemodule/:move', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var move = req.params.move;
    var body = req.body; 
    var idModule = body.ID_MODULE;
    var orden = body.ORDEN
    var idTypeMenu = body.ID_TYPE_MENU
    var params = `${idModule}, ${idTypeMenu}, ${orden}, ${move}`;
    console.log(params);
    var lsql = `EXEC MOVE_MODULE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {            
            var moduleUpdate = result.recordset;
            return res.status(200).send({
                module: moduleUpdate
            });
        }
    });
});
// End Move Module

// Get Roles
app.get('/roles', (req, res, next ) => {
    var lsql = `EXEC GET_ROLES`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var roles = result.recordset;
            return res.status(200).send({
                roles: roles
            });
        }
    });
});
// End Get Roles

// Get Roles Users
app.get('/rolesuser', (req, res, next ) => {
    var lsql = `EXEC GET_ROLES_USER`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var roles = result.recordset;
            return res.status(200).send({
                roles: roles
            });
        }
    });
});
// End Get Roles Users

// Register Role
app.post('/role', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var body = req.body; 
    var DS_ROLE = body.dsRoles.toUpperCase();
    var params = `'${DS_ROLE}'`;
    console.log(params);
    var lsql = `EXEC REGISTER_ROLE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var roleRegister = result.recordset;

            if (roleRegister[0].ID_ROLE ===0) {
                return res.status(400).send({
                    ok: true,
                    message: roleRegister[0].MESSAGE
                });
            } else {
                return res.status(200).send({
                    ok: true,
                    role: roleRegister[0]
                });
            }
        }
    });
});
// End Register Role

// Update Role
app.put('/role', mdAuthenticattion.verificarToken, (req, res, next ) => {  
    var body = req.body; 
    var ID_ROLE = body.ID_ROLE;
    var DS_ROLE = body.DS_ROLE.toUpperCase();
    var params = `${ID_ROLE}, '${DS_ROLE}'`;
    console.log(params);
    var lsql = `EXEC UPDATE_ROLE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {     
            var roleUpdate = result.recordset;
            if (roleUpdate.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Rol de usuario no registrado.'
                });
            } else {
                if (roleUpdate[0].ID_ROLE ===0) {
                    return res.status(400).send({
                        ok: true,                             
                        message: roleUpdate[0].MESSAGE
                    });
                } else {
                    return res.status(200).send({
                        ok: true,                             
                        role: roleUpdate[0]
                    });
                }
            }
        }
    });
});
// End Update Role

// Delete Role
app.delete('/role/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var ID_ROLE = req.params.id;
    var params = `${ID_ROLE}`;
    console.log(params);
    var lsql = `EXEC DELETE_ROLE ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var roleDeleted = result.recordset;
            if (roleDeleted.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Rol de usuario no registrado.'
                });
            } else {                
                return res.status(200).send({
                    ok: true,
                    role: roleDeleted[0]
                });
            }
        }
    });
});
// End Delete Role

// Update Role Modules
app.put('/rolesuser', mdAuthenticattion.verificarToken, (req, res, next ) => {
    var body = req.body; 
    var ID_MODULE = body.ID_MODULE;
    var ID_ROLE = body.ID_ROLE;
    var ACCESS = body.ACCESS;
    var params = `${ID_MODULE}, ${ID_ROLE}, '${ACCESS}'`;
    console.log(params);
    var lsql = `EXEC UPDATE_ROLES_MODULES ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var rolesModulesUpdate = result.recordset;
            if (rolesModulesUpdate.length === 0) {
                return res.status(400).send({
                    ok: true,
                    message: 'Rol-module de no existe.'
                });
            } else {
                return res.status(200).send({
                    ok: true,
                    rolesModules: rolesModulesUpdate[0]
                });
            }
        }
    });
});
// End Update Role Modules

// Security
//////////////////////////////////////////////////////////////////////////////////////////////////

module.exports = app;
