//
//  mbPagesViewController.m
//  Passborg
//
//  Created by luca rocchi on 20/11/12.
//  Copyright (c) 2012 luca rocchi. All rights reserved.
//

#import "mbPagesViewController.h"
#import "mbAppDelegate.h"
#import "UIImageView+AFNetworking.h"

@interface mbPagesViewController ()

@end

@implementation mbPagesViewController

@synthesize tableView;
@synthesize place;
@synthesize activityViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0]autorelease];
        self.tabBarItem.image = [UIImage imageNamed:@"facebook"];
        self.tabBarItem.title = @"Business";//NSLocalizedString(@"CallsKey", @"");
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;//[tableView bounds].size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (section==0){
        //return @"My Facebook Places";
    }
    return @"Subscribe Coupon service" ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (section==0){
        //return [app.dataPages count];
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int index=indexPath.row;
    int section=indexPath.section;
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    cell.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    /*if (section==0){
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[app.dataPages objectAtIndex:index] objectForKey:@"name"];
        NSString *fid = [[app.dataPages objectAtIndex:index] objectForKey:@"id"];;
        NSString *picture =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", fid];
        cell.detailTextLabel.text = [[app.dataPages objectAtIndex:index] objectForKey:@"category"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"fb_generic_place.png"]];
        [cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
    }*/
    if (section==0){
        if (index==0){
            [[cell imageView] setImage:[UIImage imageNamed:@"gift"]];
            cell.textLabel.text = @"Try 1 month free";
        }
        if (index==1){
            if (app.products.count==0){
                return cell;
            }
            SKProduct *p=app.products[0];
            NSLog(@"myProducts %@", p.localizedTitle);
            [[cell imageView] setImage:[UIImage imageNamed:@"shop"]];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:p.priceLocale];
            NSString *formattedPrice = [numberFormatter stringFromNumber:p.price];
            NSLog(@"price %@",formattedPrice);

            cell.textLabel.text = p.localizedDescription;
            cell.detailTextLabel.text = formattedPrice;
        }
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //NSString *fid = [[app.dataPages objectAtIndex:index] objectForKey:@"id"];;
        //NSString *picture =[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", fid];
        //cell.detailTextLabel.text = [[app.dataPages objectAtIndex:index] objectForKey:@"category"];
        //[cell.imageView setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"fb_generic_place.png"]];
        [cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
    }
    //[cell.textLabel setTextColor:app.bluecolor];
    //cell.accessoryView=[[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow-green.png"]] autorelease];
    //NSLog(@"---cell %d %d",section, index);
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    int index=indexPath.row;
    int section=indexPath.section;
    /*if (section==0){
        self.place=[app.dataPages objectAtIndex:index];
        [self onActionPass];
        
        //self.activityViewController = [[UIActivityViewController alloc]                                       initWithActivityItems:@[@"hello"] applicationActivities:nil];
        //[self presentViewController:self.activityViewController animated:YES completion:nil];
    }*/
    if (section==0){
        if (index==0){
            NSDictionary*data=[app.dataPages objectAtIndex:index];
            [app activateDemo:data];
        }
        if (index==1){
            if (app.products.count==0){
                return ;
            }
            SKProduct *selectedProduct=app.products[0];
            SKPayment *payment = [SKPayment paymentWithProduct:selectedProduct];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
    }

}


-(void) onActionPass {
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[app playTick];
    //[self.indicatorView setHidden:NO];
    //[self.indicatorView  startAnimating];
    
 	
    NSString *userid = [app.me valueForKey:@"id"];
	NSString *username = [app.me valueForKey:@"name"];
    NSString *placeId=[self.place valueForKey:@"id"];
    NSString *placeName=[self.place valueForKey:@"name"];
    NSString *latitude=[[self.place objectForKey:@"location"] valueForKey:@"latitude"];
    NSString *longitude=[[self.place objectForKey:@"location"] valueForKey:@"longitude"];
    NSString *category=[self.place valueForKey:@"category"];
    NSDictionary*cover=[self.place  objectForKey:@"cover"];
    NSString *coverSource=@"";
    if (cover!=nil){
        coverSource=[cover valueForKey:@"source"];
    }
    NSLog(@"cover %@",coverSource);
    NSString *url =[NSString stringWithFormat:@"%@passborg.get.pass.php?userid=%@&username=%@&id=%@&name=%@&lat=%@&lng=%@&coversource=%@&category=%@",mbUrl,userid,username,placeId,placeName,latitude,longitude,coverSource,category ];
    NSString* eurl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url pass %@",eurl);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:eurl];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        if(data) {
            [self fetchedPass:data];
        }else if(error) {
            NSLog(@"error %@",error);
        }
    });
    

}


- (void)fetchedPass:(NSData *)data {
    //NSError *error = nil;
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
    
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //init a pass object with the data
    PKPass *pass = [[PKPass alloc] initWithData:data error:&error];
    
    //NSLog(@"error %@",error); bad access
    
    //check if pass library contains this pass already
    if(0 && [app.passLib containsPass:pass]) {
        
        //pass already exists in library, show an error message
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Exists" message:@"The pass you are trying to add to Passbook is already present." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    } else {
        
        //present view controller to add the pass to the library
        PKAddPassesViewController *vc = [[PKAddPassesViewController alloc] initWithPass:pass];
        if (vc!=nil){
            [vc setDelegate:(id)self];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            NSLog(@"PKAddPassesViewController nil");
            //UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Pass Error" message:@"The pass you are trying to add to Passbook raises an error. Please retry" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[alertView show];
        }
    }
}


@end
