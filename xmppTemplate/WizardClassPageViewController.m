//
//  WizClassPageViewController.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/19/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "WizardClassPageViewController.h"
#import "WizardStudentPageViewController.h"
#import "WizardClassCell.h"
#import "AFNetworking.h"


@interface WizardClassPageViewController ()

@end

@implementation WizardClassPageViewController

@synthesize classes;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if(self = [super initWithCoder:aDecoder])
    {
       

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retrieveClassDataRequest];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JSON Requests


-(void)retrieveClassDataRequest
{
    NSURL *url = [NSURL URLWithString:@"http://ltg.evl.uic.edu:9000/runs"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
                                         {
                                             NSLog(@"JSON RESULT %@", responseObject);
                                             NSDictionary *data = [responseObject objectForKey:@"data"];
                                             NSArray *runs = [data objectForKey:@"runs"];
                                             for (NSDictionary *someRun in runs) {
                                                 NSString *runName = [someRun objectForKey:@"_id"];
                                                 [RosterModel addClass:runName];
                                             }
                                             [self.tableView reloadData];
                                             
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject)
                                         {
                                             NSLog(@"Request Failed: %@, %@", error, error.userInfo);
                                         }];
    
    [operation start];
    
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
    return  [[[[RosterModel sharedInstance] classes ] allKeys ] count ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"wizcell_class";
    WizardClassCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    
    if (cell == nil) {
        cell = [[WizardClassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *clazzez = [[[RosterModel sharedInstance] classes ] allKeys ];
    // Configure the cell.
    cell.classNameLabel.text = [[clazzez objectAtIndex:indexPath.row] capitalizedString];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"student_segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        WizardStudentPageViewController *destViewController = segue.destinationViewController;
        NSArray *clazzez = [[[RosterModel sharedInstance] classes ] allKeys ];
        destViewController.class_period = [clazzez objectAtIndex:indexPath.row];
    }
}


- (IBAction)cancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
