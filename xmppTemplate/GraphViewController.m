//
//  MapViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "GraphViewController.h"
#import "PlayerDataPoint.h"
#import "PatchInfo.h"
#import "UIColor-Expanded.h"

@interface GraphViewController() {

    //core data
    NSArray *localPlayerDataPoints;
    NSMutableDictionary *localColorMap;
    
    NSSet *patchInfos;
    
    NSTimer *intervalTimer;
    
    //corePlot
    CPTColor *blueColor;
    CPTColor *redColor;
    CPTXYGraph *graph;
    CPTBarPlot *harvestBarPlot;
    CPTXYPlotSpace *plotSpace;
    
    CGFloat minNumPlayers;
    CGFloat maxNumPlayers;
    
    CGFloat minYield;
    CGFloat maxYield;
    
    bool isRUNNING;
    bool isGAME_STOPPED;
    bool graphNeedsReload;
}

@end


@implementation GraphViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        
       
//        PatchInfo *pi = [[PatchInfo alloc] init];
//        pi.patch_id = @"patch-1";
//        pi.richness = 400.0f;
//        pi.richness_per_second = 5.0f;
//        
//        [patchInfos addObject:pi];
//        
//        pi = [[PatchInfo alloc] init];
//        
//        pi.patch_id = @"patch-2";
//        pi.richness = 600.0f;
//        pi.richness_per_second = 8.0f;
//        
//        [patchInfos addObject:pi];
        
        [self setupDelegates];
       
        
    }
    return self;
}

-(void)setupDelegates {
    self.appDelegate.xmppBaseNewMessageDelegate = self;
}

#pragma mark - PLAYER DATA DELEGATE

-(void)playerDataDidUpdate:(NSArray *)playerDataPoints WithColorMap:(NSMutableDictionary *)colorMap {
    
    localPlayerDataPoints = playerDataPoints;
    localColorMap = colorMap;
}

#pragma mark - XMPP New Message Delegate

- (void)newMessageReceived:(NSDictionary *)messageContent {
    NSLog(@"NEW MESSAGE RECIEVED");
}

- (void)replyMessageTo:(NSString *)from {
    
}

#pragma mark - TIMER

-(void)startTimer {
    if( intervalTimer == nil)
        intervalTimer = [NSTimer scheduledTimerWithTimeInterval:.2
                                                         target:self
                                                       selector:@selector(updateGraph)
                                                       userInfo:nil
                                                        repeats:YES];

}

-(void)stopTimer {
    if( intervalTimer != nil)
        [intervalTimer invalidate];
    intervalTimer = nil;

}

#pragma mark - VIEWS

-(void)viewDidAppear:(BOOL)animated {
    [self initPlot];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = graphViewTitle;
    
    // Change button color
    //_sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //[self.graphView.];
    
    //[graph reloadData];
    
}


#pragma mark - Chart behavior

-(void)initPlot {
    
    //setup colors
    
    blueColor = [CPTColor colorWithComponentRed:67.0f/255.0f green:155.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    redColor = [CPTColor colorWithComponentRed:198.0f/255.0f green:42.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    
    minNumPlayers = -0.5f;
    maxNumPlayers = [localPlayerDataPoints count];
    
    minYield = 0.0f;
    maxYield = 30000.0f;
    
    
    [self setupGraph];
    [self setupAxes];
    [self setupBarPlot];
   
    [harvestBarPlot setHidden:NO];
    
}


-(void)setupGraph {
    // 1 - Create the graph
    graph = [[CPTXYGraph alloc] initWithFrame: self.graphView.bounds];
    self.graphView.hostedGraph = graph;
    
    graph.plotAreaFrame.masksToBorder = YES;
    self.graphView.allowPinchScaling = NO;
    
    graph.paddingBottom = 1.0f;
    graph.paddingRight  = 1.0f;
    graph.paddingLeft  =  1.0f;
    graph.paddingTop    = 1.0f;
    //
    
    graph.plotAreaFrame.paddingLeft   = 75.0;
    graph.plotAreaFrame.paddingTop    = 0.0;
    graph.plotAreaFrame.paddingRight  = 0.0;
    graph.plotAreaFrame.paddingBottom = 0.0;
    
    plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;

    
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minYield) length:CPTDecimalFromFloat(maxYield)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minNumPlayers) length:CPTDecimalFromFloat(maxNumPlayers)];
}


-(void)setupBarPlot {
    // 1 - Set up the three plots
    harvestBarPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor redColor] horizontalBars:YES];
    //harvestBarPlot.backgroundColor = [[UIColor redColor] CGColor];
    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor blackColor];
    barLineStyle.lineWidth = 1;
    
    // 3 - Add plot to graph
    harvestBarPlot.dataSource = self;
    harvestBarPlot.identifier = harvestPlotId;
    harvestBarPlot.delegate = self;
    harvestBarPlot.cornerRadius = 2.0;
    
    harvestBarPlot.lineStyle = barLineStyle;
    [graph addPlot:harvestBarPlot toPlotSpace:graph.defaultPlotSpace];
}

