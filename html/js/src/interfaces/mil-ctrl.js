/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

/**
 *  @class ReadyAppSummit.milCtrl
 *  @memberOf ReadyAppSummit
 *  @description The basis for every controller in a ReadyApp. It is recommened that every controller in a ReadyApp
 *  extends this to recieve useful functionality that's common between ReadyApps.
 *  @property {string} agent                - The browser rendering the app.
 *  @property {boolean} canProcessRoutes    - True if this controller is allowed to process route changes,
 *  false if the controller should ignore actions that may cause a route change. This prevents the hybrid view
 *  from suddenly changing route unexpectedly while the client is processing native code.
 *  @author Jonathan Ballands
 *  @copyright © 2015 IBM Corporation. All Rights Reserved.
 */

var readyAppSummit;

(function () {
    'use strict';
    readyAppSummit.controller('milCtrl', function ($scope, $location, $route, $rootScope, $translate) {

        // Used to identify the agent
        $scope.agent = navigator.userAgent.toLowerCase();

        // Used to determine if the route should change
        $scope.canProcessRoutes = true;

        // Used to hold all endpoints in the child controller
        var endpoints = [];

        // Used to hold the injected JSON
        var injectedJSON;

        /**
         *  @function ReadyAppSummit.milCtrl.switchRoute
         *  @description An extension of the {@linkcode $location}.{@linkcode path} service that allows you to specify
         *  if you want the page to refresh or not when the path changes.
         *  @param {string} path The path you want to navigate to.
         *  @param {boolean} reload True if you want the page to reload, false if not.
         */
        $scope.switchRoute = function (path, reload) {

            if (!$scope.canProcessRoutes) {
                //console.warn('milCtrl: A route change was requested, but the hybrid has surrendered routing control at this time. (Did you call resumeRouteControl() first?)');
                return undefined;
            }

            if (reload === false) {
                var lastRoute = $route.current;

                var un = $rootScope.$on('$locationChangeSuccess', function () {
                    $route.current = lastRoute;
                    un();
                });
            }
            return $location.path(path);
        };

        /**
         *  @function ReadyAppSummit.milCtrl.setLanguage
         *  @description Sets the language to be used, using {@linkcode i18n.js} as the language reference.
         *  The default language is English.
         *  @param {string} lang The locale code for the language to be used. (Ex: en, fr, es, de, etc.)
         */
        $scope.setLanguage = function (lang) {
            $translate.use(lang);
            // Reload
            $route.reload();
        };

        /**
         *  @function ReadyAppSummit.milCtrl.injectData
         *  @description Used by the client to inject JSON data into the hybrid, firing off the
         *  {@linkcode raOnData} event.
         *  @param {json} data JSON data that you want to inject into the hybrid.
         */
        $scope.injectData = function (data) {
            injectedJSON = data;
            $scope.$broadcast('raOnData');
        };

        /**
         *  @function ReadyAppSummit.milCtrl.getData
         *  @description Used to access the {@linkcode injectedJSON} that was supplied via the
         *  {@linkcode injectData} function. If the data doesn't exist or doesn't exist in the correct type,
         *  this function will construct a new object of type {@linkcode expected} for you and return
         *  it immediately, outputing the appropriate warnings to the console.
         *  @param {string} key The key for the data you want from {@linkcode injectedJSON}.
         *  @param {constructor} expected The constructor function for the type of value you want;
         *  this is used to cross-reference that the value being returned matches the value you're
         *  exepcting. So, for example, if you wanted a key that should be of type Array, you would use the
         *  constructor {@linkcode Array} for this argument.
         *  @returns {any} Data that matches the class defined by {@linkcode expected}.
         *  @example
         *  // Returns data for key dogBreeds of type Array, if possible
         *  $scope.getData('dogBreeds', Array);
         */
        $scope.getData = function (key, expected) {

            // No injected data?
            if (angular.isUndefined(injectedJSON) || injectedJSON === null) {
                //console.warn('milCtrl: Will not attempt to access the key when no JSON was injected. This warning may be short-sighted and the data may arrive shortly, in which case this message may be disregarded. Otherwise: Did you forget to inject JSON first?');

                return undefined;
            }
            // Loop through keys
            for (var k in injectedJSON) {
                var match = eval('injectedJSON.' + key);

                if (match && match instanceof expected) {
                    return match;
                }
                // Handle strings especially
                else if (match && typeof match === 'string' && expected === String) {
                    return match;
                }
                // Handle numbers especially
                else if (match && typeof match === 'number' && expected === Number) {
                    return match;
                }
            }
            // Otherwise, no key was found...
            //console.warn('milCtrl: There was no match in the injected JSON for the key ' + key + '. Are you sure that ' + key + ' is of the type you were expecting? Are you sure that ' + key + ' exists?');

            return undefined;
        };

        /*
         *  Listen for when the view content has loaded; this event is emitted automatically by Angular.
         */
        $scope.$on('$viewContentLoaded', function () {
            $scope.switchRoute("/CallBack/Ready", false);
        });

        // Begin broadcasting
        $scope.$broadcast('raOnData');

    });
}());