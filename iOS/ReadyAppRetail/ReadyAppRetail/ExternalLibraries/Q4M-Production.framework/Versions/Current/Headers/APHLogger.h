//  Copyright 2014 Applause. All rights reserved.

#import "APLLogging.h"
#import "APHSettings.h"


typedef enum {
    APHLogLevelFatal DEPRECATED_ATTRIBUTE = 16,
    APHLLogLevelError DEPRECATED_ATTRIBUTE = 8,
    APHLogLevelWarning DEPRECATED_ATTRIBUTE = 4,
    APHLogLevelInfo DEPRECATED_ATTRIBUTE = 2,
    APHLogLevelVerbose DEPRECATED_ATTRIBUTE = 0
} APHLogLevel DEPRECATED_MSG_ATTRIBUTE("Use MQALogLevel instead.");

/**
 * Convinience method to log applications exceptions
 */

void APHUncaughtExceptionHandler(NSException *exception) DEPRECATED_MSG_ATTRIBUTE("Use MQAUncaughtExceptionHandler instead.");

/** APH enabled macro **/
#define APHEnabled 1

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"

/** Logging macros **/

/*
 * Replace all occurences of NSLog with APHLog.
 * Except for working like normal log it will also send message to APH server.
 */
#define APHLog(nsstring_format, ...)    \
do {                        \
[APHLogger logWithLevel:APHLogLevelInfo \
tag:nil \
line:__LINE__ fileName:[NSString stringWithUTF8String:__FILE__] \
method:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
stacktrace:[NSThread callStackReturnAddresses]\
format:nsstring_format, \
##__VA_ARGS__];\
} while(0)

/*
 * Works as the one above, except it provides additional configuration options
 */
#define APHExtendedLog(APHLogLevel, nsstring_tag, nsstring_format, ...)    \
do {                        \
[APHLogger logWithLevel:(APHLogLevel) \
tag:(nsstring_tag) \
line:__LINE__ fileName:[NSString stringWithUTF8String:__FILE__] \
method:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
stacktrace:[NSThread callStackReturnAddresses] \
format:nsstring_format, \
##__VA_ARGS__];\
} while(0)


#pragma clang diagnostic pop

/**
 * Main Quality 4 Mobile API class
 * @see http://www.quality4mobilehelp.com/library-installation/ios
 */
DEPRECATED_MSG_ATTRIBUTE("Use MQALogger class instead.")
@interface APHLogger : NSObject <APLLogging>

/**
 * Default settings:
 * - applicationVersionName is equal to CFBundleShortVersionString
 * - applicationVersionCode is equal to CFBundleVersion
 * - reportOnShakeEnabled is equal to YES
 * @return APHSettings object with default values. You can easily change Q4M behaviour by simply changing it's properties.
 */
+ (APHSettings *)defaultSettings DEPRECATED_MSG_ATTRIBUTE("Use 'settings' method of MQALogger instead.");

/**
 * Calling theese methods is strongly discouraged, since given macros and functions are more convenient way of using Applause.
 */
+ (void)logWithLevel:(APHLogLevel)level tag:(NSString *)tag line:(NSInteger)line fileName:(NSString *)fileName method:(NSString *)method stacktrace:(NSArray *)stacktrace format:(NSString *)format, ...;
+ (void)logWithLevel:(APHLogLevel)level tag:(NSString *)tag line:(NSInteger)line fileName:(NSString *)fileName method:(NSString *)method stacktrace:(NSArray *)stacktrace writeToConsole:(BOOL)writeToConsole format:(NSString *)format, ...;

@end
