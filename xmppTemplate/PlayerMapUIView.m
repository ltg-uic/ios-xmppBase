//
//  PlayerMapUIView.m
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 9/13/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import "PlayerMapUIView.h"

@implementation PlayerMapUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
//    self.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
//    self.layer.shadowOpacity = 0.10;
    /* Set UIView Border */
    /*
     // Get the contextRef
     CGContextRef contextRef = UIGraphicsGetCurrentContext();
     
     // Set the border width
     CGContextSetLineWidth(contextRef, 5.0);
     
     // Set the border color to RED
     CGContextSetRGBStrokeColor(contextRef, 255.0, 0.0, 0.0, 1.0);
     
     // Draw the border along the view edge
     CGContextStrokeRect(contextRef, rect);
     */
    
    //[self.color setFill];
    
//    self.color = _uiColor;
    
    //self.backgroundColor = _uiColor;
    CGSize mySize = self.bounds.size;
    CGFloat radius = mySize.width-2;
    // CAShapeLayer *layer = (CAShapeLayer *)self.layer;
    
    UIBezierPath *bz = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(rect.origin.x, rect.origin.y, radius, radius)];
    
    [_uiColor setFill];
    [bz fill];
    
}


@end
