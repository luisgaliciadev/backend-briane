'use strict'

var jwt = require('jsonwebtoken');

// Configs
var SEED = require('../config/config').SEED;


// Verificar token
exports.verificarToken = function(req, res, next) {
    // var token = req.query.token;
    
    if(!req.headers.authorization){
        return res.status(403).send({
            message:'La peticion no tiene la cabecera de autenticacion'
        });
    }

    var token = req.headers.authorization;
    // console.log(token);

    jwt.verify(token, SEED, (err, decode) => {
        if (err) {
            return res.status(404).send({
                ok: false,
                message: 'Petición no Autorizada.',
                error: err
            });
        } 
            
        req.user = decode.user;
        next();
    });
}

// Verificar Rol de Usuario 
exports.verificarRoleUser = function(req, res, next) {
    

    var user = req.user;

    if (user.role === 'ADMIN_ROLE') {
        next();
        return;
    } else {
        return res.status(404).send({
            ok: false,
            message: 'Petición no Autorizada.',
            error: {message: 'Peticion no Autorizada. No es usuario administrador.'}
        });
    }
}

// Verificar Usuario 
exports.verificarUser = function(req, res, next) {
    

    var user = req.user;
    var id = req.params.id;

    if (user.role === 'ADMIN_ROLE' || user._id === id) {
        next();
        return;
    } else {
        return res.status(404).send({
            ok: false,
            message: 'Petición no Autorizada.',
            error: {message: 'Peticion no Autorizada. No es usuario administrador.'}
        });
    }
}


    


