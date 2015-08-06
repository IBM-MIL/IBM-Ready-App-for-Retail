// Uncomment the initialization options as required. For advanced initialization options please refer to IBM MobileFirst Platform Foundation Knowledge Center 
 
 var wlInitOptions = {
	
	// # To disable automatic hiding of the splash screen uncomment this property and use WL.App.hideSplashScreen() API
	//autoHideSplash: false,
		 
	// # The callback function to invoke in case application fails to connect to MobileFirst Server
	//onConnectionFailure: function (){},
	
	// # MobileFirst Server connection timeout
	//timeout: 30000,
	
	// # How often heartbeat request will be sent to MobileFirst Server
	//heartBeatIntervalInSecs: 20 * 60,
	
	// # Enable FIPS 140-2 for data-in-motion (network) and data-at-rest (JSONStore) on iOS or Android.
	//   Requires the FIPS 140-2 optional feature to be enabled also.
	//enableFIPS : false,
	
	// # The options of busy indicator used during application start up
	//busyOptions: {text: "Loading..."}
};

if (window.addEventListener) {
	window.addEventListener('load', function() { WL.Client.init(wlInitOptions); }, false);
} else if (window.attachEvent) {
	window.attachEvent('onload',  function() { WL.Client.init(wlInitOptions); });
}
