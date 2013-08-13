//
//  DataPoint.h
//  ios-xmppBase
//
//  Created by Anthony Perritano on 8/12/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DataPoint : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * timestamp;

@end
