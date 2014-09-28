//
//  UFNavigationController.m
//  Userfarm
//
//  Created by luca luca on 06/06/12.
//  Copyright (c) 2012 theblogtv.it. All rights reserved.
//

#import "mbNavigationController.h"

@interface mbNavigationController ()

@end

@implementation mbNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController ];
    if (self) {
        self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //    return YES;
    //}
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = barButtonItem ;   
    NSLog(@"showRootPopoverButtonItem 1");
    
    // Add the popover button to the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    //[itemsArray insertObject:barButtonItem atIndex:0];
    //[toolbar setItems:itemsArray animated:NO];
    //[itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = nil ;   
    
    // Remove the popover button from the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    //[itemsArray removeObject:barButtonItem];
    //[toolbar setItems:itemsArray animated:NO];
    //[itemsArray release];
}



@end
