//
//  XLEndpoint.h
//  XtifyPush
//
//  Created by Jeremy Buchman on 7/28/14.
//
//

#import <Foundation/Foundation.h>

@interface XLEndpoint : NSObject

+ (instancetype) get;
- (void) setEuropeanEndpoint;
- (void) setAmericanEndpoint;
- (void) setQAEndpoint;
- (void) setCustomEndpoint:(NSString*)baseURL twoPlus:(NSString*)twoPlusURL;
- (NSURL*) setTagURL: (NSArray*)tags;
- (NSURL*) untagURL: (NSArray*)tags;
- (NSURL*) addTagURL: (NSArray*)tags;
- (NSURL*) listTagsURL;
- (NSURL*) metricsURL;
- (NSURL*) clientDataURL;
- (NSURL*) richPendingURL;
- (NSURL*) richDetailsURL: (NSString*)mid;
- (NSURL*) locationUpdateURL;
- (NSURL*) registrationURL;
- (NSURL*) userUpdateURL: (NSString*)oldAppKey;
- (NSURL*) regionListURL: (NSString*)service;
- (NSURL*) validateUserURL;
- (NSURL*) badgeURL;
- (NSURL*) userUpdateURL;
- (NSURL*) regionEventURL: (NSString*)service name:(NSString*)name;

@end
