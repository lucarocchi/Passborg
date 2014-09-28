//
//  CallView.m
//  Userfarm
//
//  Created by luca luca on 06/05/12.
//  Copyright (c) 2012 theblogtv.it. All rights reserved.
//

#import "CallView.h"

@implementation CallView
@synthesize imageView;
@synthesize userpicture;
@synthesize textLabel;
@synthesize subTextLabel;
@synthesize button;
@synthesize detailTextLabel;
@synthesize rightTextLabel;
/*@synthesize brand;
@synthesize brief;
@synthesize award;
@synthesize desc;
@synthesize category;
@synthesize brandLabel;
@synthesize awardLabel;
*/




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (CallView *)cellFromNibNamed:(NSString *)nibName {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    CallView *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[CallView class]]) {
            customCell = (CallView *)nibItem;
            customCell.selectionStyle = UITableViewCellSelectionStyleNone;
            [customCell.imageView setImage:nil];
            //customCell.awardLabel.text=NSLocalizedString(@"AwardLabelKey", @"awardLabel");
            //customCell.brandLabel.text=NSLocalizedString(@"BrandLabelKey", @"brandLabel");
            //[customCell.button setTitle:NSLocalizedString(@"JoinKey", @"join") forState:UIControlStateNormal];
            //[customCell.button setTitle:NSLocalizedString(@"JoinKey", @"join") forState:UIControlStateHighlighted];
            //[customCell.button setHighlighted:TRUE ];
            
            //[customCell.button sizeToFit];
            break; // we have a winner
        }
    }
    return customCell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleButton:(id)sender {
}

- (IBAction) voteTo:(id)sender{
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"VOTE"    object:[sender tag]];

}
/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
    NSLog(@"touchesBegan "); 
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    //UIView* viewYouWishToObtain = [self hitTest:locationPoint withEvent:event];
    if ([userpicture pointInside:locationPoint withEvent:event]) {
        NSLog(@"userpicture "); 
       //do something
    }
}
*/

@end
