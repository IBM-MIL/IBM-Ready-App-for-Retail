/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

/**
 *  @class ReadyAppSummit.starRatingViewer
 *  @memberOf ReadyAppSummit
 *  @description A directive that defines a collection of five images that can be displayed in 2 states:
 *  full or empty. Typically, this directive should be used to give items "star ratings" on a 5-star scale,
 *  with 5 stars being the best and 0 stars being the worst. This directive is decorated with three attributes:
 *  {@linkcode rating}, the number of items in the collection that you want filled in, {@linkcode fullPath}, a
 *  path to the image that depicts the "full" state, and {@linkcode emptyPath}, a path to the image that
 *  depicts the "empty" state. You may change the dimensions of the images by applying CSS rules to
 *  {@linkcode img} tags that are nested within this {@linkcode starRatingViewer}.
 *  @example
 *  <star-rating-viewer rating="4" fullStarPath="./img/fullStar.png" emptyStarPath="./img/emptyStar.png"></star-rating-viewer>
 *  @author Jonathan Ballands
 *  @copyright © 2015 IBM Corporation. All Rights Reserved.
 */

var readyAppSummit;

(function () {
    'use strict';
    readyAppSummit.directive('ratingViewer', function () {

        return {

            restrict: 'E',

            scope: {
                rating: '=',
                fullPath: '@',
                emptyPath: '@'
            },

            template: "<img src='{{availables[0]}}'><img src='{{availables[1]}}'><img src='{{availables[2]}}'><img src='{{availables[3]}}'><img src='{{availables[4]}}'>",

            link: function (scope) {

                scope.$watch('rating', function () {
                    scope.availables = [scope.emptyPath, scope.emptyPath, scope.emptyPath, scope.emptyPath, scope.emptyPath];

                    for (var i = 0; i < scope.rating; i++) {
                        scope.availables[i] = scope.fullPath;
                    }
                });

            }

        };

    });
}());