//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerDataDelegate.h"
#import "PatchMapUIView.h"

@interface MapViewController : UIViewController<PlayerDataDelegate> {
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;
@property(retain) IBOutletCollection(PatchMapUIView) NSArray *patchUIViews;
@property(nonatomic) BOOL hasInitialized;

@end
