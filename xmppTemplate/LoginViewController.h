//
//  LoginViewController.h
//  ios-xmppBase
//
//  Created by Anthony Perritano on 9/17/12.
//  Copyright (c) 2012 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController {
    
    __weak IBOutlet UITextField *loginTextField;
    __weak IBOutlet UITextField *passTextField;
}
- (IBAction)done:(id)sender;


@end
