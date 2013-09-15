//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "MapViewController.h"
#import "PatchMapUIView.h"
#import "PlayerMapUIView.h"
#import "PatchInfo.h"
#import "UIColor-Expanded.h"
#import "SWRevealViewController.h"

@interface MapViewController () {
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

-(void)setupPatches {
    
     patchInfos = [[[[self appDelegate] configurationInfo ] patches ] allObjects];
    
    _hasInitialized = YES;
    
    for (int i = 0; i < _patchUIViews.count; i++) {
        PatchMapUIView *pmap = _patchUIViews[i];
        PatchInfo *pi = patchInfos[i];
        pmap.patch_id = pi.patch_id;
        pmap.title.text = pi.patch_id;
        pmap.richness.text = [NSString stringWithFormat:@"%.2f", pi.richness_per_minute];
    }
    
}

#pragma mark - PLAYER DATA DELEGATE

-(void)playerDataDidUpdate:(NSArray *)playerDataPoints WithColorMap:(NSMutableDictionary *)colorMap {
    
    if(_hasInitialized == NO )
        [self setupPatches];
 
}

-(void)playerDataDidUpdateWithArrival:(NSString *)arrival_patch_id WithDeparture:(NSString *)departure_patch_id WithPlayerDataPoint:(PlayerDataPoint *)playerDataPoint {
    
    if( arrival_patch_id != nil ) {
        PatchMapUIView *arrivalView = [[_patchUIViews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"patch_id == %@", arrival_patch_id]] objectAtIndex:0];
        
        if( arrivalView != nil ) {
            
            for(PlayerMapUIView *pmp in arrivalView.players ) {
                
                if( pmp.hidden == YES ) {
                    
                    UIColor *hexColor = [UIColor colorWithHexString:[playerDataPoint.color stringByReplacingOccurrencesOfString:@"#" withString:@""]];
                    pmp.uiColor = hexColor;
                    pmp.backgroundColor = [UIColor clearColor];
                    pmp.player_id = playerDataPoint.rfid_tag;
                    pmp.nameLabel.text = playerDataPoint.player_id;
                    pmp.nameLabel.textColor = [self getTextColor:hexColor];
                    pmp.hidden = NO;
                    [pmp setNeedsDisplay];
                    break;
                }
            }
            
        }
    }
    
    if( departure_patch_id != nil ) {
        PatchMapUIView *departureView = [[_patchUIViews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"patch_id == %@", departure_patch_id]] objectAtIndex:0];
        
        if( departureView != nil ) {
            
            for(PlayerMapUIView *pmp in departureView.players ) {
                
                if( pmp.hidden == NO ) {
                    
                    pmp.backgroundColor = [UIColor clearColor];
                    pmp.player_id = nil;
                    pmp.nameLabel.text = nil;
                    pmp.hidden = YES;
                    [pmp setNeedsDisplay];
                    break;
                }
            }
            
        }
    }
    
}

- (UIColor *) getTextColor:(UIColor *)color
{
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    
    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
    if (colorBrightness < 0.5)
    {
        NSLog(@"my color is dark");
        return [UIColor whiteColor];
    }
    else
    {
        NSLog(@"my color is light");
        return [UIColor blackColor];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    //self.title = @"News";

    // Change button color
    //_sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];

    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    
    [self.revealButtonItem setTarget: self.revealViewController];
    [self.revealButtonItem setAction: @selector( revealToggle: )];
    [self.navigationController.navigationBar addGestureRecognizer: self.revealViewController.panGestureRecognizer];


    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    

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
