'use strict'

// Requires
var express = require('express');
var cors = require('cors')
var bodyParser = require('body-parser');

// mssql
var mssql = require('mssql');
var http = require('http');
var path = require('path');

var app = express();

// Body Parser
// parse application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

// CORS
app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", '*');
    res.header('Access-Control-Allow-Headers', 'Authorization, X-API-KEY, Origin, X-Requested-With, Content-Type, Accept, Access-Control-Allow-Request-Method');
    res.header("Access-Control-Allow-Methods", "POST, GET, PUT, DELETE, OPTIONS ");
    res.header('Allow', 'GET, POST, OPTIONS, PUT, DELETE');
    res.header('Content-Type', 'text/plain');
    next();
});

// Import Routes
var appRoutes = require('./routes/app');
var userRoutes = require('./routes/user');
var loginRoutes = require('./routes/login');
var uploadhRoutes = require('./routes/upload');
var imageRoutes = require('./routes/image');
var addressRoutes = require('./routes/address');
var securityRoutes = require('./routes/security');
var sunatRoutes = require('./routes/sunat');
var excelRoutes = require('./routes/excel');
var pdfRoutes = require('./routes/pdf');
var searchRoutes = require('./routes/search');
var registerRoutes = require('./routes/register');
var conductorRoutes = require('./routes/conductor');
var mygeotabRoutes = require('./routes/mygeotab');
var operaciones = require('./routes/operaciones');

// Connetion BD MSSQL SERVER
app.set('view engine', 'ejs');

// Config BD
var config = {
    user: 'sa',
    // driver='tedious',
    password: 'Cybersac1',
    server: '190.117.103.41',
    //port:
    database: 'BRIANE_APP',
    connectionTimeout: 900000,
    requestTimeout: 900000,
    pool: {
        idleTimeoutMillis: 900000,
        max: 100
    }
};

// var configServal = {
//     user: 'sa',
//     // driver='tedious',
//     password: 'Cybersac1',
//     server: '190.117.103.41',
//     //port:
//     database: 'FE_SUPERVAN',
//     connectionTimeout: 300000,
//     requestTimeout: 300000,
//     pool: {
//         idleTimeoutMillis: 300000,
//         max: 100
//     }
// };

// Test connection
var connection = mssql.connect(config, function(err, res) {
    if (err) {
        throw err;
    } else {
        console.log('Base de datos: ' + config.database + '\x1b[32m%s\x1b[0m', ' Online');
        // Escuchar peticiones
        app.listen(3000, () => {
            console.log('Express Server Puerto: 3000: \x1b[32m%s\x1b[0m', 'Online');
        });
    }
});

// var connectionServal = mssql.connect(configServal, function(err, res) {
//     if (err) {
//         throw err;
//     } else {
//         console.log('Base de datos: ' + configServal.database + '\x1b[32m%s\x1b[0m', ' Online');
//     }
// });

// Routes
app.use('/api/user', userRoutes);
app.use('/api/login', loginRoutes);
app.use('/api/upload', uploadhRoutes);
app.use('/api/image', imageRoutes);
app.use('/api/address', addressRoutes);
app.use('/api/security', securityRoutes);
app.use('/api/sunat', sunatRoutes);
app.use('/api/excel', excelRoutes);
app.use('/api/pdf', pdfRoutes);
app.use('/api/search', searchRoutes);
app.use('/api/register', registerRoutes);
app.use('/api/conductor', conductorRoutes);
app.use('/api/mygeotab', mygeotabRoutes);
app.use('/api/operaciones', operaciones);

app.use('/api', appRoutes);