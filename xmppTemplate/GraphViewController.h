
#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"


@interface GraphViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate, XMPPBaseNewMessageDelegate> {
    
    UILabel *feedRatioLabel;

    NSDate *startDate;
    NSMutableArray *currentRFIDS;
    NSNumber *feedRatio;


}


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphView;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *scoreAnnotation;

//ploting methods
-(void)initPlot;
-(void)setupGraph;
-(void)setupAxes;
- (IBAction)fireTimer:(id)sender;

@end
