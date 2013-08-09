//
//  ViewController.h
//  xmppTemplate
//
//  Created by Anthony Perritano on 9/14/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPBaseOnlineDelegate.h"

@interface RootViewController : UIViewController <XMPPBaseOnlineDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *red_awareness;
@property (weak, nonatomic) IBOutlet UIImageView *green_awareness;

@end
