//
//  XLappMgr.h
//  XtifyLib
//
//  Created by Gilad on 8/Jun/11.
/*
 * IBM Confidential
 * OCO Source Materials
 * 5725E28, 5725I03
 * (c) Copyright IBM Corp. 2011, 2014.
 * The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office. */
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XLXtifyOptions.h"

@protocol XLInboxDelegate;

@class XLServerMgr,XLInboxMgr;
@class UIApplication ;
@class xASIHTTPRequest;

@interface XLappMgr : NSObject
{

	XLServerMgr *serverMgr;
	XLInboxMgr *inboxMgr;

	NSMutableString  *currentAppKey ; // xtify application key
	NSDate * lastLocationUpdateDate ;
	NSString *prodName ; // product name from info plist
	// Badge
	XLBadgeManagedType badgeMgrMethod;
	// The delegate, developer needs to manage setting and talking to delegate in subclasses
	id <XLInboxDelegate> inboxDelegate;
    id <XLInboxDelegate> geoEventDelegate;
	// Called on the delegate (if implemented) when a message read in the Inbox. Default is messageCountChanged:
	SEL didInboxChangeSelector;
	SEL developerNavigationControllerSelector ;
	SEL developerInboxNavigationControllerSelector ;
	SEL developerCustomActionSelector ;
	SEL developerXidNotificationSelector ;
    SEL developerActiveTagsSelector;
    NSString * snId;
	NSTimer* timerBulkUpdate;
    NSMutableArray *activeTagArray;

	BOOL isInGettingMsgLoop ;// set to yes by the inboxMgr, when getting few messages from the server to prevent multiple updates
    NSString *curCountry;
    NSString *curLocale;
    NSString *userTimeZone;
    BOOL multipleMarketsFlag ;
}

+(XLappMgr*)get;
//Framework
- (void) initilizeXoptions:(XLXtifyOptions *)xOptions;
-(void) registerForPush ;

-(void) registerWithXtify:(NSData *)devToken ;
// 
- (void) doXtifyRegistration:(NSString*) newAppKey;
- (void) updateXtifyRegistration:(NSString *)newAppKey;
- (void) resetUserXid ; // Remove stored user's XID, reregister and store the new XID. 
- (void) registrationNoLongerInProgress ;

-(void) updateAppKey:(NSString *)appKey ;
-(NSString *)getStoredAppKey ;
- (void) updateAppDetail:(NSString *)currentAppKey;
-(void) appEnterBackground;
-(void) appEnterActive;
-(void) appEnterForeground;

-(void) updateLocDate:(NSDate *)updateDate;

-(void) applicationWillTerminate;
-(void) updateStats:(NSString *)type withTS:(NSString *)ts;
- (void) sendActionsToServerBulk:(NSTimer*)timer;

/* Locaton */
- (BOOL) getLocationRequiredFlag ;
- (BOOL) getBackgroundLocationRequiredFlag; // get the BG location tracking flag
- (BOOL) isLocationSettingOff ;

// Call this method when application starts as a results of significant location changes
- (void) handleSignificantLocation:(UIApplication *)application andOptions:(NSDictionary *)launchOptions;

// If set to true, the app starts to update location in the Foreground every 3 mins. If set to false, the app stops location services
- (void) updateLocationRequiredFlag:(BOOL )value;
// If set to true, the app starts tracking significant location update in the background
- (void) updateBackgroundLocationFlag:(BOOL )value;
- (CLLocationCoordinate2D )getLastLnownLocation ;
- (void) updateLocation;

//Notification
-(void) getPenddingNotifications;
- (UIViewController *)getInboxViewController ; // allow developer hook the inbox VC
-(void) saveIncomingNotification:(NSDictionary *)lastNotification ;
-(NSDictionary *) getIncomingNotification;

// Badge management
-(NSInteger) getSpringBoardBadgeCount ;
-(void)		 setSpringBoardBadgeCount:(NSInteger) count;
-(NSInteger) getServerBadgeCount;
-(void)		setServerBadgeCount:(NSInteger) count;
-(void)		setBadgeCountSpringBoardAndServer:(NSInteger) count;
-(void) updateBadgeCount:(NSInteger) value andOperator:(char ) op;//‘op’ is either ‘+’ or ‘-’ or nil
-(NSInteger) getInboxUnreadMessageCount ;
-(void) inboxChangedInternal:(NSInteger) count; // used by the Inbox to notify when rich message was read/received

// Called when inbox message count changed, lets the delegate know via didInboxChangeSelector
- (void)messageCountChanged;
// Called when inbox displays a rich details dialog
- (UINavigationController *)getDeveloperNavigationController;
//called when a rich push arrive and the app uses Tabbar
- (void) moveTabbarToInboxNavController ;
// called when action in rich message is set to CST; informs delegate via developerCustomActionSelector
- (void) performDeveloperCustomAction:(NSString *)actionData ;

