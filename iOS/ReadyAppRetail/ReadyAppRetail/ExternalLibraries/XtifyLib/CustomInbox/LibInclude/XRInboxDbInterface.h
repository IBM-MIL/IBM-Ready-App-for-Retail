//
//     File: XRInboxDbInterface.h
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
//
//  Data model interface to Xtify Rich Inbox
//
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class XLRichJsonMessage,RichDbMessage;

@interface XRInboxDbInterface : NSObject < NSFetchedResultsControllerDelegate> {
    
}

+(XRInboxDbInterface *)get;

- (void) updateParentVCandDB:(id)delegatedInboxVC ;
- (void) readLocalStore;
- (RichDbMessage *) addRichMessageToDb:(XLRichJsonMessage *)inputMsg ;
- (int) getUnreadMessageCount;
- (int) getMessageCount ;
- (int) decrementMessageReadCount ;

- (void) setInboxUnreadMessageCount: (int) newCount;
- (RichDbMessage *) addEmptyMid:(NSString *)pushMid ;
- (NSString *) getInboxMessagesAsString ;
- (NSMutableArray *) getInboxMessagesAsJson ;
- (NSString *) getMessageByMid:(NSString *)mid ;
- (NSDictionary *) getMessageByMidAsJson:(NSString *)mid ;
- (id) getDbMessageByMid:(NSString *)mid;
- (void) removeExpiredMessages; // remove all expired message from data store
- (NSString *) markMessageAsRead:(NSString *)mid; // mark message as read
- (NSString *) deleteMessageMid:(NSString *)mid; // Delete a message by mid


// Inbox TableViewController Interface
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section ;
- (RichDbMessage *) cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)iterateOverFectch ;
@end
