//
//  mbPlaceViewController.m
//  Borg
//
//  Created by luca rocchi on 09/10/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import "mbPlaceViewController.h"
#import "mbAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "PassKit/PassKit.h"
#import <QuartzCore/QuartzCore.h>
#import "mbPlacesViewController.h"
#import "WeatherAnnotationView.h"
#import "WeatherItem.h"
//#import "BackgroundLayer.h"


@interface mbPlaceViewController ()

@end

@implementation mbPlaceViewController

@synthesize fbImageView;
@synthesize addPassbook;
@synthesize viewFacebook;
@synthesize nameLabel;
@synthesize categoryLabel;
@synthesize mapView;
@synthesize countryLabel;
@synthesize cityLabel;
@synthesize streetLabel;
@synthesize zipLabel;
@synthesize driveButton;
@synthesize walkButton;
@synthesize activityView;
@synthesize topView;
@synthesize searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"radar"];
        self.tabBarItem.title = @"Map";//NSLocalizedString(@"CallsKey", @"");
        self.navigationItem.title = self.tabBarItem.title;
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.searchBar.selectedScopeButtonIndex= app->kmIndex;
    [self onPlacesChanged:nil];
}

    
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.searchBar.delegate=app;
    self.mapView.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onPlacesChanged:)
                                                 name:@"placeChanged"
                                               object:nil];
    

    
}

-(void) onPlacesChanged: (NSNotification *)aNotification {
    NSLog(@"onPlacesChanged %@", aNotification);
    
    
    CLLocationCoordinate2D coords;
    
    
    //MKPlacemark*p=[[MKPlacemark alloc] initWithCoordinate:coords addressDictionary:nil];
    NSLog(@"will view %@", @"map");
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    coords.latitude = app.locationManager.location.coordinate.latitude;
    coords.longitude = app.locationManager.location.coordinate.longitude;
    
    //static float spans[3]={0.01,0.02,0.1};
    static float spans[3]={0.003,0.003,0.003};
    float d=spans[app.placesViewController.searchBar.selectedScopeButtonIndex];
    
    //MKMapItem*mi=[[MKMapItem alloc] initWithPlacemark:p];
    MKCoordinateSpan span = MKCoordinateSpanMake(d, d);
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, span);
    [self.mapView setRegion:region animated:YES];
    [self.mapView removeAnnotations:[self.mapView annotations]];
    for (NSDictionary*place in app.placesViewController.dataPlaces){
        NSDictionary*location=[[NSDictionary alloc] initWithDictionary:[place objectForKey:@"location"]];
        coords.latitude = [[location objectForKey:@"latitude"] doubleValue];
        coords.longitude = [[location objectForKey:@"longitude"]  doubleValue];
        
        
         WeatherItem* item = [[WeatherItem alloc] init];
        item.place =[NSDictionary dictionaryWithDictionary:place];
        item->latitude = coords.latitude;
        item->longitude = coords.longitude;
        item.high = [NSNumber numberWithInteger:80];
        item.low = [NSNumber numberWithInteger:50];
        item.condition = [NSNumber numberWithInteger:Sunny];
        item.title=[place objectForKey:@"name"];
        [self.mapView addAnnotation:item];
        
        //item.subtitle=[place objectForKey:@"category"];
        //[item release]; // release the item - the context itself retains the necessary data
        
        
        //MKPointAnnotation *annot = [[MKPointAnnotation alloc] init];
        //annot.coordinate = coords;
        //annot.title=[place objectForKey:@"name"];
        //annot.subtitle=[place objectForKey:@"category"];
        //NSString *subtitle =[NSString stringWithFormat:@"%@ %@ %@ %@",location.street,location.zip,location.city,location.country ];
        //annot.subtitle=subtitle;
        //[self.mapView addAnnotation:item];
        //[self.mapView selectAnnotation:annot animated:YES];
    }
    
}


/*
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    //Here
    //[self.mapView selectAnnotation:[[self.mapView annotations] lastObject] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";
    //NSLog(@"viewForAnnotation");
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
        
    WeatherAnnotationView *annotationView =
    (WeatherAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[WeatherAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID] ;
    }
    annotationView.canShowCallout = YES;    
    annotationView.annotation = annotation;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.frame = CGRectMake(0, 0, 23, 23);
    annotationView.rightCalloutAccessoryView = button;
    //annotationView.accessory
    
    return annotationView;
}



- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"calloutAccessoryControlTapped %@",view.annotation.title);
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([view.annotation isKindOfClass:[MKUserLocation class]]){
        return ;
    }

    
    WeatherItem*wi=(WeatherItem*)view.annotation;
    
    app.place=wi.place;
    [app showActions:self];
    //NSString *phoneNo = view.annotation.title;
    //NSString *telString = [NSString stringWithFormat:@"tel:%@", phoneNo];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:telString]];
}

/*
 - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
 
 //DDAnnotation *anno = view.annotation;
 //access object via
 //[anno.objectX callSomeMethod];
 }
 
 */

/*


- (void) handleGesture:(UIGestureRecognizer*)g{
    NSLog(@"handleGesture %d",g.state);
    if( g.state == UIGestureRecognizerStateEnded ){
        NSSet *visibleAnnotations = [self.mapView annotationsInMapRect:self.mapView.visibleMapRect];
        for ( id<MKAnnotation> annotation in visibleAnnotations.allObjects ){
            UIView *av = [self.mapView viewForAnnotation:annotation];
            CGPoint point = [g locationInView:av];
            if( [av pointInside:point withEvent:nil] ){
                // do what you wanna do when Annotation View has been tapped!
                return;
            }
        }
        //do what you wanna do when map is tapped
    }
}*/
@end