//to manage the badge flag
- (XLBadgeManagedType) getBadgeMethod;
- (void) updateBadgeFlag:(BOOL )value;
- (void) setSnid:(NSString * )value;
- (NSString *) getSnid;

// Tags
- (void)addTag:(NSMutableArray *)tags;
- (NSString *) getTagString:(NSMutableArray *) tags;
- (void)doTagRequest:(NSURL *) tagUrlString;
- (void)unTag:(NSMutableArray *)tags;
- (void)setTag:(NSMutableArray *)tags;
- (void) getActiveTags;
- (void)successActiveTagMethod:(xASIHTTPRequest *) request;
- (void)doActiveTagsRequest:(NSURL *) tagString;
- (void) didReceiveTagRequest :(NSMutableArray * )anArray ;


-(NSString *)getXid;
- (void) checkPushEnabled;
- (NSString *) getPushSettingValue;
-(void) changeDbPushFlag: (NSString *) flag;



//Metric wrappers
- (void) insertSimpleAck:(NSString *) simpleId;
- (void) insertSimpleDisp:(NSString *) simpleId;
- (void) insertSimpleClear:(NSString *) simpleId;
- (void) insertSimpleClick:(NSString *) simpleId;
- (void) insertNotificationClick:(NSDictionary *)aPush ;

// When using custom inbox, developer needs to update metric
- (void) insertRichDisplay:(NSString *) richId;  // user displays a rich message
- (void) insertRicShare:(NSString *) richId;    // user shares a rich message via email
- (void) insertRichAction:(NSString *) richId; // user selects the action (call, safari, etc.) from therich message
- (void) insertRichMap:(NSString *) richId;     // user displays the map from a locaton based rich message
- (void) insertRichDelete:(NSString *) richId;  // user deletes a rich message
- (void) insertInboxClick; // usser selects the inbox list

//User preferences
-(void) sendTimeZoneToServer: (NSString*)currentTz;
-(void) hasTZChanged;
-(NSString *)getSdkVer;
-(void) recreateTagDb;
-(NSString *) getPushEnabled;

// Mutli markets
- (BOOL) isMultipleMarkets ;
- (void)addLocale:(NSString*)locale; // initialize and updated when first starts, in settings page and register update 
- (void)untagLocale:(NSString*)locale; // in register update

-(NSMutableDictionary *)getAppDetails;
-(void) saveRegTimestamp;
-(NSString *) getRegTimestamp;
-(void) removeAllNotifications; // clear badge and notifications center

@property (nonatomic, retain) NSString *currentAppKey;
@property (nonatomic, retain) NSString *userTimeZone;

@property (nonatomic, retain) NSString *prodName;
@property (nonatomic, assign)	BOOL isInGettingMsgLoop;
@property (nonatomic, retain) NSTimer* timerBulkUpdate;

@property (nonatomic, retain) NSDictionary *lastPush;

//badge management
@property (assign, nonatomic) id inboxDelegate;
@property (assign) SEL didInboxChangeSelector, developerCustomActionSelector;
@property (assign) SEL developerNavigationControllerSelector, developerInboxNavigationControllerSelector;

//Locale
@property (nonatomic, retain) NSString *curCountry;
@property (nonatomic, retain) NSString *curLocale;
@property (nonatomic, retain) NSMutableArray *activeTagArray;

//Tags
@property (assign) SEL  developerActiveTagsSelector ;

//Xid
@property (assign) SEL  developerXidNotificationSelector ;
@property (assign) SEL  developerRegisterNotificationSelector ;
@property (assign) SEL  developerRegistrationFailureSelector ;

-(void) xidChanged ;
-(void) registerComplete ;
-(void) registrationFailed:(int) httpStatusCode ;


//Location
@property (nonatomic, retain) 	NSDate * lastLocationUpdateDate ;
@property (assign) SEL  developerLocationUpdatSelector ;
-(void) locationUpdated:(CLLocation *)locationInformation ;

- (void) updateLocationWithCoordinate:(CLLocationCoordinate2D) latLon andAlt:(float)altitude andAccuracy:(float)accuracy;

@property (assign) SEL  geofenceEventSelector ;
-(void) geofenceEventOccurred:(NSDictionary *)event ;
-(BOOL) isGeofenceCallabackActive ;
-(void) setGeofenceEventSelector:(SEL )selector andDelegate:(id)delegate;

//Client Data
-(void) updateClientDataKey:(NSString *)key andValue:(NSString *)value ;

// last known network connectivity status
- (BOOL) getLastNetworkStatus ;

@end
