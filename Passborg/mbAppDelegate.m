//
//  mbAppDelegate.m
//  Passborg
//
//  Created by luca rocchi on 06/11/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "mbAppDelegate.h"
#import "mbNavigationController.h"
#import "SimpleWebViewController.h"
#import "Mapkit/Mapkit.h"
#import "LoaderViewController.h"
#import "mbPlacesViewController.h"
#import "mbPlaceViewController.h"
#import "mbPassesViewController.h"
#import "mbSearchViewController.h"
#import "mbPagesViewController.h"
#import "mbAccountViewController.h"
#import "mbComposeViewController.h"
#import "mbStoresViewController.h"
#import <Social/Social.h>
#import "Accounts/ACAccountStore.h"
#import "Accounts/ACAccountType.h"
#import "Accounts/ACAccount.h"
#import "Accounts/ACAccountCredential.h"
#import <FacebookSDK/FacebookSDK.h>


@implementation mbAppDelegate

@synthesize window = _window; 
@synthesize tabBarController;
//@synthesize accesstoken;
@synthesize me;
@synthesize pages;
@synthesize dataPages;
@synthesize stores;
@synthesize dataStores;
//@synthesize session=_session;
@synthesize placesViewController;
@synthesize placeViewController;
@synthesize passesViewController;
@synthesize storesViewController;
@synthesize accountViewController;
@synthesize products;
//@synthesize facebook;

@synthesize locationManager;
//@synthesize passLib;
//@synthesize searchViewController;
@synthesize loaderViewController;
@synthesize place;
@synthesize passes;
@synthesize idStores;


NSString *const SCSessionStateChangedNotification = @"com.passborg.Passborg:SCSessionStateChangedNotification";
NSString *const fbUrl = @"https://graph.facebook.com/";
NSString *const mbUrl = @"https://passborg.com/passbook/";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    // Override point for customization after application launch.
    
    
    self.loaderViewController = [[LoaderViewController alloc] init];
    //self.window.layer.cornerRadius=9;
    self.window.layer.masksToBounds = YES;
    self.window.layer.opaque = NO;

    //[self.window setRootViewController:(UIViewController*)self.tabBarController];
    [self.window setRootViewController:(UIViewController*)loaderViewController];
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self loginFacebook];
    //[self createNewSession];
    //facebook=[Facebook sharedManager];
    //NSLog(@"Facebook %@",facebook.params);
   // if (facebook.logged){
    //    self.accesstoken =[facebook.params objectForKey:@"access_token"];
     //   self.me=[NSMutableDictionary dictionary ];
      //  [self.me setObject:[facebook.params objectForKey:@"id"] forKey:@"id"];
       // [self.me setObject:[facebook.params objectForKey:@"name"] forKey:@"name"];
    //}
    //[self initMe];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    //kCLLocationAccuracyNearestTenMeters;
    // We don't want to be notified of small changes in location,
    // preferring to use our last cached results, if any.
    self.locationManager.distanceFilter = 100;
    
    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"fb_header"] forBarMetrics:UIBarMetricsDefault];
    

    
    return YES;
}

