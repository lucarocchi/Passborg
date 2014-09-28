//
//  mbAccountViewController.h
//  Passborg
//
//  Created by luca rocchi on 06/12/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassKit/PassKit.h"

@interface mbAccountViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,PKAddPassesViewControllerDelegate,UIActionSheetDelegate,UISearchBarDelegate>{
    UIBarButtonItem *businessButton;
}

@property (nonatomic, retain) IBOutlet PKPass *pass;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) NSMutableArray *menu;
@property (nonatomic, retain) NSMutableDictionary *page;
@property (strong, nonatomic) PKAddPassesViewController *pkAddPassesViewController;
@end
