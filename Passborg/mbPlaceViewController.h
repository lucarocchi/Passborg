//
//  mbPlaceViewController.h
//  Borg
//
//  Created by luca rocchi on 09/10/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>

@interface mbPlaceViewController : UIViewController <MKMapViewDelegate>{ //UISearchBarDelegate, 
    //NSDictionary* location;
}
//- (void)openMap:(NSString *)mapmode;

//-(IBAction) onActionWalk: (id) sender;
//-(IBAction) onActionDrive: (id) sender;
//-(IBAction) onActionPass: (id) sender;
//@property (strong,nonatomic,retain) NSDictionary *place;

@property (nonatomic, retain) IBOutlet UIImageView *fbImageView;
@property (nonatomic, retain) IBOutlet UIButton *addPassbook;
@property (nonatomic, retain) IBOutlet UIButton *viewFacebook;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UILabel *countryLabel;
@property (nonatomic, retain) IBOutlet UILabel *cityLabel;
@property (nonatomic, retain) IBOutlet UILabel *streetLabel;
@property (nonatomic, retain) IBOutlet UILabel *zipLabel;
@property (nonatomic, retain) IBOutlet UIButton *driveButton;
@property (nonatomic, retain) IBOutlet UIButton *walkButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) IBOutlet UIView *topView;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end
