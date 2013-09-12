//
//  PatchMapUIView.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/5/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NibLoading.h"
@interface PatchMapUIView :  NibLoadedView {
    
  
}
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *richness;

@end

