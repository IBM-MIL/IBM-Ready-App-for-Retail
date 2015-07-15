//
//  XTDetailsVC.m
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

#import "CompanyDetailsVC.h"
#import "RichDbMessage.h"
#import "XLappMgr.h"
#import "XRInboxDbInterface.h"

@interface CompanyDetailsVC()
{
    UIView *xView,*yView;
    RichDbMessage *dbMessage;
    UIInterfaceOrientation lastInterfaceOrientation;
}
- (void) updateView;
- (BOOL) hasExpired:(NSDate*)myDate ;

@end

@implementation CompanyDetailsVC
// future @synthesize subjectLandscape,webViewLandscape, toolbarLandscape;
@synthesize subjectPortrait, webViewPortrait,toobarPortrait;
@synthesize dismissPortrait;

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibName bundle:nibBundleOrNil];
	if(self )
    {
        [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        self.view=_viewPortrait;
        self.hidesBottomBarWhenPushed = YES;
        [dismissPortrait setHidden:YES];
        [dismissPortrait addTarget:self action:@selector(dismissViewHandler:) forControlEvents:UIControlEventAllTouchEvents];

    }
    return self;
}

- (void) setDismissButtonDisplay:(BOOL) flag
{
     [dismissPortrait setHidden:flag];
}
- (void)setDetailsFromDbMessage:(RichDbMessage*)message
{
    dbMessage=message ;
    if ([self hasExpired:[dbMessage expirationDate]])
    {
          // load the content HTML into a webview
        NSString *subjectAndContent=[self getHTMLContentsFromFile];
        /* landscape -future
        if( UIInterfaceOrientationIsLandscape(lastInterfaceOrientation) )
        {
            [webViewLandscape loadHTMLString:subjectAndContent baseURL:nil];
            self.view=_viewLandscape;
        }
        else
        { */
            [webViewPortrait loadHTMLString:subjectAndContent baseURL:nil];
            self.view=_viewPortrait;
            
        
    }
    else
    {
        [self updateView ];
    }
}

