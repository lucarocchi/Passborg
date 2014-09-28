//
//  mbComposeViewController.h
//  Passborg
//
//  Created by luca rocchi on 07/12/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mbTextView.h"

@interface mbComposeViewController : UIViewController<NSURLConnectionDelegate>{
}

-(IBAction) onPost: (id) sender;
-(IBAction) onCancel: (id) sender;
@property (nonatomic, retain) IBOutlet UIView *panelView;
@property (nonatomic, retain) IBOutlet UINavigationBar *headerView;
@property (nonatomic, retain) IBOutlet UITextView *textView;
@end
