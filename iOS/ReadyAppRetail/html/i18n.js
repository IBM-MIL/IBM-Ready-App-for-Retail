/*
 *  Licensed Materials - Property of IBM
 *  © Copyright IBM Corporation 2015. All Rights Reserved.
 */

(function () {
    'use strict';

    readyAppSummit.config(function ($translateProvider) {

        /*
         *  English
         */
        $translateProvider.translations('en', {
            addToCart: "Add to Cart",
            addToList: "Add to Listkk",

            detailsTitle: "Product Details",

            colorTitle: "Color"
        });

        /*
         *  English US
         */
        $translateProvider.translations('en_US', {
            addToCart: "Add to Cart",
            addToList: "Add to List",

            detailsTitle: "Product Details",

            color: "Color"
        });
                          
    $translateProvider.translations('es', {
                                            addToCart: "Add to Cart",
                                            addToList: "Agregar a Lista",
                                                          
                                            detailsTitle: "Detalle de Producto",
                                                          
                                            color: "Color"
    });
                          

        $translateProvider.preferredLanguage('es');

        $translateProvider.fallbackLanguage('es');
    });
}());