'use strict'

var express = require('express');

var mygeotab = require('mg-api-node');

// mssql
//var mssql = require('mssql');
var bodyParser = require('body-parser');
//var http = require('http');
//var path = require('path');

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

//var mdAuthenticattion = require('../middlewares/authenticated');

///////////////////////////////////////////////////////////////////////////////////////////////////
// Funciones

function sortJSON(data, key, orden) {
    return data.sort(function (a, b) {
        var x = parseFloat(a[key]),
        y = parseFloat(b[key]);
        // console.log('x:', typeof(x))

        if (orden === 'asc') {
            return ((x < y) ? -1 : ((x > y) ? 1 : 0));
        }

        if (orden === 'desc') {
            return ((x > y) ? -1 : ((x < y) ? 1 : 0));
        }
    });
}

function sumarDias(fecha, dias){
    fecha.setDate(fecha.getDate() + dias);
   (fecha.getDate() + dias);
   return fecha;
}

// Funciones
///////////////////////////////////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////////////////////////////////////
// Mygeotab

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
          let results = [];
          DeviceStatusInfo.forEach(function (DeviceStatusInfos) {
            results.push({
                bearing: DeviceStatusInfos.DeviceStatusInfo,
                currentStateDuration: DeviceStatusInfos.currentStateDuration,
                isDeviceCommunicating: DeviceStatusInfos.isDeviceCommunicating,
                isDriving : DeviceStatusInfos.isDriving,
                latitude : DeviceStatusInfos.latitude,
                longitude : DeviceStatusInfos.longitude,
                speed : DeviceStatusInfos.speed,
                dateTime : DeviceStatusInfos.dateTime,
                id : DeviceStatusInfos.device.id,
                idDriver: DeviceStatusInfos.driver.id
                });
            });

            return res.status(200).send({
                ok: true,
                DeviceStatusInfo,
                results
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
                            address: addressResults[i],
                            locationAddress: addressResults[i].formattedAddress,
                            id: infoStatus[i].device.id
                        });
                    }
                    // console.log(results);
                    return res.status(200).send({
                        ok: true,
                        statusDevices: results,
                        infoStatus
                    });
                });
            
          });
    }); // fin autenticacion
});
// End status divices

// Get total odometer
app.get('/totalodometer', (req, res) => {

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
            resultsLimit: 150
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
                        id: device.id,
                        name: device.name,
                        licensePlate: device.licensePlate,
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
                        results[i].odometer = parseFloat(statusData.data / 1000).toFixed(2);
                        results[i].dateTime = statusData.dateTime;
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
// End Get total odometer

// Get odometer
app.get('/odometer/:desde/:hasta', (req, res) => {

    var desde = req.params.desde;
    var hasta = req.params.hasta;    
    var d = new Date(desde);  
    desde = sumarDias(d, -1).toISOString();    
    desde = desde.substring(0, 10);
    desde = desde + ' 19:00';
    hasta = hasta + ' 18:59';

    var api = new mygeotab('luis.galicia@supervan.pe', 'Lgbriane2020', 'supervan_peru');
    
    api.authenticate(function(err, result) {
        if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        }

        api.call("Get", {
            "typeName": "Device",
            "resultsLimit": 150
        } // Fin get
        , function(err, devices) {
            var fromDate = desde,
            toDate = hasta,
            results = [],
            calls = [],
            diagnostic = {
                id: "DiagnosticOdometerAdjustmentId"
            };
            
            devices.forEach(function (device) {
                // console.log(divice);                
                results.push({
                    id: device.id,
                    name: device.name,
                    licensePlate: device.licensePlate,
                    vehicleIdentificationNumber : device.vehicleIdentificationNumber                                
                });
                
                calls.push({
                    method : "Get",
                    params : {
                        typeName : "StatusData",
                        search : {
                            fromDate : fromDate,
                            toDate : toDate,
                            diagnosticSearch : diagnostic,
                            deviceSearch : device
                        }
                    }
                });
             }); // fin for each
             
             api.call("ExecuteMultiCall", {
                        calls : calls
            },
            
            function (err, callResults) {
                if(err){
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                }
                
                var statusData, i;
                for (i = 0; i < callResults.length; i++) {
                    statusData = callResults[i];
                    if (statusData.length > 0) {        
                        var odometerTotal = statusData[statusData.length - 1].data;
                        var odometer = statusData[statusData.length - 1].data - statusData[0].data;
                        var dateTimeLats = statusData[statusData.length - 1].dateTime
                        results[i].odometerTotal = parseFloat(odometerTotal / 1000).toFixed(2);
                        results[i].odometer = parseFloat(odometer / 1000).toFixed(2);
                        // results[i].dateTimeLats = dateTimeLats;
                    }
                }

                // console.log('results:', results);

             
                // console.log(ordenarAsc(results, 'odometer'));
                sortJSON(results, 'odometer', 'desc')

                return res.status(200).send({
                    ok: true,
                    results
                });
            });
        } // Fin divices
        , function(e) {
            console.error("Failed:", e);
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: e
            });
        }); // Fin error principal // Fin llamada
    }); // Fin autenticacion
});
// End Get odometer

