//
//  mbPlacesViewController.h
//  Borg
//
//  Created by luca rocchi on 07/10/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const searchKey;
@interface mbPlacesViewController : UIViewController <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate> //UISearchBarDelegate, 
{
    //NSDictionary* location;
    
}
-(void) loadData;
-(void) saveSearch;
-(void) showLogin:(id)sender ;
//-(void) showHistory:(id)sender;
@property (strong,nonatomic,retain) NSDictionary *place;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UIView *clientView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic, retain) IBOutlet UIView *titleView;

@property (strong, nonatomic) UINavigationController *navController;
@property (strong,nonatomic,retain) NSMutableDictionary *places;
@property (strong,nonatomic,retain) NSMutableArray *dataPlaces;
@property (strong,nonatomic,retain) NSMutableDictionary *placeCategories;
@property (strong,nonatomic,retain) NSArray *placeCategoryKeys;
@property (nonatomic, retain) NSMutableArray *savedSearches;

@end
