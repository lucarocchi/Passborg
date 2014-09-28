//
//  mbPageViewController.m
//  Borg
//
//  Created by luca rocchi on 07/10/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import "mbPageViewController.h"
#import "mbPlacesViewController.h"
#import "mbPassesViewController.h"
#import "mbAppDelegate.h"

@interface mbPageViewController ()

@end

@implementation mbPageViewController

@synthesize pageController, pageContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}






- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self createContentPages];
    
    NSDictionary *options =
    [NSDictionary dictionaryWithObject:
     [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]
                           initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    pageController.dataSource = self;
    [[pageController view] setFrame:[[self view] bounds]];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
   
    //contentViewController *initialViewController =    [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:app.self.placesViewController];
    
    [pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    
    [self addChildViewController:pageController];
    [[self view] addSubview:[pageController view]];
    [pageController didMoveToParentViewController:self];
    
    
}


- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerBeforeViewController:
(UIViewController *)viewController
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[app playTick];
    if (viewController==(UIViewController *)app.placesViewController){
        return app.userSettingsViewController;
    }
    if (viewController==app.userSettingsViewController){
        return (UIViewController *)app.placesViewController;
    }
    //if (viewController==(UIViewController *)app.loaderViewController){
        //return(UIViewController *)app.placesViewController;
    //}
    if (viewController==(UIViewController *)app.placesViewController.searchViewController){
        return nil;
    }
    return (UIViewController *)app.placesViewController;
}

- (UIViewController *)pageViewController:
(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[app playTick];
    if (viewController==app.userSettingsViewController){
        return (UIViewController *)app.placesViewController;
    }
    if (viewController==(UIViewController *)app.placesViewController){
        return (UIViewController *)app.passesViewController;
    }
    if (viewController==(UIViewController *)app.placesViewController.searchViewController){
        return nil;
    }
    return (UIViewController *)app.placesViewController;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
