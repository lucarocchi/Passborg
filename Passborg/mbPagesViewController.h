//
//  mbPagesViewController.h
//  Passborg
//
//  Created by luca rocchi on 20/11/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mbPagesViewController : UITableViewController
//@property (nonatomic, retain) IBOutlet UITableView *tableView;
//@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (strong,nonatomic,retain) NSDictionary *place;
@property (strong,nonatomic,retain) UIActivityViewController *activityViewController;

@end
