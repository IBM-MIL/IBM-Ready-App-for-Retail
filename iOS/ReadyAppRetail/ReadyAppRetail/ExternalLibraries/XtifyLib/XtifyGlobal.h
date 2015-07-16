//
// XtifyGlobal.h
//  XtifyLib
//
//  Created by Gilad on 8/Jun/11
/*
 * IBM Confidential
 * OCO Source Materials
 * 5725E28, 5725I03
 * (c) Copyright IBM Corp. 2011, 2014.
 * The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office. */
//
//
// For help, visit: http://developer.xtify.com
//xSdkVer				@"v2.76" // internal xtify sdk version

// Xtify AppKey
//
// Enter the AppKey assigned to your app at http://console.xtify.com
// Nothing works without this.

#define DEV 1

#ifdef DEV
#define xAppKey @"Your-Xtify-Development-Key" // development
#endif

#ifndef DEV
#define xAppKey @"Your-Xtify-Production-Key" // production
#endif
//
// Location updates
//
// Set to YES to let Xtify receive location updates from the user. The user will also receive a prompt asking for permission to do so.
// Set to NO to completely turn off location updates. No prompt will appear. Suitable for simple/rich notification push only

#define xLocationRequired YES

// Background location update
//
// Set this to TRUE if you want to also send location updates on significant change to Xtify while the app is in the background.
// Set this to FALSE if you want to send location updates on significant change to Xtify while the app is in the foreground only.

#define xRunAlsoInBackground TRUE

// Desired location accuracy
//
// If using location feature, set xDesiredLocationAccuracy value to one of the following. (Keep in mind, there is a trade off between battery life and accuracy. The higher the accuracy the longer it takes to find the position and the greater the battery consumtion is).
//      kCLLocationAccuracyBestForNavigation, kCLLocationAccuracyBest, kCLLocationAccuracyNearestTenMeters,
//      kCLLocationAccuracyHundredMeters, kCLLocationAccuracyKilometer, kCLLocationAccuracyThreeKilometers
// For a detailed description about these options, please visit the Apple Documentation at the url:
// http://developer.apple.com/library/ios/#documentation/CoreLocation/Reference/CLLocationManager_Class/CLLocationManager/CLLocationManager.html

#define xDesiredLocationAccuracy kCLLocationAccuracyKilometer // kCLLocationAccuracyBest

// Badge management
//
// Set to XLInboxManagedMethod to let the Xtify SDK manage the badge count on the client and the server
// Set to XLDeveloperManagedMethod if you want to handle updating the badge on the client and server (you'll need to create your own method)
// We've included an example on how to set/update the badge in the main delegate file within our sample apps

#define xBadgeManagerMethod XLInboxManagedMethod
//#define xBadgeManagerMethod XLDeveloperManagedMethod

// Logging Flag
//
// To turn on logging change xLogging to true
#define xLogging TRUE

// Newsstand Content Notification Type
//
// Set to true to let UIRemoteNotificationTypeNewsstandContentAvailability in Apple push registration
// If set to true, badge count doesn't change from push payload
#define xNewsstandContent FALSE

// Geofence is a premium feature that supports dynamic regional tracking. This feature will only work with Enterprise accounts. Please inquire with Xtify to enable this feature.
#define xGeofenceEnabled FALSE

// iBeacon is a premium feature that supports dynamic Apple iBeacon tracking. This feature will only work with Enterprise accounts. Please inquire with Xtify to enable this feature.
#define xBeaconSupport FALSE

// iBeacon UUID
// Enter the UUID that you are using with your iBeacons if you want to
// use iBeacon support
#define xUUID @"REPLACE_WITH_YOUR_UUID"

// This is a premium feature that supports a regional control of messaging by multiple user governed by one primary organization account. Suitable for organizations that have multiple geographical regions or franchise business models. This feature will only work with Enterprise accounts. Please inquire with Xtify to enable this feature.

#define xMultipleMarkets FALSE
