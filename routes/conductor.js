'use strict'

var express = require('express');

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

// ////////////////////////////////////////////////////////////////////////////////////////////////
// Users

// Get Vijes conductores 
app.post('/viajes', (req, res) => {
    var body = req.body;
    var dni = body.DNI;    
    var desde = body.DESDE;
    var hasta = body.HASTA;   
    
    var params = `'${dni}', '${desde}', '${hasta}'`;
    var request = new mssql.Request();
    var lsql = `EXEC SP_GET_VIAJES_CONDUCTORES ${params}`;
    // console.log(lsql);
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viajes = result.recordset;
            return res.status(200).send({
                ok: true,                                   
                viajes                                 
            });           
        }
    });
});
// End Vijes conductores 

// Get Zonas Conductor
app.get('/zonas', (req, res, next ) => {   
    var lsql = `EXEC GET_ZONAS_CONDUCTOR`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var zonasConductor = result.recordset;            
            return res.status(200).send({
                ok: true,
                zonasConductor
            });
        }
    });
});
// End Zonas Conductor

// Get Conductor
app.get('/:id', (req, res, next ) => {
    var id = req.params.id;
    var params = `'${id}'`;
    var lsql = `EXEC GET_CONDUCTOR ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var conductor = result.recordset;
            if (conductor.length === 0) {
                return  res.status(400).send({
                    ok: true, 
                    message: 'Conductor no registrado.'
                }); 
            } else {
                return res.status(200).send({
                    ok: true,
                    conductor: conductor[0]
                });
            }
        }
    });
});
// End Get Conductor

// Get Datos semana
app.get('/datosemana/:dia', (req, res, next ) => {
    var dia = req.params.dia;
    var params = `'${dia}'`;
    var lsql = `EXEC GET_DATOS_SEMANA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var datosSemana = result.recordset;            
            return res.status(200).send({
                ok: true,
                datosSemana: datosSemana[0]
            });
            
        }
    });
});
// End Get Datos semana

// Get Dias Semanas
app.get('/diasemana/:desde/:hasta', (req, res, next ) => {
    var desde = req.params.desde;
    var hasta = req.params.hasta;
    var params = `'${desde}', '${hasta}'`;
    var lsql = `EXEC GET_DIAS_SEMANA ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var diasSemana = result.recordset;            
            return res.status(200).send({
                ok: true,
                diasSemana
            });
            
        }
    });
});
// End Get Dias Semanas

// Get Tarifas viaticos
app.get('/tarifasviatico/:zona', (req, res, next ) => {
    var zona = req.params.zona;
    var params = `'${zona}'`;
    var lsql = `EXEC GET_TARIFA_VIATICOS ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var tarifas = result.recordset;            
            return res.status(200).send({
                ok: true,
                tarifas: tarifas[0]
            });
            
        }
    });
});
// End Get Tarifas viaticos

