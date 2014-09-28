//
//  mbPassesViewController.h
//  Got 10 Points
//
//  Created by luca rocchi on 27/10/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassKit/PassKit.h"

@interface mbPassesViewController : UITableViewController <PKAddPassesViewControllerDelegate>
@property (strong, nonatomic) PKAddPassesViewController *pkAddPassesViewController;

@end
