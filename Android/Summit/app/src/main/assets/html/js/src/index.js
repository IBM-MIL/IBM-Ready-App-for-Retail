/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

/**
 *  @namespace ReadyAppSummit
 *  @description Defines the {@linkcode ReadyAppSummit} module. You may notice that a module called
 *  {@linkcode ReadyAppSummitMocks} exists in the dependencies section of this module;
 *  @requires ngRoute
 *  @requires ngTouch
 *  @requires pascalprecht.translate
 *  @requires ReadyAppSummitMocks
 *  @author Jonathan Ballands
 *  @author Jim Avery
 *  @copyright © 2015 IBM Corporation. All Rights Reserved.
 */

var angular;

'use strict';

var readyAppSummit = angular.module('ReadyAppSummit', ['ngRoute', 'ngTouch', 'ngAnimate', 'pascalprecht.translate']);