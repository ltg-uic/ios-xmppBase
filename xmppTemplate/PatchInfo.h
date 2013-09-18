//
//  PatchInfo.h
//  ios-xmppBase
//
//  Created by Anthony Perritano on 9/18/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ConfigurationInfo;

@interface PatchInfo : NSManagedObject

@property (nonatomic, retain) NSString * patch_id;
@property (nonatomic) float quality_per_minute;
@property (nonatomic) float quality_per_second;
@property (nonatomic) float richness;
@property (nonatomic, retain) ConfigurationInfo *configurationInfo;

@end
