//
//  loaderViewController.h
//  Artworks
//
//  Created by luca luca on 08/08/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoaderViewController : UIViewController<FBLoginViewDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *bkImage;
- (void) addFBLoginView;

@end
