//
//  CompanyInboxViewCell.h
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

#import <UIKit/UIKit.h>
#import "RichDbMessage.h"

@interface CompanyInboxViewCell : UITableViewCell 
{

 }

@property (strong, nonatomic) IBOutlet UILabel *subject;

@property (strong, nonatomic) IBOutlet UILabel *content;

@property (strong, nonatomic) IBOutlet UILabel *msgDate;
//@property (retain, nonatomic) IBOutlet UIView *unreadIndicator;

// Copy the message content to the cell
- (BOOL)setCellFromDbMessage:(RichDbMessage*)message;

- (BOOL) hasExpired:(NSDate*)myDate;
@end
