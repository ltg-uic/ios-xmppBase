//
//  ViewController.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/14/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "MapVisualizationViewController.h"

@interface MapVisualizationViewController ()

@end

@implementation MapVisualizationViewController

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

    
    CGRect patchViewFrame = CGRectMake( 100, 1, 75, 75 );
    // Create a view and add it to the window.
    UIView* patchView = [[UIView alloc] initWithFrame: patchViewFrame];

    [patchView setBackgroundColor: [UIColor redColor]];
    [self.view addSubview: patchView];
    
    
  

    
    UIDynamicAnimator* animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIGravityBehavior* gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[patchView]];
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[patchView]];
    [collisionBehavior addBoundaryWithIdentifier:@"wall" fromPoint:CGPointMake(0,300) toPoint:CGPointMake(500,300)];
   
    //collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;

  [animator addBehavior:collisionBehavior];
    [animator addBehavior:gravityBeahvior];
    self.animator = animator;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.animator removeAllBehaviors];
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    // Lighten the background color when the view is in contact with a boundary.
    [(UIView*)item setBackgroundColor:[UIColor greenColor]];
}


-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier
{
    // Restore the default color when ending a contcact.
    [(UIView*)item setBackgroundColor:[UIColor redColor]];
}

@end
