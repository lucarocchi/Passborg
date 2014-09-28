//
//  mbPassesViewController.m
//  Got 10 Points
//
//  Created by luca rocchi on 27/10/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import "mbPassesViewController.h"
#import "mbPlacesViewController.h"
#import "mbAppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface mbPassesViewController ()

@end

@implementation mbPassesViewController
@synthesize pkAddPassesViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"cards"];
        self.tabBarItem.title = @"Coupons";//NSLocalizedString(@"CallsKey", @"");
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.image = [UIImage imageNamed:@"cards"];
        self.tabBarItem.title = @"Coupons";//NSLocalizedString(@"CallsKey", @"");
        self.navigationItem.title = self.tabBarItem.title;
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSLog(@"passes %d",[app.passLib.passes count]);
    /*int c=[self.passes count];
    for (int i=0;i<c;i++){
        PKPass*p=[self.passes objectAtIndex:i];
        NSLog(@"pass %d %@ %@ ",i, [p passURL],[p serialNumber]);
    }*/
    int i=0;
    for (PKPass*p in app.passes){
        NSLog(@"pass %d %@ %@ %@",i++, [p passURL],[p passTypeIdentifier],[p serialNumber]);
    }
    //self.navigationItem.titleView=app.placesViewController.titleView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"passes %d",[app.passes count]);
    return [app.passes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;//[tableView bounds].size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if ( cell == nil) {
    //}
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    PKPass*p=[app.passes objectAtIndex:indexPath.row];
    cell.textLabel.text = [p organizationName];
    NSString *bonus=[p localizedValueForFieldKey:@"bonus"];
    cell.detailTextLabel.text = bonus;
    //cell.backgroundColor
    //NSString *bgc=[p localizedValueForFieldKey:@"backgroundColor"];
    //NSString *fid=[p localizedValueForFieldKey:@"placeid"];
    //NSLog(@"%@ %@",[p serialNumber],fgc);
    
    NSArray *a = [[NSArray alloc] init];
    a = [[p serialNumber] componentsSeparatedByString:@"@"];
    //NSString *fid=[a objectAtIndex:0];

    //[p serialNumber]
    //[cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
    //[cell.imageView setImage:p.icon];
    //NSString *picture =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type square", fid];
    //[cell.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"fb_generic_place.png"]];
    [[cell imageView] setImage:[UIImage imageNamed:@"cards"]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller{
    NSLog(@"addPassesViewControllerDidFinish: ");
    [self dismissViewControllerAnimated:YES completion:nil];
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    app.passes=[[NSArray alloc] initWithArray:app.passLib.passes];
    [self.tableView reloadData];
}

//PKAddPassesViewController *vc = [[PKAddPassesViewController alloc] initWithPass:p];
//[vc setDelegate:(id)self];
//[self presentViewController:vc animated:NO completion:nil];
//NSLog(@"passUrl:%@ ",p.passURL);

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    PKPass*p=[app.passes objectAtIndex:indexPath.row];
    //NSString * ws=p.webServiceURL;
    NSString * pt=p.passTypeIdentifier;
    NSString * sn=p.serialNumber;
    NSLog(@"pass %d %@ %@ %@",indexPath.row,p.passURL,p.passTypeIdentifier,p.serialNumber);
    
    NSString *url =[NSString stringWithFormat:@"%@passborg.refresh.pass.php?passTypeId=%@&serialNumber=%@",mbUrl,pt,sn ];
    NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"url pass %@",eurl);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:eurl]];
        [self performSelectorOnMainThread:@selector(fetchedPass:)
                               withObject:data waitUntilDone:YES]; });
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
    PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
    pkAddPassesViewController = [[PKAddPassesViewController alloc] initWithPass:pass];
    if (pkAddPassesViewController!=nil){
       [pkAddPassesViewController setDelegate:(id)self];
       [self presentViewController:pkAddPassesViewController animated:YES completion:nil];
    }
}

@end
