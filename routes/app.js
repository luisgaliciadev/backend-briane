'use strict'

var express = require('express');
var app = express();

// Prueba de ruta de server backend
app.get('/', (req, res, next ) => {

    res.status(200).send({
       ok: true,
       message: 'Petición al servidor realizada correctamente.'
    })

});

module.exports = app;
