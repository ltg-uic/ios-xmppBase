//
//  WizardStudentPageViewController.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/20/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "WizardStudentPageViewController.h"
#import "WizardReviewPageViewController.h"
#import "PlayerDataPoint.h"
#import "WizardStudentCell.h"
#import "AFNetworking.h"

@interface WizardStudentPageViewController () {
    NSArray *playerPoints;
}

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
	
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    playerPoints = [[_configurationInfo players] allObjects];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"player_id" ascending:YES];
    
    [playerPoints sortedArrayUsingDescriptors:@[sort]];

    

}
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return playerPoints.count;
    
}



-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WizardStudentCell *wz = [collectionView dequeueReusableCellWithReuseIdentifier:@"student_cell" forIndexPath:indexPath];
    
    PlayerDataPoint *pdp = [playerPoints objectAtIndex:indexPath.row];
    
    if( !(pdp == nil || [playerPoints count] == 0) ) {
        [wz.nameButton setTitle: pdp.player_id forState: UIControlStateNormal];
    }
    return wz;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"review_segue"]) {
        WizardReviewPageViewController *destViewController = segue.destinationViewController;
        [destViewController setConfigurationInfo:_configurationInfo];
        [destViewController setChoosen_student:_choosen_student];
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
