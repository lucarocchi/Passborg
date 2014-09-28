//
//  mbAccountViewController.h
//  Passborg
//
//  Created by luca rocchi on 06/12/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mbStoresViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
//@property (nonatomic, retain) NSMutableArray *menu;
@end
