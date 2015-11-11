/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

var connect = require('connect');
var serveStatic = require('serve-static');

connect().use(serveStatic('.')).listen(5000);
