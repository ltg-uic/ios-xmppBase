
#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "GraphViewController.h"
#import "SideBarCell.h"

@interface SidebarViewController () {
    
    BOOL isOnline;
    UIImage *onlineImage;
    UIImage *offlineImage;
    NSString *xmppUsername;
}

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder])
    {
        self.appDelegate.xmppBaseOnlineDelegate = self;
        
        onlineImage  = [UIImage imageNamed:@"on"];
        offlineImage = [UIImage imageNamed:@"off"];
        
        //self.appDelegate.xmppBaseNewMessageDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuItems = @[@"viz_item", @"map_item", @"graph_item",  @"settings_title_item", @"login_item", @"blank_item"];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
        
    // configure the segue.
    // in this case we dont swap out the front view controller, which is a UINavigationController.
    // but we could..
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue* rvcs = (SWRevealViewControllerSegue*) segue;
        
        SWRevealViewController* rvc = self.revealViewController;
        NSAssert( rvc != nil, @"oops! must have a revealViewController" );
        
        NSAssert( [rvc.frontViewController isKindOfClass: [UINavigationController class]], @"oops!  for this segue we want a permanent navigation controller in the front!" );
        
        rvcs.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            //            UINavigationController* nc = (UINavigationController*)rvc.frontViewController;
            //            [nc setViewControllers: @[ dvc ] animated: NO ];
            //            [rvc setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:dvc];
            [rvc setFrontViewController:nc animated:YES];
        };
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - XMPP Online Delegate

- (void)isAvailable:(BOOL)available {
    isOnline = available;
    
    if( isOnline ) {
        xmppUsername = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID ];
        xmppUsername = [[[XMPPJID jidWithString:xmppUsername] user ] capitalizedString ];
    } else {
        xmppUsername = @"PRESS HERE TO LOGIN";
    }
}

#pragma mark - XMPP New Message Delegate

- (void)newMessageReceived:(NSDictionary *)messageContent {
    
    NSLog(@"NEW MESSAGE RECIEVED");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    
    if( cellIdentifier == nil ) {
        cellIdentifier = @"blank_item";
    }
    
    int loginIndex = [_menuItems indexOfObject:@"login_item"];
    if( loginIndex == indexPath.row ) {
        SideBarCell *loginCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        if( isOnline ) {            
            loginCell.label.text = xmppUsername;
            [loginCell.leftImageView setImage:onlineImage];
            
        } else {
            loginCell.label.text = xmppUsername;
            [loginCell.leftImageView setImage:offlineImage];

        }
        return loginCell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    }
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
