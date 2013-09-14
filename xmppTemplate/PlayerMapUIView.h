//
//  PlayerMapUIView.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/13/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+NibLoading.h"
@interface PlayerMapUIView : NibLoadedView {
    
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) NSString *player_id;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) UIColor *uiColor;
@end


