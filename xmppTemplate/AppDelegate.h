//
//  AppDelegate.h
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "XMPPBaseNewMessageDelegate.h"
#import "XMPPBaseOnlineDelegate.h"
#import "XMPPRoom.h"
#import "XMPPMessage+XEP0045.h"
#import "DataPoint.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRoomStorage> {
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoom *xmppRoom;
    
    
    NSString *password;
    NSMutableDictionary *lastMessageDict;

    
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	BOOL isXmppConnected;
    
@private
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
   

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;

@property (nonatomic, weak) id <XMPPBaseNewMessageDelegate> xmppBaseNewMessageDelegate;
@property (nonatomic, weak) id <XMPPBaseOnlineDelegate>     xmppBaseOnlineDelegate;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;



- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

- (BOOL)connect;
- (void)disconnect;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end