- (void)showMainUI{
    
     self.tabBarController = [[UITabBarController alloc] init];
     [self.tabBarController setDelegate:self];
     AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:
     [[NSBundle mainBundle] pathForResource:@"tick"
     ofType:@"aiff"]],
     &tickSound);
     self.placesViewController = [[mbPlacesViewController alloc] initWithNibName:nil bundle:nil];
     //self.passesViewController = [[mbPassesViewController alloc] initWithNibName:nil bundle:nil];
     //self.pagesViewController = [[mbPagesViewController alloc] initWithNibName:nil bundle:nil];
     self.storesViewController = [[mbStoresViewController alloc] initWithNibName:nil bundle:nil];
     
     self.placeViewController  = [[mbPlaceViewController alloc] initWithNibName:nil bundle:nil];
     self.accountViewController  = [[mbAccountViewController alloc] initWithNibName:nil bundle:nil];
     //self.searchViewController = [[mbSearchViewController alloc]initWithNibName:nil bundle:nil];
     mbNavigationController *navController0 = [[mbNavigationController alloc] initWithRootViewController:self.placesViewController] ;
     mbNavigationController *navController1 = [[mbNavigationController alloc] initWithRootViewController:self.placeViewController] ;
     //mbNavigationController *navController2 = [[[mbNavigationController alloc] initWithRootViewController:self.passesViewController]autorelease] ;
     mbNavigationController *navController2 = [[mbNavigationController alloc] initWithRootViewController:self.storesViewController] ;
     //mbNavigationController *navController3 = [[[mbNavigationController alloc] initWithRootViewController:self.pagesViewController]autorelease] ;
     mbNavigationController *navController4 = [[mbNavigationController alloc] initWithRootViewController:self.accountViewController] ;
     SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithUrlName:@"http://passborg.com/" ];
     self.tabBarController.viewControllers = [NSArray arrayWithObjects:placesViewController,navController1,navController2,navController4,nil];
     [self.window setRootViewController:(UIViewController*)self.tabBarController];
    
     if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
     }
     [self.locationManager startUpdatingLocation];
    
}

-(void) initPassbook{
    //check if pass library is available
    
    if ([SKPaymentQueue canMakePayments]) {
        //MyStoreObserver *observer = [[MyStoreObserver alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        NSLog(@" canMakePayments");
        [self requestProductData];
    } else {
        NSLog(@" ! canMakePayments");
        // Warn the user that purchases are disabled.
    }
    
    _passLib = [[PKPassLibrary alloc] init];
    
    if (![PKPassLibrary isPassLibraryAvailable]){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Passborg" message:@"The Pass Library is not available." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }else{
#if !TARGET_IPHONE_SIMULATOR
        //-- Set Notification
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            //[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
            // (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
        

        
        self.passes=[[NSArray alloc] initWithArray:self.passLib.passes];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(passLibraryDidChange:)
                                                     name:PKPassLibraryDidChangeNotification                                               object:_passLib];
#endif
    }
    

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void) playTick{
	AudioServicesPlaySystemSound(tickSound);
}


// User tapped on an item...
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self playTick];
    if (self.tabBarController.selectedIndex<3){
        //
    }
}

/*- (FBSession *)createNewSession
{
    self.session = [[FBSession alloc] init];
    
    // Initiate a Facebook instance //@"414718591899027"
    //self.facebook = [[Facebook alloc] initWithAppId:self.session.appID andDelegate:nil];
    
    return self.session;
}*/

- (void)passLibraryDidChange:(NSNotification *)aNotification {
    
    NSDictionary*ui=[aNotification userInfo];
    NSLog(@"ui %@",ui);
    NSLog(@"PKPassLibraryAddedPassesUserInfoKey %@",[ui objectForKey:PKPassLibraryAddedPassesUserInfoKey]);
    NSLog(@"PKPassLibraryRemovedPassInfosUserInfoKey %@",[ui objectForKey:PKPassLibraryRemovedPassInfosUserInfoKey]);
    NSLog(@"PKPassLibraryReplacementPassesUserInfoKey %@",[ui objectForKey:PKPassLibraryReplacementPassesUserInfoKey]);
    NSLog(@"PKPassLibraryPassTypeIdentifierUserInfoKey %@",[ui objectForKey:PKPassLibraryPassTypeIdentifierUserInfoKey]);
    NSLog(@"PKPassLibrarySerialNumberUserInfoKey %@",[ui objectForKey:PKPassLibrarySerialNumberUserInfoKey]);
    
    NSDictionary*rc=[ui objectForKey:PKPassLibraryReplacementPassesUserInfoKey];
    if (rc!=NULL){
        //NSDictionary*v0=[rc objectForKey:@"PKRemoteCard"];
        //NSLog(@"PKRemoteCard 1 %@",v0);
    }
    
    NSDictionary*ac=[ui objectForKey:PKPassLibraryAddedPassesUserInfoKey];
    if (ac!=NULL){
        //NSDictionary*v1=[ac objectForKey:@"PKRemoteCard"];
        //NSLog(@"PKRemoteCard 2 %@",v1);
    }
    //[self.passesViewController.tableView reloadData];
    
    /*
     NSString * const PKPassLibraryAddedPassesUserInfoKey;
     NSString * const PKPassLibraryRemovedPassInfosUserInfoKey;
     NSString * const PKPassLibraryReplacementPassesUserInfoKey;
     NSString * const PKPassLibraryPassTypeIdentifierUserInfoKey;
     NSString * const PKPassLibrarySerialNumberUserInfoKey;
     */
	//CGRect keyboardRect = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //NSTimeInterval animationDuration =	[[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    /*UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Did receive a passLibraryDidChange"
     message:nil
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alertView show];
     [alertView release];
     */
    
}


