/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

/**
 *  @class ReadyAppSummit.imagePreloader
 *  @memberOf ReadyAppSummit
 *  @description A provider that allows for placeholder images to be displayed while a full image loads, so the entire view is not waiting on an image download before it can display. This provider is created by a factory known as the {@linkcode imagePreloader}.
 *  @property {string} src        - The source for the image to be loaded.
 *  @property {enum} state        - The current loading state of the image.
 *  @enum {number} loaderStates   - An enum with possible loading states.
 *  @example
 *  var loader = new imagePreloader();
 *  loader.src = "image-src.png";
 *  var promise = loader.beginLoad(); // Returns an AJAX promise.
 *  @author Jonathan Ballands
 *  @copyright © 2015 IBM Corporation. All Rights Reserved.
 */

var readyAppSummit, angular;

readyAppSummit.factory('imagePreloader', function ($q, $rootScope) {

    /*
     *  Constructor
     */

    function imagePreloader() {

        this.src = location;

        this.loaderStates = {
            pending: 0,
            loading: 1,
            resolved: 2,
            rejected: 3
        };

        this.state = this.loaderStates.pending;
    }

    /*
     *  Callable
     */

    /**
     *  @function ReadyAppSummit.imagePreloader.prototype.beginLoad
     *  @description Generates an AJAX promise for the image load, and begins the loading process of the image in this.src.
     *  @returns A promise corresponding to the loading of the image.
     */
    imagePreloader.prototype.beginLoad = function () {

        if (angular.isUndefined(this.src) || this.src === null) {
            return undefined;
        }

        // If the preloader is already loading, just return the promise
        if (this.isLoading()) {
            return this.promise;
        }

        // Otherwise, create a new promise
        this.deferred = $q.defer();
        this.promise = this.deferred.promise;

        // Is loading
        this.state = this.loaderStates.loading;
        this.getImageViaAjax();

        return this.promise;
    };

    /**
     *  @function ReadyAppSummit.imagePreloader.prototype.isLoading
     *  @description Determines if the preloader's promise is in a "loading" state.
     *  @returns A boolean indicating whether the promise is loading.
     */
    imagePreloader.prototype.isLoading = function () {
        return this.state === this.loaderStates.loading;
    };

    /**
     *  @function ReadyAppSummit.imagePreloader.prototype.isResolved
     *  @description Determines if the preloader's promise is in a "resolved" state.
     *  @returns A boolean indicating whether the promise is resolved.
     */
    imagePreloader.prototype.isResolved = function () {
        return this.state === this.loaderStates.resolved;
    };

    /**
     *  @function ReadyAppSummit.imagePreloader.prototype.isRejected
     *  @description Determines if the preloader's promise is in a "rejected" state.
     *  @returns A boolean indicating whether the promise is rejected.
     */
    imagePreloader.prototype.isRejected = function () {
        return this.state === this.loaderStates.rejected;
    };

    /*
     *  Helpers
     */

    /**
     *  @function ReadyAppSummit.imagePreloader.prototype.getImageViaAjax
     *  @description Attempts to load this preloader's src image via AJAX.
     */
    imagePreloader.prototype.getImageViaAjax = function () {
        var thisLoader = this;

        var image = $(new Image())
            // On load
            .load(function (event) {
                thisLoader.handleAjaxLoaded(thisLoader.src);
            })
            // On error
            .error(function (event) {
                thisLoader.handleAjaxErrored(thisLoader.src);
            })
            .prop('src', this.src); // The tells 'Image' object what to load
    };

    /**
     *  @function ReadyAppSummit.imagePreloader.prototype.handleAjaxLoaded
     *  @description Changes the loader state and promise state to indicate that the promise was resolved.
     *  @param {string} url The source URL for the image.
     */
    imagePreloader.prototype.handleAjaxLoaded = function (url) {
        var thisLoader = this;
        $rootScope.$apply(function () {
            thisLoader.state = thisLoader.loaderStates.resolved;
            thisLoader.deferred.resolve(thisLoader.src);
        });
    };

    /**
     *  @function ReadyAppSummit.imagePreloader.prototype.handleAjaxErrored
     *  @description Changes the loader state and promise state to indicate that the promise was rejected.
     *  @param {string} url The source URL for the image.
     */
    imagePreloader.prototype.handleAjaxErrored = function (url) {
        var thisLoader = this;
        $rootScope.$apply(function () {
            thisLoader.state = thisLoader.loaderStates.rejected;
            thisLoader.deferred.reject(thisLoader.src);
        });
    };

    // Return the constructor
    return imagePreloader;

});