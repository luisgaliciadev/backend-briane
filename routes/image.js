'use strict'

var express = require('express');
 
var app = express();

const path = require('path');
const fs = require('fs');


app.get('/:tipo/:image', (req, res, next ) => {
    var tipo = req.params.tipo;
    var image = req.params.image;
    var arrayExt = image.split('.');
    var ext = arrayExt[1];
    var pathImage = path.resolve(__dirname, `../uploads/${tipo}/${image}`);
    if (fs.existsSync(pathImage)){         
        if (ext === 'pdf' || ext === 'PDF') {
            // console.log(ext);
            fs.readFile(pathImage , function (err,data){
                res.contentType("application/pdf");
                res.send(data);
            });
        }

        if (ext === 'apk') {
            fs.readFile(pathImage , function (err,data){
                // res.contentType("application/apk");
                // res.send(data);
                res.download(pathImage);
            });
        } 
        
        if (ext != 'apk' || ext != 'pdf' || ext != 'PDF') {            
            res.sendFile(pathImage)
        }

    } else {
        var pathNoImage = path.resolve(__dirname, '../assets/no-image.jpg');
        res.sendFile(pathNoImage);       
    }
});

module.exports = app;
