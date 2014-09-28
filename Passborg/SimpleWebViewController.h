//
//  SimpleWebViewController.h
//  Nokiaplay
//
//  Created by luca rocchi on 18/02/11.
//  Copyright 2011 hhhhh. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MBProgressHUD.h"
#import "SubstitutableDetailViewController.h"


@interface SimpleWebViewController : UIViewController <UIWebViewDelegate,SubstitutableDetailViewController> {
    //MBProgressHUDDelegate
	 UIWebView* webView;
	 NSString *urlAddress;
	 //NSString *title;
     //MBProgressHUD*HUD;

}
- (id)initWithUrlName:(NSString *)url;

@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *urlAddress;

@end