- (void)getFacebookPages {
    //NSLog(@"getFacebookPages");
    NSString *surl =[NSString stringWithFormat:@"%@me/accounts?fields=id,name,category,location,phone,cover&access_token=%@", fbUrl,self.fbToken];
    NSURL  *url  = [NSURL URLWithString:surl];
    //NSLog(@"url0 %@",surl);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* d = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedPages:)
                               withObject:d waitUntilDone:YES]; });
}


- (void)initMe {
    NSString *surl =[NSString stringWithFormat:@"%@me?fields=id,name,cover&access_token=%@", fbUrl,self.fbToken];
    NSURL  *url  = [NSURL URLWithString:surl];
    //NSLog(@"url0 %@",surl);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* d = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedMe:)
                               withObject:d waitUntilDone:YES]; });
    
}



- (void)fetchedPages:(NSData *)responseData {
    NSError *error = nil;
    //NSLog(@"responseData %@",responseData);
    
    if (responseData == nil) {
        return;
    }
    
    self.pages = [NSJSONSerialization JSONObjectWithData:responseData 
                                   options:kNilOptions error:&error];
    NSArray*dp=[NSArray arrayWithArray:[self.pages objectForKey:@"data"]];
    
    self.dataPages=[NSMutableArray array];
    for (NSMutableDictionary*dict in dp  ){
        NSString *cat=[dict objectForKey:@"category"];
        NSDictionary *cover=[dict objectForKey:@"cover" ] ;
        if (cover==nil){
            //continue;
        }
        
        NSDictionary *location=[dict objectForKey:@"location" ] ;
        //NSLog(@"location %@",location);
        if (location==nil){
            //continue;
        }
        if ([cat isEqual:@"Application"]  ){
            continue;
        }
        if ([cat isEqual:@"App page"] ){
            //continue;
        }
        NSMutableDictionary*md=[NSMutableDictionary dictionaryWithDictionary:dict];
        NSMutableDictionary*templates=[self.me objectForKey:@"templates"];
        NSMutableDictionary*template=[templates objectForKey:[dict valueForKey:@"id"]];
        if (template!=nil){
            NSLog(@"found template %@",template);
            [md addEntriesFromDictionary:template];
        }
        [self.dataPages addObject:md];
    }
    //NSLog(@"pages %@",self.dataPages);
}


