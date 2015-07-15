//  Copyright 2014 Applause. All rights reserved.

#import "APLLogging.h"
#import "MQASettings.h"


typedef enum {
    MQALogLevelFatal = 16,
    MQALLogLevelError = 8,
    MQALogLevelWarning = 4,
    MQALogLevelInfo = 2,
    MQALogLevelVerbose = 0
} MQALogLevel;

/**
 * Convinience method to log applications exceptions
 */

void MQAUncaughtExceptionHandler(NSException *exception);

/** MQA enabled macro **/
#define MQAEnabled 1

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu-zero-variadic-macro-arguments"

/** Logging macros **/

/*
 * Replace all occurences of NSLog with MQALog.
 * Except for working like normal log it will also send message to MQA server.
 */
#define MQALog(nsstring_format, ...)    \
do {                        \
[MQALogger logWithLevel:MQALogLevelInfo \
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
#define MQAExtendedLog(MQALogLevel, nsstring_tag, nsstring_format, ...)    \
do {                        \
[MQALogger logWithLevel:(MQALogLevel) \
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
@interface MQALogger : NSObject <APLLogging>

/**
 * Default settings:
 * - applicationVersionName is equal to CFBundleShortVersionString
 * - applicationVersionCode is equal to CFBundleVersion
 * - reportOnShakeEnabled is equal to YES
 * @return MQASettings object with default values. You can easily change MQA behaviour by simply changing it's properties.
 */
+ (MQASettings *)settings;

/**
 * Calling theese methods is strongly discouraged, since given macros and functions are more convenient way of using Applause.
 */
+ (void)logWithLevel:(MQALogLevel)level tag:(NSString *)tag line:(NSInteger)line fileName:(NSString *)fileName method:(NSString *)method stacktrace:(NSArray *)stacktrace format:(NSString *)format, ...;
+ (void)logWithLevel:(MQALogLevel)level tag:(NSString *)tag line:(NSInteger)line fileName:(NSString *)fileName method:(NSString *)method stacktrace:(NSArray *)stacktrace writeToConsole:(BOOL)writeToConsole format:(NSString *)format, ...;

@end
