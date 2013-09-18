//
//  PlayerMapUIView.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/13/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "PlayerMapUIView.h"

@implementation PlayerMapUIView

//- (id) initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    [self loadContentsFromNib];
//    if( self ) {
////        self.layer.shadowColor = [[UIColor blackColor] CGColor];
////        self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
////        self.layer.shadowOpacity = 0.30;
//    }
//    return self;
//}
//
//
//- (id) initWithFrame:(CGRect)frame {
//    self = [super initWithFrame:frame];
//    if( self ) {
////        self.layer.shadowColor = [[UIColor blackColor] CGColor];
////        self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
////        self.layer.shadowOpacity = 0.10;
//    }
//    return self;
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{    
    //self.backgroundColor = _uiColor;
    CGSize mySize = self.bounds.size;
    CGFloat radius = mySize.width-2;
    // CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    
    UIBezierPath *bz = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x, rect.origin.y, radius, radius)];
    
    [_uiColor setFill];
    [bz fill];
    
}


@end