-(void)setupAxes {

    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.graphView.hostedGraph.axisSet;

    // Line styles
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = .5;
    axisLineStyle.lineColor = [CPTColor lightGrayColor];
    
    
    // Text styles
    CPTMutableTextStyle *labelTitleTextStyleBlue = [CPTMutableTextStyle textStyle];
    labelTitleTextStyleBlue.fontName = helveticaNeueMedium;
    labelTitleTextStyleBlue.fontSize = 28.0;
    labelTitleTextStyleBlue.color = blueColor;
    
    CPTMutableTextStyle *labelTitleTextStyleRed = [CPTMutableTextStyle textStyle];
    labelTitleTextStyleRed.fontName = helveticaNeueMedium;
    labelTitleTextStyleRed.fontSize = 28.0;
    labelTitleTextStyleRed.color = redColor;
    
    CPTXYAxis *y = axisSet.yAxis;
    
    y.plotSpace                   = graph.defaultPlotSpace;
    y.labelingPolicy              = CPTAxisLabelingPolicyNone;
    y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(1);
    y.tickDirection               = CPTSignNone;
    y.axisLineStyle               = axisLineStyle;
    y.majorTickLength             = 0.0f;

    NSMutableSet *newAxisLabels = [NSMutableSet set];
    for ( NSUInteger i = 0; i < [localPlayerDataPoints count]; i++ ) {
        
        
        CPTMutableTextStyle *textStyle;
        if (i % 2) {
            // odd
            textStyle = labelTitleTextStyleBlue;
        } else {
            //even
            textStyle = labelTitleTextStyleRed;
        }
        
        
        
        PlayerDataPoint *pdp = [localPlayerDataPoints objectAtIndex:i];

        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[pdp.name uppercaseString]
                                                          textStyle:textStyle];

        newLabel.tickLocation = CPTDecimalFromUnsignedInteger(i);
        newLabel.offset       = y.labelOffset + y.majorTickLength;

        
        [newAxisLabels addObject:newLabel];
    }
    y.axisLabels = newAxisLabels;
    
    
    
    CPTXYAxis *x = axisSet.xAxis;
    
    x.plotSpace                   = graph.defaultPlotSpace;
    x.labelingPolicy              = CPTAxisLabelingPolicyNone;
    x.axisLineStyle               = nil;
    x.majorTickLineStyle          = nil;
    x.minorTickLineStyle          = nil;
    x.majorTickLength             = 4.0f;
    x.minorTickLength             = 2.0f;
    x.tickDirection               = CPTSignNegative;

    x.majorIntervalLength         = CPTDecimalFromString(@"1");
    x.orthogonalCoordinateDecimal = CPTDecimalFromString(@"1");

    
    
    graph.axisSet.axes = @[x,y];

    
}

- (IBAction)fireTimer:(id)sender {
    
    if( isRUNNING == NO) {
        isRUNNING = YES;
        [self startTimer];
    } else {
        isRUNNING = NO;
        [self stopTimer];
    }
    
}

#pragma mark - CPTPlotDataSource methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [localPlayerDataPoints count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	if ((fieldEnum == CPTBarPlotFieldBarTip) && (index < [localPlayerDataPoints count])) {
		if ([plot.identifier isEqual:harvestPlotId]) {
            PlayerDataPoint *pdp = [localPlayerDataPoints objectAtIndex:index];
            
            NSLog(@"SCORES %f", [pdp.score floatValue]);
            
            return pdp.score;
        }
	}
	return [NSDecimalNumber numberWithUnsignedInteger:index];
}


-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    CPTMutableTextStyle *axisTitleTextStyle = [CPTMutableTextStyle textStyle];
    axisTitleTextStyle.fontName = helveticaNeueMedium;
    axisTitleTextStyle.fontSize = 26.0;
    
    PlayerDataPoint *pdp = [localPlayerDataPoints objectAtIndex:index];
    
    CPTTextLayer *label=[[CPTTextLayer alloc] initWithText: [pdp.score stringValue] style:axisTitleTextStyle];
    return label;
}


#pragma mark - Annotation methods

-(void)hideAnnotation {
//none at this time
}

-(CPTFill *)barFillForBarPlot:(CPTBarPlot *)barPlot
                  recordIndex:(NSUInteger)index {
    
    if ( [barPlot.identifier isEqual:harvestPlotId] ) {
        NSString *hexColor = [[localPlayerDataPoints objectAtIndex:index] valueForKey:@"color"];
        UIColor *rgbColor = [localColorMap objectForKey:hexColor];
        CPTFill *fill = [CPTFill fillWithColor:[CPTColor colorWithCGColor:rgbColor.CGColor]];
        return fill;
        
    }
    return [CPTFill fillWithColor:redColor];
    
}


#pragma update

-(void)updateGraph {
    
    if( isRUNNING && localPlayerDataPoints.count > 0 ) {
        
        //get all the current arrivals and departures
//        patchPlayerInfos = [[self appDelegate] patchPlayerInfos];
//        
//        
//        NSArray *rfidKeys = [patchPlayerInfos allKeys];
//        
//        for( NSString *rfid in rfidKeys ) {
//            //find the patch where she is at
//            NSString *patch_id = [patchPlayerInfos objectForKey:rfid];
//            
//            
//            //get the players score
//            NSPredicate * playerPredicate = [NSPredicate predicateWithFormat:@"rfid = %@", rfid];
//            PlayerDataPoint *pdp = [[localPlayerDataPoints filteredArrayUsingPredicate:playerPredicate] objectAtIndex: 0 ];
//
//            
//            //calculate the new score
//            float playerOldScore = [pdp.score floatValue];
//            
//            
//        
//            
//            
        
            
       // }
        
        
        for (PlayerDataPoint *pdp in localPlayerDataPoints) {
            if( [pdp.name isEqual:@"XPR"]) {
                pdp.score = [NSNumber numberWithFloat:[pdp.score floatValue] + 10];
            }
        }
        
        [graph reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
