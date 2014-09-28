//
//  mbPassEditorViewController.h
//  Passborg
//
//  Created by luca rocchi on 29/12/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mbPassEditorViewController : UIViewController

-(IBAction) stepperChanged:(UIStepper *)sender;
@property (nonatomic, retain) IBOutlet UIStepper *stepperView;
@property (nonatomic, retain) IBOutlet UILabel *nameView;
@property (nonatomic, retain) IBOutlet UILabel *percentView;
@property (nonatomic, retain) IBOutlet UILabel *titleView;
@property (nonatomic, retain) IBOutlet UILabel *descView;
@property (nonatomic, retain) IBOutlet UIImageView *coverView;
@property (nonatomic, retain) IBOutlet UIImageView *pictureView;
@property (nonatomic, retain) IBOutlet UILabel *noCoverView;
@end