- (void)fetchedMe:(NSData *)responseData {
    NSError *error = nil;
    //NSLog(@"fetchedMe %@",responseData);
    
    if (responseData == nil) {
        //[self.session closeAndClearTokenInformation];
        [self.placesViewController showLogin:self];
        return;
    }
    
    NSMutableDictionary*    me2 = [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:kNilOptions error:&error];
    
    self.me=[[NSMutableDictionary alloc]initWithDictionary:me2 ];
    
    //[self.facebook.params addEntriesFromDictionary:self.me];
    //[self.facebook writeToFile];
    NSLog(@"me %@",self.me);
    //NSLog(@"facebook %@",self.facebook.params);
    [self.placesViewController loadData];
    [self loadBusiness];
    //[self.window setRootViewController:(UIViewController*)tabBarController];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMainUI];
    });

    
    /*
     NSString *fid = [me valueForKey:@"id"];
     NSString *name = [me valueForKey:@"name"];
     NSDictionary *cover=[me objectForKey:@"cover"];
     NSString *source = [cover valueForKey:@"source"];
     
     NSString *surl =[NSString stringWithFormat:@"%@artworks.store.user.php?id=%@&name=%@&cover=%@", mbUrl,fid,name,source];
     NSLog(@"%@",surl);
     NSString* eurl = [surl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     NSURL  *url  = [NSURL URLWithString:eurl];
     NSLog(@"url %@",url);
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     NSData* d0 = [NSData dataWithContentsOfURL:url ] ;
     
     [self performSelectorOnMainThread:@selector(meStored:)
     withObject:d0 waitUntilDone:YES]; });
     
     */
    //data=[[NSArray alloc] initWithArray:[json objectForKey:@"data"]];
    //if ([[json objectForKey:@"data"] isKindOfClass:[NSArray class]]) {
    //    NSLog(@"array: ");
    //}else{
    //    NSLog(@"!array: ");
    //}
    //for(NSDictionary *item in data2) {
    //[dataitems
    //NSLog(@"Item: %@", item);
    //}
    
    
    //NSLog(@"data dict %@ %@",data,error);
    
    
    /*
     NSString *surl2 =[NSString stringWithFormat:@"%@me/friends?fields=id,name,cover&access_token=%@",fbUrl, accesstoken];
     NSLog(@"%@",surl2);
     NSURL  *url2  = [NSURL URLWithString:surl2];
     
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     NSData* d = [NSData dataWithContentsOfURL:url2];
     [self performSelectorOnMainThread:@selector(fetchedFriends:)
     withObject:d waitUntilDone:YES]; });
     */
    
}

- (void)loadBusiness {
    NSString *fid = [me valueForKey:@"id"];

    NSString *surl =[NSString stringWithFormat:@"%@passborg.get.business.php?ownerId=%@", mbUrl,fid];
    NSURL  *url  = [NSURL URLWithString:surl];
    //NSLog(@"url0 %@",surl);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* d = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(fetchedBusiness:)
                               withObject:d waitUntilDone:YES]; });
    
}

- (void)fetchedBusiness:(NSData *)responseData {
    NSError *error = nil;
    //NSLog(@"fetchedBusiness %@",responseData);
    
    if (responseData == nil) {
        return;
    }
    
    NSMutableDictionary*    business = [NSJSONSerialization
                                   JSONObjectWithData:responseData
                                   options:kNilOptions error:&error];
    NSMutableDictionary*owner=[business objectForKey:@"owner"];
    NSMutableArray*templates=[business objectForKey:@"data"];
    NSMutableDictionary* idTemplates=[NSMutableDictionary dictionary];
    for (NSMutableDictionary*dict in templates  ){
        [idTemplates setObject:dict forKey:[dict valueForKey:@"id"]];
    }
    //[self.me setObject:business forKey:@"business"];
    [self.me setObject:owner forKey:@"owner"];
    [self.me setObject:idTemplates forKey:@"templates"];
    //[self.me setObject:templates forKey:@"templates"];
    
    //[self.facebook.params addEntriesFromDictionary:self.me];
    //[self.facebook writeToFile];
    //NSLog(@"me business %@",self.me);
    //NSLog(@"me templates %@",idTemplates);
    //NSLog(@"facebook %@",self.facebook.params);
    [self getFacebookPages];

    
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if (!oldLocation ||
        (oldLocation.coordinate.latitude != newLocation.coordinate.latitude &&
         oldLocation.coordinate.longitude != newLocation.coordinate.longitude)) {
            
            // To-do, add code for triggering view controller update
            //NSLog(@"Got location: %f, %f",newLocation.coordinate.latitude,                  newLocation.coordinate.longitude);
        }
    [self.placesViewController loadData];
    
}



- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"locationManager %@", error);
}

- (void) requestProductData
{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:
                                 [NSSet setWithObject: @"Passborg"]];
    request.delegate = self;
    [request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products=[NSArray arrayWithArray: response.products];
    if ([self.products count]==0)
        return;
    SKProduct *p=self.products[0];
    NSLog(@"myProducts %@", p.localizedDescription);
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:p.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:p.price];
    NSLog(@"price %@",formattedPrice);
    // Populate your UI from the products list.
    // Save a reference to the products list.
}

//https://developer.apple.com/library/prerelease/ios/#documentation/NetworkingInternet/Conceptual/StoreKitGuide/AddingaStoretoYourApplication/AddingaStoretoYourApplication.html#//apple_ref/doc/uid/TP40008267-CH101-SW1

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                //[self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //[self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                //[self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

/*- (void)accessTokenFound:(NSString *)aToken{
    NSLog(@"accessTokenFound %@" ,aToken);
    self.accesstoken =aToken;
    NSLog(@"token %@",accesstoken);
    [self initMe];
}*/

//searchbar delegate
/*- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    //self.searchBar.showsCancelButton=[searchText length]>0;
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //app.placePickerController.searchText=searchText;
    //[self loadData];
    //NSLog(@"%@",searchText);
}*/

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",@"searchBarCancelButto˙nClicked");
    [searchBar resignFirstResponder];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%@",@"searchBarSearchButtonClicked");
    [searchBar resignFirstResponder];
    [placesViewController loadData];
    [placesViewController saveSearch];
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    //NSString * text=self.searchBar.scopeButtonTitles[selectedScope];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //app->listIndex=selectedScope;
    app->kmIndex=selectedScope;
    [placesViewController loadData];
    
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"bookmark %@",@"ok");
    [self showHistory:self];
}

- (UIViewController*) selectedController{
    if (self.tabBarController.selectedIndex==0){
        return self.placesViewController;
    }
    if (self.tabBarController.selectedIndex==1){
        return self.placeViewController;
    }
    if (self.tabBarController.selectedIndex==2){
        return self.storesViewController;
    }
    if (self.tabBarController.selectedIndex==3){
        return self.accountViewController;
    }
    return nil;
}


- (void)showHistory:(id)sender {
    mbSearchViewController*svc = [[mbSearchViewController alloc]initWithNibName:nil bundle:nil];
    UIViewController *vc=[self selectedController];    
    [vc.navigationController pushViewController:svc animated:YES];
}

- (void)showActions:(id)sender {
    //UIViewController *vc=[self selectedController];
    NSString*fid=[self.place valueForKey:@"id"];
    NSLog(@"place id %@",fid);
    NSString *mapcmd=@"Drive to";
    if (self->kmIndex==0){
        mapcmd=@"Walk to";
    }
    id item=[self.idStores objectForKey:fid];
    
    UIActionSheet *actionSheet=nil;
    if (true || item){
        actionSheet = [[UIActionSheet alloc] initWithTitle:[self.place valueForKey:@"name"] delegate:self cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:mapcmd,@"Open Facebook page",@"Add to Passbook", nil];
    }else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:[self.place valueForKey:@"name"] delegate:self cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:mapcmd,@"Open Facebook page", nil];
    }
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}


- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(int)index
{
    UIViewController *vc=[self selectedController];
    NSLog(@"index %d",index);
    if (index == sender.destructiveButtonIndex) {
        // Handle the destructive button - Usually in red indicates actions that require cautious
        
    } else if (index != sender.cancelButtonIndex) {
        if (index==0){
            if (self->kmIndex==0){
                [self openMap:MKLaunchOptionsDirectionsModeWalking];
            }else{
                [self openMap:MKLaunchOptionsDirectionsModeDriving];
            }
        }
        if (index==1){
            NSString *fid = [self.place objectForKey:@"id"];
            NSString *url =[NSString stringWithFormat:@"https://www.facebook.com/%@",fid ];
            NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"url %@",eurl);
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:eurl]];
            
            SimpleWebViewController *wv = [[SimpleWebViewController alloc] initWithUrlName:url ];
            wv.title=[self.place objectForKey:@"name"];
            [vc.navigationController pushViewController:wv animated:YES];
        }
        if (index==2){
            [self onActionPass:self];
        }
        if (index==3){
            //[self activateTemplate:self.place];
        }
        
    }
}


- (void)openMap:(NSString *)mapmode {
    CLLocationCoordinate2D coords;
    
    coords.latitude = [[[self.place objectForKey:@"location"] objectForKey:@"latitude"]doubleValue];
    coords.longitude = [[[self.place objectForKey:@"location"] objectForKey:@"longitude"] doubleValue];
    
    MKPlacemark*p=[[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:nil];
    NSLog(@"p %@", p);
    MKMapItem*mi=[[MKMapItem alloc] initWithPlacemark:p];
    mi.name=[self.place objectForKey:@"name"];
    //[mi openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving}];
    [mi openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey: mapmode}];
}


-(void) onActionPass: (id) sender{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    [app playTick];
    //UIViewController *vc=[self selectedController];
    //[vc.indicatorView setHidden:NO];
    //[vc.indicatorView  startAnimating];
    
 	NSString *userid = [app.me valueForKey:@"id"];
	NSString *username = [app.me valueForKey:@"name"];
    NSString *placeId=[self.place valueForKey:@"id"];
    NSString *placeName=[self.place valueForKey:@"name"];
    NSString *latitude=[[self.place objectForKey:@"location"] valueForKey:@"latitude"];
    NSString *longitude=[[self.place objectForKey:@"location"] valueForKey:@"longitude"];
    NSString *category=[self.place valueForKey:@"category"];
    NSDictionary*cover=[self.place  objectForKey:@"cover"];
    NSString *coverSource=@"";
    if (cover!=nil){
        coverSource=[cover valueForKey:@"source"];
        NSLog(@"cover orig %@",coverSource);
        coverSource = [[coverSource dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
        
    }
    NSLog(@"cover %@",coverSource);
    
    
    //NSString *url =@"https://passborg.com/mbpass/tbtv.php";
    NSString *url =[NSString stringWithFormat:@"%@passborg.get.pass.php?userid=%@&username=%@&id=%@&name=%@&lat=%@&lng=%@&coversource=%@&category=%@",mbUrl,userid,username,placeId,placeName,latitude,longitude,coverSource,category ];
    NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url pass %@",eurl);
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:eurl]];
     [self performSelectorOnMainThread:@selector(fetchedPass:)
     withObject:data waitUntilDone:YES];
     
     });*/
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:eurl];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if(data) {
            [self fetchedPass:data];
        }else if(error) {
            NSLog(@"error ... %@",error);
        }
    });
}



