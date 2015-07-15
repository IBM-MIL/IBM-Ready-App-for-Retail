//
//  XTDetailsVC
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
#import <MessageUI/MFMailComposeViewController.h>

#define dExpireTemplate       @"ExpireTemplate"

@class RichDbMessage;

@interface CompanyDetailsVC : UIViewController  <UIWebViewDelegate,MFMailComposeViewControllerDelegate> { 

}
// portrait
@property (strong, nonatomic) IBOutlet UIView *viewPortrait;
@property (strong, nonatomic) IBOutlet UILabel *subjectPortrait;
@property (strong, nonatomic) IBOutlet UIWebView *webViewPortrait;
@property (retain, nonatomic) IBOutlet UIToolbar *toobarPortrait;
@property (retain, nonatomic) IBOutlet UIButton *dismissPortrait;

// landscape
/* future. declared but not used */
@property (strong, nonatomic) IBOutlet UIView *viewLandscape;
@property (strong, nonatomic) IBOutlet UIWebView *webViewLandscape;
@property (strong, nonatomic) IBOutlet UILabel *subjectLandscape;
@property (retain, nonatomic) IBOutlet UIToolbar *toolbarLandscape;
/* end future*/
- (void)setDetailsFromDbMessage:(RichDbMessage*)message;
- (void)sendMsgTo:(id)sender;
- (void)displaySentToComposerSheet ;
- (void) setDismissButtonDisplay:(BOOL) flag; //set to no to display dismiss button

@end
