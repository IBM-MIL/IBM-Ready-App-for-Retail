//
//  XLXtifyOptions.m
//  XtifyLib
//
//  Created by Gilad on 8/Jan/12
/*
 * IBM Confidential
 * OCO Source Materials
 * 5725E28, 5725I03
 * (c) Copyright IBM Corp. 2011, 2014.
 * The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office. */
//

#import "XLXtifyOptions.h"
#import "XtifyGlobal.h"
#import <UIKit/UIKit.h>

static XLXtifyOptions* xXtifyOptions = nil;

@implementation XLXtifyOptions

+ (XLXtifyOptions*)getXtifyOptions
{
    if (xXtifyOptions == nil) {
        xXtifyOptions = [[XLXtifyOptions alloc] init];
    }
    return xXtifyOptions;
}

- (id)init
{
    if (self = [super init]) {
        xoAppKey = xAppKey;
        xoLocationRequired = xLocationRequired;
        xoBackgroundLocationRequired = xRunAlsoInBackground;
        xoLogging = xLogging;
        xoMultipleMarkets = xMultipleMarkets;
        xoNewsstandContent = xNewsstandContent;
        xoManageBadge = xBadgeManagerMethod;
        xoGeofenceEnabled = xGeofenceEnabled;
        xoBeaconSupport = xBeaconSupport;
        xoUUID = xUUID;
        xoDesiredLocationAccuracy = xDesiredLocationAccuracy;
    }
    return self;
}

- (BOOL)isBeaconSupportEnabled
{
    return xoBeaconSupport;
}
- (NSString*)getUUID
{
    return xoUUID;
}
- (NSString*)getAppKey
{
    return xoAppKey;
}
- (BOOL)isLocationRequired
{
    return xoLocationRequired;
}
- (BOOL)isBackgroundLocationRequired
{
    return xoBackgroundLocationRequired;
}
- (BOOL)isLogging
{
    return xoLogging;
}
- (BOOL)isMultipleMarkets
{
    return xoMultipleMarkets;
}
- (BOOL)isNewsstandContent
{
    return xoNewsstandContent;
}

- (BOOL)isGeofenceEnabled
{
    return xoGeofenceEnabled;
}

- (XLBadgeManagedType)getManageBadgeType
{
    return xoManageBadge;
}
- (CLLocationAccuracy)geDesiredLocationAccuracy
{
    return xoDesiredLocationAccuracy;
}
- (void)xtLogMessage:(NSString*)header content:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    if (xoLogging) {
        NSString* prettyFmt = [NSString stringWithFormat:@"%@ %@", header, format];
        NSLogv(prettyFmt, args);
    }
    va_end(args);
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (void)registerForPush
{
    [self xtLogMessage:XTLOG content:@"Attempt to register for push notifications..."];

    UIApplication* app = [UIApplication sharedApplication];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

    if ([app respondsToSelector:@selector(registerForRemoteNotifications)]) {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:types categories:self.categories];
        [app registerUserNotificationSettings:settings];
        [app registerForRemoteNotifications];
    }
    else {
#endif
        UIRemoteNotificationType types = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        if ([[XLXtifyOptions getXtifyOptions] isNewsstandContent])
            types = UIRemoteNotificationTypeNewsstandContentAvailability | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [app registerForRemoteNotificationTypes:types];
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    }
#endif
}

@end
