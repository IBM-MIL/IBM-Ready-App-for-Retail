/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

/**
 *  @class ReadyAppSummit.dropDown
 *  @memberOf ReadyAppSummit
 *  @description A directive that automates the creation of a stylized drop down menu, functionally
 *  equivalent to an HTML <select>. This directive is decorated with three attributes: {@linkcode name}
 *  optionally provides a name to the internal <select> so that its data can be acquired by an HTML form.
 *  {@linkcode dropData} is an object consisting of a {@linkcode name}, which is the header text, and
 *  {@linkcode values}, which is an array of values that will populate the drop-down menu.
 *  {@linkcode buttonImage} is an optional image that displays on the right side of the menu.
 *  @example
 *  <drop-down name="formName" dropData="{name: 'Lorem Ipsum', values: [1,2,3]}" buttonImage="down-arrow.png"></drop-down>
 *  @author Jim Avery
 *  @copyright © 2015 IBM Corporation. All Rights Reserved.
 */

var readyAppSummit;

(function () {
    'use strict';
    readyAppSummit.directive('dropDown', function ($window) {

        return {

            restrict: 'E',

            scope: {
                name: '@',
                dropData: '=',
                buttonImage: '@'
            },

            template: "<style>.dropDownBox{}.dropDownText{text-align: right;margin-bottom: 7px;}.dropDownSelect{float: right;-webkit-appearance: none;-moz-appearance: none;appearance: none;padding: 5px 35px 5px 12px;font-size: 16px;border: 2px #ddd solid;background: transparent;background: url('{{buttonImage}}') 80% / 15px no-repeat #fff;background-position: right 10px center;}</style><div class='dropDownBox' ng-if='displayDropdown'><p class='dropDownText'>{{selectTitle}}<span ng-if='dropData.values.length == 1'>: {{dropData.values[0]}}</span></p><select class='dropDownSelect' name='{{name}}' ng-if='dropData.values.length > 1'><option ng-repeat=\"option in selectOptions | orderBy:'value'\" value='{{option.value}}'>{{option.display}}</option></select></div>",

            link: function (scope) {

                /* Since we're using two-way binding, we need to encase everything in a watch function. */
                scope.$watch('dropData', function () {
                    scope.displayDropdown = true;
                    scope.selectOptions = [];

                    /* A function to loop over all the strings and trim them. This is separated out because
                     * we may have to redo it multiple times. */
                    scope.trimStrings = function (stringArray, lengthLimit, useColorPicker, listButtonDropped, cartButtonDropped) {
                        var retArray = [];

                        /* Iterate over and truncate every string to fit the window. */
                        for (var i = 0; i < stringArray.length; i++) {
                            retArray.push(String(stringArray[i]));

                            /* We also need a minimum length, to avoid an infinite loop when the
                             * window gets too small. The minimum length is the first character
                             * plus an ellipsis. */
                            var canvas = $document.createElement('canvas');
                            var context = canvas.getContext('2d');
                            context.font = "16px Oswald";
                            var minLength = context.measureText(retArray[i].charAt(0) + "…").width;

                            /* Here's where we loop over an individual string to get its length where it needs to be. */
                            var length = context.measureText(retArray[i]).width;
                            while (length > lengthLimit && length > minLength) {
                                retArray[i] = retArray[i].slice(0, -2) + "…";
                                length = context.measureText(retArray[i]).width;

                                /* Have we reached our truncate limit? If so, act accordingly. If we can still drop buttons
                                 * down, we'll return null, which is the signal to the outer function to adjust the lengthLimit
                                 * and try again. Otherwise, we just need to shorten it as much as possible. */
                                if (length <= minLength && !useColorPicker) {
                                    if (!cartButtonDropped || !listButtonDropped) {
                                        return null;
                                    }

                                    /* One last measurement to make sure the loop runs correctly. */
                                    length = context.measureText(retArray[i]).width;
                                }
                            }
                        }

                        return retArray;
                    };

                    /* We may need to truncate some of the strings, if they get too long. */
                    scope.truncateValues = function (optionArray, windowWidth) {
                        var retArray = [];

                        /* Need to determine the maximum allowable length for a select string.
                         * Depending on the other injected data, we may be sizing based on either the
                         * color picker or the Cart/List buttons. */
                        /* The full window size, with padding. */
                        var lengthLimit = windowWidth - 50;

                        /* The size of the two buttons, with padding. */
                        var canvas = $document.createElement('canvas');
                        var context = canvas.getContext('2d');
                        context.font = "11pt OpenSansRegular";
                        var listButtonWidth = context.measureText(String(scope.$parent.addToList)).width + 33;
                        var cartButtonWidth = context.measureText(String(scope.$parent.addToCart)).width + 33;

                        /* The size of the color picker. It's either the longest possible Color string or
                         * the length of all the blocks, whichever is longer. Note that we cap the color
                         * picker at four columns of color blocks. */
                        var colorPickerLen = 0;
                        var colorArrayLen = 0;
                        var useColorArray = false;
                        var colorArray = scope.$parent.colorData;
                        var colorTitle = String(scope.$parent.colorTitle);
                        if (colorArray !== null && angular.isDefined(colorArray)) {
                            for (var i = 0; i < colorArray.length; i++) {
                                if ('color' in colorArray[i] && 'hexColor' in colorArray[i]) {
                                    colorArrayLen += 1;
                                }
                            }
                            if (colorArrayLen > 4) {
                                colorArrayLen = 4;
                            }
                            useColorArray = colorArrayLen > 0;
                            var colorBlocksLen = 31 * colorArrayLen;
                            /* Measure the length of the longest string. */
                            var maxColorStringLen = 0;
                            context.font = "16pt OpenSans";
                            var colorTitleLen = context.measureText(String(colorTitle)).width;
                            for (i = 0; i < colorArray.length; i++) {
                                var colorStringLen = context.measureText(String(colorArray[i].color)).width + colorTitleLen;
                                if (colorStringLen > maxColorStringLen) {
                                    maxColorStringLen = colorStringLen;
                                }
                            }
                            /* Which of the above two measurements is longest? */
                            colorPickerLen = Math.max(colorBlocksLen, maxColorStringLen) + 5;
                        }

                        /* Which one do we look at? If there's at least one valid color in the color picker,
                         * then we'll base what we're doing on that. */
                        if (useColorArray) {
                            lengthLimit -= colorPickerLen;
                        } else {
                            lengthLimit -= listButtonWidth;
                            lengthLimit -= cartButtonWidth;
                        }

                        /* The size of the select box without the text. */
                        lengthLimit -= 61;

                        /* The trimStrings function will handle the actual string trimming, appropriately. We
                         * need to control the parameters and any possible restarts. For example, if it turns
                         * out a button is going to drop down, we need to re-measure and restart completely. */
                        retArray = scope.trimStrings(optionArray, lengthLimit, useColorArray, false, false);
                        /* Do we need to drop the cart button? */
                        if (retArray == null) {
                            lengthLimit += cartButtonWidth;
                            retArray = scope.trimStrings(optionArray, lengthLimit, useColorArray, false, true);
                        }
                        /* Do we need to drop the list button? */
                        if (retArray == null) {
                            lengthLimit += listButtonWidth;
                            retArray = scope.trimStrings(optionArray, lengthLimit, useColorArray, true, true);
                        }

                        return retArray;
                    };

                    /* The function to generate the options array. Includes windowWidth as a
                     * parameter for easier unit testing. */
                    //scope.getOptions = function (providedValues, windowWidth) {
                    scope.getOptions = function (providedValues) {
                        var retArray = [];

                        var valuesArray = providedValues;
                        //var displaysArray = scope.truncateValues(providedValues, windowWidth);
                        var displaysArray = providedValues;
                        for (var i = 0; i < valuesArray.length; i++) {
                            retArray.push({
                                display: displaysArray[i],
                                value: valuesArray[i]
                            });
                        }

                        return retArray;
                    };

                    /* If the data is invalid in some way, the drop down will not display at all. */
                    if (angular.isDefined(scope.dropData) && scope.dropData !== null && scope.dropData.constructor === Object &&
                        'name' in scope.dropData && scope.dropData.name != null && scope.dropData.name.constructor === String &&
                        'values' in scope.dropData && scope.dropData.values != null && scope.dropData.values.constructor === Array && scope.dropData.values.length > 0) {
                        scope.selectTitle = scope.dropData.name;

                        /* We're going to have an array of objects, with a string to be displayed and a string
                         * representing the actual value. This is useful for truncating display string. */
                        //scope.selectOptions = scope.getOptions(scope.dropData.values, $window.outerWidth - 10);
                        scope.selectOptions = scope.getOptions(scope.dropData.values);
                    } else {
                        scope.displayDropdown = false;
                        scope.selectTitle = "";
                    }
                });

                /* We need to dynamically resize the select when the window resizes. */
                angular.element($window).bind('resize', function () {
                    scope.$apply(function () {
                        //scope.selectOptions = scope.getOptions(scope.dropData.values, $window.outerWidth - 10);
                        scope.selectOptions = scope.getOptions(scope.dropData.values);
                    });
                });
            }

        };

    });
}());