// Get total consume fuel
app.get('/totalfuelconsume', (req, res) => {

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
            resultsLimit: 150
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
                    id: "DiagnosticDeviceTotalFuelId"
                };
                               
                devices.forEach(function (device) {
                    results.push({
                        id: device.id,
                        name: device.name,
                        licensePlate: device.licensePlate,
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
                        results[i].consumeFuel = parseFloat(statusData.data / 3.785).toFixed(2);
                        results[i].dateTime = statusData.dateTime;
                    }
                }             
                return res.status(200).send({
                    ok: true,
                    results
                });               
            });
        });       
    }); // Fin autenticacion
});
// End Get total consume fuel

// Get  consume fuel
app.get('/fuelconsume/:desde/:hasta', (req, res) => {

    var desde = req.params.desde;
    var hasta = req.params.hasta;    
    var d = new Date(desde);  
    desde = sumarDias(d, -1).toISOString();    
    desde = desde.substring(0, 10);
    desde = desde + ' 19:00';
    hasta = hasta + ' 18:59';

    var api = new mygeotab('luis.galicia@supervan.pe', 'Lgbriane2020', 'supervan_peru');
    
    api.authenticate(function(err, result) {
        if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        }

        api.call("Get", {
            "typeName": "Device",
            "resultsLimit": 150
        } // Fin get
        , function(err, devices) {
            var now = new Date().toISOString(),
            results = [],
            calls = [],
            diagnostic = {
                id: "DiagnosticDeviceTotalFuelId"
            };
            
            devices.forEach(function (device) {             
                results.push({
                    id: device.id,
                    name: device.name,
                    licensePlate: device.licensePlate,
                    vehicleIdentificationNumber : device.vehicleIdentificationNumber
                });
                
                calls.push({
                    method : "Get",
                    params : {
                        typeName : "StatusData",
                        search : {
                            fromDate : desde,
                            toDate : hasta,
                            diagnosticSearch : diagnostic,
                            deviceSearch : device
                        }
                    }
                });
             }); // fin for each
             
             api.call("ExecuteMultiCall", {
                        calls : calls
            },
            
            function (err, callResults) {
                if(err){
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                }
                
                var statusData, i;                
                for (i = 0; i < callResults.length; i++) {
                    statusData = callResults[i];                   
                    if (statusData.length > 0) {        
                        var fuelUsedTotal = statusData[statusData.length - 1].data;
                        var fuelUsed = statusData[statusData.length - 1].data - statusData[0].data;                                                                  
                        var dateTimeLats = statusData[statusData.length - 1].dateTime
                        results[i].fuelUsedTotal = parseFloat(fuelUsedTotal / 3.785).toFixed(2);
                        results[i].fuelUsed = parseFloat(fuelUsed / 3.785).toFixed(2);                       
                    } else {
                        results[i].fuelUsedTotal = 0;
                        results[i].fuelUsed = 0;
                    }
                }   
                
                sortJSON(results, 'fuelUsed', 'desc')

                return res.status(200).send({
                    ok: true,
                    results
                    // callResults
                });
            });
        } // Fin divices
        , function(e) {
            console.error("Failed:", e);
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: e
            });
        }); // Fin error principal // Fin llamada
    }); // Fin autenticacion
});
// End Get consume fuel