// Register Viatico
app.post('/viatico', mdAuthenticattion.verificarToken, (req, res, next ) => {       
    var body = req.body;   
    var params = '';
    var values = [];
    
    body.forEach(function (viatico) {
        var idZona = viatico.ID_ZONA;
        var idConductor = viatico.ID_CONDUCTOR;
        var fhDesde = viatico.FH_DESDE;
        var fhHasta = viatico.FH_HASTA;
        var nroSemana = viatico.NRO_SEMANA;
        var fhDia = viatico.FH_DIA;
        var arrayFhDia = fhDia.split("/");
        fhDia = arrayFhDia[2] + '-' + arrayFhDia[1] + '-' + arrayFhDia[0];
        var monto1 = viatico.MONTO1;
        var monto2 = viatico.MONTO2;
        var monto3 = viatico.MONTO3;
        var montoTotal = viatico.MONTO_TOTAL;    
        // params = `${idZona}, '${idConductor}' , '${fhDesde}', '${fhHasta}', '${nroSemana}', '${fhDia}', ${monto1}, ${monto2}, ${monto3}, ${montoTotal}`;
         
        params = params + ',' + '\n' + `(${idZona}, '${idConductor}' , '${fhDesde}', '${fhHasta}', '${nroSemana}', '${fhDia}', ${monto1}, ${monto2}, ${monto3}, ${montoTotal})`;
        values.push([params]);
    });

    
    // var lsql = "INSERT INTO VIATICOS_CONDUCTOR (ID_ZONA,ID_CONDUCTOR,FH_DESDE,FH_HASTA,NRO_SEMANA,FH_DIA,MONTO1,MONTO2,MONTO3,MONTO_TOTAL) VALUES ?";
    // var request = new mssql.Request();

    // request.query(lsql, [[values]], (err, result) => {
    //     if (err) throw err;
    //     console.log(" Number of records inserted: " + result.affectedRows);
    // });

            //  return res.status(200).send({
            //     ok: true,                             
            //     values
            // });
    
    params = params.substring(1);
    var lsql = `INSERT INTO VIATICOS_CONDUCTOR (ID_ZONA,ID_CONDUCTOR,FH_DESDE,FH_HASTA,NRO_SEMANA,FH_DIA,MONTO1,MONTO2,MONTO3,MONTO_TOTAL) 
    VALUES ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {
            var viaticos = result.rowsAffected[0];
            return res.status(200).send({
                ok: true,                             
                viaticos
            });
        }
    }); 
});
// End Register Viatico





// // Get Users
// app.get('/users/:search', (req, res, next ) => {
//     var search = req.params.search;
//     var params = `'${search}'`;
//     var lsql = `EXEC GET_USERS ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var users = result.recordset;
//             if (users.length > 0) {
//                 var total = users[0].TOTAL 
//             } else {
//                 total = 0
//             }
//             return res.status(200).send({
//                 ok: true,
//                 users: users, 
//                 total: total
//             });
//         }
//     });
// });
// // End Get Users

// // Get User
// app.get('/:id', (req, res, next ) => {
//     var id = req.params.id;
//     var params = `${id}`;
//     var lsql = `EXEC GET_USER ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {            
//             var user = result.recordset;
//             if (user.length === 0) {
//                 return  res.status(400).send({
//                     ok: true, 
//                     message: 'Usuario no registrado.'
//                 }); 
//             } else {
//                 return res.status(200).send({
//                     ok: true,
//                     user: user[0]
//                 });
//             }
//         }
//     });
// });
// // End Get User

// // Update User
// app.put('/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {
//     var id = req.params.id;
//     var body = req.body;
//     var name = body.NAME;
//     var email = body.EMAIL;
//     console.log(email);
//     var phone = body.PHONE;
//     var id_role = body.ID_ROLE;
//     var params = `${id}, '${name}', '${email}', '${phone}', ${id_role}`;
//     console.log(params);
//     var request = new mssql.Request();
//     var lsql = `EXEC UPDATE_USER ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var userUpdated = result.recordset;
//             if (userUpdated.length === 0) {
//                 return res.status(400).send({
//                     ok: true,
//                     message: 'Usuario no registrado.'
//                 });
//             } else {
//                 if (userUpdated[0].ID_USER ===0) {
//                     return res.status(400).send({
//                         ok: true,
//                         message: userUpdated[0].MESSAGE
//                     });
//                 } else {
//                     return res.status(200).send({
//                         ok: true,
//                         user: userUpdated[0]
//                     });
//                 }
//             }
//         }
//     });
// });
// // End Update User

// // Update Password User
// app.put('/password/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {
//     var id = req.params.id;
//     var body = req.body;
//     var password = bcrypt.hashSync(body.PASSWORD, 10);
//     var params = `${id}, '${password}'`;
//     var request = new mssql.Request();
//     var lsql = `EXEC UPDATE_PASSWORD ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var userUpdated = result.recordset;
//             if (userUpdated.length === 0) {
//                 return res.status(400).send({
//                     ok: true,
//                     message: 'Usuario no registrado.'
//                 });
//             } else {
//                 if (userUpdated[0].ID_USER ===0) {
//                     return res.status(400).send({
//                         ok: true,
//                         message: userUpdated[0].MESSAGE
//                     });
//                 } else {
//                     return res.status(200).send({
//                         ok: true,
//                         user: userUpdated[0]
//                     });
//                 }
//             }
//         }
//     });
// });
// // End Update Password User

// // Delete User
// app.delete('/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {
//     var id = req.params.id;
//     var params = `${id}`;  
//     var lsql = `EXEC DELETE_USER ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var userDeleted = result.recordset;
//             return res.status(200).send({
//                 ok: true, 
//                 message: userDeleted[0].MESSAGE,
//                 user: userDeleted[0]
//             });
//         }
//     });
// });
// // End Delete User

// // User 
// //////////////////////////////////////////////////////////////////////////////////////////////////

// //////////////////////////////////////////////////////////////////////////////////////////////////
// // Companys

// // Get Companys Users
// app.post('/companys/:id', (req, res, next ) => {
//     var id = req.params.id;
//     var search = req.body.search;
//     var params = `${id}, '${search}'`;
//     var lsql = `EXEC GET_COMPANYS_USER ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var companys = result.recordset;
            
//             return res.status(200).send({
//                 ok: true,
//                 companys: companys
//             });
//         }
//     });
// });
// // End Get Companys Users

// // Get Company User
// app.get('/company/:id/:id_user', (req, res, next ) => {
//     var id = req.params.id;
//     var id_user = req.params.id_user;
//     var params = `${id}, ${id_user}`;
//     var lsql = `EXEC GET_COMPANY_USER ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var company = result.recordset;
//             if (company.length === 0) {
//                 return res.status(400).send({
//                     ok: true,
//                     message: 'La empresa no esta registrada.'
//                 });
//             } else {
//                 return res.status(200).send({
//                     ok: true,
//                     company: company[0]
//                 });
//             }
//         }
//     });
// });
// // End Get Company User

// // Register Company
// app.post('/company', mdAuthenticattion.verificarToken, (req, res, next ) => {       
//     var body = req.body;
//     var id_company = body.ID_COMPANY;
//     var id_user = body.ID_USER;
//     var ds_company = body.DS_COMPANY;
//     var email = body.EMAIL;
//     var phone = body.PHONE;
//     var contact = body.CONTACT;
//     var params = `'${id_company}',${id_user} , '${ds_company}', '${email}', '${phone}', '${contact}'`;
//     var request = new mssql.Request();
//     var lsql = `EXEC REGISTER_COMPANY ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var companyRegister = result.recordset;
//             if (companyRegister.length === 0) {
//                 return res.status(400).send({
//                     ok: true,
//                     message: 'Empresa no registrada.'
//                 });
//             } else {
//                 if (companyRegister[0].ID_COMPANY_USER === 0) {
//                     return res.status(400).send({
//                         ok: true,                             
//                         message: companyRegister[0].MESSAGE
//                     });
//                 } else {
//                     return res.status(200).send({
//                         ok: true,                             
//                         company: companyRegister[0]
//                     });
//                 }
//             }
//         }
//     });
// });
// // End Register Company

// // Register Company
// app.put('/company/:id/:id_user', mdAuthenticattion.verificarToken, (req, res, next ) => {
//     var id = req.params.id;
//     var id_user = req.params.id_user;
//     var body = req.body;
//     var id_company = body.ID_COMPANY
//     var ds_company = body.DS_COMPANY;    
//     var email = body.EMAIL;
//     var phone = body.PHONE;
//     var contact = body.CONTACT;
//     var address = body.ADDRESS;
//     var params = `${id}, ${id_user}, '${id_company}', '${ds_company}', '${email}', '${phone}', '${contact}'`;
//     var request = new mssql.Request();
//     var lsql = `EXEC UPDATE_COMPANY ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {
//             var companyUpdated = result.recordset;
//             if (companyUpdated.length === 0) {
//                 return res.status(400).send({
//                     ok: true,
//                     message: 'Empresa no registrada.'
//                 });
//             } else {
//                 if (companyUpdated[0].ID_COMPANY_USER === 0) {
//                     return res.status(400).send({
//                         ok: true,                             
//                         message: companyUpdated[0].MESSAGE
//                     });
//                 } else {
//                     return res.status(200).send({
//                         ok: true,                             
//                         company: companyUpdated[0]
//                     });
//                 }
//             }
//         }
//     });
// });
// // End Register Company

// // Delete Company
// app.delete('/company/:id', mdAuthenticattion.verificarToken, (req, res, next ) => {
//     var id = req.params.id;
//     var params = `${id}`;
//     var request = new mssql.Request();
//     var lsql = `EXEC DELETE_COMPANY_USER ${params}`;
//     var request = new mssql.Request();
//     request.query(lsql, (err, result) => {
//         if (err) { 
//             return res.status(500).send({
//                 ok: false,
//                 message: 'Error en la petición.',
//                 error: err
//             });
//         } else {   
//             var companyDeleted = result.recordset;
//             if (companyDeleted.length === 0) {
//                 return res.status(400).send({
//                     ok: true,
//                     message: 'Empresa no registrada.'
//                 });
//             } else {
//                 return res.status(200).send({
//                     ok: true,
//                     company: companyDeleted[0]
//                 });
//             }
//         }
//     });
// });
// End Delete Company

// Companys
//////////////////////////////////////////////////////////////////////////////////////////////////

module.exports = app;
