//
//  AppDelegate.h
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.

#import <UIKit/UIKit.h>
#import "ConfigurationInfo.h"
#import "PlayerDataDelegate.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, XMPPRoomStorage> {
    NSString *password;
    NSMutableDictionary *lastMessageDict;    
    
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	BOOL isXmppConnected;
    BOOL isMultiUserChat;
    
@private
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPRoom *xmppRoom;


@property (nonatomic, weak) id <XMPPBaseNewMessageDelegate> xmppBaseNewMessageDelegate;
@property (nonatomic, weak) id <XMPPBaseOnlineDelegate>     xmppBaseOnlineDelegate;
@property (nonatomic, weak) id <PlayerDataDelegate>         playerDataDelegate;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) NSArray *patcheInfos;
@property (strong, nonatomic) NSArray *playerDataPoints;
@property (strong, nonatomic) NSMutableDictionary *colorMap;
@property (strong, nonatomic) ConfigurationInfo *configurationInfo;
@property (nonatomic) float refreshRate;




- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

- (BOOL)connect;
- (void)disconnect;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

-(void)setupConfigurationAndRosterWithRunId:(NSString *)run_id;


@end
