//
//  CallView.h
//  Userfarm
//
//  Created by luca luca on 06/05/12.
//  Copyright (c) 2012 theblogtv.it. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallView : UITableViewCell //<UIGestureRecognizerDelegate>

+ (CallView *)cellFromNibNamed:(NSString *)nibName;
- (IBAction) toggleButton:(id)sender;
- (IBAction) voteTo:(id)sender;

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIImageView *userpicture;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UILabel *subTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *rightTextLabel;
@property (nonatomic, retain) IBOutlet UIButton *button;
/*
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *brief;
@property (nonatomic, retain) IBOutlet UILabel *brand;
@property (nonatomic, retain) IBOutlet UILabel *award;
@property (nonatomic, retain) IBOutlet UILabel *desc;
@property (nonatomic, retain) IBOutlet UILabel *category;
@property (nonatomic, retain) IBOutlet UILabel *brandLabel;
@property (nonatomic, retain) IBOutlet UILabel *awardLabel;
@property (nonatomic, retain) IBOutlet UIButton *button;
 */

@end
