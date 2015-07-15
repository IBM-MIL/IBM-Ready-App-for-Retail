/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

/**
 *  @class ReadyAppSummit.textExpander
 *  @memberOf ReadyAppSummit
 *  @description A directive that creates a text box that smoothly reveals and hides itself when the
 *  title area is clicked. This directive is decorated with four attributes: {@linkcode title} specifies the text
 *  to be displayed in the title area. {@linkcode text} specifies the text that will be shown or hidden.
 *  {@linkcode buttonImage} is an optional attribute for specifying an image that will exist to the right of the
 *  title. {@linkcode buttonRotation} is an optional attribute to specify the number of degrees the
 *  {@linkcode buttonImage} will rotate when the text is shown; negative values indicate counterclockwise rotation.
 *  @example
 *  <text-expander title="Lorem" text="Ipsum" button-image="arrow-button.jpg" button-rotation="90"></text-expander>
 *  @author James Avery
 *  @copyright © 2015 IBM Corporation. All Rights Reserved.
 */

var readyAppSummit;

(function () {
    'use strict';
    readyAppSummit.directive('textExpander', function () {

        return {

            restrict: 'E',

            scope: {
                title: '@',
                text: '@',
                buttonImage: '@',
                buttonRotation: '@'
            },

            /*template: "<style>.titleText{font-family: 'Oswald';font-size:16pt;margin-bottom: 25px;}.titleText span:last-child{float: right;}.expandButton{height: auto; width: 18px;-webkit-transition: all ease 0.3s;transition: all ease 0.3s;}.detailsText{margin-bottom: 25px;font-family: 'OpenSansRegular';font-size: 14pt;}.rotateButton{-webkit-transform: rotate({{buttonRotation}}deg);transform: rotate({{buttonRotation}}deg);}.hideAnimation.ng-hide-add, .hideAnimation.ng-hide-remove{-webkit-transition: all ease 0.6s;transition: all ease 0.6s;}.hideAnimation.ng-hide-add{max-height: 300px;margin-bottom: 25px;overflow: hidden;}.hideAnimation.ng-hide-add-active{max-height: 0px;margin-bottom: 0px;}.hideAnimation.ng-hide-remove{max-height: 0px;margin-bottom: 0px;overflow: hidden;}.hideAnimation.ng-hide-remove-active{max-height: 300px;margin-bottom: 25px;}</style><div class='titleText' ng-click='displayText = !displayText'><span>{{title}}</span><span><img class='expandButton' src='{{buttonImage}}' ng-class='{rotateButton: !displayText}'></span></div><div class='detailsText hideAnimation' ng-show='displayText'>{{text}}</div>",*/
            template: "<style>.titleText{font-family: 'Oswald';font-size:16pt;margin-bottom: 25px;}.titleText span:last-child{float: right;}.expandButton{height: auto; width: 18px;-webkit-transition: all ease 0.3s;transition: all ease 0.3s;}.detailsText{padding-bottom: 0px;font-family: 'OpenSansRegular';line-height: 140%;}.rotateButton{-webkit-transform: rotate({{buttonRotation}}deg);transform: rotate({{buttonRotation}}deg);}.hideAnimation.ng-hide-add, .hideAnimation.ng-hide-remove{-webkit-transition: all ease 0.6s;transition: all ease 0.6s;}.hideAnimation.ng-hide-add{max-height: 300px;padding-bottom: 0px;overflow: hidden;}.hideAnimation.ng-hide-add-active{max-height: 0px;padding-bottom: 0px;}.hideAnimation.ng-hide-remove{max-height: 0px;padding-bottom: 0px;overflow: hidden;}.hideAnimation.ng-hide-remove-active{max-height: 300px;padding-bottom: 0px;}</style><div class='titleText' ng-click='displayText = !displayText'><span>{{title}}</span><span><img class='expandButton' src='{{buttonImage}}' ng-class='{rotateButton: !displayText}'></span></div><div class='detailsText hideAnimation' ng-show='displayText'>{{text}}</div>",

            link: function (scope) {
                scope.displayText = true;
            }

        };

    });
}());