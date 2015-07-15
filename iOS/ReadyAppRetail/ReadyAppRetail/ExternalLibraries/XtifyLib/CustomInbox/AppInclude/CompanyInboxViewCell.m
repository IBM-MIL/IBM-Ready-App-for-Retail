//
//  CompanyInboxViewCell.m
//  XtifyLib
//
//  Created by Gilad on 9/19/12.
/*
 * IBM Confidential
 * OCO Source Materials
 * 5725E28, 5725I03
 * Copyright IBM Corp. 2011, 2014.
 * The source code for this program is not published or otherwise divested of its trade secrets, irrespective of what has been deposited with the U.S. Copyright Office. */
//
#import "CompanyInboxViewCell.h"

@implementation CompanyInboxViewCell

@synthesize subject;
@synthesize content;
@synthesize msgDate ;
//unreadIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews 
{
    if(self.editing) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)setCellFromDbMessage:(RichDbMessage*)message
{
    // A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	}
    
    msgDate.text=[dateFormatter stringFromDate:[message aDate]];


	if ([self hasExpired:[message expirationDate]]){
        subject.text=	@"Message expired";
    }

    content.text = [self flattenHTML:message.content];

    [subject setText:[message subject]];
    
    if([message.read boolValue]) {
//        unreadIndicator.hidden = YES;
        return YES;
    } else {
//        unreadIndicator.hidden = NO;
        return FALSE;
    }
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
   NSLog(@"Exp date is %@, Today is %@", [dateFormatter stringFromDate:myDate], [dateFormatter stringFromDate:now]);
    
    BOOL hasExp = !([now compare:myDate] == NSOrderedAscending);
    
    return hasExp;
}
// trim the html tags and leading spaced to display in the inbox list
- (NSString *)flattenHTML:(NSString *)html 
{
	
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
		
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        // replace the found tag with a space
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
											   withString:@""];
		
    } // while //
    
	NSString *trimmedString = [html stringByTrimmingCharactersInSet:
							   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
	
}

- (void)dealloc {
//    [unreadIndicator release];
    [super dealloc];
}
@end
