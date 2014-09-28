//
//  SubstitutableDetailViewController.h
//  Userfarm
//
//  Created by luca luca on 26/05/12.
//  Copyright (c) 2012 theblogtv.it. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubstitutableDetailViewController
- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem;
@end
