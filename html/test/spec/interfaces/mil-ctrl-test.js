/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

describe("milCtrl", function () {

    /*
     *  Setup
     */

    // Mock ReadyAppSummit
    beforeEach(module('ReadyAppSummit'));

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
            $rootScope: $rootScope
        });
    }));

    /*
     *  Specs
     */

    it("should change route", function () {
        $scope.switchRoute("/This/Is/A/Cool/Path", true);
        expect($location.path()).toBe("/This/Is/A/Cool/Path");

        $scope.switchRoute("/This/Path/Did/Not/Reload", false);
        expect($location.path()).toBe("/This/Path/Did/Not/Reload");
    });

    it("should change language", function () {
        $scope.setLanguage("gibberish");
        expect($filter("translate")("blahblah")).toBe("blahblah");

        $scope.setLanguage("en");
        expect($filter("translate")("addToCart")).toBe("Add to Cart");
    });

    it("should inject JSON data and get injected data", function () {
        var injectedTestJSON = {
            name: 'Hipster Ipsum Shoes',
            rating: 4,
            prices: {
                current: '$14.99',
                old: '$20.99'
            }
        };
        var priceObject = {
            current: '$14.99',
            old: '$20.99'
        };

        $scope.injectData(injectedTestJSON);
        expect($scope.getData("name", String)).toBe("Hipster Ipsum Shoes");
        expect($scope.getData("rating", Number)).toBe(4);
        expect($scope.getData("prices.current", String)).toBe("$14.99");
        expect($scope.getData("prices.old", String)).toBe("$20.99");
        expect($scope.getData("prices", Object)).toEqual(priceObject);
    });

    // Done Testing

});