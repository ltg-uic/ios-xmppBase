//
//  RosterModel.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/20/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "RosterModel.h"

@implementation RosterModel

#pragma mark Singleton Implementation
static RosterModel *rosterModel;

+(RosterModel *)sharedInstance {
    if (rosterModel == nil) {
        rosterModel = [[super allocWithZone:NULL] init];
        [rosterModel initModel];
    }
    return rosterModel;
}


-(void)initModel {
    _classes = [[NSMutableDictionary dictionary] init];
}

#pragma mark Shared Public Methods

+(void)addClass: (NSString*)clazz {
    RosterModel *rosterModel = [RosterModel sharedInstance];
    
    NSArray *allKeys = [[rosterModel classes ] allKeys];
    if (![allKeys containsObject:clazz]){
        [[rosterModel classes ] setObject:[[NSMutableArray array] init] forKey:clazz];
    }
}

+(void)addStudent: (NSString*)student toClass: (NSString*)clazz {
    
    RosterModel *rosterModel = [RosterModel sharedInstance];
    NSMutableArray *students = [[rosterModel classes] objectForKey:clazz];
    
    if( students == nil ) {
        students = [[NSMutableArray array] init];
    }
    
    if (![students containsObject:student])
        [students addObject:student];
    
    [[rosterModel classes] setObject:students forKey:clazz];

    
}

+(NSArray *)getStudentsForClass: (NSString*)clazz {
    
    RosterModel *rosterModel = [RosterModel sharedInstance];
    NSMutableArray *students = [[rosterModel classes] objectForKey:clazz];
    
    if( students == nil ) {
        return nil;
    } else {
        return [NSArray arrayWithArray:students];
    }
    
}

+(int)classCount {
    RosterModel *rosterModel = [RosterModel sharedInstance];
    return [[[rosterModel classes ] allKeys ] count ];
}

+(int)studentCountForClass: (NSString *)clazz {
    return[[RosterModel getStudentsForClass:clazz] count];
}


@end
    
