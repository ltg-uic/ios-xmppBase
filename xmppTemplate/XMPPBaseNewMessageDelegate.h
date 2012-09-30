
//
//  NewXMPPMessageDelegate.h
//
//  Protocol for recieving new messages
//
//  Created by Anthony Perritano on 9/30/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.

@protocol XMPPBaseNewMessageDelegate

- (void)newMessageReceived:(NSDictionary *)messageContent;

- (void)replyMessageTo:(NSString *)from;

@end
