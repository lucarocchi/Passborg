//
//  mbPassEditorViewController.m
//  Passborg
//
//  Created by luca rocchi on 29/12/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import "mbPassEditorViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "mbAccountViewController.h"
#import "mbAppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface mbPassEditorViewController ()

@end

@implementation mbPassEditorViewController
@synthesize percentView;
@synthesize stepperView;
@synthesize coverView;
@synthesize pictureView;
@synthesize nameView;
@synthesize titleView;
@synthesize descView;
@synthesize noCoverView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Setup Coupon";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.layer.cornerRadius=9;
    self.view.layer.masksToBounds = YES;
    self.view.layer.opaque = NO;
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary*place=app.accountViewController.page;
    NSLog(@"edit %@",place);
    NSDictionary*cover=[place  objectForKey:@"cover"];
    self.nameView.text=[place  valueForKey:@"name"];
    self.percentView.shadowColor = [UIColor whiteColor];
    self.percentView.shadowOffset = CGSizeMake(0, 1);
    self.percentView.text = [place  valueForKey:@"value"];;
    self.titleView.text=[place  valueForKey:@"category"];
    self.descView.text=[place  valueForKey:@"name"];
    NSString *fid = [place valueForKey:@"id"];
    NSString *picture =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", fid];
    [self.pictureView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:nil]];
    NSString *coverSource=@"";
    if (cover!=nil){
        coverSource=[cover valueForKey:@"source"];
        [self.coverView setImageWithURL:[NSURL URLWithString:coverSource] placeholderImage:[UIImage imageNamed:nil]];
    }else{
        [self.noCoverView setHidden:NO];
    }
    UIBarButtonItem*doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"  style:UIBarButtonItemStyleDone  target:self  action:@selector (saveTemplate:)];
	self.navigationItem.rightBarButtonItem = doneButton;

   // Do any additional setup after loading the view from its nib.
}

- (void)saveTemplate:(id)sender {
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSMutableDictionary*place=[NSMutableDictionary dictionaryWithDictionary:app.accountViewController.page];
    NSMutableDictionary*place=app.accountViewController.page;
    [place setValue:self.percentView.text forKey:@"value"];
    [app activateTemplate:place];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)stepperChanged:(UIStepper *)sender {
    NSUInteger value = sender.value;
    self.percentView.text = [NSString stringWithFormat:@"%d",value];
}

@end
