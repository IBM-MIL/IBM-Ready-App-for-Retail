/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */
describe("routing", function () {

    /*
     *  Setup
     */

    // Mock ReadyAppHC
    beforeEach(module('ReadyAppSummit'));

    // Retrieve providers
    var $route;

    beforeEach(inject(function (_$route_) {
        $route = _$route_;
    }));

    /*
     *  Specs
     */

    it("should map routes to controllers", function () {
        expect($route.routes['/'].controller).toBe('productDetailsCtrl');
        expect($route.routes['/'].templateUrl).toBe('views/product-details.html');

        expect($route.routes['/WebView/product_details'].controller).toBe('productDetailsCtrl');
        expect($route.routes['/WebView/product_details'].templateUrl).toBe('views/product-details.html');
    });

    // Done Testing

});