// Get total hours engine
app.get('/totalhoursengine', (req, res) => {

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
            resultsLimit: 150
           
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
                    id: "DiagnosticEngineHoursAdjustmentId"
                };
                // console.log(devices);
                devices.forEach(function (device) {
                    results.push({
                        id: device.id,
                        name: device.name,
                        licensePlate: device.licensePlate,
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
                        results[i].hoursEngine = Math.round(statusData.data / 3600);
                        results[i].dateTime = statusData.dateTime;
                    }
                }             
                return res.status(200).send({
                    ok: true,
                    results
                });
               
            });
        });       
    }); // Fin autenticacion
});
// End Get total hours engine

// Get hours engine
app.get('/hoursengine/:desde/:hasta', (req, res) => {

    var desde = req.params.desde;
    var hasta = req.params.hasta;    
    var d = new Date(desde);  
    desde = sumarDias(d, -1).toISOString();    
    desde = desde.substring(0, 10);
    desde = desde + ' 19:00';
    hasta = hasta + ' 18:59';

    var api = new mygeotab('luis.galicia@supervan.pe', 'Lgbriane2020', 'supervan_peru');
    
    api.authenticate(function(err, result) {
        if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        }

        api.call("Get", {
            "typeName": "Device",
            "resultsLimit": 150
        } // Fin get
        , function(err, devices) {
            var now = new Date().toISOString(),
            results = [],
            calls = [],
            diagnostic = {
                id: "DiagnosticEngineHoursAdjustmentId"
            };
            
            devices.forEach(function (device) {
                // console.log(divice);
                
                results.push({
                    id: device.id,
                    name: device.name,
                    licensePlate: device.licensePlate,
                    vehicleIdentificationNumber : device.vehicleIdentificationNumber
                });
                
                calls.push({
                    method : "Get",
                    params : {
                        typeName : "StatusData",
                        search : {
                            fromDate : desde,
                            toDate : hasta,
                            diagnosticSearch : diagnostic,
                            deviceSearch : device
                        }
                    }
                });
             }); // fin for each
             
             api.call("ExecuteMultiCall", {
                        calls : calls
            },
            
            function (err, callResults) {
                if(err){
                    return res.status(500).send({
                        ok: false,
                        message: 'Error en la petición.',
                        error: err
                    });
                }
                
                var statusData, i;
                for (i = 0; i < callResults.length; i++) {
                    statusData = callResults[i];
                    if (statusData.length > 0) {        
                        var engineHoursTotal = statusData[statusData.length - 1].data;
                        var engineHours = statusData[statusData.length - 1].data - statusData[0].data;                       
                        var dateTimeLats = statusData[statusData.length - 1].dateTime
                        results[i].engineHoursTotal = Math.round(engineHoursTotal / 3600);
                        results[i].engineHours = Math.round(engineHours / 3600);                        
                    }
                }          
                
                sortJSON(results, 'engineHours', 'desc')
                
                return res.status(200).send({
                    ok: true,
                    results,
                    callResults
                });
            });
        } // Fin divices
        , function(e) {
            console.error("Failed:", e);
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: e
            });
        }); // Fin error principal // Fin llamada
    }); // Fin autenticacion
});
// End Get consume fuel

// Get drivers
app.get('/drivers', (req, res) => {

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
          typeName: 'User',
          resultsLimit: 1000
        }, function(err, drivers) {
          if(err){
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
          }
            return res.status(200).send({
                ok: true,
                drivers
            });
        });
    });
});
// End get divice

module.exports = app;
