//
//  mbPlacesViewController.m
//  Borg
//
//  Created by luca rocchi on 07/10/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "mbPlacesViewController.h"
#import "mbAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "mbPlaceViewController.h"
#import "CallView.h"
#import "mbSearchViewController.h"
#import "SimpleWebViewController.h"
//#import "ASIHTTPRequest.h"
//#import "ASIFormDataRequest.h"
//#import "FacebookConnectViewController.h"
#import "AFNetworking.h"
#import "TYMActivityIndicatorView.h"

@interface mbPlacesViewController ()

@end

@implementation mbPlacesViewController
@synthesize place;
@synthesize searchBar;
@synthesize clientView;
@synthesize places;
@synthesize dataPlaces;
@synthesize tableView;
@synthesize navController;
@synthesize savedSearches;
@synthesize indicatorView;
@synthesize placeCategories;
@synthesize placeCategoryKeys;
@synthesize titleView;

NSString * const searchKey=@"searchHistory";
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0]autorelease];
        self.tabBarItem.image = [UIImage imageNamed:@"tbi_place"];
        self.tabBarItem.title = @"Near places";//NSLocalizedString(@"CallsKey", @"");
        self.navigationItem.title = self.tabBarItem.title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.view.layer.cornerRadius=10;
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    searchBar.delegate=app;
    tableView.delegate=self;
    app->listIndex=1;
    self.savedSearches = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]
                          objectForKey:searchKey]];
    
    if (self.savedSearches == nil) {
        self.savedSearches = [NSMutableArray array];
    }
    //if (self.savedSearches==nil){
    //    self.savedSearches=[[NSMutableArray alloc] init];
    //}
    NSLog(@"1 self.savedSearches %@",self.savedSearches);
    self.navigationItem.titleView=self.titleView;
    
    //self.searchBar.=self.titleView;
    //self.tableController = [[[UITableViewController alloc] init];

    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[self addChildViewController:app.placePickerController];
    //[[self clientView] addSubview:[app.placePickerController view]];
    //[self addGestureRecognizersToPiece:[self tableView]];
    // Do any additional setup after loading the view from its nib.
    //UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithTitle:@"Search"  style:UIBarButtonItemStylePlain  target:self  action:@selector (showHistory:)];
    //UIImage *img=[UIImage imageNamed:@"15-tags"] ;
    //UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:img  style:UIBarButtonItemStylePlain  target:self  action:@selector (showHistory:)];
	//self.navigationItem.rightBarButtonItem = searchButton;
    
    //UIBarButtonItem *loginButton = [[UIBarButtonItem alloc] initWithTitle:@"Compose"  style:UIBarButtonItemStylePlain  target:self  action:@selector (fbCompose:)];
	//self.navigationItem.leftBarButtonItem = loginButton;

    
    // Create a final modal view controller
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
     [infoButton addTarget:self
     action:@selector(showInfo:)
     forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *infoBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
     self.navigationItem.leftBarButtonItem = infoBarButtonItem;
    

    //self.tableView.backgroundView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.jpg"]];
     self.placeCategories=[NSMutableDictionary dictionary];

}
- (void)showLogin:(id)sender {
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //FacebookConnectViewController*fbViewController = [[FacebookConnectViewController alloc]initWithNibName:nil bundle:nil];
    //fbViewController.delegate=app;
    //[self.navigationController pushViewController:fbViewController animated:YES];
    NSLog(@"fbViewController push");
}

- (void)showInfo:(id)sender {
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];

    SimpleWebViewController *vc = [[SimpleWebViewController alloc] initWithUrlName:@"http://passborg.com/?page_id=2" ];
    
    //FacebookConnectViewController*fbViewController = [[FacebookConnectViewController alloc]initWithNibName:nil bundle:nil];
    //fbViewController.delegate=app;
    [self.navigationController pushViewController:vc animated:YES];
    //NSLog(@"fbViewController push");
    //[fbViewController release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //self.searchBar.selectedScopeButtonIndex= app->listIndex;
    self.searchBar.selectedScopeButtonIndex= app->kmIndex;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	//NSLog(@"scrollViewWillBeginDragging %@",@"1");
    [self.searchBar resignFirstResponder];
}

- (void)addGestureRecognizersToPiece:(UIView *)piece
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];
    [piece addGestureRecognizer:tapGesture];
    
    /*UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotatePiece:)];
     [piece addGestureRecognizer:rotationGesture];
     
     UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
     [pinchGesture setDelegate:self];
     [piece addGestureRecognizer:pinchGesture];
     */
	/*NSLog(@"gesture %@",@"addGestureRecognizersToPiece");
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [piece addGestureRecognizer:panGesture];
    */
    /*UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showResetMenu:)];
     [piece addGestureRecognizer:longPressGesture];
     */
}

