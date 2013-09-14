
#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "PlayerDataDelegate.h"

@interface GraphViewController : UIViewController <CPTBarPlotDataSource, CPTBarPlotDelegate, XMPPBaseNewMessageDelegate, PlayerDataDelegate> {
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *revealButtonItem;


@property (nonatomic, strong) IBOutlet CPTGraphHostingView *graphView;

//ploting methods
-(void)initPlot;
-(void)setupGraph;
-(void)setupAxes;
-(IBAction)fireTimer:(id)sender;

@end
