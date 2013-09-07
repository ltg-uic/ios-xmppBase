//
//  AppDelegate.m
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "PlayerDataPoint.h"
#import "PatchInfo.h"
#import "ConfigurationInfo.h"
#import "EventInfo.h"
#import "WizardClassPageViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SBJsonParser.h"
#import "AFNetworking.h"


// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@interface AppDelegate() {

    NSArray *patchInfos;
   

}

@end

@implementation AppDelegate

#pragma mark APPDELEGATE METHODS

-(void)customizeGlobalAppearance {
    //[[UINavigationBar appearance] setValue:helveticaNeueMedium forKey:UITextAttributeFont];
    //[[UINavigationBar appearance] setValue:[UIColor blackColor] forKey:NSForegroundColorAttributeName];

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[self customizeGlobalAppearance];
    
    
    isMultiUserChat = YES;
    //setup test data
    
    [self deleteAllObjects:@"PlayerDataPoint"];
    [self deleteAllObjects:@"PatchPlayerInfo"];
    [self deleteAllObjects:@"PatchInfo"];
    [self deleteAllObjects:@"ConfigurationInfo"];
    
  
    
    //setup test user
    [self setupTestUser];
    
    //[self setupConfiguration];
    
    //[self clearUserDefaults];
    
    // Configure logging framework
	
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Setup the XMPP stream
    
	[self setupStream];
    
	if (![self connect])
	{
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                                     bundle: nil];
        
            UIViewController *controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"WizardNavController"];
            controller.modalPresentationStyle = UIModalPresentationFormSheet;
          
            
			[self.window.rootViewController presentViewController:controller animated:YES completion:nil];
		});
	}
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
   
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}
    
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark XMPP SETUP STREAM

