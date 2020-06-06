'use strict'

var express = require('express');

// bcryptjs
var bcrypt = require('bcryptjs');

// jwt
var jwt = require('jsonwebtoken');

var excel = require('node-excel-export');

var mygeotab = require('mg-api-node');

// mssql
var mssql = require('mssql');
var bodyParser = require('body-parser');
var http = require('http');
var path = require('path');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');

// ////////////////////////////////////////////////////////////////////////////////////////////////
// Users

// Get divice
app.get('/divices', (req, res) => {

    var api = new mygeotab('luis.galicia@supervan.pe', 'Lgbriane2020', 'supervan_peru');
    
    api.authenticate(function(err, result) {
        if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        }
      
        api.call('Get', {
          typeName: 'Device',
          resultsLimit: 150
        }, function(err, devices) {
          if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
          }
            return res.status(200).send({
                ok: true,
                devices
            });
        });
    });
});
// End get divice

// Get status divice info
app.get('/statusdiviceinfo', (req, res) => {

    var api = new mygeotab('luis.galicia@supervan.pe', 'Lgbriane2020', 'supervan_peru');
    
    api.authenticate(function(err, result) {
        if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        }
      
        api.call('Get', {
          typeName: 'DeviceStatusInfo',
          resultsLimit: 150
        }, function(err, DeviceStatusInfo) {
          if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
          }
            return res.status(200).send({
                ok: true,
                DeviceStatusInfo
            });
        });
    });
});
// End Get status divice info

// Get status divices
app.get('/statusdivices', (req, res) => {

    var api = new mygeotab('luis.galicia@supervan.pe', 'Lgbriane2020', 'supervan_peru');
    
    api.authenticate(function(err, result) {
        if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        }
        var results = [];
        api.call('Get', {
            typeName: 'DeviceStatusInfo',
            resultsLimit: 150
          }, function(err, statusInfo) {
                if(err){
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                }
                var infoStatus = statusInfo
                var coordinates = [];
                // console.log(statusInfo);
                infoStatus.forEach(function (infoStatus) {
                    coordinates.push({
                        x: infoStatus.longitude,
                        y: infoStatus.latitude
                    });
                });
                
                api.call("GetAddresses", {
                    coordinates: coordinates
                }, function (err, addressResults) {
                    // console.log('infoStatus:', infoStatus);
                    var i;
                    for (i = 0; i < infoStatus.length; i++) {
                        results.push({
                            device: infoStatus[i].device,
                            isDriving: infoStatus[i].isDriving,
                            address: addressResults[i]
                        });
                    }
                    console.log(results);
                    return res.status(200).send({
                        ok: true,
                        statusDevices: results
                    });
                });
            
          });
    }); // fin autenticacion
});
// End status divices

// Get odometer
app.get('/odometer', (req, res) => {

    var api = new mygeotab('luis.galicia@supervan.pe', 'Lgbriane2020', 'supervan_peru');
    
    api.authenticate(function(err, result) {
        if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        }


        var group = {
            id: "GroupCompanyId" // Populated with the desired group id.
        },
        results = [];    
        api.call("Get", {
            typeName : "Device",
            search : {
                "groups" : [group]
            },
            resultsLimit: 10
        }, function (err, devices) {
                if(err){
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                }

                var now = new Date().toISOString(),
                calls = [],
                diagnostic = {
                    id: "DiagnosticOdometerAdjustmentId"
                };
                               
                devices.forEach(function (device) {
                    results.push({
                        name : device.name,
                        vehicleIdentificationNumber : device.vehicleIdentificationNumber
                    });
                calls.push({
                    method : "Get",
                    params : {
                        typeName : "StatusData",
                        search : {
                            fromDate : now,
                            toDate : now,
                            diagnosticSearch : diagnostic,
                            deviceSearch : device
                        }
                    }
                });
            });
            api.call("ExecuteMultiCall", {
                calls : calls
            }, function (err, callResults) {
                if(err){
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                }
                var statusData, i;
                for (i = 0; i < callResults.length; i++) {
                    statusData = callResults[i][0];
                    if (statusData) {
                        results[i].odometer = statusData.data;
                    }
                }
                // console.log(results);               
                return res.status(200).send({
                    ok: true,
                    results
                });
               
            });
        });       
    }); // Fin autenticacion
});
// End Get fuel usage divice



module.exports = app;
