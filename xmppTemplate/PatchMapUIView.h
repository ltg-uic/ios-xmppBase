//
//  PatchMapUIView.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/5/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NibLoading.h"
#import "PlayerMapUIView.h"
@interface PatchMapUIView :  NibLoadedView {
    
  
}
@property(retain) IBOutletCollection(PlayerMapUIView) NSArray *players;
@property (strong, nonatomic) IBOutlet NSString *patch_id;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *richness;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UILabel *extraPlayerCountLabel;

@end

