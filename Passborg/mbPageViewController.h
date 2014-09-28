//
//  mbPageViewController.h
//  Borg
//
//  Created by luca rocchi on 07/10/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface mbPageViewController : UIViewController
<UIPageViewControllerDataSource>
{
    UIPageViewController *pageController;
    NSArray *pageContent;
}
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSArray *pageContent;
@end