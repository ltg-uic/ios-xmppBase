//
//  PatchMapUIView.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/5/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "PatchMapUIView.h"

@implementation PatchMapUIView



//-(void)awakeFromNib {
//    //Note that you must change @”BNYSharedView’ with whatever your nib is named
//        [self addSubview: self.contentView ];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if( self ) {
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.layer.shadowOpacity = 0.40;
    }
    return self;
}

@end
