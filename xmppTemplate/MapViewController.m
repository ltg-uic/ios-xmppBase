//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MapViewController.h"
#import "PatchMapUIView.h"
#import "PatchInfo.h"

@interface MapViewController () {
    NSMutableDictionary *patchViewMap;
    NSArray *patchInfos;
    

}

@end

@implementation MapViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        
        self.appDelegate.playerDataDelegate = self;

    }
    return self;
}

#pragma mark - PLAYER DATA DELEGATE

-(void)playerDataDidUpdate:(NSArray *)playerDataPoints WithColorMap:(NSMutableDictionary *)colorMap {
    
    
//    if ( patchViewMap == nil || patchViewMap.count == 0 ) {
//        
//        patchViewMap = [[NSMutableDictionary alloc] init];
//        patchInfos = [[[[self appDelegate] configurationInfo ] patches ] allObjects];
//        
//        int x = 20;
//        int y = 60;
//        for( PatchInfo *pi in patchInfos) {
//            
//            
//            PatchMapUIView *patchView = [self createPatchViewsWithPatchInfo:pi AtX:x AtY:y];
//            [patchViewMap setObject:patchView forKey:pi.patch_id];
//            [self.view addSubview:patchView];
//            
//            x = x + 200;
//            y = y + 100;
//            
//        }
//        
//        
//        [self.view setNeedsDisplay];
//    }
    
    
    
    //    localPlayerDataPoints = playerDataPoints;
    //    localColorMap = colorMap;
    //
    //    [graph reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.title = @"News";

    // Change button color
    //_sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);

    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
//    [patchViewMap enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
//                                             usingBlock:^(id key, id object, BOOL *stop) {
//                                                 [self.view addSubview:object];
//                                             }];
}

-(PatchMapUIView *)createPatchViewsWithPatchInfo:(PatchInfo *)patchInfo AtX:(int)x AtY:(int)y  {

    
    PatchMapUIView *patchView = [[PatchMapUIView alloc] init];
    
    CGRect frame = patchView.frame;
    frame.origin.x = x;
    frame.origin.y = y;

    patchView.frame = frame;
    patchView.richness.text = [NSString stringWithFormat:@"%.0f", patchInfo.richness_per_minute];
    patchView.title.text = patchInfo.patch_id;
    [patchView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    return patchView;
    
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
