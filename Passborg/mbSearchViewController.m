//
//  mbSearchViewController.m
//  Borg
//
//  Created by luca rocchi on 13/10/12.
//  Copyright (c) 2012 hhhhh. All rights reserved.
//

#import "mbSearchViewController.h"
#import "mbAppDelegate.h"
#import "mbPageViewController.h"
#import "mbPlacesViewController.h"

@interface mbSearchViewController ()

@end

@implementation mbSearchViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
        self.navigationItem.title = @"Search";
        //self.tabBarItem.image = [UIImage imageNamed:@"tbi_place"];
        //self.tabBarItem.title = @"Places";//NSLocalizedString(@"CallsKey", @"");
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    //self.navigationItem.prompt=@"Passborg";
    //self.navigationItem.title=@"Passborg";
    //self.navigationItem.titleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header.png"]];
    //[[[UIImageView alloc] initWithContentsOfFile:@"header.png"] autorelease];
    
    
    //UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed)];
    //[self.navigationItem setLeftBarButtonItem:leftButton];
    //[leftButton release];
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editTable:)];
    
    [self.navigationItem setRightBarButtonItem:addButton];
    
     
    

}

- (IBAction) editTable:(id)sender

{
    
    if(self.editing)
        
    {
        
        [super setEditing:NO animated:NO];
        
        [self.tableView setEditing:NO animated:NO];
        
        [self.tableView reloadData];
        
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        
    } else {
        
        [super setEditing:YES animated:YES];
        
        [self.tableView setEditing:YES animated:YES];
        
        [self.tableView reloadData];
        
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        
    }
    
}

- (void)cancelButtonPressed
{
    NSLog(@"cancel");
    //mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    //NSArray *viewControllers = [NSArray arrayWithObject:app.placesViewController];
    /*[app.pageViewController.pageController setViewControllers:viewControllers
                                                    direction:UIPageViewControllerNavigationDirectionForward
                                                     animated:YES
                                                   completion:nil];
     */
    //[app playTick ];
    //[self.navigationController dismissViewControllerAnimated:TRUE completion:nil] ;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;//[tableView bounds].size.height;
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
    NSLog(@"count %d",app.placesViewController.savedSearches.count);
    return app.placesViewController.savedSearches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    }
    mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    cell.textLabel.text = [app.placesViewController.savedSearches
                           objectAtIndex:indexPath.row];
    
    //[cell.textLabel setFont:[UIFont fontWithName:@"ArialMT" size:16]];
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
    //[app playTick ];
    //NSArray *viewControllers = [NSArray arrayWithObject:app.placesViewController];
    /*[app.pageViewController.pageController setViewControllers:viewControllers
                                                    direction:UIPageViewControllerNavigationDirectionForward
                                                     animated:YES
                                                completion:nil];
     */
    app.placesViewController.searchBar.text=[app.placesViewController.savedSearches objectAtIndex:indexPath.row];
    NSLog(@"didSelectRowAtIndexPath %@"  , app.placesViewController.searchBar.text);
    [app.placesViewController loadData];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        mbAppDelegate *app = (mbAppDelegate *)[[UIApplication sharedApplication] delegate];
        [app playTick ];
        NSLog(@"delete");
        [app.placesViewController.savedSearches removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults]
         setObject:app.placesViewController.savedSearches forKey:searchKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

@end
