/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

describe("textExpander", function () {

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

    // Create a new text-expander element.
    var newTextExpander = function (scope) {
        var newText = angular.element('<text-expander title=\"{{title}}\" text=\"{{text}}\" button-image=\"{{buttonImage}}\" button-rotation=\"{{buttonRotation}}\"></text-expander>');
        $compile(newText)(scope);
        scope.$digest();
        return newText;
    };
    
    // Create a new scope.
    var scope;
    beforeEach(function() {
        scope = $rootScope.$new();
    });

    /*
     *  Specs
     */
});