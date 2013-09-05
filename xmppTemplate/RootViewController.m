//
//  ViewController.m
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        self.appDelegate.xmppBaseOnlineDelegate = self;
        self.appDelegate.xmppBaseNewMessageDelegate = self;
    }
    return self;
}
- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

	// Do any additional setup after loading the view, typically from a nib.
    //self.title = [NSString stringWithFormat:@"Viz",0];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMPP Online Delegate

- (void)isAvailable:(BOOL)available {
    
    if( available ) {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID ];
        
        
        statusBarButton.title = [[[XMPPJID jidWithString:userName] user ] capitalizedString ];
        statusBarButton.tintColor = [UIColor greenColor];
    } else {
        statusBarButton.tintColor = [UIColor redColor];
    }
    
}

#pragma mark - XMPP New Message Delegate

- (void)newMessageReceived:(NSDictionary *)messageContent {

    NSLog(@"NEW MESSAGE RECIEVED");
}

- (void)replyMessageTo:(NSString *)from {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