- (void)tapPiece:(UIPanGestureRecognizer *)gestureRecognizer
{
    
	NSLog(@"gesture %@",@"tapPiece");
    //UIView *piece = [gestureRecognizer view];
    [self.searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)saveSearch {
	NSLog(@"%s",__PRETTY_FUNCTION__);
    
    return ;
    NSString *searchTerm = self.searchBar.text;
     
    if (![self.savedSearches containsObject:searchTerm]) {
        [self.savedSearches addObject:searchTerm];
        
        self.savedSearches = (NSMutableArray*)[self.savedSearches sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        
        [[NSUserDefaults standardUserDefaults]
         setObject:self.savedSearches forKey:searchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"self.savedSearches %@",self.savedSearches);
    }
    
    /*[[[[UIAlertView alloc] initWithTitle:@"Search saved"
                                 message:@"Your search was saved"
                                delegate:nil
                       cancelButtonTitle:@"OK"
                       otherButtonTitles:nil] autorelease] show];*/
    
}



- (void) loadData{

    //[self.activityIndicatorView startAnimating];
    
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSMutableDictionary *params = [NSMutableDictionary new];
    
    
    NSString *query=@" ";
    if (self.searchBar.text!=nil){
        query=self.searchBar.text;
    }
    static int kms[4]={1000,5000,25000,50000};
    //static NSString *types[2]={@"place",@"event"};
    NSInteger dist=kms[3];
    //NSString *type=types[app->listIndex];
    
    //https://graph.facebook.com/search?q=coffee&type=place&center=37.76,-122.427&distance=1000
    NSString *placeurl =[[NSString stringWithFormat:@"%@search?fields=id,name,category,location,phone,cover&type=place&q=%@&center=%f,%f&distance=%d&limit=1000&access_token=%@",fbUrl,query,app.locationManager.location.coordinate.latitude,app.locationManager.location.coordinate.longitude,dist, app.fbToken]
                         stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    //NSLog(@"placeurl %@",placeurl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:placeurl parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //self.data=[[responseObject objectForKey:@"data"]objectForKey:@"contents"];
              //NSLog(@"doSearch %@",responseObject);
              places = responseObject;
              NSMutableArray*data=[[NSMutableArray alloc] initWithArray:[places objectForKey:@"data"]];
              self.dataPlaces=[NSMutableArray array];
              for (NSDictionary*p in data){
                  NSDictionary *location=[p objectForKey:@"location" ] ;
                  NSString *street=[location objectForKey:@"street"];
                  NSDictionary *cover=[p objectForKey:@"cover" ] ;
                  if (cover==nil){
                      continue;
                  }
                  if (street!=nil && [street length]>0) {
                      [self.dataPlaces addObject:p];
                  }
              }
              
              mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
              if (app->listIndex==0){
                  
                  for (NSDictionary*p in self.dataPlaces){
                      NSString *cat=[p valueForKey:@"category"];
                      NSDictionary *cover=[p objectForKey:@"cover" ] ;
                      if (cover==nil){
                          continue;
                      }
                      /*
                       NSDictionary *location=[p objectForKey:@"location" ] ;
                       NSLog(@"location %@",location);
                       if (location==nil)
                       continue;
                       */
                      if ([self.placeCategories objectForKey:cat]!=nil) {
                          NSMutableArray*pp=[self.placeCategories objectForKey:cat];
                          [pp addObject:p];
                          // contains key
                      }else{
                          NSMutableArray*pp=[NSMutableArray array];
                          [pp addObject:p];
                          [self.placeCategories setObject:pp forKey:cat];
                      }
                  }
                  
                  NSArray *myKeys = [self.placeCategories  allKeys];
                  self.placeCategoryKeys= [myKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
              }
              //NSMutableArray *sortedValues = [[[NSMutableArray alloc] init] autorelease];
              
              /*for(id key in self.placeCategoryKeys) {
               id pp = [self.placeCategories objectForKey:key];
               NSLog(@"%@ %d",key,[pp count]);
               }*/
              
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"placeChanged"
                                                                  object:self
                                                                userInfo:nil];
              
              //NSLog(@"fetchedPlaces %@",dataPlaces);
              [self.tableView reloadData];
              
              

              //[self.activityIndicatorView stopAnimating];
              
              //[self dismissViewControllerAnimated:YES completion:nil];
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"contentadd Error: %@", error);
              dispatch_async(dispatch_get_main_queue(), ^{
                  //UIAlertView *popup=[[UIAlertView alloc]initWithTitle:APPNAME message:error.description delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                  //[popup show];
              });
              //[self.activityIndicatorView stopAnimating];
              
              
          }];
    
}













