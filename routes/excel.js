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

var app = express();

app.use(bodyParser.urlencoded({ extended: false}));
app.use(bodyParser.json());

var mdAuthenticattion = require('../middlewares/authenticated');

//////////////////////////////////////////////////////////////////////////////////////////////////
// Company

// Get Companys
app.get('/companys/:id/:search', (req, res, next ) => {    
    var id = req.params.id;
    var search = req.params.search;
    var params = `${id}, '${search}'`;
    var lsql = `EXEC GET_COMPANYS_USER ${params}`;
    var request = new mssql.Request();
    request.query(lsql, (err, result) => {
        if (err) { 
            return res.status(500).send({
                ok: false,
                message: 'Error en la petición.',
                error: err
            });
        } else {            
            var companys = result.recordset;            
            // You can define styles as json object
    const styles = {
        header: {
          fill: {
            fgColor: {
              rgb: '3393FF'
            }
          },
          font: {
            color: {
              rgb: 'FFFFFFFF'
            },
            sz: 12,
            bold: true,
            // underline: true,
            margin: 'center'
            // numberFormat: '$#,##0.00; ($#,##0.00); -',
          }
        },
        cellPink: {
          fill: {
            fgColor: {
              rgb: 'FFFFCCFF'
            }
          }
        },
        cellGreen: {
          fill: {
            fgColor: {
              rgb: 'FF00FF00'
            }
          }
        }
      };
      //Array of objects representing heading rows (very top)
      const heading = [
         [''],
         [{value: 'LISTADO DE EMPRESAS', style: styles.header}],
         [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        ID_COMPANY: { // <- the key should match the actual data key
          displayName: 'RUC', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style
          // cellStyle: function(value, row) { // <- style renderer function
          //   // if the status is 1 then color in green else color in red
          //   // Notice how we use another cell value to style the current one
          //   return (row.status_id == 1) ? styles.cellGreen : {fill: {fgColor: {rgb: 'FFFF0000'}}}; // <- Inline cell style is possible 
          // },
          width: 100 // <- width in pixels
        },
        DS_COMPANY: {
          displayName: 'RAZON SOCIAL',
          headerStyle: styles.header,
          // cellFormat: function(value, row) { // <- Renderer function, you can access also any row.property
          //   return (value == 1) ? 'Active' : 'Inactive';
          // },
          width: 300 // <- width in chars (when the number is passed as string)
        },
        EMAIL: {
          displayName: 'EMAIL',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 150 // <- width in pixels
        },
        PHONE: {
            displayName: 'TELEFONO',
            headerStyle: styles.header,
            // cellStyle: styles.cellPink, // <- Cell style
            width: 100 // <- width in pixels
        },
        CONTACT: {
            displayName: 'CONTACTO',
            headerStyle: styles.header,
            // cellStyle: styles.cellPink, // <- Cell style
            width: 250 // <- width in pixels
        },
      }
      const dataset = companys;       
      // Define an array of merges. 1-1 = A:1
      // The merges are independent of the data.
      // A merge will overwrite all data _not_ in the top-left cell.
      const merges = [
        //{ start: { row: 1, column: 1 }, end: { row: 1, column: 5 } },
        { start: { row: 2, column: 1 }, end: { row: 2, column: 5 } }
        //{ start: { row: 2, column: 6 }, end: { row: 2, column: 5   } }
      ]
       
      // Create the excel report.
      // This function will return Buffer
      const report = excel.buildExport(
        [ // <- Notice that this is an array. Pass multiple sheets to create multi sheet report
          {
            name: 'Report', // <- Specify sheet name (optional)
            heading: heading, // <- Raw heading array (optional)
            merges: merges, // <- Merge cell ranges
            specification: specification, // <- Report specification
            data: dataset // <-- Report data
          }
        ]
      );       
      // You can then return this straight
      res.attachment('report.xlsx'); // This is sails.js specific (in general you need to set headers)
      return res.status(200).send(report);
        }
    });
});
// End Get Companys

// Companys
//////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////
// Users

// Get Users
app.get('/users/:search', (req, res, next ) => {
    var search = req.params.search;
    var params = `${search}`;
    var lsql = `EXEC GET_USERS '${params}'`;
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
            const styles = {
                header: {
                  fill: {
                    fgColor: {
                      rgb: '3393FF'
                    }
                  },
                  font: {
                    color: {
                      rgb: 'FFFFFFFF'
                    },
                    sz: 12,
                    bold: true,
                    margin: 'center'
                  }
                },
                cellPink: {
                  fill: {
                    fgColor: {
                      rgb: 'FFFFCCFF'
                    }
                  }
                },
                cellGreen: {
                  fill: {
                    fgColor: {
                      rgb: 'FF00FF00'
                    }
                  }
                }
              };
            const heading = [
                [''],
                [{value: 'LISTADO DE USUARIOS', style: styles.header}],
                ['']
            ];             
            const specification = {
              NAME: { 
                displayName: 'NOMBRE', 
                headerStyle: styles.header, 
                width: 250 
              },
              EMAIL: {
                displayName: 'EMAIL',
                headerStyle: styles.header,
                width: 150 
              },
              DS_ROLE: {
                displayName: 'ROL',
                headerStyle: styles.header,
                width: 100
              },
              AUTHENTICATION: {
                displayName: 'AUTENTICACION',
                headerStyle: styles.header,
                width: 100
              }
            }
              const dataset = users;
            const merges = [
              { start: { row: 2, column: 1 }, end: { row: 2, column: 4 } }
            ]
            const report = excel.buildExport(
              [ 
                {
                  name: 'Report',
                  heading: heading,
                  merges: merges,
                  specification: specification,
                  data: dataset
                }
              ]
            );        
            res.attachment('report.xlsx'); 
            return res.status(200).send(report);
        }
    });
});
// End Get Users

