/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

describe("dropDown", function () {

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
    
    // Create a new scope.
    var scope;
    beforeEach(function() {
        scope = $rootScope.$new();
        scope.addToList = "Add to List";
        scope.addToCart = "Add to Cart";
    });

    // Create a new drop-down element.
    var newDropDown = function (scope) {
        var newMenu = angular.element('<drop-down drop-data=\"dropData\" button-image=\"{{buttonImage}}\"></drop-down>');
        $compile(newMenu)(scope);
        scope.$digest();
        return newMenu;
    };

    /*
     *  Specs
     */

    var buttonImage = "arrow-button.jpg";

    it("should not display if the drop-down data is not present or not an object", function () {
        // Undefined.
        var dropDown = newDropDown(scope);
        var iScope = dropDown.isolateScope();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Null.
        scope.dropData = null;
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Not an object.
        scope.dropData = ["A", "B", "C"];
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);
    });

    it("should not display if the drop-down data does not contain a valid name", function () {
        scope.dropData = {
            values: [5, 6, 7]
        };

        // No name.
        var dropDown = newDropDown(scope);
        var iScope = dropDown.isolateScope();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Name is present but null.
        scope.dropData = {
            name: null,
            values: [5, 6, 7]
        };
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Name is present but undefined.
        scope.dropData.name = undefined;
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Name is present but not a string.
        scope.dropData.name = 5;
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);
    });

    it("should not display if the drop-down data does not contain valid values", function () {
        scope.dropData = {
            name: "Size"
        };

        // No values.
        var dropDown = newDropDown(scope);
        var iScope = dropDown.isolateScope();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Values are present but null.
        scope.dropData = {
            name: "Size",
            values: null
        };
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Values are present but undefined.
        scope.dropData.values = undefined;
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Values are present but not an array.
        scope.dropData.values = "[5,6,7]";
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);

        // Values are present but are a zero-length array.
        scope.dropData.values = [];
        scope.$digest();
        expect(iScope.displayDropdown).toBe(false);
        expect(iScope.selectTitle).toEqual("");
        expect(iScope.selectOptions).toEqual([]);
    });
    
    /*it("should shorten option names to fit with the color picker", function () {
        scope.dropData = {
            name: "Size",
            values: ["m", "mm", "mmmmm", "nineteen characters"]
        };
        scope.colorData = [{
            color: 'Brown',
            hexColor: '#BF965C'
        }, {
            color: 'Black',
            hexColor: '#000000'
        }, {
            color: 'Green',
            hexColor: '#22CC55'
        }, {
            color: 'White',
            hexColor: '#FFFFFF'
        }];
        
        var dropDown = newDropDown(scope);
        var iScope = dropDown.isolateScope();
        expect(iScope.selectOptions[0].display).toEqual("m");
        expect(iScope.selectOptions[1].display).toEqual("mm");
        expect(iScope.selectOptions[2].display).toEqual("mmmmm");
        expect(iScope.selectOptions[3].display).toEqual("nineteen characters");
        
        // Now change the size.
        var shorterOptions = iScope.truncateValues(scope.dropData.values, 308);
        expect(shorterOptions[0]).toEqual("m");
        expect(shorterOptions[1]).toEqual("mm");
        expect(shorterOptions[2]).toEqual("mmmmm");
        expect(shorterOptions[3]).toEqual("ninetee…");
    });
    
    it("should shorten option names to fit with the add buttons if no color picker is present", function () {
        scope.dropData = {
            name: "Size",
            values: ["m", "mm", "mmmmm", "nineteen characters"]
        };
        
        var dropDown = newDropDown(scope);
        var iScope = dropDown.isolateScope();
        expect(iScope.selectOptions[0].display).toEqual("m");
        expect(iScope.selectOptions[1].display).toEqual("mm");
        expect(iScope.selectOptions[2].display).toEqual("mmmmm");
        expect(iScope.selectOptions[3].display).toEqual("nineteen characters");
        
        // Now change the size.
        var shorterOptions = iScope.truncateValues(scope.dropData.values, 374);
        expect(shorterOptions[0]).toEqual("m");
        expect(shorterOptions[1]).toEqual("mm");
        expect(shorterOptions[2]).toEqual("mmm…");
        expect(shorterOptions[3]).toEqual("ninete…");
        
        // Now change the size again. One of the buttons should have dropped.
        shorterOptions = iScope.truncateValues(scope.dropData.values, 345);
        expect(shorterOptions[0]).toEqual("m");
        expect(shorterOptions[1]).toEqual("mm");
        expect(shorterOptions[2]).toEqual("mmmmm");
        expect(shorterOptions[3]).toEqual("nineteen characters");
        
        // Another size change.
        shorterOptions = iScope.truncateValues(scope.dropData.values, 257);
        expect(shorterOptions[0]).toEqual("m");
        expect(shorterOptions[1]).toEqual("mm");
        expect(shorterOptions[2]).toEqual("mm…");
        expect(shorterOptions[3]).toEqual("nine…");
        
        // And again. At this point the second button should have dropped.
        shorterOptions = iScope.truncateValues(scope.dropData.values, 235);
        expect(shorterOptions[0]).toEqual("m");
        expect(shorterOptions[1]).toEqual("mm");
        expect(shorterOptions[2]).toEqual("mmmmm");
        expect(shorterOptions[3]).toEqual("nineteen characters");
        
        // One final change.
        shorterOptions = iScope.truncateValues(scope.dropData.values, 1);
        expect(shorterOptions[0]).toEqual("m");
        expect(shorterOptions[1]).toEqual("mm");
        expect(shorterOptions[2]).toEqual("m…");
        expect(shorterOptions[3]).toEqual("n…");
    });*/
    
    it("should split the values array into display and values arrays", function () {
        scope.dropData = {
            name: "Size",
            values: ["m", "mm", "mmm", "nineteen characters"]
        };
        
        var dropDown = newDropDown(scope);
        var iScope = dropDown.isolateScope();
        var selectOptions = iScope.getOptions(scope.dropData.values, 374);
        expect(selectOptions[3].value).toEqual("nineteen characters");
        expect(selectOptions[3].display).toEqual("nineteen characters");
    });
});