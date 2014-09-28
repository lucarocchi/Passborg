//
//  mbComposeViewController.m
//  Passborg
//
//  Created by luca rocchi on 07/12/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import "mbComposeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface mbComposeViewController (){
    UIImage *viewImage;
}
@end

@implementation mbComposeViewController
@synthesize  panelView;
@synthesize  headerView;
@synthesize  textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGSize size = [[UIApplication sharedApplication] keyWindow].frame.size;
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        //UIGraphicsBeginImageContext(size);
        [[[UIApplication sharedApplication] keyWindow].layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage*black=[UIImage imageNamed:@"black gradient"];
        int y=(size.height-black.size.height)/2;
        NSLog(@"y %d",y);

        [black drawAtPoint:CGPointMake(0,y)];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        //UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.panelView.layer.cornerRadius=9;
    self.panelView.layer.masksToBounds = YES;
    self.panelView.layer.opaque = NO;
    //self.view.backgroundColor = [UIColor colorWithHue:0.0 saturation:0.0 brightness:1.0 alpha:0.2];
    
    

    self.view.backgroundColor = [UIColor colorWithPatternImage:viewImage];
    //self.panelView.layer.shadowOffset = CGSizeMake(-5, 5);
    //self.panelView.layer.shadowRadius = 5;
    //self.panelView.layer.shadowOpacity = 0.5;
    
    self.panelView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.panelView.layer.borderWidth = 2.0f;

    //self.headerView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"fb_header"]];
    //self.textView.font                       =   [UIFont fontWithName:@"MarkerFelt-Thin" size:19.0];
    //self.textView.backgroundColor            =   [UIColor colorWithPatternImage: [UIImage imageNamed: @"Notes.png"]];
    //if respondsToSelector
    [self.headerView setBackgroundImage:[UIImage imageNamed:@"fb_header"] forBarMetrics:UIBarMetricsDefault];
    
    [self.textView becomeFirstResponder];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onPost: (id) sender{
    
    NSMutableURLRequest *request = [NSMutableURLRequest
									requestWithURL:[NSURL URLWithString:@"https://graph.facebook.com/"]];
    
    NSString *params = [[NSString alloc] initWithFormat:@"foo=bar&key=value"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
    // Do anything you want with it
    
    //[responseText release];
}


-(IBAction) onCancel: (id) sender{
    NSLog(@"cancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
