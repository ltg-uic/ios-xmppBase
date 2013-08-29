//
//  MapViewController.m
//  RevealControllerStoryboardExample
//
//  Created by Nick Hodapp on 1/9/13.
//  Copyright (c) 2013 CoDeveloper. All rights reserved.
//

#import "GraphViewController.h"
#import "PlayerDataPoint.h"
#import "UIColor-Expanded.h"

@interface GraphViewController() {

    //corePlot
    CPTColor *blueColor;
    CPTColor *redColor;
    CPTXYGraph *graph;
    CPTBarPlot *harvestBarPlot;
    CPTXYPlotSpace *plotSpace;
}

@end


@implementation GraphViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        [self performDataFetch];
        
    }
    return self;
}


#pragma mark - Fetching

- (void)performDataFetch
{
    managedObjectContext = [[self appDelegate] managedObjectContext];
    // 1 - Decide what Entity you want
    NSString *entityName = @"PlayerDataPoint"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:entityName inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    NSError *error;
    playerDataPoints = [managedObjectContext executeFetchRequest:request error:&error];
    if (playerDataPoints == nil)
    {
         NSLog(@"ERRORRRR FETCHING: %@", [error localizedDescription]);
    } else {
        for (PlayerDataPoint  *pdp in playerDataPoints) {
            NSLog(@"PDP !!!!! %@", pdp.name);
        }
    }
    
    
    // 4 - Sort it if you want
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                                     ascending:YES
                                                                                      selector:@selector(localizedCaseInsensitiveCompare:)]];
                
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
    [self initPlot];
}

#pragma mark - Chart behavior

-(void)initPlot {
    
    //setup colors
    
    blueColor = [CPTColor colorWithComponentRed:67.0f/255.0f green:155.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    redColor = [CPTColor colorWithComponentRed:198.0f/255.0f green:42.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    
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
    
    CGFloat minNumPlayers = -0.5f;
    CGFloat maxNumPlayers = [playerDataPoints count];
    
    CGFloat minYield = 0.0f;
    CGFloat maxYield = 10000.0f;
    
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
    for ( NSUInteger i = 0; i < [playerDataPoints count]; i++ ) {
        
        
        CPTMutableTextStyle *textStyle;
        if (i % 2) {
            // odd
            textStyle = labelTitleTextStyleBlue;
        } else {
            //even
            textStyle = labelTitleTextStyleRed;
        }
        
        
        
        PlayerDataPoint *pdp = [playerDataPoints objectAtIndex:i];

        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[pdp.name uppercaseString]
                                                          textStyle:textStyle];

        newLabel.tickLocation = CPTDecimalFromUnsignedInteger(i);
        newLabel.offset       = y.labelOffset + y.majorTickLength;

        
        [newAxisLabels addObject:newLabel];
    }
    y.axisLabels = newAxisLabels;
    graph.axisSet.axes = @[y];

    
}

#pragma mark - CPTPlotDataSource methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [playerDataPoints count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
	if ((fieldEnum == CPTBarPlotFieldBarTip) && (index < [playerDataPoints count])) {
		if ([plot.identifier isEqual:harvestPlotId]) {
            PlayerDataPoint *pdp = [playerDataPoints objectAtIndex:index];
            return pdp.score;
        }
	}
	return [NSDecimalNumber numberWithUnsignedInteger:index];
}


-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
    CPTMutableTextStyle *axisTitleTextStyle = [CPTMutableTextStyle textStyle];
    axisTitleTextStyle.fontName = helveticaNeueMedium;
    axisTitleTextStyle.fontSize = 26.0;
    
    PlayerDataPoint *pdp = [playerDataPoints objectAtIndex:index];
    
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
        
        CPTColor *barColor;
        
        if (index % 2) {
            // odd
            //blue
            barColor = blueColor;
        } else {
            //even
            //red
            barColor = redColor;
        }
        
        CPTFill *fill = [CPTFill fillWithColor:barColor];
        return fill;
        
    }
    return [CPTFill fillWithColor:redColor];
    
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
