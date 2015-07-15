/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

/**
 *  @class ReadyAppSummit.milCtrl.productDetailsCtrl
 *  @augments ReadyAppSummit.milCtrl
 *  @memberOf ReadyAppSummit
 *  @description Controller for the product details view that allows you to specific details about a product
 *  in Summit, including: reviews, price, similar items, and the ability to add the currently viewed item to
 *  a list or to your cart.
 *  @property {string} addToCart        - The text for the 'Add to Cart' button.
 *  @property {string} addToList        - The text for the 'Add to List' button.
 *  @property {string} colorTitle       - The title to give to the color swatches.
 *  @property {boolean} shouldPadBottom - A flag that's {@linkcode true} when padding should be alotted for the
 *                                        iOS tab bar, {@linkcode false} if there should be no padding.
 *  @property {boolean} imageIsLoading  - A flag that's {@linkcode true} when the loading image should be 
 *                                        displayed, {@linkcode false} to display something else.
 *  @property {boolean} imageLoadWasSuccessful - Only matters if {@linkcode imageIsLoading} is {@linkcode false}.
 *                                               {@linkcode true} to display the image of the product 
                                                 loaded from the server, {@linkcode false} to show error text.
 *  @property {string} productName      - The name of the product this view is presenting.
 *  @property {string} imageData        - A base64 encoding of the image reprsenting the product.
 *  @property {number} rating           - The number of stars (between 0 and 5) this product recieved.
 *  @property {string} availability     - Indicates the availability of the product.
 *  @property {string} location         - The department or asile the item is located in the store.
 *  @property {string} currentPrice     - The current price of the product, whether the regular price or a
 *  discounted price. Displays in gold in the view.
 *  @property {string} oldPrice         - The regular price for the product, usually when there is a
 *  discounted price present. If there is no discounted price, this property should be {@linkcode null}.
 *  Displays in gray and crossed-out in the view.
 *  @property {array} colorData        - An array of objects that represent the color options for a product.
 *  Use {@linkcode null} for no colors.
 *  @property {object} optionsData         - An object with a {@linkcode name} property and a {@linkcode values}
 *  property that represent options for the product (for example, shoe size, shirt size, etc.). Use
 *  {@linkcode null} for no options.
 *  @see {@linkcode product-details.html}
 *  @author Jonathan Ballands
 *  @author Jim Avery
 *  @copyright © 2015 IBM Corporation. All Rights Reserved.
 */

var readyAppSummit, angular;

(function () {
    'use strict';

    readyAppSummit.controller('productDetailsCtrl', function ($scope, $translate, $filter, imagePreloader, $controller, $timeout) {

        // Inheritance
        angular.extend(this, $controller('milCtrl', {
            $scope: $scope
        }));

        var loader = new imagePreloader();

        $scope.imageIsLoading = true;
        $scope.imageLoadWasSuccessful = false;

        $scope.addToCart = $filter("translate")("addToCart");
        $scope.addToList = $filter("translate")("addToList");

        $scope.colorTitle = $filter("translate")("colorTitle");

        $scope.shouldPadBottom = $scope.agent.indexOf('chrome') < 0;
        //console.log($scope.shouldPadBottom);

        $scope.$on('raOnData', function () {
            $scope.availability = $scope.getData('availability', String);
            $scope.location = $scope.getData('location', String);

            $scope.productName = $scope.getData('name', String);

            $scope.rating = $scope.getData('rating', Number);

            var p = $scope.getData('salePrice', String);
            if (p) {
                $scope.currentPrice = p;
                $scope.oldPrice = $scope.getData('price', String);
            } else {
                $scope.currentPrice = $scope.getData('price', String);
            }

            $scope.colorData = $scope.getData('colorOptions', Array);

            $scope.optionsData = $scope.getData('option', Object);

            $scope.detailsTitle = $filter('translate')('detailsTitle');
            $scope.detailsBody = $scope.getData('description', String);

            // Handle images especially
            $scope.src = $scope.getData('imageUrl', String);
            loader.src = $scope.src;
            var promise = loader.beginLoad();
            if (promise) {
                promise.then(
                    function handleResolve(src) {
                        $scope.imageIsLoading = false;
                        $scope.imageLoadWasSuccessful = true;
                    },
                    function handleReject(src) {
                        $scope.imageIsLoading = false;
                        $scope.imageLoadWasSuccessful = false;
                    });
            }
        });

        /**
         *  @function ReadyAppSummit.milCtrl.productDetailsCtrl.fetchNewImage
         *  @description A callback for the {@linkcode colorPicker} directive that gets invoked
         *  when a new color swatch is selected. This allows a new image with the correct color of the item
         *  to display.
         *  @param {object} color A color object that contains a {@linkcode url} property to grab the image from.
         */
        $scope.fetchNewImage = function (color) {
            $scope.src = color.url;
            loader.src = $scope.src;

            $scope.imageIsLoading = true;
            $scope.imageLoadWasSuccessful = true;

            var promise = loader.beginLoad();
            if (promise) {
                promise.then(
                    function handleResolve(src) {
                        $scope.imageIsLoading = false;
                        $scope.imageLoadWasSuccessful = true;
                    },
                    function handleReject(src) {
                        $scope.imageIsLoading = false;
                        $scope.imageLoadWasSuccessful = false;
                    });
            }
        };

        var buttonReady = true;
        /**
         *  @function ReadyAppSummit.milCtrl.productDetailsCtrl.addToListClicked
         *  @description A function is called when the 'Add to List' button is clicked. This causes
         *  the route to switch momentarily to allow the native end to detect the change, and then switches
         *  the route back again so that the native can begin listening once more. Causes the button to be
         *  disabled briefly while the route resets.
         */
        $scope.addToListClicked = function () {
            // Time out for a second and then flip back so the native can start listening again
            // This is kind of hacky...
            if (buttonReady) {
                buttonReady = false;
                $scope.switchRoute('/NativeView/AddToList', false);
                $timeout(function () {
                    $scope.switchRoute('/CallBack/Done', false);
                    buttonReady = true;
                }, 1000);
            }
        };

    });
}());