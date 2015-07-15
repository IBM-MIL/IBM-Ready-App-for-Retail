/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

describe("ratingViewer", function () {

    /*
     *  Setup
     */

    // Mock ReadyAppSummit
    beforeEach(module('ReadyAppSummit'));

    // Retrieve providers
    var $scope, $rootScope, $controller, $compile;

    beforeEach(inject(function (_$rootScope_, _$controller_, _$compile_) {
        $scope = _$rootScope_;
        $rootScope = _$rootScope_;
        $controller = _$controller_;
        $compile = _$compile_
    }));

    var milCtrl;

    // Create milCtrl
    beforeEach(inject(function () {
        milCtrl = $controller("milCtrl", {
            $scope: $scope,
            $rootScope: $rootScope,
            $compile: $compile
        });
    }));

    // Create a new rating-viewer element.
    var newRatingViewer = function (scope) {
        var newViewer = angular.element('<rating-viewer rating=\"rating\" empty-path=\"{{emptyPath}}\" full-path=\"{{fullPath}}\"></rating-viewer>');
        $compile(newViewer)(scope);
        scope.$digest();
        return newViewer;
    };
    
    // Create a new scope.
    var scope;
    beforeEach(function() {
        scope = $rootScope.$new();
        scope.emptyPath = emptyPath;
        scope.fullPath = fullPath;
    });

    /*
     *  Specs
     */

    var emptyPath = "empty-star.jpg";
    var fullPath = "full-star.jpg";

    it("should round up fractional ratings to the next whole number", function () {
        var rating = 3.4;
        scope.rating = rating;

        var ratingViewer = newRatingViewer(scope);
        var iScope = ratingViewer.isolateScope();
        expect(iScope.availables[0]).toEqual(fullPath);
        expect(iScope.availables[1]).toEqual(fullPath);
        expect(iScope.availables[2]).toEqual(fullPath);
        expect(iScope.availables[3]).toEqual(fullPath);
        expect(iScope.availables[4]).toEqual(emptyPath);
    });

    it("should default to zero stars with zero or negative ratings", function () {
        var rating = 0;
        scope.rating = rating;

        var ratingViewer = newRatingViewer(scope);
        var iScope = ratingViewer.isolateScope();
        expect(iScope.availables[0]).toEqual(emptyPath);
        expect(iScope.availables[1]).toEqual(emptyPath);
        expect(iScope.availables[2]).toEqual(emptyPath);
        expect(iScope.availables[3]).toEqual(emptyPath);
        expect(iScope.availables[4]).toEqual(emptyPath);

        scope.rating = -2;
        scope.$digest();
        expect(iScope.availables[0]).toEqual(emptyPath);
        expect(iScope.availables[1]).toEqual(emptyPath);
        expect(iScope.availables[2]).toEqual(emptyPath);
        expect(iScope.availables[3]).toEqual(emptyPath);
        expect(iScope.availables[4]).toEqual(emptyPath);
    });

    it("should default to five stars with ratings greater than five", function () {
        var rating = 7;
        scope.rating = rating;

        var ratingViewer = newRatingViewer(scope);
        var iScope = ratingViewer.isolateScope();
        expect(iScope.availables[0]).toEqual(fullPath);
        expect(iScope.availables[1]).toEqual(fullPath);
        expect(iScope.availables[2]).toEqual(fullPath);
        expect(iScope.availables[3]).toEqual(fullPath);
        expect(iScope.availables[4]).toEqual(fullPath);
    });

    it("should default to zero stars with an invalid rating", function () {
        var rating = "three";
        scope.rating = rating;

        var ratingViewer = newRatingViewer(scope);
        var iScope = ratingViewer.isolateScope();
        expect(iScope.availables[0]).toEqual(emptyPath);
        expect(iScope.availables[1]).toEqual(emptyPath);
        expect(iScope.availables[2]).toEqual(emptyPath);
        expect(iScope.availables[3]).toEqual(emptyPath);
        expect(iScope.availables[4]).toEqual(emptyPath);

        scope.rating = null;
        scope.$digest();
        expect(iScope.availables[0]).toEqual(emptyPath);
        expect(iScope.availables[1]).toEqual(emptyPath);
        expect(iScope.availables[2]).toEqual(emptyPath);
        expect(iScope.availables[3]).toEqual(emptyPath);
        expect(iScope.availables[4]).toEqual(emptyPath);

        scope.rating = undefined;
        scope.$digest();
        expect(iScope.availables[0]).toEqual(emptyPath);
        expect(iScope.availables[1]).toEqual(emptyPath);
        expect(iScope.availables[2]).toEqual(emptyPath);
        expect(iScope.availables[3]).toEqual(emptyPath);
        expect(iScope.availables[4]).toEqual(emptyPath);

        scope.rating = [3, 5, 7];
        scope.$digest();
        expect(iScope.availables[0]).toEqual(emptyPath);
        expect(iScope.availables[1]).toEqual(emptyPath);
        expect(iScope.availables[2]).toEqual(emptyPath);
        expect(iScope.availables[3]).toEqual(emptyPath);
        expect(iScope.availables[4]).toEqual(emptyPath);

        /*scope.rating = true;
        scope.$digest();
        expect(iScope.availables[0]).toEqual(emptyPath);
        expect(iScope.availables[1]).toEqual(emptyPath);
        expect(iScope.availables[2]).toEqual(emptyPath);
        expect(iScope.availables[3]).toEqual(emptyPath);
        expect(iScope.availables[4]).toEqual(emptyPath);*/

        scope.rating = {
            rating: 4
        };
        scope.$digest();
        expect(iScope.availables[0]).toEqual(emptyPath);
        expect(iScope.availables[1]).toEqual(emptyPath);
        expect(iScope.availables[2]).toEqual(emptyPath);
        expect(iScope.availables[3]).toEqual(emptyPath);
        expect(iScope.availables[4]).toEqual(emptyPath);
    });

});