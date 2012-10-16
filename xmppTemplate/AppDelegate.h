//
//  AppDelegate.h
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "XMPPBaseNewMessageDelegate.h"
#import "XMPPRoom.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRoomStorage> {
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoom *xmppRoom;
    
    
    NSString *password;
    NSMutableDictionary *lastMessageDict;

    
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    
    id <XMPPBaseNewMessageDelegate> __weak xmppBaseNewMessageDelegate;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;

@property (nonatomic, weak) id <XMPPBaseNewMessageDelegate> xmppBaseNewMessageDelegate;

- (BOOL)connect;
- (void)disconnect;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end
