//
//  ConfigurationInfo.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/4/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PatchInfo;

@interface ConfigurationInfo : NSManagedObject

@property (nonatomic, retain) NSString * run_id;
@property (nonatomic) float harvest_calculator_bout_length_in_minutes;
@property (nonatomic, retain) NSSet *patches;
@end

@interface ConfigurationInfo (CoreDataGeneratedAccessors)

- (void)addPatchesObject:(PatchInfo *)value;
- (void)removePatchesObject:(PatchInfo *)value;
- (void)addPatches:(NSSet *)values;
- (void)removePatches:(NSSet *)values;

@end
