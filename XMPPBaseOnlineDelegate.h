
//
//  XMPPBaseOnlineDelegate
//
//  Protocol for recieving new messages
//
//  Created by Anthony Perritano on 9/30/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.

#import <Foundation/Foundation.h>

@protocol XMPPBaseOnlineDelegate

- (void)isAvailable:(BOOL)available;

@end
