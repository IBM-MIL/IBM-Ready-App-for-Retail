/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

module.exports = function (config) {
    config.set({
        basePath: '',

        frameworks: ['jasmine'],

        files: [
            // Vendor
            './bower_components/angular/angular.js',
            '../js/bower_components/angular-animate/angular-animate.js',
            './bower_components/angular-mocks/angular-mocks.js',
            '../js/bower_components/angular-route/angular-route.js',
            '../js/bower_components/angular-touch/angular-touch.js',
            '../js/vendor/angular-translate.js',
            '../js/bower_components/jquery/dist/jquery.js',

            // Src
            '../js/src/*.js',
            '../js/src/**/*.js',

            // Specs
            './spec/**/*.js'
        ],

        exclude: [
        ],

        preprocessors: {},

        reporters: ['progress'],
        port: 9876,
        colors: true,
        logLevel: config.LOG_INFO,
        autoWatch: false,
        browsers: ['Safari', 'Chrome'],
        singleRun: true,

        client: {
            captureConsole: true
        }
    });
};