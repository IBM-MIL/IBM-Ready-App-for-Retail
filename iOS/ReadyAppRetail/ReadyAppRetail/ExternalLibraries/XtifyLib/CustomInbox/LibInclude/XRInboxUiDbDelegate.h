//
//  XRInboxUiDbDelegate.h
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
//  For custom Inbox, Inbox View Controller UI must adopt XRInboxUiDbDelegate protocol and
//      provides data model,
//              database name,
//              inbox entity name, and
//              tableView, the UI element
//   all of which will be use by XRInboxDbInterface

#import <Foundation/Foundation.h>

@protocol XRInboxUiDbDelegate <NSObject>

@required

- (NSString *) getInboxDbName;
- (NSString *) getDbModelName;
- (NSString *) getInboxEntityName;
- (UITableView *)getInboxTableView ;

// Notify Inbox VC after getPending server call is completed. Parameter, the number of new messages received
- (void) didGetPendingResult:(int)newMessages;

@end
