//
//  RichDbMessage.h
//  XtifyLib
//
//  Created by Gilad on 2/22/11.
/*
 * Licensed Materials - Property of IBM
 *
 * 5725E28, 5725I03
 *
 * (c) Copyright IBM Corp. 2011, 2014
 * US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
 */
//

#import <CoreData/CoreData.h>

@class XLRichJsonMessage;

@interface RichDbMessage :  NSManagedObject  
{
}
-(void) setFromJson:(XLRichJsonMessage *)xMessage ;
-(void) updateMessage:(BOOL )value;

- (NSString *) getMessageAsString ;
- (NSDictionary *) getMessageAsJson ;

@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * mid;
@property (nonatomic, retain) NSString * actionLabel;
@property (nonatomic, retain) NSNumber * userLon;
@property (nonatomic, retain) NSNumber * ruleLon;
@property (nonatomic, retain) NSNumber * read;
@property (nonatomic, retain) NSString * actionData;
@property (nonatomic, retain) NSString * actionType;
@property (nonatomic, retain) NSNumber * userLat;
@property (nonatomic, retain) NSDate * aDate;
@property (nonatomic, retain) NSNumber * ruleLat;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * expirationDate;


@end



