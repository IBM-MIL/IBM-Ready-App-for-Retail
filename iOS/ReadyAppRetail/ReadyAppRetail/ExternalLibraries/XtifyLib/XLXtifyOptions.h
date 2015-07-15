//
//  XLXtifyOptions.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum _XLBadgeManagedType {
	XLInboxManagedMethod = 0,
    XLDeveloperManagedMethod = 1
} XLBadgeManagedType ;

#define XTLOG  ([NSString stringWithFormat:@"%s [Line %d] ", __PRETTY_FUNCTION__, __LINE__])

@interface XLXtifyOptions :NSObject
{
    NSString *xoAppKey;
    NSString *xoUUID;
    BOOL    xoBeaconSupport;
    BOOL    xoLocationRequired ;
    BOOL    xoBackgroundLocationRequired ;
    BOOL    xoLogging ;
    BOOL    xoMultipleMarkets;
    BOOL    xoNewsstandContent ;
    BOOL    xoGeofenceEnabled ;
    XLBadgeManagedType xoManageBadge;
    CLLocationAccuracy xoDesiredLocationAccuracy ;
}
@property (strong,nonatomic) NSSet* categories;

+ (XLXtifyOptions *)getXtifyOptions;

- (NSString *)getAppKey ;
- (BOOL) isLocationRequired;
- (BOOL) isBackgroundLocationRequired ;
- (BOOL) isLogging ;
- (BOOL) isMultipleMarkets;
- (BOOL) isNewsstandContent;
- (BOOL) isGeofenceEnabled;
- (BOOL) isBeaconSupportEnabled;
- (NSString *)getUUID;
- (XLBadgeManagedType)  getManageBadgeType;
- (CLLocationAccuracy ) geDesiredLocationAccuracy ;
- (void)xtLogMessage:(NSString *)header content:(NSString *)message, ...;
-(void)registerForPush;
@end

