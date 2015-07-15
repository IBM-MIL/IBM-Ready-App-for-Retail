/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

var readyAppSummit;

(function () {
    'use strict';

    readyAppSummit.config(function ($routeProvider) {

        /*
         *  Default
         */
        $routeProvider.when('/', {
            templateUrl: 'product-details.html',
            controller: 'productDetailsCtrl'
        });

        /*
         *  Product View
         */
        $routeProvider.when('/WebView/product_details', {
            templateUrl: 'product-details.html',
            controller: 'productDetailsCtrl'
        });

    });
}());