//
//  mbAccountViewController.m
//  Passborg
//
//  Created by luca rocchi on 06/12/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import "mbAccountViewController.h"
#import "mbAppDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "mbPassesViewController.h"
#import "mbPagesViewController.h"
#import "SimpleWebViewController.h"
#import "Mapkit/Mapkit.h"
#import "CallView.h"
#import "mbPassEditorViewController.h"

@interface mbAccountViewController ()

@end

@implementation mbAccountViewController
@synthesize tableView;
@synthesize menu;
@synthesize pass;
@synthesize page;
@synthesize pkAddPassesViewController;
@synthesize searchBar;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"cards"];
        self.tabBarItem.title = @"Coupons";//NSLocalizedString(@"CallsKey", @"");
        self.navigationItem.title = self.tabBarItem.title;
        NSString *path = [[NSBundle mainBundle] pathForResource: @"account" ofType:@"plist"];
        self.menu = [[NSMutableArray alloc] initWithContentsOfFile:path];
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
    self.searchBar.delegate=self;
    NSLog(@"account");
    //for (NSString *str in menu){
    //    NSLog(@"%@", str);
    //}
    businessButton = [[UIBarButtonItem alloc] initWithTitle:@"Subscribe"  style:UIBarButtonItemStyleDone  target:self  action:@selector (showBusiness:)];
	//self.navigationItem.rightBarButtonItem = businessButton;
    //businessButton.
}

- (void)showBusiness:(id)sender {
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    mbPagesViewController*pagesViewController = [[mbPagesViewController alloc]initWithNibName:nil bundle:nil];
    //fbViewController.delegate=app;
    [self.navigationController pushViewController:pagesViewController animated:YES];
    NSLog(@"pagesViewController push");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"numberOfSectionsInTableView");
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int scope=self.searchBar.selectedScopeButtonIndex;
    if (scope==0){
        return [app.passes count];
    }
    if (scope==1){
        return [app.dataPages count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int scope=self.searchBar.selectedScopeButtonIndex;
    if (scope==0){
        return @"Coupons in my wallet";
    }
    if (scope==1){
        return @"my Business Coupon offers";
    }
    return nil;
 }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int index=indexPath.row;
    //int section=indexPath.section;
    int scope=self.searchBar.selectedScopeButtonIndex;
    
    if (scope==0){
        static NSString *CellIdentifier = @"CallView";
        CallView *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (CallView *)[CallView cellFromNibNamed:@"CallView"];
        }
        PKPass*p=[app.passes objectAtIndex:indexPath.row];
        cell.textLabel.text = [p organizationName];
        NSString *bonus=[p localizedValueForFieldKey:@"bonus"];
        cell.rightTextLabel.text = bonus;
        cell.subTextLabel.text = [p localizedName];
        cell.detailTextLabel.text = [p localizedValueForFieldKey:@"description"];
        
        NSArray *a = [[NSArray alloc] init];
        a = [[p serialNumber] componentsSeparatedByString:@"@"];
        NSString *fid=[a objectAtIndex:0];
        //NSLog(@"pass serial %@",fid);
        
        //[p serialNumber]
        //[cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
        //[cell.imageView setImage:p.icon];
        NSString *picture =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", fid];
        //NSLog(@"pass serial %@",picture);
        [cell.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"cards50"]];
        //[[cell imageView] setImage:[UIImage imageNamed:@"cards50"]];
        cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
        cell.accessoryView=nil;
        return cell;
    }
    if (scope==1){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
        }
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[app.dataPages objectAtIndex:index] objectForKey:@"name"];
        NSString *fid = [[app.dataPages objectAtIndex:index] objectForKey:@"id"];;
        NSString *picture =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", fid];
        cell.detailTextLabel.text = [[app.dataPages objectAtIndex:index] objectForKey:@"category"];
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [cell.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"map-marker50"]];
        //[cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];

        
        /*if (index==0){
            cell.textLabel.text = [self.menu objectAtIndex:index];
            [[cell imageView] setImage:[UIImage imageNamed:@"f"]];
        }
        if (index==1){
            cell.textLabel.text = [self.menu objectAtIndex:index];
            [[cell imageView] setImage:[UIImage imageNamed:@"cards"]];
        }*/
        cell.accessoryView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Add_to_Passbook_Badge"]];
        return cell;
    }
    //cell.accessoryType =UITableViewCellAccessoryDetailDisclosureButton;
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int scope=self.searchBar.selectedScopeButtonIndex;
    if (scope==0){
        self.pass=[app.passes objectAtIndex:indexPath.row];
        [self showActions:self];
    }
    if (scope==1){
        //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
        self.page=[app.dataPages objectAtIndex:indexPath.row];
        self.pass=nil;
        [self showActions:self];
    }
}

