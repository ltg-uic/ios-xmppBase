//
//  EventInfo.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/2/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface EventInfo : NSManagedObject

@property (nonatomic, retain) NSString * rfid;
@property (nonatomic, retain) NSString * event_type;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSNumber * score;

@end
