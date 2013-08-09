//
//  ViewController.m
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate.xmppBaseOnlineDelegate = self;
    _green_awareness.hidden = YES;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)isAvailable:(BOOL)available {
    
    if( available ) {
        _red_awareness.hidden = YES;
        _green_awareness.hidden = NO;
    } else {
        _red_awareness.hidden = NO;
        _green_awareness.hidden = YES;
    }
    
}
@end