- (void)fetchedPass:(NSData *)data {
    //NSError *error = nil;
    UIViewController *vc=[self selectedController];
    //[self.indicatorView setHidden:YES];
    //[self.indicatorView  stopAnimating];
    //NSLog(@"data %@",data);
    if (data == nil){
        //pass already exists in library, show an error message
        NSLog(@"fetchedPass nil");
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Error" message:@"The pass you are trying to add to Passbook raises an error. Please retry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    //load StoreCard.pkpass from resource bundle
    //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"StoreCard" ofType:@"pkpass"];
    //NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    
    //init a pass object with the data
    PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
    
    //NSLog(@"error %@",error); bad access
    
    //check if pass library contains this pass already
    if(0 && [self.passLib containsPass:pass]) {
        
        //pass already exists in library, show an error message
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Exists" message:@"The pass you are trying to add to Passbook is already present." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } else {
        
        //present view controller to add the pass to the library
        PKAddPassesViewController *avc = [[PKAddPassesViewController alloc] initWithPass:pass];
        if (avc!=nil){
            [avc setDelegate:(id)self];
            [vc presentViewController:avc animated:YES completion:nil];
        }else{
            NSLog(@"PKAddPassesViewController nil");
            //UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Error" message:@"The pass you are trying to add to Passbook raises an error. Please retry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alertView show];
        }
    }
}

- (void)fbCompose:(id)sender{
    UIViewController *vc=[self selectedController];
    
    mbComposeViewController * composeView=[[mbComposeViewController alloc] init];
    //composeView.modalPresentationStyle = UIModalPresentationFullScreen;
    //composeView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    composeView.modalPresentationStyle = UIModalPresentationFormSheet;
    [vc presentViewController:composeView animated:YES completion:nil];
    return;
    
    SLComposeViewController *fbController =
    [SLComposeViewController
     composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewControllerCompletionHandler __block completionHandler=
        ^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Sent"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"Dismiss"
                                                           otherButtonTitles: nil];
                    [alert show];
                }
                    break;
            }};
        
        [fbController addImage:[UIImage imageNamed:@"your_image.jpg"]];
        [fbController setInitialText:@"..."];
        [fbController addURL:[NSURL URLWithString:@"the url you wanna share"]];
        [fbController setCompletionHandler:completionHandler];
        [vc presentViewController:fbController animated:YES completion:nil];
    }else{
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                         message:@"Setting - Facebook not enabled"
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok"
                                               otherButtonTitles: nil];
        [alert show];
    }
}

- (void)activateTemplate:(NSDictionary*)data{
    NSString *userid = [self.me valueForKey:@"id"];
    NSString *username = [self.me valueForKey:@"name"];
    NSData*json = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    NSString *sData = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    NSLog(@"location=%@",sData);
    NSString *url =[NSString stringWithFormat:@"%@passborg.activate.template.php?businessid=%@&name=%@&data=%@",mbUrl,userid,username,sData];
    NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:eurl];
        NSError *error = nil;
        // NSDAta *data = [NSData stringWithContentsOfURL:url options:0 error:&error];
        NSString *rc=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error: &error];
        NSLog(@"rc=%@",rc);
        if([rc isEqual:@"ok"]) {
            [self didActivateDemo];
        }else if([rc isEqual:@"found"]) {
            NSLog(@"found ... ");
        }else if(error) {
            NSLog(@"error ... %@",error);
        }
    });
    
}

- (void)activateDemo:(NSDictionary*)data{
    NSString *userid = [self.me valueForKey:@"id"];
    NSString *username = [self.me valueForKey:@"name"];
    NSData*json = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    NSString *sData = [[NSString alloc]initWithData:json encoding:NSUTF8StringEncoding];
    NSLog(@"location=%@",sData);
    NSString *url =[NSString stringWithFormat:@"%@passborg.activate.demo.php?businessid=%@&name=%@&data=%@",mbUrl,userid,username,sData];
    NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:eurl];
        NSError *error = nil;
        // NSDAta *data = [NSData stringWithContentsOfURL:url options:0 error:&error];
        NSString *rc=[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error: &error];
        NSLog(@"rc=%@",rc);
        if([rc isEqual:@"ok"]) {
            [self didActivateDemo];
        }else if([rc isEqual:@"found"]) {
            NSLog(@"found ... ");
        }else if(error) {
            NSLog(@"error ... %@",error);
        }
    });

}

- (void)didActivateDemo{
    NSLog(@"onActivateDemo");
}


