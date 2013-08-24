//
//  ViewController.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/14/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "VizViewController.h"

@interface MapVisualizationViewController : VizViewController<UICollisionBehaviorDelegate> {
}
@property (weak, nonatomic) IBOutlet UIView *patchView;
@property (nonatomic) UIDynamicAnimator* animator;
@property (assign, nonatomic,readwrite) NSInteger index;

@end
