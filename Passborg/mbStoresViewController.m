//
//  mbAccountViewController.m
//  Passborg
//
//  Created by luca rocchi on 06/12/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "mbStoresViewController.h"
#import "mbAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "mbPassesViewController.h"
#import "mbPagesViewController.h"
#import "CallView.h"

@interface mbStoresViewController ()

@end

@implementation mbStoresViewController
@synthesize tableView;
@synthesize searchBar;
//@synthesize menu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"gift"];
        self.tabBarItem.title = @"Offers";
        self.navigationItem.title = self.tabBarItem.title;
        //NSString *path = [[NSBundle mainBundle] pathForResource: @"account" ofType:@"plist"];
        //self.menu = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.searchBar.delegate=app;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPlacesChanged:) name:@"placeChanged" object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.searchBar.selectedScopeButtonIndex= app->kmIndex;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"numberOfSectionsInTableView");
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Coupon offers around";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"numberOfRowsInSection %d",[app.dataStores count]);
    return [app.dataStores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int index=indexPath.row;
    //int section=indexPath.section;
    //int index=indexPath.section;
    //NSLog(@"cell %d %d",section, index);
    
    NSDictionary *data=[app.dataStores objectAtIndex:index];

    /*static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }*/
    static NSString *CellIdentifier = @"CallView";
    CallView *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (CallView *)[CallView cellFromNibNamed:@"CallView"];
    }
    
    
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [data valueForKey:@"name"];
    NSDictionary*location=[data objectForKey:@"location"];
    NSString * street=[location valueForKey:@"street"];
    NSString * city=[location valueForKey:@"city"];
    NSString *desc =[NSString stringWithFormat:@"%@ %@",street,city];
    cell.detailTextLabel.text = desc;
    //[[cell imageView] setImage:[UIImage imageNamed:@"cards"]];

    NSString *fid = [data objectForKey:@"id"];;
    NSString *picture =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", fid];
    //NSLog(@"---cell %@ %d",picture, index);
    
    cell.subTextLabel.text = [data objectForKey:@"category"];
    cell.rightTextLabel.text = [NSString stringWithFormat:@"%@%%", [data objectForKey:@"value"]]; 
    UIImage *placeHolder=[UIImage imageNamed:@"cards50"];

    [cell.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:placeHolder];
    //cell.imageView.layer.contentsScale=.5;
    
    //cell.detailTextLabel.text=value ;
    //[[cell imageView] setImage:[UIImage imageNamed:@"brief.png"]];
    //[cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
    //[cell.textLabel setTextColor:app.bluecolor];
    //cell.accessoryView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"accessory"]] autorelease];
    //NSLog(@"---cell %d %d",section, index);
    cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;//[tableView bounds].size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int index=indexPath.row;
    NSDictionary *data=[app.dataStores objectAtIndex:index];
    app.place=data;
    [app onActionPass:self];
}



@end
