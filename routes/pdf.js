'use strict'

var express = require('express');

// jwt
var jwt = require('jsonwebtoken');

var excel = require('node-excel-export');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var http = require('http');
var path = require('path');

var fs = require('fs');
var pdf = require('html-pdf');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');


// ////////////////////////////////////////////////////////////////////////////////////////////////
// User

// // GET pdf
app.get('/', (req, res, next ) => {

    // var lsql = `EXEC GET_USERS 1`   
    // var request = new mssql.Request();

    // request.query(lsql, (err, result) => {
    //     if (err) { 
    //         return res.status(500).send({
    //             ok: false,
    //             message: 'Error en la petición.',
    //             error: err
    //         });
    //     } else {            
    //         var users = result.recordset; 
    //         var total = users.length     


    //         return res.status(200).send({
    //             ok: true,                             
    //             users: users
    //         });
    //     }
    // });

    
    var tabla  =`
            <td>luis</td>                                   
            <td>Galicia</td>
            <td>luisgalic@gmail.com</td>
    `;
    const content = `
    <html>
    <head>
      <meta charset="utf8">
      <title>Listado de Usuarios</title>
      <h2>Listado de Usuarios</h2>
    </head>
    <body>
      <div class="page">
        <div class="bottom">
          <div class="line">Marc Bachmann</div>
          <div class="line">cto</div>
  
          <div class="group">
            <div class="line">p: +41 00 000 00 00</div>
            <div class="line">github: marcbachmann</div>
          </div>
          <div class="group">
            <div class="line">suitart ag</div>
            <div class="line">räffelstrasse 25</div>
            <div class="line">8045 zürich</div>
          </div>
        </div>
      </div>
      <div class="page">
        <img class="logo" src="{{image}}">
        <div class="bottom">
            <div class="line center">8045 zürich</div>
        </div>
      </div>
    </body>
  </html>
`;

pdf.create(content).toFile('./uploads/pdf/html-pdf.pdf', function(err, resp) {
    if (err){
        console.log(err);
    } else {
        console.log(resp);
        return res.status(200).send({
            ok: true,
            resp: resp
        });
    }
});   
});
// // Fin pdf


// PETICIONES PARA USUARIOS
// ////////////////////////////////////////////////////////////////////////////////////////////////




module.exports = app;
