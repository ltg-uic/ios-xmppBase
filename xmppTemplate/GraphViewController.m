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
    NSArray *localPatches;
    
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
        
        [self setupDelegates];
        localColorMap = [[self appDelegate] colorMap];
        localPlayerDataPoints = [[self appDelegate] playerDataPoints];
        localPatches = [[[[self appDelegate] configurationInfo ] patches ] allObjects];
    }
    return self;
}

-(void)setupDelegates {
    self.appDelegate.xmppBaseNewMessageDelegate = self;
    self.appDelegate.playerDataDelegate = self;
}

#pragma mark - PLAYER DATA DELEGATE

-(void)playerDataDidUpdate:(NSArray *)playerDataPoints WithColorMap:(NSMutableDictionary *)colorMap {
    
//    localPlayerDataPoints = playerDataPoints;
//    localColorMap = colorMap;
//    
//    [graph reloadData];
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
    //[self initPlot];
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
    
    [self initPlot];
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
    maxYield = 10000.0f;
    
    
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
    
    CPTMutableTextStyle *labelTitleTextStyleBlack = [CPTMutableTextStyle textStyle];
    labelTitleTextStyleBlack.fontName = helveticaNeueMedium;
    labelTitleTextStyleBlack.fontSize = 28.0;
    labelTitleTextStyleBlack.color = [CPTColor blackColor];
    
    CPTXYAxis *y = axisSet.yAxis;
    
    y.plotSpace                   = graph.defaultPlotSpace;
    y.labelingPolicy              = CPTAxisLabelingPolicyNone;
    y.orthogonalCoordinateDecimal = CPTDecimalFromUnsignedInteger(1);
    y.tickDirection               = CPTSignNone;
    y.axisLineStyle               = axisLineStyle;
    y.majorTickLength             = 0.0f;

    NSMutableSet *newAxisLabels = [NSMutableSet set];
    for ( NSUInteger i = 0; i < [localPlayerDataPoints count]; i++ ) {
        
        PlayerDataPoint *pdp = [localPlayerDataPoints objectAtIndex:i];
        
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[pdp.player_id uppercaseString]
                                                          textStyle:labelTitleTextStyleBlack];
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
    
    if( isRUNNING && localPlayerDataPoints.count > 0 && localPatches.count > 0) {
        
        //get all the current arrivals and departures
//        patchPlayerInfos = [[self appDelegate] patchPlayerInfos];
//        
//        
        NSArray *players = [localPlayerDataPoints filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"currentPatch != nil"]];

        if( players.count == 0 )
            return;
        
        for( PlayerDataPoint *pdp in localPlayerDataPoints ) {
            //get the patch
            
            
            
            PatchInfo *pi = [[localPatches filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"patch_id == %@", pdp.currentPatch]] objectAtIndex:0];
            
            int numberOfPlayerAtPatches = [localPlayerDataPoints valueForKey:@"@count"];
            //get the players score
            
            
            //calculate the new score
            float playerOldScore = [pdp.score floatValue];
            
            float adjustment = pi.richness / numberOfPlayerAtPatches;

            
            pdp.score = [NSNumber numberWithFloat:(playerOldScore + adjustment)];
            
            NSLog(@"PLAYER %@ for score %f",pdp.player_id, [pdp.score floatValue]);
            
            
        
            
       }
        
        
//        for (PlayerDataPoint *pdp in localPlayerDataPoints) {
//            if( [pdp.name isEqual:@"XPR"]) {
//                pdp.score = [NSNumber numberWithFloat:[pdp.score floatValue] + 10];
//            }
//        }
        
        [graph reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
