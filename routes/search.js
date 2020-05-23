'use strict'

var express = require('express');
//var mongoosePaginate = require('mongoose-pagination');

// bcryptjs
var bcrypt = require('bcryptjs');

// jwt
var jwt = require('jsonwebtoken');

var excel = require('node-excel-export');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var http = require('http');
var path = require('path');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');


// var User = require('../models/user');

// // Prueba de ruta de user
// app.get('/', (req, res, next ) => {

//     res.status(200).send({
//        ok: true,
//        message: 'Get de usuarios.'
//     })
// });


// ////////////////////////////////////////////////////////////////////////////////////////////////
// PETICIONES PARA USUARIOS

// GET SEARCH USERS
app.get('/users/:search', (req, res, next ) => {

    var search = req.params.search;

    var params = `'${search}'`;  
    var lsql = `EXEC SEARCH_USERS ${search}`    

    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var users = result.recordset;
            return res.status(200).send({
                ok: true,
                users: users
            });  
            
        }
    });
});
// Fin de GET SEARCH USERS

// ////////////////////////////////////////////////////////////////////////////////////////////////
// PETICIONES PARA USUARIOS




module.exports = app;
