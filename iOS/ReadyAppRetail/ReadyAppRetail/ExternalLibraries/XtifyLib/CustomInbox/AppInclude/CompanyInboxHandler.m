//
//  CompanyInboxHandler.m
//  XtifyLib
//
//  Created by Gilad on 9/19/12.
/*
 * IBM Confidential
 * OCO Source Materials
 * 5725E28, 5725I03
 * (c) Copyright IBM Corp. 2011, 2014.
 * The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office. */
//

#import "CompanyInboxHandler.h"
#import "XRInboxDbInterface.h"
#import "RichDbMessage.h"
#import "XLappMgr.h"
#import "CompanyCustomInbox.h"

@interface CompanyInboxHandler ()

@end

@implementation CompanyInboxHandler


#pragma mark - Xtify Inbox Table View and Database Delegate XRInboxUiDbDelegate
- (void) getPendingCustom
{
    [[CompanyCustomInbox get] getPending:self];//update badge count if a new message has arrived
}

- (NSString *) getInboxDbName
{
    return @"CompanyInboxDb.sqlite";
}
- (NSString *) getDbModelName
{
    return @"CompanyInbox"; // mom schema file
}

- (NSString *) getInboxEntityName
{
    return @"XInbox"; //Inbox Entity name, must match table name in schema file (mom)
}

- (UITableView *)getInboxTableView
{
    return nil;
}
// Get notified when getPending completed
-(void)didGetPendingResult:(int)newMessages
{
    int unreadMessages =[[XRInboxDbInterface get] getUnreadMessageCount]; // get the updated value
    NSLog(@"unreadMessages=%d",unreadMessages);
}

@end
