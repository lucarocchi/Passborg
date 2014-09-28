//
//  loaderViewController.m
//  Artworks
//
//  Created by luca luca on 08/08/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "LoaderViewController.h"
#import "mbAppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface LoaderViewController ()
@property (strong, nonatomic) FBLoginView *loginView;
@end

@implementation LoaderViewController
@synthesize  bkImage;
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
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.bkImage.layer.masksToBounds = YES;
    //self.bkImage.layer.opaque = NO;
    //self.view.layer.cornerRadius=20;
    //self.view.backgroundColor = [[UIColor alloc] initWithRed:0/255.0 green:82/255.0 blue:140/255.0 alpha:1];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app playTick];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) addFBLoginView{
    self.loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    self.loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    int dy=self.view.frame.size.height/2 +100;
    self.loginView.frame = CGRectOffset(self.loginView.frame, (self.view.center.x - (self.loginView.frame.size.width / 2)), dy);
    [self.view addSubview:self.loginView];
    self.loginView.delegate=self;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    //NSLog(@"You're logged in as");
    [self.loginView setHidden:YES];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"Access Token %@", [[FBSession.activeSession accessTokenData] accessToken]);
    
    app.fbToken=[[FBSession.activeSession accessTokenData] accessToken];
    NSLog(@"Facebook Login token %@ ",app.fbToken);
    //NSString*fbid=[app.fb objectForKey:@"pageid"];
    [app initMe];
    
    //[self loadFBId:fbid];
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"You're not logged in!");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"loginViewFetchedUserInfo  found %@",user);
    [self.loginView setHidden:YES];
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