- (void) updateView
{
    UIToolbar *toolBar;
    self.title=[dbMessage subject];
//    UIDeviceOrientation dOrientation = [UIDevice currentDevice].orientation;
//    NSLog(@"dOrientation=%d",dOrientation);
    lastInterfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    /* landscape -future
    if( UIInterfaceOrientationIsLandscape(lastInterfaceOrientation) )
    {
        [subjectLandscape setText:[dbMessage subject]];
        [webViewLandscape loadHTMLString:[dbMessage content] baseURL:nil];
        self.view=_viewLandscape;
        toolBar=toolbarLandscape;
    }
    else
    { */
        [subjectPortrait setText:[dbMessage subject]];
        [webViewPortrait loadHTMLString:[dbMessage content] baseURL:nil];
        self.view=_viewPortrait;
        toolBar=toobarPortrait;
        
    
	UIBarButtonItem *sendtoItem = nil;
	BOOL canSend=[MFMailComposeViewController canSendMail];
	if (canSend) {
	    sendtoItem = [[UIBarButtonItem alloc]
					  initWithBarButtonSystemItem:UIBarButtonSystemItemAction
					  target:self action:@selector(sendMsgTo:)];
	}
	// setup action/phone button
	UIBarButtonItem *actionItem=nil ;
	
	// flex item used to separate the left groups items and right grouped items
	UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
																			  target:nil
																			  action:nil];
	NSArray *itemsTemp=nil;
    NSString *actionLabel=[dbMessage actionLabel];
	if (actionLabel.length > 0 ) {
		actionItem = [[UIBarButtonItem alloc] initWithTitle:actionLabel style:UIBarButtonItemStyleDone
													 target:self action:@selector(actionButtonHandler:)];
		itemsTemp=[NSArray arrayWithObjects: flexItem ,actionItem,flexItem,nil];
		[actionItem release];
	}
    
	NSArray *itemsFinal=[NSArray arrayWithArray:itemsTemp];
	if (canSend) {
		NSArray *t=[NSArray arrayWithObjects:flexItem ,sendtoItem,flexItem,nil];
		if (itemsTemp) {
			itemsFinal=[itemsTemp arrayByAddingObjectsFromArray:t];
		} else {
			itemsFinal=[NSArray arrayWithArray:t];
		}
        [sendtoItem release];
	}
	if (itemsFinal) {
		[toolBar setItems:itemsFinal animated:NO];
	}
    [flexItem release];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"should willRotateToInterfaceOrientation?");
    lastInterfaceOrientation =toInterfaceOrientation;
}
-(BOOL)shouldAutorotate
{
    NSLog(@"should shouldAutorotate");
    return YES;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // allow any orientation.
    lastInterfaceOrientation =interfaceOrientation;

    return YES;
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateView];
}
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [[XLappMgr get]insertRichDisplay:dbMessage.mid];
}
#pragma mark -
#pragma mark MFMailComposeViewController
// Dismisses the email composition interface when users tap Cancel or Send.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{	// is there a different between cancel and send?
    //	MFMailComposeResultCancelled	The user cancelled the operation. No email message was queued.
    //	MFMailComposeResultSaved	The email message was saved in the user’s Drafts folder.
    //	MFMailComposeResultSent	The email message was queued in the user’s outbox. It is ready to send the next time the user connects to email.
    //	MFMailComposeResultFailed	The email message was not saved or queued, possibly due to an error.
    
	// update stats if result== MFMailComposeResultSent
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendMsgTo:(id)sender {
	[self displaySentToComposerSheet];
}
// Display only updates if Hold/Release button hasn't been pressed
- (void)actionButtonHandler:(id)sender
{
	NSString *actionT=[dbMessage actionType];
	if ( actionT.length == 0 ) {
		return;
	}
    [[XLappMgr get] insertRichAction:[dbMessage mid]];
	
	if([dbMessage.actionType  caseInsensitiveCompare:@"NONE"]==NSOrderedSame) {
        NSLog(@"None is true...no Action button to begin with");
		return ;
	}
	
	UIAlertView *alertView=nil ;
	NSString *cancelButton=nil;
	NSString *otherButton=nil;
	
	if([dbMessage.actionType  caseInsensitiveCompare:@"PHN"]==NSOrderedSame) {
		cancelButton=@"Cancel";
		otherButton=@"Call";
	}
	else if([dbMessage.actionType  caseInsensitiveCompare:@"WEB"]==NSOrderedSame) {
		cancelButton=@"Cancel";
		otherButton=@"Safari";
	}
	///
	else if([dbMessage.actionType  caseInsensitiveCompare:@"CST"]==NSOrderedSame) {
		[[XLappMgr get] performDeveloperCustomAction:[dbMessage actionData]];
 	}
	//
	if (cancelButton !=nil) {
		alertView = [[UIAlertView alloc] initWithTitle:nil message:[dbMessage actionData] delegate:self
									 cancelButtonTitle:cancelButton otherButtonTitles:otherButton, nil];
		[alertView show];
        [alertView release];
	}
	
}
- (void)dismissViewHandler:(id)sender
{
    int unreadMessages =[[XRInboxDbInterface get] getUnreadMessageCount]; // get the updated value
    [[XLappMgr get]setBadgeCountSpringBoardAndServer:unreadMessages];

    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)displaySentToComposerSheet
{
    [[XLappMgr get] insertRicShare:[dbMessage mid]] ;
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:[dbMessage subject]];//subjectLabel.text];
	// Fill out the email body text
	NSString *emailBody =[dbMessage content] ;//substringToIndex:size];
	[picker setMessageBody:emailBody isHTML:YES];
	
	[self presentViewController:picker animated:YES completion:nil];
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}
#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	// starting the load, show the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	// finished loading, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	// load error, hide the activity indicator in the status bar
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	// report the error inside the webview
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><font size=+3 color='blue'>An error occurred:<br>%@<br>for url:%@<br></font></center></html>",
							 error.localizedDescription,[dbMessage actionData]];
	[webView loadHTMLString:errorString baseURL:nil];
}


- (void)viewDidUnload {
    [self setViewPortrait:nil];
    [self setWebViewPortrait:nil];
    [self setSubjectPortrait:nil];
    [self setToobarPortrait:nil];
    [self setDismissPortrait:nil];
        /* landscape -future
         [self setWebViewLandscape:nil];
         [self setSubjectLandscape:nil];
         [self setViewLandscape:nil];
         [self setToolbarLandscape:nil];
            */
    [super viewDidUnload];
}

- (NSString *) getHTMLContentsFromFile
{
    NSError* error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:dExpireTemplate ofType: @"html"];
    NSString *res = [NSString stringWithContentsOfFile: path encoding:NSUTF8StringEncoding error: &error];
    return res;
}

- (BOOL) hasExpired:(NSDate*)myDate
{
    if(myDate == nil)
    {
        return false;
    }
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	}
    NSDate *now = [NSDate date];
    BOOL hasExp = !([now compare:myDate] == NSOrderedAscending);
    return hasExp;
}

- (void)dealloc {
    [toobarPortrait release];
//    [toolbarLandscape release];
    [dismissPortrait release];
    [super dealloc];
}

#pragma mark -
#pragma mark - UIAlertViewDelegate
//Called when the user click (and open) the notification message
- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) { // user select open
		NSLog(@"User selects the action ");
		NSString *actionD=[dbMessage actionData];
        [[XLappMgr get] insertRichAction:[dbMessage mid]];

		if([dbMessage.actionType  caseInsensitiveCompare:@"PHN"]==NSOrderedSame) {
			NSString *telUrl=[NSString stringWithFormat:@"tel:%@",actionD] ;
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
		}
		if([dbMessage.actionType  caseInsensitiveCompare:@"WEB"]==NSOrderedSame) {
			NSString *urlLink=[[[NSString alloc]initWithString:[dbMessage actionData]]autorelease];
			NSURL *url = [NSURL URLWithString:urlLink];
			[[UIApplication sharedApplication] openURL:url];
		}
	}
}

@end