- (void)viewPass {
    //NSString * ws=p.webServiceURL;
    NSString * pt=self.pass.passTypeIdentifier;
    NSString * sn=self.pass.serialNumber;
    //NSLog(@"pass %d %@ %@ %@",index,p.passURL,p.passTypeIdentifier,p.serialNumber);
    
    NSString *url =[NSString stringWithFormat:@"%@passborg.refresh.pass.php?passTypeId=%@&serialNumber=%@",mbUrl,pt,sn ];
    NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"url pass %@",eurl);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:eurl]];
        [self performSelectorOnMainThread:@selector(fetchedPass:)
                               withObject:data waitUntilDone:YES]; });
    
}


- (void)showActions:(id)sender {
    //UIViewController *vc=[self selectedController];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *mapcmd=@"Drive to";
    if (app->kmIndex==0){
        mapcmd=@"Walk to";
    }
    if (self.pass!=nil){
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[self.pass organizationName] delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Delete coupon"
                                                        otherButtonTitles:@"View coupon",@"Open page", nil];
        
        [actionSheet showFromTabBar:app.tabBarController.tabBar];
        
    }
    if (self.pass==nil){
        
 
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[self.page valueForKey:@"name"] delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Open Facebook page",@"Setup coupon",@"Preview coupon", nil];
        
        [actionSheet showFromTabBar:app.tabBarController.tabBar];
        
    }
    
}


- (void)actionSheet:(UIActionSheet *)sender clickedButtonAtIndex:(int)index
{
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"index= %d",index);
    if (index == sender.destructiveButtonIndex) {
        //[self.pass ]
    }
    if (self.pass==nil){
        if (index==sender.firstOtherButtonIndex){
            NSString *fid=[self.page valueForKey:@"id"];
            [self viewPage:fid];
            //[self viewPass];
        }
        if (index==sender.firstOtherButtonIndex+1){
            //[app fbCompose:self];
            [self editPass];
        }
        return;
    }
    if (index==sender.firstOtherButtonIndex){
    }
    if (index==sender.firstOtherButtonIndex+1){
        NSArray *a = [[NSArray alloc] init];
        a = [[self.pass serialNumber] componentsSeparatedByString:@"@"];
        NSString *fid=[a objectAtIndex:0];
        [self viewPage:fid];
    }
}


- (void)editPass {
    mbPassEditorViewController*passViewController = [[mbPassEditorViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:passViewController animated:YES];
    NSLog(@"mbPassEditorViewController push");
}

-(void)viewPage: (NSString*)fid{
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //UIViewController *vc=[app selectedController];
    //NSString *fid = [app.place objectForKey:@"id"];
    NSString *url =[NSString stringWithFormat:@"https://www.facebook.com/%@",fid ];
    NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url %@",eurl);
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:eurl]];
    
    SimpleWebViewController *wv = [[SimpleWebViewController alloc] initWithUrlName:url ];
    wv.title=[self.page  objectForKey:@"name"];
    [self.navigationController pushViewController:wv animated:YES];
}

-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller{
    NSLog(@"addPassesViewControllerDidFinish: ");
    [self dismissViewControllerAnimated:YES completion:nil];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    app.passes=[[NSArray alloc] initWithArray:app.passLib.passes];
    [self.tableView reloadData];
}



- (void)fetchedPass:(NSData *)data {
    //[self.indicatorView setHidden:YES];
    //[self.indicatorView  stopAnimating];
    //NSLog(@"data %@",data);
    if (data == nil){
        //pass already exists in library, show an error message
        NSLog(@"fetchedPass nil");
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Error" message:@"The pass you are trying to add to Passbook raises an error. Please retry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    NSError *error;
    PKPass *p = [[PKPass alloc] initWithData:data error:&error];
    pkAddPassesViewController = [[PKAddPassesViewController alloc] initWithPass:p];
    if (pkAddPassesViewController!=nil){
        [pkAddPassesViewController setDelegate:(id)self];
        [self presentViewController:pkAddPassesViewController animated:YES completion:nil];
    }
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [tableView reloadData];
    
    self.navigationItem.rightBarButtonItem =self.searchBar.selectedScopeButtonIndex? businessButton:nil;

    
}

@end
