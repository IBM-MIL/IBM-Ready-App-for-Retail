/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

describe('imagePreloaderFactory', function () {

    /*
     *  Setup
     */

    // Mock ReadyAppSummit
    beforeEach(module('ReadyAppSummit'));

    // Retrieve providers
    var preloaderFactory, preloader, $httpBackend, $rootScope;

    // Create milCtrl
    beforeEach(inject(function (_imagePreloader_, _$httpBackend_, _$rootScope_) {
        preloaderFactory = _imagePreloader_;
        preloader = new preloaderFactory();
        
        $httpBackend = _$httpBackend_;
        $rootScope = _$rootScope_;
    }));
    
    /*
     *  Specs
     */

    it('should be able to resolve a promise', function (done) {
        // Setup the preloader
        preloader.src = 'http://cute-n-tiny.com/wp-content/uploads/2010/12/cute-cool-corgis.jpg';
        
        var promise = preloader.beginLoad();
        
        promise.then(function (response) {
            expect(preloader.isResolved()).toBeTruthy();
            done();
        }, function (reason) {
            // Should not reject
            fail('Should not reject image data');
            done();
        });
    });

    it('should be able to reject a promise', function (done) {
        // Setup the preloader
        preloader.src = '/some/path/to/resoruce';
        $httpBackend.whenGET('/some/path/to/resoruce').respond('not an image');
        
        var promise = preloader.beginLoad();
        
        promise.then(function (response) {
            // Should not resolve
            fail('Should not resolve bad image data');
            done();
        }, function (reason) {
            expect(preloader.isRejected()).toBeTruthy();
            done();
        });
    });

    // Done Testing

});