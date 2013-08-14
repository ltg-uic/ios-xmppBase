//
//  ViewController.h
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPBaseOnlineDelegate.h"
#import "XMPPBaseNewMessageDelegate.h"
#import "DataPoint.h"
#import "APPChildViewController.h"

@interface RootViewController : UIViewController<XMPPBaseOnlineDelegate,XMPPBaseNewMessageDelegate,UIPageViewControllerDataSource> {
    
    __weak IBOutlet UIBarButtonItem *statusBarButton;

}

@property (weak, nonatomic) IBOutlet UIImageView *red_awareness;
@property (weak, nonatomic) IBOutlet UIImageView *green_awareness;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) UIPageViewController *pageController;

@end