- (void)setupStream
{
	NSAssert(_xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The xmppStream is the base class for all activity.
	// Everything else plugs into the __xmppStream, such as modules/extensions and delegates.
    
	_xmppStream = [[XMPPStream alloc] init];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.
		
		_xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	_xmppReconnect = [[XMPPReconnect alloc] init];
	
	// Activate xmpp modules
    
    //_xmppStream.hostName = XMPP_HOSTNAME;
    
    if( isMultiUserChat ) {
    //setup of room
        XMPPJID *roomJID = [XMPPJID jidWithString:ROOM_JID];
    
        _xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:self jid:roomJID];
        [_xmppRoom  activate:_xmppStream];
        [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
        
  	[_xmppReconnect activate:_xmppStream];
    
	// Add ourself as a delegate to anything we may be interested in
    
    [_xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[_xmppStream removeDelegate:self];
	[_xmppReconnect deactivate];
	[_xmppStream disconnect];
	
	_xmppStream = nil;
	_xmppReconnect = nil;
    
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

#pragma mark XMPP ONLINE OFFLINE

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[_xmppStream sendElement:presence];
    
    [_xmppBaseOnlineDelegate isAvailable:YES];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[_xmppStream sendElement:presence];
}

#pragma mark CONNECT/DISCONNECT

- (BOOL)connect
{
	if (![_xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    

    
	[_xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
    [_xmppStream setHostName:[[XMPPJID jidWithString:myJID] domain ] ];
    
	password = myPassword;
    
    
	NSError *error = nil;
	if (![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];
        
		DDLogError(@"ERROR CONNECTING\n: %@", error);
        
		return NO;
	}

	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[_xmppStream disconnect];
}

#pragma mark XMPPStream DELEGATE

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = _xmppStream.hostName;
		NSString *virtualDomain = [_xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![_xmppStream authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	} else {
        //play sound
        
        NSString *logonSoundPath = [[NSBundle mainBundle] pathForResource:@"logon_sound" ofType:@"aif"];
        NSURL *logonSoundURL = [NSURL fileURLWithPath:logonSoundPath];
        
        SystemSoundID _logonSound;
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)logonSoundURL, &_logonSound);
        
        //Just sound
        //AudioServicesPlaySystemSound(_logonSound);
        
        //sound and vibrate
        AudioServicesPlayAlertSound(_logonSound);
    
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    if( isMultiUserChat ) {
        NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
        [_xmppRoom joinRoomUsingNickname:myJID history:nil];
    }
    
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
    

	// A simple example of inbound message handling.
    if( [message isGroupChatMessageWithBody]) {
        NSString *msg = [[message elementForName:@"body"] stringValue];
        
        [self processXmppMessage:msg];
        
        
//        NSString *from = [[message attributeForName:@"from"] stringValue];
//        
//        lastMessageDict = [[NSMutableDictionary alloc] init];
//        [lastMessageDict setObject:msg forKey:@"msg"];
//        [lastMessageDict setObject:from forKey:@"sender"];
//        
//        
//        if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
//		{
//			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message"
//                                                                message:msg
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles:nil];
//			[alertView show];
//		}
//		else
//		{
//			// We are not active, so use a local notification instead
//			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//			localNotification.alertAction = @"Ok";
//			//localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
//            
//			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//		}
        
        //[_xmppBaseNewMessageDelegate newMessageReceived:lastMessageDict];

	} else if ([message isChatMessageWithBody]) {
		//XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		//                                                         _xmppStream:_xmppStream
		 //                                              managedObjectContext:[self managedObjectContext_roster]];
		
		//NSString *body = [[message elementForName:@"body"] stringValue];
		//NSString *displayName = [user displayName];
        
        NSString *msg = [[message elementForName:@"body"] stringValue];
        
        
        NSString *from = [[message attributeForName:@"from"] stringValue];
        
        lastMessageDict = [[NSMutableDictionary alloc] init];
        [lastMessageDict setObject:msg forKey:@"msg"];
        [lastMessageDict setObject:from forKey:@"sender"];
        
//        DataPoint *dp = [NSEntityDescription insertNewObjectForEntityForName:@"DataPoint"
//                                                   inManagedObjectContext:self.managedObjectContext];
//        
//        dp.from = from;
//        dp.to = @"bob";
//        dp.message = msg;
//        dp.timestamp = [NSDate date];
//
//        
//        [self.managedObjectContext save:nil];
    
        
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"test"
                                                                message:msg
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
			[alertView show];
		}
		else
		{
			// We are not active, so use a local notification instead
			UILocalNotification *localNotification = [[UILocalNotification alloc] init];
			localNotification.alertAction = @"Ok";
			//localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
            
			[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
		}
        [_xmppBaseNewMessageDelegate newMessageReceived:lastMessageDict];

	}
}

-(void)processXmppMessage: (NSString *)msg {
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    
    NSDictionary *jsonObjects = [jsonParser objectWithString:msg];
    
    if( jsonObjects != nil){
        NSString *destination = [jsonObjects objectForKey:@"destination"];
        
        
        NSString *event = [jsonObjects objectForKey:@"event"];
        
//        if( [event isEqualToString:@"game_reset"] ) {
//            [self resetGame];
//        } else if( [event isEqualToString:@"game_stop"] ) {
//            isRUNNING = NO;
//            isGAME_STOPPED = YES;
//        }
//        
//        if( ! [destination isEqualToString:[self origin]] )
//            return;
//        
        if( event != nil) {
            if( [event isEqualToString:@"patch_init_data"]){
//                
//                [[DataStore sharedInstance] resetPlayerCount];
//                
//                NSDictionary *payload = [jsonObjects objectForKey:@"payload"];
//                
//                feedRatio = @([[payload objectForKey:@"feed-ratio"] integerValue]);
//                
//                NSArray *tags = [payload objectForKey:@"tags"];
//                
//                for (NSDictionary *tag in tags) {
//                    
//                    NSString *tagId = [tag objectForKey:@"tag"];
//                    NSString *cluster = [tag objectForKey:@"cluster"];
//                    NSString *color = [tag objectForKey:@"color"];
//                    
//                    [[DataStore sharedInstance] addPlayerWithRFID:tagId withCluster:cluster withColor:color];
//                }
//                
//                [[DataStore sharedInstance] printPlayers];
//                
//                [[DataStore sharedInstance] addPlayerSpacing];
//                
//                
//                
//                //init the graph
//                if( hasGraph) {
//                    [graph reloadData];
//                } else {
//                    hasGraph = YES;
//                    
//                    [self initPlot];
//                }
//                
//                
            } else if( [event isEqualToString:@"rfid_update"] ){
                
                
                NSDictionary *payload = [jsonObjects objectForKey:@"payload"];
                NSArray *arrivals = [payload objectForKey:@"arrivals"];
                NSArray *departures = [payload objectForKey:@"departures"];
                
                if( arrivals != nil && arrivals.count > 0 ) {
                
                    if( _playerDataPoints == nil )
                        _playerDataPoints = [self getAllPlayerDataPoints];
                    
                    for (NSString *rfid in arrivals) {
                        PlayerDataPoint *player = [[_playerDataPoints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rfid == %@", rfid]] objectAtIndex:0];
                        
                        //set the arrival
                        [player setValue:destination forKey:@"PlayerDataPoint.currentPatch"];
                        

                    }
                }
                
                if( departures != nil && departures.count > 0 ) {
                    for (NSString *rfid in departures) {
                        PlayerDataPoint *player = [[_playerDataPoints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rfid == %@", rfid]] objectAtIndex:0];
                        
                        //set the arrival
                        [player setValue:nil forKey:@"PlayerDataPoint.currentPatch"];
                    }
                }
            }
            
            
        }
    }
    
    NSLog(@"message %@", msg);


}



- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    NSString *presenceType = [presence type]; // online/offline
	NSString *myUsername = [[sender myJID] user];
	NSString *presenceFromUser = [[presence from] user];
	
	if ([presenceFromUser isEqualToString:myUsername]) {
		
		if ([presenceType isEqualToString:@"available"]) {
            
            NSString *t = [NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"];
            DDLogVerbose(@"%@",t);
			
            [_xmppBaseOnlineDelegate isAvailable:YES];
			
		} else if ([presenceType isEqualToString:@"unavailable"]) {
			
            NSString *t = [NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"];
            DDLogVerbose(@"%@",t);
            
            [_xmppBaseOnlineDelegate isAvailable:NO];
			
		}
		
	}
    
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check _xmppStream.hostName");
	}
}

#pragma mark - XMPP ROOM DELEGATE

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[_xmppRoom fetchConfigurationForm];
	[_xmppRoom fetchBanList];
	[_xmppRoom fetchMembersList];
	[_xmppRoom fetchModeratorsList];
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    [_xmppBaseOnlineDelegate isAvailable:YES];
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)handleDidLeaveRoom:(XMPPRoom *)room
{
	DDLogInfo(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender didChangeOccupants:(NSDictionary *)occupants {
    DDLogVerbose(@"xmpp room did receiveMessage");
    //this is not correct should tell when leaves room
    [_xmppBaseOnlineDelegate isAvailable:NO];
}

#pragma mark CORE DATA DELETES

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext: [self managedObjectContext]];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [[self managedObjectContext ] executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
    	[[self managedObjectContext ] deleteObject:managedObject];
    	NSLog(@"%@ object deleted",entityDescription);
    }
    if (![[self managedObjectContext ] save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

#pragma mark CORE DATA INSERTS

- (void)insertPlayerDataPointWithCluster:(NSString *)cluster WithColor:(NSString *)color WithName:(NSString *)name WithPatch:(NSString *)patch WithRfid:(NSString *)rfid WithScore:(NSNumber *)score {
    PlayerDataPoint *pdp = [NSEntityDescription insertNewObjectForEntityForName:@"PlayerDataPoint"
                                               inManagedObjectContext:self.managedObjectContext];
    pdp.cluster = cluster;
    pdp.color = color;
    pdp.name = name;
    pdp.currentPatch = patch;
    pdp.rfid = rfid;
    pdp.score = score;
    pdp.timestamp = [NSDate date];
}

-(PatchInfo *)createPatchInfoWithPatchId: (NSString *)patch_id withRichness:(float) richness withRichnessPerSecond: (float)richness_per_second withRichnessPerMinute:(float)richness_per_minute {
    
    PatchInfo *pi = [NSEntityDescription insertNewObjectForEntityForName:@"PatchInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
    
    pi.patch_id = patch_id;
    pi.richness = richness;
    pi.richness_per_second = richness_per_second;
    pi.richness_per_minute = richness_per_minute;
    return pi;
}


-(ConfigurationInfo *)createConfigurationWithRunId: (NSString *)run_id withHarvestCalculatorBoutLengthInMinutes:(float)harvest_calculator_bout_length_in_minutes {
    
    ConfigurationInfo *ci = [NSEntityDescription insertNewObjectForEntityForName:@"ConfigurationInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
    
    ci.run_id = run_id;
    ci.harvest_calculator_bout_length_in_minutes = harvest_calculator_bout_length_in_minutes;
    return ci;
}


-(void)setupConfiguration {
    
    NSURL *url = [NSURL URLWithString:@"http://ltg.evl.uic.edu:9292/hunger-games-fall-13/configuration"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
                                         {
                                             NSLog(@"JSON RESULT %@", responseObject);
                                            // NSArray *configurations = [responseObject objectForKey:@"data"];
                                             
                                             for(NSDictionary *someConfig in responseObject) {
                                                 
                                                 
                                                 NSString *run_id = [someConfig objectForKey:@"run_id"];
                                                 NSString *boutLength = [someConfig objectForKey:@"harvest_calculator_bout_length_in_minutes"];
                                                 NSArray *patches = [someConfig objectForKey:@"patches"];
                                                
                                                 ConfigurationInfo *ci = [self createConfigurationWithRunId:run_id withHarvestCalculatorBoutLengthInMinutes:[boutLength floatValue]];
                                                 
                                                 for(NSDictionary *somePatch in patches) {
                                                     
                                                     NSString *patch_id = [somePatch objectForKey:@"patch_id"];
                                                     float richness = [[somePatch objectForKey:@"richness"] floatValue];
                                                     float richnessPerMinute = [[somePatch objectForKey:@"richness_per_minute"] floatValue];
                                                     float richnessPerSecond = [[somePatch objectForKey:@"richness_per_second"] floatValue];
                                                     
                                                     PatchInfo *pi = [self createPatchInfoWithPatchId:patch_id withRichness:richness withRichnessPerSecond: richnessPerSecond withRichnessPerMinute:richnessPerMinute];
                                                     [ci addPatchesObject:pi];
                                                 }
                                                 
                                                 
                                                 //load in the roster
                                                 [self importTestData];
                                                 [self.managedObjectContext save:nil];
                                                 
                                                 //setup the playerDataPoints for other controllers
                                                 _playerDataPoints = [self getAllPlayerDataPoints];

                                             }
                                             
                                             
                                             
                                             
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject)
                                         {
                                             NSLog(@"Request Failed: %@, %@", error, error.userInfo);
                                         }];
    
    [operation start];    
}




-(void)createEventInfoWithRFID: (NSString *)rfid WithEventType: (NSString *)eventType WithScore: (NSNumber *) score {
    EventInfo *ei = [NSEntityDescription insertNewObjectForEntityForName:@"EventInfo"
                                                  inManagedObjectContext:self.managedObjectContext];
    ei.rfid = rfid;
    ei.event_type = eventType;
    ei.score = score;
    ei.timestamp = [NSDate date];
}

#pragma mark CORE DATA FETCHES

-(PlayerDataPoint *)getPlayerDataPointWithRFID: (NSString *)rfid {
    NSManagedObjectModel* model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest* request = [model fetchRequestFromTemplateWithName:@"playerDataPointWithRFID" substitutionVariables:@{@"RFID" : rfid}];
    NSError* error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if( results.count == 0 ) {
        return nil;
    }
    
    return [results objectAtIndex:0];
}

-(NSArray *)getAllPatchInfos {
    NSManagedObjectModel* model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest* request = [model fetchRequestFromTemplateWithName:@"allPatchInfos" substitutionVariables:nil];
    NSError* error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    return results;
    
}

-(NSArray *)getAllPlayerDataPoints {
    NSManagedObjectModel* model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest* request = [model fetchRequestFromTemplateWithName:@"allPlayerDataPoints" substitutionVariables:nil];
    NSError* error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    return results;
    
}

-(NSArray *)getAllConfigurationsInfos {
    NSManagedObjectModel* model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest* request = [model fetchRequestFromTemplateWithName:@"allConfigurationsInfos" substitutionVariables:nil];
    NSError* error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    return results;
    
}

-(ConfigurationInfo *)getConfigurationInfoWithRunId: (NSString *)run_id {
    NSManagedObjectModel* model = [[self.managedObjectContext persistentStoreCoordinator] managedObjectModel];
    NSFetchRequest* request = [model fetchRequestFromTemplateWithName:@"configurationInfoWithRunId"
                                                substitutionVariables:@{@"RUN_ID" : run_id}];
    NSError* error = nil;
    NSArray* results = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if( results.count == 0 ) {
        return nil;
    }
    
    return [results objectAtIndex:0];
}

-(void)updateScores {
    
//    if( patchInfos == nil || patchInfos.count == 0) {
//        patchInfos = [self getAllPatchInfos];
//    }
//    
//    for (PatchInfo *pi in patchInfos ) {
//        
//        NSArray * playersAtPatch = [self getPatchPlayerInfosWithPatchName:pi.name];
//        
//        if( playersAtPatch.count > 0 ) {
//            
//            
//            //.2 sec so you get 2 cal
//            float adjustedFeedratio = [pi.yield floatValue] / 5.0f;
//            
//            float newPatchYield = adjustedFeedratio/playersAtPatch.count;
//            
//            
//            
//            for(PatchPlayerInfo *pap in playersAtPatch) {
//                PlayerDataPoint *pdp = [self getPlayerDataPointWithRFID:pap.rfid];
//                
//                float newScore = [pdp.score floatValue]+newPatchYield;
//                NSLog(@"OLD SCORE %f NEW SCORE %f", [pdp.score floatValue], newScore);
//                
//                pdp.score = [NSNumber numberWithFloat:newScore];
//                
//            }
//            
//            [self.managedObjectContext save:nil];
//            
//            [_xmppBaseNewMessageDelegate newMessageReceived:nil];
//        }
//    }
    
    
    
}

-(void)setupConfigurationAndRosterWithRunId:(NSString *)run_id {
    
    _configurationInfo = [self getConfigurationInfoWithRunId:run_id];
    
    
}

- (void)importCoreDataDefaultGraph {
    
    NSLog(@"Importing Core Data Default Values for Graph.......");
    
    
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#89369e" WithName:@"XPR" WithPatch:@"3" WithRfid:@"1623110" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#99896f" WithName:@"NOI" WithPatch:@"3" WithRfid:@"1623392" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#cb5012" WithName:@"NLO" WithPatch:@"3" WithRfid:@"1623115" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#146d71" WithName:@"NUI" WithPatch:@"3" WithRfid:@"1623373" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#ffbeb4" WithName:@"NER" WithPatch:@"3" WithRfid:@"1623110" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#89369e" WithName:@"NWE" WithPatch:@"3" WithRfid:@"1623667" WithScore:[NSNumber numberWithInt:0]];
    
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#89369e" WithName:@"NQW" WithPatch:@"3" WithRfid:@"1623678" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#99896f" WithName:@"NSE" WithPatch:@"3" WithRfid:@"1623663" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#cb5012" WithName:@"NXS" WithPatch:@"3" WithRfid:@"1623302" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#146d71" WithName:@"NLP" WithPatch:@"3" WithRfid:@"1623303" WithScore:[NSNumber numberWithInt:10000]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#ffbeb4" WithName:@"NPR" WithPatch:@"3" WithRfid:@"1623126" WithScore:[NSNumber numberWithInt:0]];
    
    
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#89369e" WithName:@"NIR" WithPatch:@"3" WithRfid:@"1623238" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#89369e" WithName:@"NWR" WithPatch:@"3" WithRfid:@"1623257" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#99896f" WithName:@"NWR" WithPatch:@"3" WithRfid:@"1623210" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#cb5012" WithName:@"NMR" WithPatch:@"3" WithRfid:@"1623305" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#146d71" WithName:@"EPR" WithPatch:@"3" WithRfid:@"1623386" WithScore:[NSNumber numberWithInt:0]];
    
    
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#ffbeb4" WithName:@"OPR" WithPatch:@"3" WithRfid:@"1623392" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#99896f" WithName:@"KPR" WithPatch:@"3" WithRfid:@"1623115" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#cb5012" WithName:@"MPR" WithPatch:@"3" WithRfid:@"1623373" WithScore:[NSNumber numberWithInt:0]];
    [self insertPlayerDataPointWithCluster:@"a" WithColor:@"#cb5012" WithName:@"JPR" WithPatch:@"3" WithRfid:@"1623110" WithScore:[NSNumber numberWithInt:0]];
    NSLog(@"Importing Core Data Default Values for Graph Completed!");
}



- (void)importTestData {
    NSLog(@"Importing Core Data Default Values for DataPoints...");
    
    [self importCoreDataDefaultGraph];
    
    
    
//    [self insertDataPointWith:@"Obama" To:@"Biden" WithMessage:@"Don't fuck up"];
//    [self insertDataPointWith:@"TEster" To:@"Biden" WithMessage:@"Don't fuck up asshole"];
    NSLog(@"Importing Core Data Default Values for DataPoints Completed!");
}

-(void)setupTestUser {
    [[NSUserDefaults standardUserDefaults] setObject:@"tester@ltg.evl.uic.edu" forKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] setObject:@"tester" forKey:kXMPPmyPassword];
}

-(void)clearUserDefaults {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kXMPPmyPassword];
}

#pragma mark XMPPRoomStorage PROTOCOL


- (void)handlePresence:(XMPPPresence *)presence room:(XMPPRoom *)room
{
    
}

- (void)handleIncomingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    
}

- (void)handleOutgoingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    
}

- (BOOL)configureWithParent:(XMPPRoom *)aParent queue:(dispatch_queue_t)queue
{
	return YES;
}

#pragma mark CoreDataManagement PROTOCOL

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    
    NSError *error = nil;
    NSManagedObjectContext *objectContext = self.managedObjectContext;
    if (objectContext != nil)
    {
        if ([objectContext hasChanges] && ![objectContext save:&error])
        {
            // add error handling here
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"localdb.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}

@end
