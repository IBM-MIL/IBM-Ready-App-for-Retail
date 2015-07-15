//
//  CompanyInboxHandler
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

#import <UIKit/UIKit.h>
#import "XRInboxUiDbDelegate.h"

@interface CompanyInboxHandler : NSObject <XRInboxUiDbDelegate>
{

}
- (void) getPendingCustom ; // get the pending messages and update the badge upon return

@end
