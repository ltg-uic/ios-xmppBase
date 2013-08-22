//
//  WizardReviewPageViewController.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/21/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "WizardReviewPageViewController.h"
#import "AppDelegate.h"

@interface WizardReviewPageViewController ()

@end

@implementation WizardReviewPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    studentNameLabel.text = [[_choosen_student capitalizedString] stringByAppendingString:@"?"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doLoginWithStudentName:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:[_choosen_student stringByAppendingString:XMPP_TAIL] forKey:kXMPPmyJID];
    
    [[NSUserDefaults standardUserDefaults] setObject:_choosen_student forKey:kXMPPmyPassword];
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        [[self appDelegate] disconnect];
        [[self appDelegate] connect];
    }];
    
    
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



@end
