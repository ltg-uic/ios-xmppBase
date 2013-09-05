//
//  PatchInfo.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/4/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConfigurationInfo;

@interface PatchInfo : NSManagedObject

@property (nonatomic, retain) NSString * patch_id;
@property (nonatomic, retain) NSString * richness;
@property (nonatomic) float richness_per_second;
@property (nonatomic) float richness_per_minute;
@property (nonatomic, retain) ConfigurationInfo *configurationInfo;

@end
