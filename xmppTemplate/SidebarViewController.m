
#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "SideBarCell.h"

@interface SidebarViewController ()

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
        //self.appDelegate.xmppBaseNewMessageDelegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuItems = @[@"viz_item", @"graph_item",@"map_item", @"mike_item", @"yield_item",  @"settings_title_item",@"settings_item", @"login_item", @"blank_item", @"blank_item"];
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
//    // Set the photo if it navigates to the PhotoView
//    if ([segue.identifier isEqualToString:@"showPhoto"]) {
//        PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
//        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [_menuItems objectAtIndex:indexPath.row]];
//        photoController.photoFilename = photoFilename;
//    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
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
    
    int index = [_menuItems indexOfObject:@"login_item"];
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    SideBarCell *loginCell = (SideBarCell *)[self.tableView cellForRowAtIndexPath:indexPath];

    
    if( available ) {
        NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID ];
        
        loginCell.label.text = [[[XMPPJID jidWithString:userName] user ] capitalizedString ];
        loginCell.imageView.image = [UIImage imageNamed:@"on.png"];

    } else {
        loginCell.label.text = @"login needed";
        loginCell.imageView.image = [UIImage imageNamed:@"off.png"];
    }
 
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    
    if( cellIdentifier == nil ) {
        cellIdentifier = @"blank_item";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (AppDelegate *)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
