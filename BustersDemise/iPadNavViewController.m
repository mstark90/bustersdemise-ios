//
//  iPadNavViewController.m
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "iPadNavViewController.h"
#import "iPadViewController.h"
#import "DataCollectionViewController.h"
#import "SetListViewController.h"

@interface iPadNavViewController ()

@end

@implementation iPadNavViewController

@synthesize rootController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _navItems = [NSArray arrayWithObjects:@"Create Data Set", @"View Data Sets", @"Analytics", nil];
        [self setTitle:@"Menu"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_navItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = (NSString*)[_navItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setText: CellIdentifier];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController* newViewController = nil;
    bool isDetailView = false;
    if(indexPath.row == 0)
    {
        DataCollectionViewController* dataCollector = [[DataCollectionViewController alloc] initWithNibName:@"DataCollectionViewController_iPad" bundle:nil];
        
        [dataCollector setManagedObjectContext: [rootController managedObjectContext]];
        [dataCollector setSensorReader: [rootController sensorReader]];
        
        newViewController = dataCollector;
        isDetailView = true;
    }
    else if(indexPath.row == 1)
    {
        SetListViewController* setList = [[SetListViewController alloc] initWithNibName:@"SetListViewController" bundle:nil];
        [setList setManagedObjectContext: [rootController managedObjectContext]];
        [setList setTitle: @"Data Sets"];
        [self.navigationController pushViewController:setList animated:YES];
    }
    else if(indexPath.row == 2)
    {
        UIAlertView* notFunctioningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"That feature has not been implemented yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [notFunctioningAlert show];
    }
    
    if(isDetailView)
    {
        UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, newViewController, nil];
        [self rootController].viewControllers = viewControllers;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
