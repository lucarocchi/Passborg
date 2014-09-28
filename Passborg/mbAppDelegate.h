//
//  mbAppDelegate.h
//  Passborg
//
//  Created by luca rocchi on 06/11/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
//#import "FacebookSDK/FacebookSDK.h"
#import "Mapkit/Mapkit.h"
#import "Passkit/Passkit.h"
#import "Storekit/Storekit.h"
//#import "FacebookConnectViewController.h"
@class LoaderViewController;
@class mbPlacesViewController;
@class mbPlaceViewController;
@class mbPageViewController;
@class SettingsViewController;
@class mbPassesViewController;
@class mbSearchViewController;
@class mbPagesViewController;
@class mbAccountViewController;
@class mbStoresViewController;


//extern NSString *const SCSessionStateChangedNotification;
extern NSString *const mbUrl;
extern NSString *const fbUrl;
//FacebookConnectDelegate,
@interface mbAppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,CLLocationManagerDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver,UISearchBarDelegate,UIActionSheetDelegate>
{
    NSString*accesstoken;
    SystemSoundID tickSound;
    NSMutableDictionary* me;
    //NSMutableDictionary* pages;
@public
    NSInteger kmIndex;
    NSInteger listIndex;
}
- (void) onActionPass: (id) sender;
- (void)activateDemo:(NSDictionary*)data;
- (void)activateTemplate:(NSDictionary*)data;

- (void)showActions:(id)sender;
- (void) loadStores;
- (void) playTick;
- (void)fbCompose:(id)sender;

- (void)openMap:(NSString *)mapmode;
- (UIViewController*) selectedController;

- (void)loginFacebook ;
- (void)initMe;

//- (void) openSessionCheckCache:(BOOL)check;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) CLLocationManager *locationManager;
//@property (strong, nonatomic) FBUserSettingsViewController *userSettingsViewController;
@property (strong, nonatomic) mbPlacesViewController *placesViewController;
@property (strong, nonatomic) mbPlaceViewController *placeViewController;
@property (strong, nonatomic) mbPassesViewController *passesViewController;
@property (strong, nonatomic) mbStoresViewController *storesViewController;
//@property (strong, nonatomic) mbSearchViewController *searchViewController;
@property (strong, nonatomic) mbPagesViewController *pagesViewController;
@property (strong, nonatomic) LoaderViewController *loaderViewController;
@property (strong, nonatomic) mbAccountViewController *accountViewController;

//@property (strong, nonatomic) NSString *accesstoken;
//@property (strong, nonatomic) FBSession *session;
@property (strong,nonatomic,retain) NSMutableDictionary *me;
@property (strong,nonatomic,retain) NSMutableDictionary *pages;
@property (strong,nonatomic,retain) NSMutableArray *dataPages;
@property (strong,nonatomic,retain) NSMutableDictionary *idStores;
@property (strong,nonatomic,retain) NSMutableDictionary *stores;
@property (strong,nonatomic,retain) NSMutableArray *dataStores;
@property (strong,nonatomic,retain) NSArray *products;
@property (strong, nonatomic) PKPassLibrary *passLib;
//@property (nonatomic, retain) Facebook *facebook;
@property (strong,nonatomic,retain) NSDictionary *place;
@property (strong,nonatomic,retain) NSArray *passes;

@property (strong, nonatomic) NSString*fbToken;


@end
