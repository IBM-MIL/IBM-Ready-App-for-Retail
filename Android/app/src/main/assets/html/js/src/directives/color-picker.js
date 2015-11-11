/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

/**
 *  @class ReadyAppSummit.colorPicker
 *  @memberOf ReadyAppSummit
 *  @description A directive that defines a color picker, which displays a variety of colors as selectable buttons.
 *  This directive is decorated with two attributes: {@linkcode colorOptions} is an array of objects with
 *  color names and hex values. {@linkcode colorPicked} is an optional external function that will be triggered
 *  whenever a color is clicked.
 *  @example
 *  <color-picker color-options="[{color: 'Red', hexColor: '#F00'}]" color-picked="func(color)"></color-picker>
 *  @author James Avery
 *  @copyright © 2015 IBM Corporation. All Rights Reserved.
 */

var readyAppSummit;

(function () {
    'use strict';

    readyAppSummit.directive('colorPicker', function () {

        return {

            restrict: 'E',

            scope: {
                colorOptions: '=',
                colorPicked: '&',
                colorTitle: '@'
            },

            template: "<style>.color-pick-box {width: 25px;height: 25px;padding: 3px;border: 1px;border-style: solid;border-color: #888888;margin: 0px auto;background-color: white;z-index: 10;float: left;position: relative;}.color-pick-box-inner {content: '';display: block;border: 1px;border-style: solid;border-color: #DDD;position: absolute;top: 3px;bottom: 3px;left: 3px;right: 3px;z-index: -1;}.row-of-four > div:nth-of-type(4n+1){clear: both;}</style><div class='row-of-four'><p style='margin-bottom: 10px' ng-if='finalColors.length > 0'>{{colorTitle}}: {{currentColor.color}}</p> <div ng-repeat-start='pick in finalColors' class='color-pick-box' ng-if='currentColor.hexColor == pick.hexColor' ng-click='changeColor($index)'><div class='color-pick-box-inner' style='background-color: {{pick.hexColor}}'></div></div><div class='color-pick-box' style='border-color: #ffffff;' ng-if='currentColor.hexColor != pick.hexColor' ng-click='changeColor($index)'><div class='color-pick-box-inner' style='background-color: {{pick.hexColor}}'></div></div><p ng-repeat-end ng-if='($index % 4) == 3' /></div>",

            link: function (scope) {

                scope.currentElem = 0;

                /* Since we're using two-way binding, we need to encase everything in a watch function. */
                scope.$watch('colorOptions', function () {
                    scope.finalColors = [];

                    /* A function to change the selected color. */
                    scope.changeColor = function (colorIndex) {
                        scope.currentElem = colorIndex;
                        scope.currentColor = scope.colorOptions[scope.currentElem];
                        if (scope.colorPicked !== null && angular.isDefined(scope.colorPicked)) {
                            scope.colorPicked({
                                color: scope.currentColor
                            });
                        }
                    };

                    /* A function to sanitize the received color array. */
                    scope.cleanColors = function (colorArray) {
                        var retArray = [];
                        for (var i = 0; i < colorArray.length; i++) {
                            if ('color' in colorArray[i] && 'hexColor' in colorArray[i]) {
                                retArray.push(colorArray[i]);
                            }
                        }
                        return retArray;
                    };

                    /* Sanitize the provided color array before doing anything else. */
                    if (angular.isDefined(scope.colorOptions) && scope.colorOptions !== null && scope.colorOptions.constructor === Array && scope.colorOptions.length > 0) {
                        scope.finalColors = scope.cleanColors(scope.colorOptions);
                    }

                    /* Initialize a selected color. */
                    if (scope.finalColors.length > 0) {
                        scope.currentColor = scope.finalColors[scope.currentElem];
                    } else {
                        scope.currentColor = {
                            color: "",
                            hexColor: "",
                            url: ""
                        };
                    }
                });

            }

        };

    });
}());