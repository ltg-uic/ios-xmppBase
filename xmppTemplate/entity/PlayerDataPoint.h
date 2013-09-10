//
//  PlayerDataPoint.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/9/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConfigurationInfo;

@interface PlayerDataPoint : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * currentPatch;
@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * rfid_tag;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * player_id;
@property (nonatomic, retain) ConfigurationInfo *configurationInfo;

@end
