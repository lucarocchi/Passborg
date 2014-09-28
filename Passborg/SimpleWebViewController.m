//
//  SimpleWebViewController.m
//  Nokiaplay
//
//  Created by luca rocchi on 18/02/11.
//  Copyright 2011 hhhhh. All rights reserved.
//

#import "SimpleWebViewController.h"


@implementation SimpleWebViewController
@synthesize webView;
@synthesize urlAddress;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        webView=[[UIWebView alloc] init];
    }
    return self;
}*/

- (id)initWithUrlName:(NSString *)url {
    self = [super initWithNibName:@"SimpleWebView" bundle:[NSBundle mainBundle]];
	urlAddress=url;
    if (self) {
        self.title = @"Info";// NSLocalizedString(@"CallsKey", @"");
        //self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0]autorelease];
        self.tabBarItem.image = [UIImage imageNamed:@"gear"];
        self.tabBarItem.title = @"Info";//NSLocalizedString(@"CallsKey", @"");
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
	//HUD = [[MBProgressHUD alloc] initWithView:self.view];
	//[self.view addSubview:HUD];
	webView.delegate=self;
	
	//HUD.dimBackground = YES;
    //HUD.labelText = @"Loading"; navigationController
	//HUD.delegate = self;
    if (urlAddress.length){
        NSURL *url=[NSURL URLWithString:urlAddress];
        NSURLRequest*requestObj=[NSURLRequest requestWithURL:url];
        [webView loadRequest:requestObj];
    }
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //    return YES;
    //}
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




- (void)webViewDidStartLoad:(UIWebView *)webview {
	//NSLog(webView.request.URL.absoluteString);	
    //[HUD show:TRUE];
}

- (void)webViewDidFinishLoad:(UIWebView *)webview  {
    //[HUD hide:TRUE];
    // now really done loading code goes next
    //[logic]
}

#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = barButtonItem ;   
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
