//
//  PatchPlayerInfo.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/4/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PatchPlayerInfo : NSManagedObject

@property (nonatomic, retain) NSString * patch_name;
@property (nonatomic, retain) NSString * rfid;

@end
