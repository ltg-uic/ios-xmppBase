//
//  ViewController.m
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"
#import "VizViewController.h"
#import "VizOneViewController.h"
#import "VizTwoViewController.h"
#import "VizThreeViewController.h"

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
    
   
    
    _pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"page_controller"];

    //config the datasource
    self.pageController.dataSource = self;
    //[[self.pageController view] setFrame:[[self view] bounds]];
    
    //setup all the vizes
    [self setupVizViewControllers];
    
    [self.pageController setViewControllers:@[[all_visualizations objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

    //add the subviews
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
	// Do any additional setup after loading the view, typically from a nib.
    //self.title = [NSString stringWithFormat:@"Viz",0];
}

-(void)setupVizViewControllers {
    
    VizViewController *viz1 = [self.storyboard instantiateViewControllerWithIdentifier:@"viz_1"];
    VizViewController *viz2 = [self.storyboard instantiateViewControllerWithIdentifier:@"viz_2"];
    VizViewController *viz3 = [self.storyboard instantiateViewControllerWithIdentifier:@"viz_3"];

    viz1.index = 0;
    viz2.index = 1;
    viz3.index = 2;
    
    all_visualizations = @[viz1,viz2,viz3];
}


#pragma mark - page controller

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if( completed ) {
        
    }
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    //self.title = [NSString stringWithFormat:@"Viz #%d",index];
    
   // VizViewController *viz = [all_visualizations objectAtIndex:index];
    //viz.index = index;
    
    return [all_visualizations objectAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(VizViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((VizViewController *)viewController).index;
    
    index++;
    
    if (index == 3) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 3;
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

    NSLog(@"NEW MESSAGE RECIEVED");
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
