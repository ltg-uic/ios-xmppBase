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
    self.appDelegate.xmppBaseNewMessageDelegate = self;
   
    
    _pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"page_controller"];
    
//    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    
    self.pageController.dataSource = self;
//    [[self.pageController view] setFrame:[[self view] bounds]];
//    
    APPChildViewController *initialViewController = [self viewControllerAtIndex:0];
//    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
//    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - page controller

- (APPChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    APPChildViewController *childViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"screen_one"];
    childViewController.index = index;
    
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(APPChildViewController *)viewController index];
    
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMPP Online Delegate

- (void)isAvailable:(BOOL)available {
    
    if( available ) {
        statusBarButton.tintColor = [UIColor greenColor];
    } else {
        statusBarButton.tintColor = [UIColor redColor];
    }
    
}

#pragma mark - XMPP New Message Delegate

- (void)newMessageReceived:(NSDictionary *)messageContent {

}

- (void)replyMessageTo:(NSString *)from {
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)setupFetchedResultsController
{
    // 1 - Decide what Entity you want
    NSString *entityName = @"DataPoint"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    //request.predicate = [NSPredicate predicateWithFormat:@"Role.name = Blah"];
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp"
                                                                                     ascending:NO]];
    // 5 - Fetch it
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.appDelegate.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
   // [self performFetch];
}


@end
