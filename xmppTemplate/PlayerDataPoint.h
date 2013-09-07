//
//  PlayerDataPoint.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/7/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PlayerDataPoint : NSManagedObject

@property (nonatomic, retain) NSString * cluster;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * currentPatch;
@property (nonatomic, retain) NSString * rfid;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSDate * timestamp;

@end
