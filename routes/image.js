'use strict'

var express = require('express');
 
var app = express();

const path = require('path');
const fs = require('fs');

// Prueba de ruta de server backend
app.get('/:tipo/:image', (req, res, next ) => {
    var tipo = req.params.tipo;
    var image = req.params.image;
    var pathImage = path.resolve(__dirname, `../uploads/${tipo}/${image}`);
    if (fs.existsSync(pathImage)){
       res.sendFile(pathImage)
    } else {
        var pathNoImage = path.resolve(__dirname, '../assets/no-image.jpg');
        res.sendFile(pathNoImage);       
    }
});

module.exports = app;
