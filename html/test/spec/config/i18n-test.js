/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

describe("i18n", function () {

    /*
     *  Setup
     */

    // Mock ReadyAppHC with test translations
    beforeEach(module('ReadyAppSummit', function ($translateProvider) {
        $translateProvider.translations('corgi', {
            addToList: "GRR...",
            addToCart: "BARK~",

            detailsTitle: "BARK?",

            colorTitle: "BARK.",
        });
    }));

    // Retrieve providers
    var $scope, $location, $route, $rootScope, $translate, $controller, $filter;

    beforeEach(inject(function (_$location_, _$route_, _$rootScope_, _$translate_, _$controller_, _$filter_) {
        $scope = _$rootScope_;
        $location = _$location_;
        $route = _$route_;
        $rootScope = _$rootScope_;
        $translate = _$translate_;
        $controller = _$controller_;
        $filter = _$filter_;
    }));

    var milCtrl;

    // Create milCtrl
    beforeEach(inject(function () {
        milCtrl = $controller("milCtrl", {
            $scope: $scope,
            $location: $location,
            $route: $route,
            $rootScope: $scope,
            $translate: $translate,
            $rootScope: $rootScope
        });
    }));

    /*
     *  Specs
     */

    it("should default to English", function () {
        expect($filter("translate")("addToCart")).toBe("Add to Cart");
        expect($filter("translate")("addToList")).toBe("Add to List");

        expect($filter("translate")("detailsTitle")).toBe("Product Details");

        expect($filter("translate")("colorTitle")).toBe("Color");
    });

    it("should translate keys", function () {
        // Set to corgi
        $scope.setLanguage("corgi");

        expect($filter("translate")("addToList")).toBe("GRR...");
        expect($filter("translate")("addToCart")).toBe("BARK~");

        expect($filter("translate")("detailsTitle")).toBe("BARK?");

        expect($filter("translate")("colorTitle")).toBe("BARK.");

    });

    // Done Testing

});