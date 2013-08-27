
#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface GraphViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate> {
    
    CPTGraph *graph;
    CPTXYPlotSpace *plotSpace;
    
    bool isRUNNING;
    bool isGAME_STOPPED;
    bool hasGraph;
    
    
    UILabel *feedRatioLabel;
    NSTimer *intervalTimer;
    NSDate *startDate;
    NSMutableArray *currentRFIDS;
    NSNumber *feedRatio;
    
    NSManagedObjectContext *managedObjectContext;
    NSArray *playerDataPoints;
}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphView;
@property (nonatomic, strong) CPTBarPlot *trianglePlot;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *scoreAnnotation;

//ploting methods
-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;

@end