// Users
//////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////
// Clients

// Get Clients
app.get('/clients/:id/:search', (req, res, next ) => {    
  var id = req.params.id;
  var search = req.params.search;
  var params = `${id}, '${search}'`;
  console.log(params);
  var lsql = `EXEC GET_CLIENTS ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
      if (err) { 
          return res.status(500).send({
              ok: false,
              message: 'Error en la petición.',
              error: err
          });
      } else {            
          var clients = result.recordset;            
          // You can define styles as json object
  const styles = {
      header: {
        fill: {
          fgColor: {
            rgb: '3393FF'
          }
        },
        font: {
          color: {
            rgb: 'FFFFFFFF'
          },
          sz: 12,
          bold: true,
          // underline: true,
          margin: 'center'
          // numberFormat: '$#,##0.00; ($#,##0.00); -',
        }
      },
      cellPink: {
        fill: {
          fgColor: {
            rgb: 'FFFFCCFF'
          }
        }
      },
      cellGreen: {
        fill: {
          fgColor: {
            rgb: 'FF00FF00'
          }
        }
      }
    };
    //Array of objects representing heading rows (very top)
    const heading = [
       [''],
       [{value: 'LISTADO DE CLIENTES', style: styles.header}],
       [''] // <-- It can be only values
    ];       
    //Here you specify the export structure
    const specification = {
      COD_CLIENT: { // <- the key should match the actual data key
        displayName: 'RUC', // <- Here you specify the column header
        headerStyle: styles.header, // <- Header style     
        width: 100 // <- width in pixels
      },
      DS_CLIENT: {
        displayName: 'RAZON SOCIAL',
        headerStyle: styles.header,
        width: 300 // <- width in chars (when the number is passed as string)
      },
      EMAIL: {
        displayName: 'EMAIL',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 150 // <- width in pixels
      },
      PHONE: {
          displayName: 'TELEFONO',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 100 // <- width in pixels
      },
      CONTACT: {
          displayName: 'CONTACTO',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 250 // <- width in pixels
      },
    }
    const dataset = clients;
    console.log(clients)
    const merges = [
      { start: { row: 2, column: 1 }, end: { row: 2, column: 5 } }
     
    ]
   
    const report = excel.buildExport(
      [ 
        {
          name: 'Report', // <- Specify sheet name (optional)
          heading: heading, // <- Raw heading array (optional)
          merges: merges, // <- Merge cell ranges
          specification: specification, // <- Report specification
          data: dataset // <-- Report data
        }
      ]
    ); 
    res.attachment('report.xlsx'); // This is sails.js specific (in general you need to set headers)
    return res.status(200).send(report);
      }
  });
});
// End Get Clients

// Clients
//////////////////////////////////////////////////////////////////////////////////////////////////

module.exports = app;
