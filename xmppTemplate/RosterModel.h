//
//  RosterModel.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/20/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RosterModel : NSObject {
    
    NSMutableArray *students;
}

// Properties as usual
@property (nonatomic, retain) NSMutableDictionary *classes;

-(void)initModel;
+(RosterModel *)sharedInstance;
+(void)addStudent: (NSString*)student toClass: (NSString*)clazz;
+(NSArray *)getStudentsForClass: (NSString*)clazz;
+(int)classCount;
+(int)studentCountForClass: (NSString *)clazz;
+(void)addClass: (NSString*)clazz;

@end
