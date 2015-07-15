//
//  CompanyInboxVC.m
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

#import "CompanyInboxVC.h"
#import "XRInboxDbInterface.h"
#import "CompanyInboxViewCell.h"
#import "RichDbMessage.h"
#import "CompanyDetailsVC.h"
#import "XLappMgr.h"
#import "CompanyCustomInbox.h"

@interface CompanyInboxVC ()

@end

@implementation CompanyInboxVC

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibName bundle:nibBundleOrNil];
	if(self )
    {
        [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
      
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [[XLappMgr get]insertInboxClick ];
    
    if ([[XRInboxDbInterface get] getMessageCount] >0) {
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self.editButtonItem setTitle:@"Delete"];
    }
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];

    [self.tableView reloadData];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    if(editing) {
        [self.editButtonItem setTitle:@"Done"];
    }
	else {
		[self.editButtonItem setTitle:@"Delete"];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

	NSInteger count =[[XRInboxDbInterface get] numberOfSectionsInTableView:tableView ];
	if (count == 0) {
		count = 1;
	}
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = [[XRInboxDbInterface get] tableView:tableView numberOfRowsInSection:section ];
     return numberOfRows;

}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell
	[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

// Override to support editing (deleting) in the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        [[XRInboxDbInterface get] tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
	}
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CompanyInboxViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"CoCellId"];
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:@"CompanyInboxViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell
    RichDbMessage *aDbMessage = [[XRInboxDbInterface get]  cellForRowAtIndexPath:indexPath];
    BOOL unreadIndicator =[cell setCellFromDbMessage:aDbMessage];
    if (! unreadIndicator) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-dot.png"]];
        
        imageView.center = CGPointMake(10, 20);
        [cell.contentView addSubview:imageView];
        [imageView release];
    }
    return cell;
}

#pragma mark - Table view delegate
// User selects the message
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Update the details view controller
    CompanyDetailsVC *detailsViewController=[[CompanyDetailsVC alloc] initWithNibName:@"CompanyDetailsVC" bundle:nil];
    RichDbMessage *aDbMessage =  [[XRInboxDbInterface get]  cellForRowAtIndexPath:indexPath];

    // mark message as read
    if (![aDbMessage.read boolValue]) {
        [aDbMessage updateMessage:TRUE]; //message is updaged as read
        
        int unreadMessages =[[XRInboxDbInterface get] decrementMessageReadCount];
        [[XLappMgr get] inboxChangedInternal:unreadMessages];
        if (unreadMessages>0) {
            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",unreadMessages];
  //  inboxChangedInternal does it         [[XLappMgr get]setBadgeCountSpringBoardAndServer:unreadMessages];
        }
        else
        {
            self.tabBarItem.badgeValue=nil;  // clear the badge
        }
    }

    [detailsViewController setDetailsFromDbMessage:aDbMessage];
    
    //Uncomment the following if you want to deselect the row
    [tableView  deselectRowAtIndexPath:indexPath  animated:YES];
    
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailsViewController animated:YES];
    [detailsViewController release];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    return self.tableView;
}
// Get notified when getPending completed
-(void)didGetPendingResult:(int)newMessages
{
    int unreadMessages =[[XRInboxDbInterface get] getUnreadMessageCount]; // get the updated value
    self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",unreadMessages];
     [[XLappMgr get]setBadgeCountSpringBoardAndServer:unreadMessages];
}

#pragma mark - Orientation Changes
- (void)orientationChanged:(NSNotification *)notification
{
    // Add a delay here, otherwise we'll swap in the new view
	// too quickly and we'll get an animation glitch
//    [self performSelector:@selector(updateLandscapeView) withObject:nil afterDelay:0];
}
/* Landscape future
- (void)updateLandscapeView
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView)
	{
//        [self presentViewController:self.landscapeViewController animated:YES completion:nil];
        isShowingLandscapeView = YES;

    }
	else if (deviceOrientation == UIDeviceOrientationPortrait && isShowingLandscapeView)
	{
       // [self dismissViewControllerAnimated:YES completion:nil];
        isShowingLandscapeView = NO;
    }
}
*/
// override to allow orientations other than the default portrait orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait); // support only portrait
}

-(void) viewDidUnload {
    [self setView:nil];
    [self setView:nil];
	[super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}
@end
