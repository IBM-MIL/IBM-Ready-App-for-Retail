//  Copyright 2014 Applause. All rights reserved.

#import <Foundation/Foundation.h>
#import "APLSetting.h"

@protocol APLLogging <NSObject>

/**
 * Default settings:
 * - applicationVersionName is equal to CFBundleShortVersionString
 * - applicationVersionCode is equal to CFBundleVersion
 * - reportOnShakeEnabled is equal to YES
 * @return an object conforming to APLSetting protocol with default values. You can easily change SDK behaviour by simply changing it's properties.
 */
+ (id<APLSetting>)settings;

/**
 * ONLY FOR PRE PRODUCTION
 * Pre Production is using CMMotionManager for shake gesture. Apple advices to use one CMMotionManager per application.
 * If your application is using one, please register it to Pre Production library via this method.
 * If you won't do this Pre Production will create it's own CMMotionManager.
 */
+ (void)registerMotionManager:(id)motionManager;

/**
 * Starting session. Should be called once per application run - doing otherwise will result in an undefined behavior.
 * If you want to change default settings change properties for object [LOGGER_CLASSNAME settings].
 * @param applicationID Application ID that you can get from Web Server
 */
+ (void)startNewSessionWithApplicationKey:(NSString *)applicationId;

/**
 * Logs exception. Screenshot will be included in the data sent to the server.
 * You can use APLUncaughtExceptionHandler as a convenience accessor to this method.
 * @param error Exception that will be passed to Web Server
 */
+ (void)logApplicationException:(NSException *)error;

/**
 * This method will register object for logging, meaning each and every method sent to it will be logged, including timestamp.
 * @param object Object that will be registered for logging
 */
+ (id)registerObjectForLogging:(id)object;

/**
 * Forces the contents of the session log buffer to be send.
 */
+ (void)flush;

/**
 * ONLY FOR PRE PRODUCTION
 * This function manually shows report screen that is normally accessible by shaking device.
 */
+ (void)showReportScreen;

/**
 * ONLY FOR PRODUCTION
 * Function to show feedback modal where user can write and send feedback about application.
 * You can theme this using Appearance protocol (above iOS 5.0).
 * @param title Title of modal header
 * @param placeholder Placeholder of text field
 */
+ (void)feedback:(NSString *)title placeholder:(NSString *)placeholder DEPRECATED_ATTRIBUTE;

/**
 * ONLY FOR PRODUCTION
 * @see LOGGER_CLASSNAME#feedback:placeholder:
 */
+ (void)feedback:(NSString *)title DEPRECATED_ATTRIBUTE;

/**
 * ONLY FOR PRODUCTION
 * Default title is "Feedback".
 * @see LOGGER_CLASSNAME#feedback:placeholder:
 */
+ (void)feedback DEPRECATED_ATTRIBUTE;

/**
 * ONLY FOR PRODUCTION
 * Function which sends feedback to Applause. It is used by feedback modal.
 * @param feedback Text which you want send to Applause.
 */
+ (void)sendFeedback:(NSString *)feedback DEPRECATED_ATTRIBUTE;

@end
