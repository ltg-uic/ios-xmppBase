//
//  WebViewController.h
//  hg-ios-class-display
//
//  Created by Anthony Perritano on 8/29/13.
//  Copyright (c) 2013 Learning Technologies Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController {
    
    __weak IBOutlet UIWebView *webView;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


- (IBAction)reloadWebPage:(id)sender;

@end
