//
//  WizardStudentPageViewController.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/20/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "WizardStudentPageViewController.h"
#import "RosterModel.h"
#import "WizardStudentCell.h"

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


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray *students = [RosterModel getStudentsForClass:_class_period];
    
    return students.count;
    
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WizardStudentCell *wz = [collectionView dequeueReusableCellWithReuseIdentifier:@"student_cell" forIndexPath:indexPath];
    
    NSArray *students = [RosterModel getStudentsForClass:_class_period];
    
    
    [wz.nameButton setTitle: students[indexPath.row] forState: UIControlStateNormal];
    return wz;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