/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 20;
    return 20;//for other title header section
}*/

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //[view setFont:[UIFont fontWithName:@"ArialMT" size:16]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int index=indexPath.row;
    int section=indexPath.section;
    //int index=indexPath.section;
    //NSLog(@"cell %d %d",section, index);
    
    NSString*cat=[self.placeCategoryKeys objectAtIndex:section];
    NSArray*items=[self.placeCategories objectForKey:cat]; 
    if (app->listIndex==1){
        items=self.dataPlaces;
    }
    static NSString *CellIdentifier = @"CallView";
    CallView *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (CallView *)[CallView cellFromNibNamed:@"CallView"];
    }
    [cell.imageView setImage:nil];

    /*static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
     */
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[items objectAtIndex:index] objectForKey:@"name"];
    NSString *fid = [[items objectAtIndex:index] objectForKey:@"id"];
    //NSInteger i=[app.idStores indexOfObject:fid];
    id item=[app.idStores objectForKey:fid];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    if (item !=nil ){ //i!= NSNotFound
        NSString *picture =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", fid];
        //UIImageView *iw=[[UIImageView alloc]init];
        //iw.frame = CGRectMake(5, 5, 40, 40);
        //[cell addSubview:iw];
        [cell.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"map-marker"]];
        //cell.backgroundColor
        //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //[[cell imageView] setImage:[UIImage imageNamed:@"cards50"]];
        //[cell.textLabel setTextColor:[UIColor greenColor]];
        //[cell.textLabel setTextColor:[UIColor colorWithRed:(188/255.f) green:(188/255.f) blue:188/255.f alpha:1]];
        cell.rightTextLabel.text = @"10%";
        //cell.rightTextLabel.text = [item valueForKey:@"bonus"];
    }else{
        NSDictionary*place0=[items objectAtIndex:index];
        NSDictionary*cover=[place0 objectForKey:@"cover"];
        NSString *source=[cover objectForKey:@"source"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:source] placeholderImage:nil];
        //[[cell imageView] setImage:[UIImage imageNamed:@"map-marker50"]];
        cell.rightTextLabel.text = @" ";
    }
    //NSLog(@"---cell %@ %d",picture, index);

    NSString * category=[[items objectAtIndex:index] objectForKey:@"category"];
    NSString * street=[[[items objectAtIndex:index] objectForKey:@"location"] objectForKey:@"street"];
    NSString * city=[[[items objectAtIndex:index] objectForKey:@"location"] objectForKey:@"city"];
    NSString *desc =[NSString stringWithFormat:@"%@ %@",street,city];
    //location.zip,location.country
    cell.detailTextLabel.text = desc;
    cell.subTextLabel.text = category;

    //cell.detailTextLabel.text=value ;
    //[[cell imageView] setImage:[UIImage imageNamed:@"brief.png"]];
    //[cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
    //[cell.textLabel setTextColor:app.bluecolor];
    //cell.accessoryView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow-green.png"]] autorelease];
    //NSLog(@"---cell %d %d",section, index);
    //cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSString *fid = [[self.dataPlaces objectAtIndex:indexPath.row] objectForKey:@"id"];
    //NSInteger i=[app.idStores indexOfObject:fid];
    //if (i!= NSNotFound){
    //    return 70;
    //}
    return 320;//[tableView bounds].size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForSectionAtIndexPath:(NSIndexPath *)indexPath
{
    return 320;//[tableView bounds].size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app->listIndex==0){
        return [self.placeCategories count];
    }
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app->listIndex==0){
        NSString*cat=[self.placeCategoryKeys objectAtIndex:section];
        NSArray*items=[self.placeCategories objectForKey:cat];
        return [items count];
    }
    return [self.dataPlaces count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
    /*mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app->listIndex==0){
       NSString*cat=[self.placeCategoryKeys objectAtIndex:section];
       return cat;
    }
    return nil;*/
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
	int index=indexPath.row ;
    //NSLog(@"id=%@", self.selectedPlace.id);
    //NSLog(@"id=%@", self.selectedPlace.cover);
    //app.placeViewController = [[[mbPlaceViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    //app.placeViewController.place=[dataPlaces objectAtIndex:index];
    int section=indexPath.section;
    NSString*cat=[self.placeCategoryKeys objectAtIndex:section];
    NSArray*items=[self.placeCategories objectForKey:cat]; //self.dataPlaces
    
    if (app->listIndex==1){
        items=self.dataPlaces;
    }

    self.place=[items objectAtIndex:index];
    app.place=[items objectAtIndex:index];
    [app showActions:self];
    return;
}




@end
