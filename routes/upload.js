'use strict'

var express = require('express');

var fileUpload = require('express-fileupload');
var fs = require('fs');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var http = require('http');
var path = require('path');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

app.use(fileUpload());

app.put('/:tipo/:id/:id_user', (req, res, next ) => {

    var tipo = req.params.tipo;
    var id = req.params.id;
    var id_user = req.params.id_user;

    var tiposValidos = ['user', 'company']

    if (tiposValidos.indexOf(tipo) < 0) {
        return res.status(400).send({
            ok: false,
            message: 'El tipo de colección no es valido.'
         });
    }

    if (!req.files) {
        res.status(400).send({
            ok: false,
            message: 'No se ha selecciono ningun un archivo.'
         });
    } else {
        // Get File Name
        var file = req.files.image;
        var fileName = file.name.split('.');
        var extFile = fileName[fileName.length - 1];
        
        var extValida = ['png', 'PNG', 'jpeg', 'JPEG', 'gif', 'GIF', 'jpg', 'JPG'];

        if (extValida.indexOf(extFile) < 0) {
            res.status(400).send({
                ok: false,
                message: 'Extensión de archivo no valida.'
            });
        } else {
            // File Name
            var fileName = `${id}-${new Date().getMilliseconds()}.${extFile}`;

            // Tempotal path
            var path = `./uploads/${tipo}/${fileName}`;
            file.mv(path, err => {
                if(err){
                    res.status(500).send({
                        ok: false,
                        message: 'Error al intentar guardar el archivo.',
                        error: err
                    });
                } else {
                    uploadFile(tipo, id, fileName, res, id_user);
                }
            });
        }
    }
});

function uploadFile(tipo, id, fileName, res, id_user){    
    if (tipo === 'user'){
        var params = `${id}`;
        var lsql = `EXEC GET_USER ${params}`;
        var request = new mssql.Request();
        request.query(lsql, (err, result) => {
            if (err) { 
                return res.status(500).send({
                    ok: false,
                    message: 'Error en la petición.',
                    error: err
                });
            } else {
                var user = result.recordset;
                var ID_USER = user[0].ID_USER;                
                if (ID_USER === 0) {
                    return  res.status(400).send({
                        ok: true, 
                        message: 'Usuario no registrado'
                    }); 
                } else {                   
                    var oldPath = './uploads/user/' + user[0].IMAGE;
                    // elimina la imagen anterior 
                    if(fs.existsSync(oldPath)){
                        if (user[0].IMAGE.length > 0) {
                            fs.unlinkSync(oldPath);
                        }
                    }
                    var params = `${id}, '${fileName}'`;
                    var lsql = `EXEC UPDATE_IMAGE_USER ${params}`;
                    var request = new mssql.Request();
                    request.query(lsql, (err, result) => {
                        if (err) { 
                            return res.status(500).send({
                                ok: false,
                                message: 'Error en la petición.',
                                error: err
                            });
                        } else {
                            var userUpdated = result.recordset;
                            if (userUpdated.length === 0) {
                                return res.status(400).send({
                                    ok: true,
                                    message: 'Usuario no registrado.'
                                });
                            } else {
                                return res.status(200).send({
                                    ok: true,
                                    message: userUpdated[0].MESSAGE,                             
                                    user: userUpdated[0]
                                });
                            }
                        }
                    });
                }
            }
        });
    }
    
    if (tipo === 'company'){
        var params = `${id}, ${id_user}`;
        var lsql = `EXEC GET_COMPANY_USER ${params}`;
        var request = new mssql.Request();
        request.query(lsql, (err, result) => {
            if (err) { 
                return res.status(500).send({
                    ok: false,
                    message: 'Error en la petición.',
                    error: err
                });
            } else {
                var company = result.recordset;
                var ID_COMPANY_USER = company[0].ID_COMPANY_USER;                
                if (ID_COMPANY_USER === 0) {
                    return  res.status(400).send({
                        ok: true, 
                        message: 'Empresa no registrada.'
                    }); 
                } else {                   
                    var oldPath = './uploads/company/' + company[0].IMAGE;
                    // elimina la imagen anterior
                    if (fs.existsSync(oldPath)) {
                        if (company[0].IMAGE.length > 0) {
                            fs.unlinkSync(oldPath);
                        }
                    }
                    var params = `${id}, '${fileName}'`;
                    var lsql = `EXEC UPDATE_IMAGE_COMPANY ${params}`;
                    var request = new mssql.Request();
                    request.query(lsql, (err, result) => {
                        if (err) { 
                            return res.status(500).send({
                                ok: false,
                                message: 'Error en la petición.',
                                error: err
                            });
                        } else {
                            var companyUpdated = result.recordset;
                            if (companyUpdated.length === 0) {
                                return res.status(400).send({
                                    ok: true,
                                    message: 'Usuario no registrado.'
                                });
                            } else {
                                return res.status(200).send({
                                    ok: true,
                                    message: companyUpdated[0].MESSAGE,                             
                                    user: companyUpdated[0]
                                });
                            }
                        }
                    });
                }
            }
        });
    }
}

module.exports = app;
