/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

describe("colorPicker", function () {

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
        $compile = _$compile_;
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

    // Create a new color-picker element.
    var newColorPicker = function (scope) {
        var newPicker = angular.element('<color-picker color-options=\"colorOptions\" color-picked=\"colorPicked(color)\"></color-picker>');
        $compile(newPicker)(scope);
        scope.$digest();
        return newPicker;
    };

    // A dummy function to test the callback functionality.
    var testColor;
    beforeEach(function () {
        testColor = null;
    });
    var dummyFunc = function (colorItem) {
        testColor = colorItem;
    };
    
    // Create a new scope.
    var scope;
    beforeEach(function() {
        scope = $rootScope.$new();
    });

    /*
     *  Specs
     */

    it("should change the selected color when a new color is clicked", function () {
        var colorData = [{
            color: "Purple",
            hexColor: "#AAAAFF",
            url: "purple-pic.jpg"
        }, {
            color: "Cream",
            hexColor: "#FFFFEE",
            url: "cream-pic.jpg"
        }, {
            color: "Teal",
            hexColor: "#45EAB6",
            url: "teal-pic.jpg"
        }];

        scope.colorOptions = colorData;
        scope.colorPicked = dummyFunc;

        var colorPicker = newColorPicker(scope);
        var iScope = colorPicker.isolateScope();

        // Click on an element. (Simulated with changeColor().)
        iScope.changeColor(1);
        scope.$digest();
        expect(iScope.currentElem).toEqual(1);
        expect(iScope.currentColor.color).toEqual("Cream");
        expect(iScope.currentColor.hexColor).toEqual("#FFFFEE");
        expect(iScope.currentColor.url).toEqual("cream-pic.jpg");

        iScope.changeColor(2);
        scope.$digest();
        expect(iScope.currentElem).toEqual(2);
        expect(iScope.currentColor.color).toEqual("Teal");
        expect(iScope.currentColor.hexColor).toEqual("#45EAB6");
        expect(iScope.currentColor.url).toEqual("teal-pic.jpg");
    });

    it("should run the callback function when a new color is clicked", function () {
        var colorData = [{
            color: "Purple",
            hexColor: "#AAAAFF",
            url: "purple-pic.jpg"
        }, {
            color: "Cream",
            hexColor: "#FFFFEE",
            url: "cream-pic.jpg"
        }, {
            color: "Teal",
            hexColor: "#45EAB6",
            url: "teal-pic.jpg"
        }];

        scope.colorOptions = colorData;
        scope.colorPicked = dummyFunc;

        var colorPicker = newColorPicker(scope);
        var iScope = colorPicker.isolateScope();

        // Click on an element. (Simulated with changeColor().)
        iScope.changeColor(1);
        scope.$digest();
        // The dummy function will change the testColor variable in this unit test file.
        expect(testColor.color).toEqual("Cream");
        expect(testColor.hexColor).toEqual("#FFFFEE");
        expect(testColor.url).toEqual("cream-pic.jpg");

        iScope.changeColor(2);
        scope.$digest();
        expect(testColor.color).toEqual("Teal");
        expect(testColor.hexColor).toEqual("#45EAB6");
        expect(testColor.url).toEqual("teal-pic.jpg");
    });

    it("should run successfully if no callback function is provided", function () {
        var colorData = [{
            color: "Purple",
            hexColor: "#AAAAFF",
            url: "purple-pic.jpg"
        }, {
            color: "Cream",
            hexColor: "#FFFFEE",
            url: "cream-pic.jpg"
        }, {
            color: "Teal",
            hexColor: "#45EAB6",
            url: "teal-pic.jpg"
        }];

        scope.colorOptions = colorData;
        scope.colorPicked = dummyFunc;

        var colorPicker = angular.element('<color-picker color-options=\"colorOptions\"></color-picker>');
        $compile(colorPicker)(scope);
        scope.$digest();
        var iScope = colorPicker.isolateScope();

        // Click on an element. (Simulated with changeColor().)
        iScope.changeColor(1);
        scope.$digest();
        // The color will be changed inside the directive.
        expect(iScope.currentElem).toEqual(1);
        expect(iScope.currentColor.color).toEqual("Cream");
        expect(iScope.currentColor.hexColor).toEqual("#FFFFEE");
        expect(iScope.currentColor.url).toEqual("cream-pic.jpg");
        // But the callback function will do nothing.
        expect(testColor).toBe(null);
    });

    // Note that we are allowing the directive to function correctly without URLs, to
    // make it more universal.
    it("should eliminate invalid colors from the selector", function () {
        scope.colorPicked = dummyFunc;

        // Color name is missing.
        scope.colorOptions = [{
            color: "Purple",
            hexColor: "#AAAAFF",
            url: "purple-pic.jpg"
        }, {
            color: "Cream",
            hexColor: "#FFFFEE",
            url: "cream-pic.jpg"
        }, {
            hexColor: "#45EAB6",
            url: "teal-pic.jpg"
        }];

        var colorPicker = newColorPicker(scope);
        var iScope = colorPicker.isolateScope();

        // Teal should be eliminated.
        expect(iScope.finalColors.length).toEqual(2);
        expect(iScope.finalColors[0].color).toEqual("Purple");
        expect(iScope.finalColors[1].color).toEqual("Cream");

        // hexColor value is missing.
        scope.colorOptions = [{
            color: "Purple",
            hexColor: "#AAAAFF",
            url: "purple-pic.jpg"
        }, {
            color: "Cream",
            url: "cream-pic.jpg"
        }, {
            color: "Teal",
            hexColor: "#45EAB6",
            url: "teal-pic.jpg"
        }];
        scope.$digest();

        // Cream should be eliminated.
        expect(iScope.finalColors.length).toEqual(2);
        expect(iScope.finalColors[0].color).toEqual("Purple");
        expect(iScope.finalColors[1].color).toEqual("Teal");
    });

    it("should not display if there are no valid colors", function () {
        scope.colorPicked = dummyFunc;

        var colorPicker = newColorPicker(scope);
        var iScope = colorPicker.isolateScope();

        // No color data is present.
        expect(iScope.finalColors.length).toEqual(0);
        expect(iScope.currentColor.color).toEqual("");

        // Color data is present but null.
        scope.colorOptions = null;
        scope.$digest();
        expect(iScope.finalColors.length).toEqual(0);
        expect(iScope.currentColor.color).toEqual("");

        // Color data is present but undefined.
        scope.colorOptions = undefined;
        scope.$digest();
        expect(iScope.finalColors.length).toEqual(0);
        expect(iScope.currentColor.color).toEqual("");

        // Color data is present but an empty list.
        scope.colorOptions = [];
        scope.$digest();
        expect(iScope.finalColors.length).toEqual(0);
        expect(iScope.currentColor.color).toEqual("");

        // Color data is present but all colors are invalid.
        scope.colorOptions = [{
            color: "Teal"
        }, {
            hexColor: "#45EAB6"
        }];
        scope.$digest();
        expect(iScope.finalColors.length).toEqual(0);
        expect(iScope.currentColor.color).toEqual("");
    });

});