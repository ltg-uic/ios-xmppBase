//
//  WizClassPageViewController.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/19/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RosterModel.h"

@interface WizardClassPageViewController : UITableViewController {
}

@property (nonatomic, retain) NSArray *classes;
- (IBAction)cancelLogin:(id)sender;

@end
