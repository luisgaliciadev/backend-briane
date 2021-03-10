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
const { text } = require('body-parser');

//////////////////////////////////////////////////////////////////////////////////////////////////
// Company

// Get Companys
app.get('/companys/:id/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {    
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
          },
          alignment: {
            horizontal: "center"
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
app.get('/users/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {
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
                  },
                  alignment: {
                    horizontal: "center"
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
                width: 250 
              },
              DS_ROLE: {
                displayName: 'ROL',
                headerStyle: styles.header,
                width: 200
              },
              // AUTHENTICATION: {
              //   displayName: 'AUTENTICACION',
              //   headerStyle: styles.header,
              //   width: 100
              // }
            }
              const dataset = users;
            const merges = [
              { start: { row: 2, column: 1 }, end: { row: 2, column: 3 } }
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
app.get('/clients/:id/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {    
  var id = req.params.id;
  var search = req.params.search;
  var params = `${id}, '${search}'`;
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

///////////////////////////////////////////////////////////////////////////////////////////////
// Denuncias

// Get Denuncias
app.get('/denuncias/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {    
  var search = req.params.search;
  var params = `'${search}'`;
  var lsql = `EXEC GET_DENUNCIAS ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
      if (err) { 
          return res.status(500).send({
              ok: false,
              message: 'Error en la petición.',
              error: err
          });
      } else {            
          var denuncias = result.recordset;       
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
        },
        alignment: {
          horizontal: "center"
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
       [{value: 'LISTADO DE DENUNCIAS', style: styles.header}],
       [''] // <-- It can be only values
    ];       
    //Here you specify the export structure
    const specification = {
      ID_DENUNCIA: { // <- the key should match the actual data key
        displayName: 'ID', // <- Here you specify the column header
        headerStyle: styles.header, // <- Header style     
        width: 100 // <- width in pixels
      },
      TITULO: {
        displayName: 'TITULO',
        headerStyle: styles.header,
        width: 300 // <- width in chars (when the number is passed as string)
      },
      FH_REGISTRO: {
        displayName: 'FECHA',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 150 // <- width in pixels
      },
      DESCRIPCION: {
        displayName: 'INFORMACIÓN',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 250 // <- width in pixels
      },
    }
    const dataset = denuncias;
    const merges = [
      { start: { row: 2, column: 1 }, end: { row: 2, column:  4} }
     
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
// End Get Denuncias

// Denuncias
///////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////
// Operaciones

// Get Guias
app.get('/guias/:idUser/:search/:desde/:hasta', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var idUser = req.params.idUser;
  var search = req.params.search;
  var desde = req.params.desde;
  var hasta = req.params.hasta;
  var params =  `${idUser},'${search}','${desde}','${hasta}'`;
  var lsql = `EXEC GET_GUIAS ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
      if (err) { 
          return res.status(500).send({
              ok: false,
              message: 'Error en la petición.',
              error: err
          });
      } else {            
          var guias = result.recordset;       
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
        },
        alignment: {
          horizontal: "center"
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
       [{value: 'LISTADO DE GUIAS', style: styles.header}],
       [''] // <-- It can be only values
    ];       
    //Here you specify the export structure
    const specification = {
      ITEMS: { // <- the key should match the actual data key
        displayName: 'ITEM', // <- Here you specify the column header
        headerStyle: styles.header, // <- Header style     
        width: 100 // <- width in pixels
      },
      ID_GUIA: { // <- the key should match the actual data key
        displayName: 'ID', // <- Here you specify the column header
        headerStyle: styles.header, // <- Header style     
        width: 100 // <- width in pixels
      },
      CORRELATIVO: {
        displayName: 'NRO. GUIA TRANSPORTE',
        headerStyle: styles.header,
        width: 150 // <- width in chars (when the number is passed as string)
      },
      NRO_GUIA_CLIENTE: {
        displayName: 'NRO. GUIA CLIENTE',
        headerStyle: styles.header,
        width: 150 // <- width in chars (when the number is passed as string)
      },
      FH_GUIA: {
        displayName: 'FECHA',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 1 // <- width in pixels
      },
      NOMBRE_CONDUCTOR: {
        displayName: 'CONDUCTOR',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 250 // <- width in pixels
      },
      PLACA_TRACTO: {
        displayName: 'TRACTO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 100 // <- width in pixels
      },
      PLACA_REMOLQUE: {
        displayName: 'REMOLQUE',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 100 // <- width in pixels
      },
      PESO_BRUTO: {
        displayName: 'PESO BRUTO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 100 // <- width in pixels
      },
      PESO_TARA: {
        displayName: 'PESO TARA',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 100 // <- width in pixels
      },
      PESO_NETO: {
        displayName: 'PESO NETO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 100 // <- width in pixels
      },
      CORRELATIVO_OS: {
        displayName: 'ORDEN SERVICIO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 150 // <- width in pixels
      },
      DS_TIPO_SERVICIO: {
        displayName: 'SERVICIO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 150 // <- width in pixels
      },
      DS_ORI_DEST: {
        displayName: 'ORIGEN',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 180 // <- width in pixels
      },
      DESTINO: {
        displayName: 'DESTINO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 180 // <- width in pixels
      },
      DS_PRODUCTO: {
        displayName: 'PRODUCTO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 150 // <- width in pixels
      },
      RAZON_SOCIAL: {
        displayName: 'CLIENTE',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 250 // <- width in pixels
      },
      USUARIO_BS: {
        displayName: 'COORDINADOR',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 250 // <- width in pixels
      },
    }
    const dataset = guias;
    const merges = [
      { start: { row: 2, column: 1 }, end: { row: 2, column:  18} }
     
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
// End Get Guias

// Get Guias diferencia de peso
app.get('/viajesDiferenciaPesoTotal/:search/:desde/:hasta', mdAuthenticattion.verificarToken,  (req, res) => {
  var search = req.params.search;
  var desde = req.params.desde;
  var hasta = req.params.hasta;
  var params = `'${search}','${desde}', '${hasta}'`;
  var request = new mssql.Request();
  var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_VIAJES_DIFERENCIA_PESO_ALL ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
      if (err) { 
          return res.status(500).send({
              ok: false,
              message: 'Error en la petición.',
              error: err
          });
      } else {            
          var guias = result.recordset;       
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
        },
        alignment: {
          horizontal: "center"
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
       [{value: 'LISTADO DE GUIAS', style: styles.header}],
       [''] // <-- It can be only values
    ];       
    //Here you specify the export structure
    const specification = {
      ITEMS: { // <- the key should match the actual data key
        displayName: 'ITEM', // <- Here you specify the column header
        headerStyle: styles.header, // <- Header style     
        width: 70 // <- width in pixels
      },
      ID_GUIA: { // <- the key should match the actual data key
        displayName: 'ID', // <- Here you specify the column header
        headerStyle: styles.header, // <- Header style     
        width: 70 // <- width in pixels
      },
      CORRELATIVO: {
        displayName: 'NRO. GUIA',
        headerStyle: styles.header,
        width: 100 // <- width in chars (when the number is passed as string)
      },
      FH_GUIA: {
        displayName: 'FECHA',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 80 // <- width in pixels
      },
      NOMBRE_CONDUCTOR: {
        displayName: 'CONDUCTOR',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 250 // <- width in pixels
      },
      PLACA_TRACTO: {
        displayName: 'TRACTO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 70 // <- width in pixels
      },
      PLACA_REMOLQUE: {
        displayName: 'REMOLQUE',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 80 // <- width in pixels
      },
      PESO_BRUTO: {
        displayName: 'PESO BRUTO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 80 // <- width in pixels
      },
      PESO_TARA: {
        displayName: 'PESO TARA',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 80 // <- width in pixels
      },
      PESO_NETO: {
        displayName: 'PESO NETO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 80 // <- width in pixels
      },
      PESO_LLEGADA: {
        displayName: 'PESO LLEGADA',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 100 // <- width in pixels
      },
      DIFERENCIA: {
        displayName: 'DIFERENCIA PESO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 120 // <- width in pixels
      },
      DS_MOTIVO_DESCARGO: {
        displayName: 'MOTIVO DESCARGO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 150 // <- width in pixels
      },
      CORRELATIVO_OS: {
        displayName: 'ORDEN SERVICIO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 110 // <- width in pixels
      },
      DS_ORI_DEST: {
        displayName: 'ORIGEN',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 200 // <- width in pixels
      },
      DESTINO: {
        displayName: 'DESTINO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 200 // <- width in pixels
      },
      RAZON_SOCIAL: {
        displayName: 'CLIENTE',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 250 // <- width in pixels
      },
      DS_PRODUCTO: {
        displayName: 'PRODUCTO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 150 // <- width in pixels
      },
    }
    const dataset = guias;
    const merges = [
      { start: { row: 2, column: 1 }, end: { row: 2, column:  18} }
     
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
// End Get diferencia de peso

// Get rutas
app.get('/rutas/:search',mdAuthenticattion.verificarToken, (req, res, next ) => {    
  var search = req.params.search;
  var lsql = `EXEC FE_SUPERVAN.DBO.SP_GET_OP_RUTAS '${search}'`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
      if (err) { 
          return res.status(500).send({
              ok: false,
              message: 'Error en la petición.',
              error: err
          });
      } else {            
          var rutas = result.recordset;       
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
        },
        alignment: {
          horizontal: "center"
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
       [{value: 'LISTADO DE RUTAS', style: styles.header}],
       [''] // <-- It can be only values
    ];       
    //Here you specify the export structure
    const specification = {
      ITEMS: { // <- the key should match the actual data key
        displayName: 'ITEM', // <- Here you specify the column header
        headerStyle: styles.header, // <- Header style     
        width: 70 // <- width in pixels
      },
      ID_RUTA: { // <- the key should match the actual data key
        displayName: 'ID', // <- Here you specify the column header
        headerStyle: styles.header, // <- Header style     
        width: 70 // <- width in pixels
      },
      ORIGEN: {
        displayName: 'ORIGEN',
        headerStyle: styles.header,
        width: 200 // <- width in chars (when the number is passed as string)
      },
      DESTINO: {
        displayName: 'DESTINO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 200 // <- width in pixels
      },
      RAZON_SOCIAL: {
        displayName: 'CLIENTE',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 250 // <- width in pixels
      },
      TARIFA: {
        displayName: 'TARIFA',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 70 // <- width in pixels
      },
      DS_MONEDA: {
        displayName: 'MONEDA',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 80 // <- width in pixels
      },
      DS_TIPO_COBRO_OS: {
        displayName: 'TIPO COBRO',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 100 // <- width in pixels
      },
      ESTATUS: {
        displayName: 'ESTATUS',
        headerStyle: styles.header,
        // cellStyle: styles.cellPink, // <- Cell style
        width: 100 // <- width in pixels
      },
    }
    const dataset = rutas;
    const merges = [
      { start: { row: 2, column: 1 }, end: { row: 2, column:  9} }
     
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
// End Get rutas

// Operaciones
///////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////
// Conductor

// Get deta peaje telecredito
app.get('/detapeajetelecredito/:idPeaje', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var idPeaje = req.params.idPeaje;
  var params =  `${idPeaje}`;
  var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIEW_OP_DETA_PEAJE_TELECREDITO ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
        return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
        });
    } else {            
      var detaPeajes = result.recordset;       
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
          },
          alignment: {
            horizontal: "center"
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
        [{value: `Solicitud de Peaje NRO.: ${detaPeajes[0].ID_PEAJE}`, style: styles.header}],
        [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        FH_EMISION: { // <- the key should match the actual data key
          displayName: 'FechaEmision', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 85 // <- width in pixels
        },
        FH_VECIMIENTO: { // <- the key should match the actual data key
          displayName: 'FechaVencimiento', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 115 // <- width in pixels
        },
        IDENTIFICACION: {
          displayName: 'ID_Personal',
          headerStyle: styles.header,
          width: 80 // <- width in chars (when the number is passed as string)
        },
        SERIE: {
          displayName: 'Serie',
          headerStyle: styles.header,
          width: 35 // <- width in chars (when the number is passed as string)
        },
        DOCUMENTO: {
          displayName: 'Documento',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 75 // <- width in pixels
        },
        MONEDA: {
          displayName: 'Moneda',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 55 // <- width in pixels
        },
        MONTO: {
          displayName: 'Importe',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 55 // <- width in pixels
        },
        CONCEPTO: {
          displayName: 'Concepto',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 250 // <- width in pixels
        },
        FECHA_APLICACION: {
          displayName: 'FechaAplicacion',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 100 // <- width in pixels
        },
        ESTADO: {
          displayName: 'Estado',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 45 // <- width in pixels
        },
        MENSAJE_ERROR: {
          displayName: 'MensajeError',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 85 // <- width in pixels
        },
      }
      const dataset = detaPeajes;
      const merges = [
        { start: { row: 2, column: 1 }, end: { row: 2, column:  11} }
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
// End Get deta peajes telecredito

// Get Get saldos peaje
app.get('/saldospeaje/:desde/:hasta/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var desde = req.params.desde;
  var hasta = req.params.hasta;
  var search = req.params.search;
  var params =  `'${desde}','${hasta}','${search}'`;
  var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIEW_OP_DETA_PEAJES_SALDOS ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
        return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
        });
    } else {            
      var detaPeajes = result.recordset;       
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
          },
          alignment: {
            horizontal: "center"
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
        [{value: `SALDOS DE CONDUCTORES - (PEAJES)`, style: styles.header}],
        [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        ITEMS: { // <- the key should match the actual data key
          displayName: 'ITEM', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 50 // <- width in pixels
        },
        ID_PEAJE: { // <- the key should match the actual data key
          displayName: 'NRO. SOLICITUD', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
        FH_SOLICITUD: {
          displayName: 'FECHA SOLICITUD',
          headerStyle: styles.header,
          width: 115 // <- width in chars (when the number is passed as string)
        },
        CORRELATIVO: {
          displayName: 'NRO. ORDEN SERVICIO',
          headerStyle: styles.header,
          width: 150 // <- width in chars (when the number is passed as string)
        },
        IDENTIFICACION: {
          displayName: 'DNI',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 85 // <- width in pixels
        },
        NOMBRE_APELLIDO: {
          displayName: 'CONDUCTOR',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 250 // <- width in pixels
        },
        FH_PEAJE: {
          displayName: 'FECHA',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 100 // <- width in pixels
        },
        MONTO: {
          displayName: 'MONTO (S/)',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 80 // <- width in pixels
        },
        ABONO: {
          displayName: 'ABONO (S/)',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 80 // <- width in pixels
        },
        TOTAL_SUSTENTAR: {
          displayName: 'SALDO (S/)',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 80 // <- width in pixels
        },
        NOTIFICACION: {
          displayName: 'ESTATUS',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 100 // <- width in pixels
        },
      }
      const dataset = detaPeajes;
      const merges = [
        { start: { row: 2, column: 1 }, end: { row: 2, column:  11} }
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
// End Get saldos peaje

// Get Get descuento peaje
app.get('/descuentopeaje/:desde/:hasta/:search', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var desde = req.params.desde;
  var hasta = req.params.hasta;
  var search = req.params.search;
  var params =  `'${desde}','${hasta}','${search}'`;
  var lsql = `EXEC FE_SUPERVAN.DBO.SP_VIEW_OP_DETA_PEAJES_DESCUENTOS ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
        return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
        });
    } else {            
      var detaPeajes = result.recordset;       
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
          },
          alignment: {
            horizontal: "center"
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
        [{value: `DESCUENTO DE CONDUCTORES - (PEAJES)`, style: styles.header}],
        [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        ITEMS: { // <- the key should match the actual data key
          displayName: 'ITEM', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 50 // <- width in pixels
        },
        ID_PEAJE: { // <- the key should match the actual data key
          displayName: 'NRO. SOLICITUD', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
        FH_SOLICITUD: {
          displayName: 'FECHA SOLICITUD',
          headerStyle: styles.header,
          width: 115 // <- width in chars (when the number is passed as string)
        },
        CORRELATIVO: {
          displayName: 'NRO. ORDEN SERVICIO',
          headerStyle: styles.header,
          width: 150 // <- width in chars (when the number is passed as string)
        },
        IDENTIFICACION: {
          displayName: 'DNI',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 85 // <- width in pixels
        },
        NOMBRE_APELLIDO: {
          displayName: 'CONDUCTOR',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 250 // <- width in pixels
        },
        FH_PEAJE: {
          displayName: 'FECHA',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 100 // <- width in pixels
        },
        MONTO: {
          displayName: 'MONTO (S/)',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 80 // <- width in pixels
        },
        ABONO: {
          displayName: 'ABONO (S/)',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 80 // <- width in pixels
        },
        TOTAL_SUSTENTAR: {
          displayName: 'SALDO (S/)',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 80 // <- width in pixels
        },
        DESCUENTO: {
          displayName: 'ESTATUS',
          headerStyle: styles.header,
          // cellStyle: styles.cellPink, // <- Cell style
          width: 100 // <- width in pixels
        },
      }
      const dataset = detaPeajes;
      const merges = [
        { start: { row: 2, column: 1 }, end: { row: 2, column:  11} }
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
// End Get descuento peaje

// Get Get documentos conductor
app.get('/documentosConductor', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_DOCUMENTOS_CONDUCTOR`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
        return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
        });
    } else {            
      var documentosConductor = result.recordset;   
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
          },
          alignment: {
            horizontal: "center"
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
        [{value: `DOCUMENTOS DE CONDUCTORES`, style: styles.header}],
        [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        ITEMS: { // <- the key should match the actual data key
          displayName: 'ITEM', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 50 // <- width in pixels
        },
        DS_DOCUMENTO: { // <- the key should match the actual data key
          displayName: 'NOMBRE DOCUMENTO', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 700 // <- width in pixels
        },
      }
      const dataset = documentosConductor;
      const merges = [
        { start: { row: 2, column: 1 }, end: { row: 2, column:  2} }
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
// End Get documentos unidades

// Get peajes facturas conductor
app.get('/peajefact/:idDeta', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var idDeta = req.params.idDeta;
  var params =  `${idDeta}`;
  var lsql = `FE_SUPERVAN.DBO.SP_OP_RELACION_PEAJE_FACTURAS ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
        return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
        });
    } else {            
      var peajesFacturas = result.recordset;   
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
          },
          alignment: {
            horizontal: "center"
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
        },
        info: {          
          font: {
            sz: 12,
            bold: true
          }
        }
      };
      
      //Array of objects representing heading rows (very top)
      const heading = [
        [''],
        [{value: `Gastos Operativos | Conductor: ${peajesFacturas[0].IDENTIFICACION} - ${peajesFacturas[0].NOMBRE_APELLIDO}`, style: styles.header}],
        [''], // <-- It can be only values
        [{value: `Nro. Solicitud: ${peajesFacturas[0].ID_PEAJE}`, style: styles.info}],
        [{value: `Fecha Solicitud: ${peajesFacturas[0].FH_SOLICITUD}`, style: styles.info}],
        [{value: `Nro. Orden Servicio: ${peajesFacturas[0].NRO_OS}`, style: styles.info}],
        [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        ITEMS: { // <- the key should match the actual data key
          displayName: 'ITEMS', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 50 // <- width in pixels
        },
        DS_TIPO_CONCEPTO_OP: { // <- the key should match the actual data key
          displayName: 'CONCEPTO', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 150 // <- width in pixels
        },
        DS_TIPO_DOC_PEAJE: { // <- the key should match the actual data key
          displayName: 'TIPO DOCUMENTO', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 150 // <- width in pixels
        },
        NRO_COMPROBANTE: { // <- the key should match the actual data key
          displayName: 'NRO. DOCCUMENTO/REFERENCIA', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 210 // <- width in pixels
        },
        FECHA: { // <- the key should match the actual data key
          displayName: 'FECHA', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 80 // <- width in pixels
        },
        MONTO_COMPROBANTE: { // <- the key should match the actual data key
          displayName: 'MONTO S/', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 80 // <- width in pixels
        },
        CORRELATIVO: { // <- the key should match the actual data key
          displayName: 'NRO. GUIA', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
      }
      const dataset = peajesFacturas;
      const merges = [
        { start: { row: 2, column: 1 }, end: { row: 2, column:  7} }
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
// End Get peajes facturas conductor

// Get peajes facturas conductor total
app.get('/peajeFactTotal/:idPeaje', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var idPeaje = req.params.idPeaje;
  var params =  `${idPeaje}`;
  var lsql = `FE_SUPERVAN.DBO.SP_OP_RELACION_PEAJE_FACTURAS_TOTAL ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
        return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
        });
    } else {            
      var peajesFacturas = result.recordset;   
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
          },
          alignment: {
            horizontal: "center"
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
        },
        info: {          
          font: {
            sz: 12,
            bold: true
          }
        }
      };
      
      //Array of objects representing heading rows (very top)
      let nroSolicitud = '';
      let fechaSolicitud = '';
      let nroOrdenServicio = '';

      if (peajesFacturas.length > 0) {
        nroSolicitud = peajesFacturas[0].ID_PEAJE;
        fechaSolicitud = peajesFacturas[0].FH_SOLICITUD;
        nroOrdenServicio = peajesFacturas[0].NRO_OS;
      }


      const heading = [
        [''],
        [{value: `GASTOS OPERATIVOS`, style: styles.header}],
        [''], // <-- It can be only values
        [{value: `Nro. Solicitud: ${nroSolicitud}`, style: styles.info}],
        [{value: `Fecha Solicitud: ${fechaSolicitud}`, style: styles.info}],
        [{value: `Nro. Orden Servicio: ${nroOrdenServicio}`, style: styles.info}],
        [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        ITEMS: { // <- the key should match the actual data key
          displayName: 'ITEMS', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 50 // <- width in pixels
        },
        IDENTIFICACION: { // <- the key should match the actual data key
          displayName: 'DNI', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 80 // <- width in pixels
        },
        NOMBRE_APELLIDO: { // <- the key should match the actual data key
          displayName: 'CONDUCTOR', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 250 // <- width in pixels
        },
        DS_TIPO_CONCEPTO_OP: { // <- the key should match the actual data key
          displayName: 'CONCEPTO', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
        DS_TIPO_DOC_PEAJE: { // <- the key should match the actual data key
          displayName: 'TIPO DOCUMENTO', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 120 // <- width in pixels
        },
        NRO_COMPROBANTE: { // <- the key should match the actual data key
          displayName: 'NRO. DOCCUMENTO/REFERENCIA', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 210 // <- width in pixels
        },
        FECHA: { // <- the key should match the actual data key
          displayName: 'FECHA', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 80 // <- width in pixels
        },
        MONTO_COMPROBANTE: { // <- the key should match the actual data key
          displayName: 'MONTO S/', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 80 // <- width in pixels
        },
        CORRELATIVO: { // <- the key should match the actual data key
          displayName: 'NRO. GUIA', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
      }
      const dataset = peajesFacturas;
      const merges = [
        { start: { row: 2, column: 1 }, end: { row: 2, column:  9} }
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
// End Get peajes facturas conductor total

// Get peajes deta conductor
app.get('/peajesDeta/:search/:desde/:hasta', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var search = req.params.search;
  var desde = req.params.desde;
  var hasta = req.params.hasta;
  var params =  `'${search}','${desde}','${hasta}'`;
  var lsql = `FE_SUPERVAN.DBO.SP_VIEW_OP_PEAJES_DETA_CONDUCTOR ${params}`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
        return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
        });
    } else {            
      var peajesDeta = result.recordset;   
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
          },
          alignment: {
            horizontal: "center"
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
        },
        info: {          
          font: {
            sz: 12,
            bold: true
          }
        }
      };
      
      //Array of objects representing heading rows (very top)
      const heading = [
        [''],
        [{value: `Detalle de Solicitud de Gatos Operativos`, style: styles.header}],
        [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        ITEMS: { // <- the key should match the actual data key
          displayName: 'ITEMS', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 50 // <- width in pixels
        },
        ID_PEAJE: { // <- the key should match the actual data key
          displayName: 'NRO. SOLICITUD', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
        FH_SOLICITUD: { // <- the key should match the actual data key
          displayName: 'FECHA', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
        IDENTIFICACION: { // <- the key should match the actual data key
          displayName: 'DNI', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 80 // <- width in pixels
        },
        NOMBRE_APELLIDO: { // <- the key should match the actual data key
          displayName: 'CONDUCTOR', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 300 // <- width in pixels
        },
        MONTO: { // <- the key should match the actual data key
          displayName: 'MONTO S/', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
        ESTADO: { // <- the key should match the actual data key
          displayName: 'ESTATUS', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 100 // <- width in pixels
        },
        CORRELATIVO: { // <- the key should match the actual data key
          displayName: 'NRO. ORDEN SERVICIO', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 150 // <- width in pixels
        },
        RAZON_SOCIAL: { // <- the key should match the actual data key
          displayName: 'CLIENTE', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 300 // <- width in pixels
        },
        ORIGEN: { // <- the key should match the actual data key
          displayName: 'ORIGEN', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 200 // <- width in pixels
        },
        DESTINO: { // <- the key should match the actual data key
          displayName: 'DESTINO', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 200 // <- width in pixels
        },
      }
      const dataset = peajesDeta;
      const merges = [
        { start: { row: 2, column: 1 }, end: { row: 2, column:  11} }
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
// End Get peajes deta conductor

// Conductor
///////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////
//Unidades vehiculos

// Get Get documentos unidades vehiculos
app.get('/documentosUnidad', mdAuthenticattion.verificarToken, (req, res, next ) => {       
  var lsql = `FE_SUPERVAN.DBO.SP_GET_OP_DOCUMENTOS_UNIDAD`;
  var request = new mssql.Request();
  request.query(lsql, (err, result) => {
    if (err) { 
        return res.status(500).send({
            ok: false,
            message: 'Error en la petición.',
            error: err
        });
    } else {            
      var documentosConductor = result.recordset;   
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
          },
          alignment: {
            horizontal: "center"
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
        [{value: `DOCUMENTOS DE UNIDADES`, style: styles.header}],
        [''] // <-- It can be only values
      ];       
      //Here you specify the export structure
      const specification = {
        ITEMS: { // <- the key should match the actual data key
          displayName: 'ITEM', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 50 // <- width in pixels
        },
        DS_DOCUMENTO: { // <- the key should match the actual data key
          displayName: 'NOMBRE DOCUMENTO', // <- Here you specify the column header
          headerStyle: styles.header, // <- Header style     
          width: 700 // <- width in pixels
        },
      }
      const dataset = documentosConductor;
      const merges = [
        { start: { row: 2, column: 1 }, end: { row: 2, column:  2} }
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
// End Get unidades vehiculos

//Unidades Vehiculos
/////////////////////////////////////////////////////////////////////////////////////////////


module.exports = app;
