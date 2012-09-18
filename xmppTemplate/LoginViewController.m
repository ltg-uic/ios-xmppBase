//
//  LoginViewController.m
//  ios-xmppBase
//
//  Created by Anthony Perritano on 9/17/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark View lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    NSString *l = [[NSUserDefaults standardUserDefaults] stringForKey:@"kXMPPmyJID"];
    NSString *p = [[NSUserDefaults standardUserDefaults] stringForKey:@"kXMPPmyPassword"];
    
    if( l != nil ) {
        loginTextField.text = l;
    }
    
    if( p != nil ) {
        passTextField.text = p;
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}


- (IBAction)done:(id)sender
{
    [self setField:loginTextField forKey:@"kXMPPmyJID"];
    [self setField:passTextField forKey:@"kXMPPmyPassword"];
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