- (void) loadStores{
    if (self.fbToken == nil) {
        NSLog(@"loadData accesstoken nil");
        return;
    }
    static int kms[4]={1000,5000,10000,25000};
    NSInteger dist=kms[self->kmIndex];
    
    NSString *placeurl =[[NSString stringWithFormat:@"%@passborg.get.stores.php?lat=%f&lng=%f&distance=%d",mbUrl,self.locationManager.location.coordinate.latitude,self.locationManager.location.coordinate.longitude,dist]
                         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
    NSLog(@"store url%@",placeurl);
    NSURL  *url  = [NSURL URLWithString:placeurl];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* d = [NSData dataWithContentsOfURL:url];
        [self performSelectorOnMainThread:@selector(didReceiveStores:)
                               withObject:d waitUntilDone:YES]; });
    
}

- (void)didReceiveStores:(NSData *)responseData {
    NSError *error = nil;
    if (responseData == nil) {
        NSLog(@"didReceiveStores nil");
        return;
    }
    //NSLog(@"fetchedPlaces ok");
    
    
    //NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    self.stores = [NSJSONSerialization
              JSONObjectWithData:responseData
              options:kNilOptions error:&error];
    self.dataStores=[[NSMutableArray alloc] initWithArray:[stores objectForKey:@"data"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"storesChanged"
                                                        object:self
                                                      userInfo:nil];
    
    self.idStores=[NSMutableDictionary dictionary];
    [self.idStores removeAllObjects];
    for (NSDictionary*p in self.dataStores){
        //[self.idStores addObject:[p valueForKey:@"id"]];
        [self.idStores setObject:p forKey:[p valueForKey:@"id"]];
    }
    //NSLog(@"fetched stores %@",self.idStores);

    
    UITabBarItem *tbi=self.tabBarController.tabBar.items[2];
    if ([dataStores count]>0){
        tbi.badgeValue=[NSString stringWithFormat:@"%d", [dataStores count]];
        [self.storesViewController.tableView reloadData];
    }else{
        tbi.badgeValue=nil;
    }
    [self.placesViewController.tableView reloadData];
}

- (void)loginFacebook {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        //NSLog(@"Facebook account not available");
        //[self.rootViewController addFBLoginView];
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            
            // If there's one, just open the session silently, without showing the user the login UI
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                               allowLoginUI:NO
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                              // Handler for session state changes
                                              // This method will be called EACH time the session state changes,
                                              // also for intermediate states and NOT just when the session open
                                              [self sessionStateChanged:session state:state error:error];
                                          }];
            return;
        }
        
        
    }
    
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    ACAccountStore *_accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *fbActType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
#define FB_KEY "383838271692702"
    
    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @FB_KEY,(NSString *)ACFacebookAppIdKey,
                             ACFacebookAudienceKey , ACFacebookAudienceFriends,
                             [NSArray arrayWithObject:@"email"],(NSString *)ACFacebookPermissionsKey,
                             nil];
    
    
    [_accountStore requestAccessToAccountsWithType:fbActType options:options completion:^(BOOL granted, NSError *error) {
        if (granted == YES) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *accounts = [_accountStore accountsWithAccountType:fbActType];
                ACAccount*account=[accounts lastObject];
                ACAccountCredential *ac=[account credential];
                app.fbToken=[ac oauthToken];
                [self initMe];
                //NSLog(@"Facebook Login token %@ ",app.fbToken);
               // NSString*fbid=[app.fb objectForKey:@"pageid"];
                
               // [self.rootViewController loadFBId:fbid];
                
            });
            
            
        } else {
            //NSLog(@"Facebook Login not granted ");
            [self.loaderViewController addFBLoginView];
        }
    }
     ];
    
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        //[self userLoggedIn];
        mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
        //NSLog(@"Access Token %@", [[FBSession.activeSession accessTokenData] accessToken]);
        
        app.fbToken=[[FBSession.activeSession accessTokenData] accessToken];
        [self initMe];
        NSLog(@"Facebook Login token %@ ",app.fbToken);
        //NSString*fbid=[app.fb objectForKey:@"pageid"];
        
        //[self.rootViewController loadFBId:fbid];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        //[self.rootViewController addFBLoginView];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}

@end
