//
//  XLCustomInboxMgr.h
//  XtifyLib
//
//  Created by Gilad on 8/Jan/14.
/*
 * IBM Confidential
 * OCO Source Materials
 * 5725E28, 5725I03
 * (c) Copyright IBM Corp. 2011, 2014.
 * The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office. */
//

#import <Foundation/Foundation.h>
@class ASIHTTPRequest;

typedef enum {
    ciNoError = 0,
    ciHttpServerError , 
    ciAppKeyNotSet,
    ciXIDisNil ,
    ciMessageNotFound,
    ciDuplicateMessage,
    ciJsonNotValid,
    ciUnknownError 

} CiErrorType ;

@interface XLCustomInboxMgr : NSObject
{
}


- (void) setCiMessagSelectors:(SEL)aSuccessSelector failSelector:(SEL)aFailureSelector andDelegate:(id)aDelegate;
- (void) setCiPendingSelectors:(SEL)aSuccessSelector failSelector:(SEL)aFailureSelector andDelegate:(id)aDelegate;
- (void) successPendingMessageMethodCI:(ASIHTTPRequest *) request ;
// Get a single rich message
- (void) getCIMessage:(NSString *)mid;

// Get pending messages
- (void) getCIPenddingNotifications;


@end
