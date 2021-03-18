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
    var tiposValidos = ['user', 'company','denuncia','viaticos-conductor','documentos-conductor','documentos-unidad','facturas-peaje']

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
        var nombreArchivo = fileName[0];
       
        if (tipo === 'user' || tipo === 'company') {
            var extValida = ['png', 'PNG', 'jpeg', 'JPEG', 'gif', 'GIF', 'jpg', 'JPG'];
        }

        if (tipo === 'denuncia') {
            var extValida = ['png','PNG','jpeg','JPEG','jpg','JPG','pdf','txt','zip','rar','docx','xlsx', 'pptx']; 
        }

        if (tipo === 'viaticos-conductor') {
            var extValida = ['pdf']; 
        }

        if (tipo === 'documentos-conductor') {
            var extValida = ['png','PNG','jpeg','JPEG','jpg','JPG','pdf','txt','docx','xlsx', 'pptx']; 
        }

        if (tipo === 'documentos-unidad') {
            var extValida = ['png','PNG','jpeg','JPEG','jpg','JPG','pdf','txt','docx','xlsx', 'pptx']; 
        }

        if (tipo === 'facturas-peaje') {
            var extValida = ['png','PNG','jpeg','JPEG','jpg','JPG','pdf']; 
        }

        if (extValida.indexOf(extFile) < 0) {
            res.status(400).send({
                ok: false,
                message: 'Extensión de archivo no valida.' + 'extFile: ' + extFile
            });
        } else {
            // File Name
            var fileName = `${id}-${new Date().getMilliseconds()}.${extFile}`;

            if (tipo === 'documentos-conductor') {
                var fileName = `${id_user}-${id}-${nombreArchivo}-${new Date().getMilliseconds()}.${extFile}`;
            }

            if (tipo === 'documentos-unidad') {
                var fileName = `${id_user}-${id}-${nombreArchivo}-${new Date().getMilliseconds()}.${extFile}`;
            }

            if (tipo === 'facturas-peaje') {
                var fileName = `${nombreArchivo}.${extFile}`;
            }

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

    if (tipo === 'denuncia'){      
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
                var ID_DENUNCIA = denuncia[0].ID_DENUNCIA;                
                if (ID_DENUNCIA === 0) {
                    return  res.status(400).send({
                        ok: true, 
                        message: 'Denuncia no registrada.'
                    }); 
                } else { 
                                      
                    if (id_user === 1) {
                        var oldPath = './uploads/denuncia/' + denuncia[0].ARCHIVO1;
                    } 
                    
                    if (id_user === 2) {
                        var oldPath = './uploads/denuncia/' + denuncia[0].ARCHIVO2;
                    }
                    
                    if (id_user === 3) {
                        var oldPath = './uploads/denuncia/' + denuncia[0].ARCHIVO3;
                    }
                   
                    // elimina la imagen anterior
                    if (fs.existsSync(oldPath)) {
                        // if (company[0].IMAGE.length > 0) {
                            fs.unlinkSync(oldPath);
                        // }
                    }
                    var params = `${id}, '${fileName}', '${id_user}'`;
                    var lsql = `EXEC UPDATE_ARCHIVO_DENUNCIA ${params}`;
                    var request = new mssql.Request();
                    request.query(lsql, (err, result) => {
                        if (err) { 
                            return res.status(500).send({
                                ok: false,
                                message: 'Error en la petición.',
                                error: err
                            });
                        } else {
                            var denunciaUpdated = result.recordset;
                            if (denunciaUpdated.length === 0) {
                                return res.status(400).send({
                                    ok: true,
                                    message: 'Denuncia no registrado.'
                                });
                            } else {
                                return res.status(200).send({
                                    ok: true,
                                    message: denunciaUpdated[0].MESSAGE,                             
                                    denuncia: denunciaUpdated[0]
                                });
                            }
                        }
                    });
                }
            }
        });
    }

    if (tipo === 'documentos-conductor'){      
        var params = `${id}`;
        var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_RELACION_DOCUMENTOS_CONDUCTOR ${params}`;
        var request = new mssql.Request();
        request.query(lsql, (err, result) => {
            if (err) { 
                return res.status(500).send({
                    ok: false,
                    message: 'Error en la petición.',
                    error: err
                });
            } else {
                var relacionDocConductor = result.recordset;
                var idRelacion = relacionDocConductor[0].ID_RELACION_DOC_COND;                
                if (idRelacion === 0) {
                    return  res.status(400).send({
                        ok: true, 
                        message: 'Registro no encontrado.'
                    }); 
                } else {                                       
                    var oldPath = './uploads/documentos-conductor/' + relacionDocConductor[0].NB_ARCHIVO;
                    // elimina archivo anterior
                    // if (fs.existsSync(oldPath)) {
                    //     // if (company[0].IMAGE.length > 0) {
                    //         fs.unlinkSync(oldPath);
                    //     // }
                    // }
                    var params = `${id}, '${fileName}', '${id_user}'`;
                    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_ARCHIVO_RELACION_DOCUMENTOS_CONDUCTOR ${params}`;
                    var request = new mssql.Request();
                    request.query(lsql, (err, result) => {
                        if (err) { 
                            return res.status(500).send({
                                ok: false,
                                message: 'Error en la petición.',
                                error: err
                            });
                        } else {
                            var relacionDocConductor = result.recordset;
                            if (relacionDocConductor.length === 0) {
                                return res.status(400).send({
                                    ok: true,
                                    message: 'No existe el registro.'
                                });
                            } else {
                                var params = `${id}, '${fileName}'`;
                                var lsql = `EXEC FE_SUPERVAN.DBO.SP_REGISTER_OP_DETA_RELACION_DOCUMENTOS_CONDUCTOR ${params}`;
                                var request = new mssql.Request();
                                request.query(lsql, (err, result) => {
                                    if (err) { 
                                        return res.status(500).send({
                                            ok: false,
                                            message: 'Error en la petición.',
                                            error: err
                                        });
                                    } else {
                                        var detaRelacionDocConductor = result.recordset;
                                        if (detaRelacionDocConductor.length === 0) {
                                            return res.status(400).send({
                                                ok: true,
                                                message: 'No actualizo el registro documento.'
                                            });
                                        }
                                        return res.status(200).send({
                                            ok: true,                  
                                            relacionDocConductor,
                                            detaRelacionDocConductor
                                        });
                                    }
                                });
                            }
                        }
                    });
                }
            }
        });
    }

    if (tipo === 'documentos-unidad'){    
        var params = `${id}`;
        var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_RELACION_DOCUMENTOS_UNIDAD ${params}`;
        var request = new mssql.Request();        
        request.query(lsql, (err, result) => {
            if (err) { 
                return res.status(500).send({
                    ok: false,
                    message: 'Error en la petición.',
                    error: err
                });
            } else {
                var relacionDocUnidad = result.recordset;
                var idRelacion = relacionDocUnidad[0].ID_RELACION_DOC_UNIDAD;                
                if (idRelacion === 0) {
                    return  res.status(400).send({
                        ok: true, 
                        message: 'Registro no encontrado.'
                    }); 
                } else {                                       
                    var oldPath = './uploads/documentos-unidad/' + relacionDocUnidad[0].NB_ARCHIVO;
                    // elimina archivo anterior
                    // if (fs.existsSync(oldPath)) {
                    //     // if (company[0].IMAGE.length > 0) {
                    //         fs.unlinkSync(oldPath);
                    //     // }
                    // }
                    var params = `${id}, '${fileName}', '${id_user}'`;
                    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_ARCHIVO_RELACION_DOCUMENTOS_UNIDAD ${params}`;
                    var request = new mssql.Request();
                    request.query(lsql, (err, result) => {
                        if (err) { 
                            return res.status(500).send({
                                ok: false,
                                message: 'Error en la petición.',
                                error: err
                            });
                        } else {
                            var relacionDocUnidad = result.recordset;
                            if (relacionDocUnidad.length === 0) {
                                return res.status(400).send({
                                    ok: true,
                                    message: 'No existe el registro.'
                                });
                            } else {
                                var params = `${id}, '${fileName}'`;
                                var lsql = `EXEC FE_SUPERVAN.DBO.SP_REGISTER_OP_DETA_RELACION_DOCUMENTOS_UNIDAD ${params}`;
                                var request = new mssql.Request();
                                request.query(lsql, (err, result) => {
                                    if (err) { 
                                        return res.status(500).send({
                                            ok: false,
                                            message: 'Error en la petición.',
                                            error: err
                                        });
                                    } else {
                                        var detaRelacionDocUnidad = result.recordset;
                                        if (detaRelacionDocUnidad.length === 0) {
                                            return res.status(400).send({
                                                ok: true,
                                                message: 'No actualizo el registro documento.'
                                            });
                                        }
                                        return res.status(200).send({
                                            ok: true,                                                                     
                                            relacionDocUnidad,
                                            detaRelacionDocUnidad
                                        });
                                    }
                                });                         
                            }
                        }
                    });
                }
            }
        });
    }

    if (tipo === 'facturas-peaje'){    
        var params = `${id}`;
        var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_RELACION_PEAJE_FACTURA ${params}`;
        var request = new mssql.Request();
        request.query(lsql, (err, result) => {
            if (err) { 
                return res.status(500).send({
                    ok: false,
                    message: 'Error en la petición.',
                    error: err
                });
            } else {
                var relacionPeajeFactura = result.recordset[0];
                var idRelacion = relacionPeajeFactura.ID_RELACION_PEAJES;                
                if (idRelacion === 0) {
                    return  res.status(400).send({
                        ok: true, 
                        message: 'Registro no encontrado.'
                    }); 
                } else {                                       
                    var oldPath = './uploads/facturas-peaje/' + relacionPeajeFactura.NB_ARCHIVO;
                    // elimina archivo anterior
                    if (fs.existsSync(oldPath)) {
                        // if (company[0].IMAGE.length > 0) {
                            fs.unlinkSync(oldPath);
                        // }
                    }
                    var params = `${id}, '${fileName}', ${id_user}`;
                    var lsql = `EXEC FE_SUPERVAN.DBO.SP_UPDATE_ARCHIVO_RELACION_PEAJE_FACTURAS ${params}`;
                    var request = new mssql.Request();
                    request.query(lsql, (err, result) => {
                        if (err) { 
                            return res.status(500).send({
                                ok: false,
                                message: 'Error en la petición.',
                                error: err
                            });
                        } else {
                            var relacionPeajeFacturas = result.recordset;
                            if (relacionPeajeFacturas.length === 0) {
                                return res.status(400).send({
                                    ok: true,
                                    message: 'No existe el registro.'
                                });
                            } else {
                                return res.status(200).send({
                                    ok: true,
                                    // message: denunciaUpdated[0].MESSAGE,                             
                                    relacionPeajeFacturas
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
