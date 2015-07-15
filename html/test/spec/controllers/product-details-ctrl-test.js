/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

describe("productDetailsCtrl", function () {

    /*
     *  Setup
     */

    // Mock ReadyAppRT
    beforeEach(module('ReadyAppSummit'));

    // Retrieve providers
    var $scope, $location, $route, $rootScope, $translate, $controller, $filter, $timeout, imagePreloader, $httpBackend;

    beforeEach(inject(function (_$location_, _$route_, _$rootScope_, _$translate_, _$controller_, _$filter_, _$timeout_, _imagePreloader_, _$httpBackend_) {
        $scope = _$rootScope_;
        $location = _$location_;
        $route = _$route_;
        $rootScope = _$rootScope_;
        $translate = _$translate_;
        $controller = _$controller_;
        $filter = _$filter_;
        $timeout = _$timeout_;
        imagePreloader = _imagePreloader_;
        $httpBackend = _$httpBackend_;
    }));

    var milCtrl;

    // Create milCtrl
    beforeEach(inject(function () {
        milCtrl = $controller('milCtrl', {
            $scope: $scope,
            $location: $location,
            $route: $route,
            $rootScope: $rootScope,
            $translate: $translate,
            $controller: $controller
        });
    }));

    var productDetailsCtrl;

    // Create milCtrl
    beforeEach(inject(function () {
        productDetailsCtrl = $controller('productDetailsCtrl', {
            $scope: $scope,
            $translate: $translate,
            $filter: $filter,
            imagePreloader: imagePreloader,
            $timeout: $timeout,
            $controller: $controller
        });
    }));

    /*
     *  Specs
     */

    it("should have correct initial property values", function () {        
        expect($scope.imageIsLoading).toBe(true);
        expect($scope.imageLoadWasSuccessful).toBe(false);

        expect($scope.addToCart).toBe("Add to Cart");
        expect($scope.addToList).toBe("Add to List");

        expect($scope.colorTitle).toBe("Color");

        expect($scope.availability).toBe(undefined);
        expect($scope.location).toBe(undefined);

        expect($scope.productName).toBe(undefined);

        expect($scope.rating).toBe(undefined);

        expect($scope.currentPrice).toBe(undefined);
        expect($scope.oldPrice).toBe(undefined);

        expect($scope.colorData).toBe(undefined);

        expect($scope.optionsData).toBe(undefined);

        expect($scope.detailsTitle).toBe(undefined);
        expect($scope.detailsBody).toBe(undefined);

        expect($scope.src).toBe(undefined);
    });

    it("should have correct property values on injection", function () {
        $httpBackend.expectGET('views/product-details.html');
        $httpBackend.whenGET('views/product-details.html').respond({ hello: "world" });
        
        // Perform an injection
        $scope.injectData({
            name: 'A name',
            imageUrl: 'A url',
            rating: 1,
            salePrice: '$0.00',
            price: '$1.00',
            colorOptions: [{
                color: 'Red',
                hexColor: '#F00',
                url: 'A red url'
            }, {
                color: 'White',
                hexColor: '#FFF',
                url: 'A white url'
            }],
            option: {
                name: 'Size',
                values: [1, 2, 3]
            },
            availability: 'In Stock',
            location: 'Aisle 0',
            description: 'A description'
        });

        // Check properties
        expect($scope.imageIsLoading).toBe(true);
        expect($scope.imageLoadWasSuccessful).toBe(false);

        expect($scope.addToCart).toBe("Add to Cart");
        expect($scope.addToList).toBe("Add to List");

        expect($scope.colorTitle).toBe("Color");

        expect($scope.availability).toBe("In Stock");
        expect($scope.location).toBe("Aisle 0");

        expect($scope.productName).toBe("A name");

        expect($scope.rating).toBe(1);

        expect($scope.currentPrice).toBe("$0.00");
        expect($scope.oldPrice).toBe("$1.00");

        expect($scope.colorData).toEqual([{color: 'Red',hexColor: '#F00',url: 'A red url'}, {color: 'White',hexColor: '#FFF',url: 'A white url'}]);

        expect($scope.optionsData).toEqual({name: 'Size',values: [1, 2, 3]});

        expect($scope.detailsTitle).toBe("Product Details");
        expect($scope.detailsBody).toBe("A description");

        expect($scope.src).toBe("A url");
    });

    // Done Testing

});