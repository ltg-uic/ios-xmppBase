//
//  WizardStudentPageViewController.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/20/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "WizardStudentPageViewController.h"
#import "WizardReviewPageViewController.h"
#import "RosterModel.h"
#import "WizardStudentCell.h"
#import "AFNetworking.h"

@interface WizardStudentPageViewController ()

@end

@implementation WizardStudentPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self retrieveStudentDataRequestWithClass:_class_period];

}
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *students = [RosterModel getStudentsForClass:_class_period];
    
    return students.count;
    
}

#pragma mark - JSON Requests


-(void)retrieveStudentDataRequestWithClass: (NSString *)clazz
{
    NSURL *url = [NSURL URLWithString: [@"http://ltg.evl.uic.edu:9000/" stringByAppendingString:clazz]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //AFNetworking asynchronous url request
    AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                         JSONRequestOperationWithRequest:request
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, id responseObject)
                                         {
                                             NSLog(@"JSON RESULT %@", responseObject);
                                             NSDictionary *data = [responseObject objectForKey:@"data"];
                                             NSArray *students = [data objectForKey:@"roster"];
                                             for (NSDictionary *someStudent in students) {
                                                 NSString *studentId = [someStudent objectForKey:@"_id"];
                                                 [RosterModel addStudent:studentId toClass:clazz];
                                             }
                                             [self.collectionView reloadData];
                                             
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject)
                                         {
                                             NSLog(@"Request Failed: %@, %@", error, error.userInfo);
                                         }];
    
    [operation start];
    
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WizardStudentCell *wz = [collectionView dequeueReusableCellWithReuseIdentifier:@"student_cell" forIndexPath:indexPath];
    
    NSArray *students = [RosterModel getStudentsForClass:_class_period];
    
    if( !(students == nil || [students count] == 0) ) {
        [wz.nameButton setTitle: students[indexPath.row] forState: UIControlStateNormal];
    }
    return wz;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"review_segue"]) {
        WizardReviewPageViewController *destViewController = segue.destinationViewController;
        destViewController.choosen_student = _choosen_student;
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chooseStudent:(id)sender {
    
    UIButton *studentButton = (UIButton *)sender;
    
    _choosen_student = studentButton.titleLabel.text;
    
}
@end
