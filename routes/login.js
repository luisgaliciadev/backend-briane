'use strict'

var express = require('express');

// Configs
var SEED = require('../config/config').SEED;

// bcryptjs
var bcrypt = require('bcryptjs');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var http = require('http');
var path = require('path');

// jwt
var jwt = require('jsonwebtoken');

var app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');

const fs = require('fs');

//Google
var CLIENT_ID = require('../config/config').CLIENT_ID;
const { OAuth2Client } = require('google-auth-library');
const client = new OAuth2Client(CLIENT_ID);

// Renew Token
app.get('/renewtoken', mdAuthenticattion.verificarToken, (req, res) => {
    
    // esperar(myFunction, 5000);

    var token = jwt.sign({ user: req.user }, SEED, { expiresIn: 43200 }) // expira en 12 horas
    return res.status(200).send({
        ok: true,
        mensaje: 'New Token!!',
        token: token
    });
});

function esperar () {
    console.log('TIME 5 SEG');
}

// Google Authentication
async function verify(token) {
    const ticket = await client.verifyIdToken({
        idToken: token,
        audience: CLIENT_ID
    });
    const payload = ticket.getPayload();
    return {
        nombre: payload.name,
        email: payload.image,
        imagen: payload.picture,
        google: true,
        payload: payload
    }
}

app.post('/google', async(req, res) => {
    var token = req.body.token || '';
    var googleUser = await verify(token)
        .catch(e => {
            return res.status(403).send({
                ok: false,
                message: 'Token no Valido',
                token: token,
                error: e.message
            });
        });

    var email = googleUser.payload.email;
    var params = `'${email}'`;
    var request = new mssql.Request();
    var lsql = `SELECT ID_USER, NAME, EMAIL, PASSWORD, IMAGE, GOOGLE, PHONE, ID_ROLE FROM USERS WHERE EMAIL = ${params} AND FG_ACTIVE = 1`
    request.query(lsql, (err, result) => {
        if (err) {
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var userLogin = result.recordset;
            if (userLogin.length > 0) {
                if (userLogin[0].GOOGLE === false) {
                    return res.status(400).send({
                        ok: true,
                        message: 'Debe usar su autenticación normal.'
                    });
                } else {
                    var token = jwt.sign({ user: userLogin[0] }, SEED, { expiresIn: 43200 }); // expira en 12 horas

                    // Get Menu
                    var id_role = userLogin[0].ID_ROLE;
                    var params = `${id_role}`;
                    var lsql = `EXEC GETS_MODULES ${params}`;

                    var request = new mssql.Request();
                    request.query(lsql, (err, result) => {
                        if (err) {
                            var menu = [];
                            return menu;
                        } else {
                            var menu = result.recordset;
                            return res.status(200).send({
                                ok: true,
                                message: 'Login Correcto.',
                                id: userLogin[0].ID_USER,
                                user: userLogin[0],
                                token: token,
                                menu: menu
                            });
                        }
                    });
                }
            } else {

                // Register User
                var name = googleUser.payload.name;
                var email = googleUser.payload.email;
                var password = bcrypt.hashSync(':)', 10);;
                var image = googleUser.payload.picture;
                var google = true;
                var phone = ''
                var idRole = 2;
                var params = `'${name}', '${email}', '${password}', '${image}', '${google}', '${phone}', '${idRole}'`;
                var request = new mssql.Request();
                var lsql = `EXEC REGISTER_USER ${params}`
                request.query(lsql, (err, result) => {
                    if (err) {
                        return res.status(500).send({
                            ok: false,
                            message: 'Error en la petición.',
                            error: err
                        });
                    } else {
                        var userRegister = result.recordset;
                        var ID_USER = userRegister[0].ID_USER;

                        if (ID_USER === 0) {
                            return res.status(400).send({
                                ok: true,
                                message: userRegister[0].MESSAGE
                            });
                        } else {
                            var token = jwt.sign({ user: userRegister[0] }, SEED, { expiresIn: 43200 }); // expira en 12 horas

                            // Get Menu
                            var id_role = userRegister[0].ID_ROLE;
                            var params = `${id_role}`;
                            var lsql = `EXEC GETS_MODULES ${params}`;
                            var request = new mssql.Request();
                            request.query(lsql, (err, result) => {
                                if (err) {
                                    var menu = [];
                                    return menu;
                                } else {
                                    var menu = result.recordset;
                                    return res.status(200).send({
                                        ok: true,
                                        message: 'Login Correcto.',
                                        id: userRegister[0].ID_USER,
                                        user: userRegister[0],
                                        token: token,
                                        menu: menu
                                    });
                                }
                            });
                        }
                    }
                });
            }
        }
    });
});

// Login normal
app.post('/', (req, res) => {
    var body = req.body;
    var email = body.EMAIL;
    var password = body.PASSWORD;
    var params = `'${email}'`;
    var request = new mssql.Request();
    var lsql = `EXEC LOGIN ${params}`;
    request.query(lsql, (err, result) => {
        if (err) {
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var userLogin = result.recordset;
            var ID_USER = userLogin[0].ID_USER;
            var loginPassword = userLogin[0].PASSWORD;

            if (ID_USER === 0) {
                return res.status(400).send({
                    ok: true,
                    message: userLogin[0].MESSAGE
                });
            } else {
                if (!bcrypt.compareSync(password, loginPassword)) {
                    return res.status(404).send({
                        ok: true,
                        message: 'Password Incorrecto.',
                        error: err
                    });
                } else {
                    // Create token
                    userLogin[0].PASSWORD = null;
                    var token = jwt.sign({ user: userLogin }, SEED, { expiresIn: 43200 }); // expira en 12 horas

                    // Get Menu
                    var id_role = userLogin[0].ID_ROLE;
                    var params = `${id_role}`;
                    var lsql = `EXEC GETS_MODULES ${params}`;
                    var request = new mssql.Request();
                    request.query(lsql, async (err, result) => {
                        if (err) {
                            var menu = [];
                            return menu;
                        } else {
                            var menu = result.recordset;
                            
                            return res.status(200).send({
                                ok: true,
                                message: userLogin[0].MESSAGE,
                                id: userLogin[0].ID_USER,
                                user: userLogin[0],
                                token: token,
                                menu: menu
                            });
                        }
                    });
                }
            }
        }
    });
});

// Login normal conductor
app.post('/conductor', (req, res) => {
    var body = req.body;
    var dni = body.DNI;
    var password = body.PASSWORD;
    var params = `'${dni}', '${password}'`;
    var request = new mssql.Request();
    var lsql = `EXEC LOGIN_CONDUCTOR ${params}`;
    request.query(lsql, (err, result) => {
        if (err) {
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var userLogin = result.recordset;
            var ID_USER = userLogin[0].ID_USUARIO;

            if (ID_USER === 0) {
                return res.status(400).send({
                    ok: true,
                    message: userLogin[0].MESSAGE
                });
            } else {               
                // Create token
                var token = jwt.sign({ user: userLogin }, SEED, { expiresIn: 43200 }); // expira en 12 horas

                return res.status(200).send({
                    ok: true,
                    message: userLogin[0].MESSAGE,
                    conductor: {
                        id: userLogin[0].ID_USUARIO,
                        dni: userLogin[0].DNI
                    },                    
                    token: token
                });      
            }
        }
    });
});

module.exports = app;