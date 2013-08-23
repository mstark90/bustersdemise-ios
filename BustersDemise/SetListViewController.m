//
//  SetListViewController.m
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "SetListViewController.h"
#import "BDReportBuilder.h"
#import "SensorRun.h"
#import "SetInfoViewController.h"
#import "iPadViewController.h"
#import "MBProgressHUD.h"
#import "BDEmailHelper.h"

@interface SetListViewController ()

@end

@implementation SetListViewController

@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    if(_currentData != nil)
    {
        [_currentData release];
    }
    [self.managedObjectContext release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonClicked:)];
    _refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshButtonClicked:)];
    
    [_editButton setTintColor: [UIColor blueColor]];

    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext: self.managedObjectContext]];
    NSArray* result = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    
    if([result count] == 0)
    {
        [_editButton setEnabled: NO];
        [self.clearAllButtonItem setEnabled: NO];
        [self.exportAllButtonItem setEnabled: NO];
        [self.exportButtonItem setEnabled: NO];
    }
    
    [fetch release];
    
    [[self navigationItem] setRightBarButtonItem: _refreshButton];
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [[self navigationItem] setLeftBarButtonItem: _editButton];
    }
    else
    {
        NSMutableArray* options = [NSMutableArray arrayWithArray:[self.optionsBar items]];
        [options insertObject:_editButton atIndex:0];
        UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [options insertObject:spacer atIndex:1];
        [[self optionsBar] setItems: options];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)editButtonClicked:(UIBarButtonItem *)sender {
    if(self.runTable.isEditing == NO)
    {
        [self.runTable setEditing:YES animated:YES];
        [_editButton setTitle:@"Done"];
        [_editButton setTintColor: [UIColor redColor]];
    }
    else
    {
        [self.managedObjectContext save: nil];
        [self.runTable setEditing:NO animated:YES];
        [_editButton setTitle:@"Edit"];
        [_editButton setTintColor: [UIColor blueColor]];
        [self updateButtonConstraints];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray* tmpArray = [NSMutableArray arrayWithArray: _currentData];

        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tmpArray removeObjectAtIndex: indexPath.row];
        [_currentData release];
        _currentData = nil;
        _currentData = [NSArray arrayWithArray: tmpArray];
        [tableView endUpdates];
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext: self.managedObjectContext]];
        NSArray* result = [self.managedObjectContext executeFetchRequest:fetch error:nil];
        [self.managedObjectContext deleteObject: [result objectAtIndex: indexPath.row]];
        [_currentData retain];
    }
}

- (IBAction)refreshButtonClicked:(UIBarButtonItem *)sender {
    [self reloadData];
}

- (IBAction)exportButtonClicked:(UIBarButtonItem *)sender {
    if(_isMultiExportEnabled)
    {
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext: self.managedObjectContext]];
        NSArray* indexPaths = [self.runTable indexPathsForSelectedRows];
        if([indexPaths count] > 0)
        {
            NSArray* result = [self.managedObjectContext executeFetchRequest:fetch error:nil];
            NSMutableDictionary* generatedReports = [[NSMutableDictionary alloc] init];
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
            else
            {
                [MBProgressHUD showHUDAddedTo:self.splitViewController.view animated:YES];
            }
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
               {
                   [indexPaths retain];
                   for (NSIndexPath* indexPath in indexPaths)
                   {
                       SensorRun* sensorRunInfo = [result objectAtIndex:[indexPath row]];
                       BDSensorRun* run = [NSKeyedUnarchiver unarchiveObjectWithFile: [sensorRunInfo dataFileName]];
                       [generatedReports setValue:[[BDReportBuilder createReport: run] dataUsingEncoding:NSUTF8StringEncoding] forKey:[NSString stringWithFormat:@"%@.csv", [run dataSetName]]];
                   }
                   [indexPaths release];
                   [fetch release];
                   dispatch_async(dispatch_get_main_queue(), ^(void)
                      {
                          if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                          {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [BDEmailHelper sendEmail:self emailSubject:@"Buster's Demise Output Data" emailText:@"Attached to this e-mail are the selected data sets from Buster's Demise." reports:generatedReports viewController:self];
                          }
                          else
                          {
                              [MBProgressHUD hideHUDForView:self.splitViewController.view animated:YES];
                              [BDEmailHelper sendEmail:self emailSubject:@"Buster's Demise Output Data" emailText:@"Attached to this e-mail are the selected data sets from Buster's Demise." reports:generatedReports viewController:self.splitViewController];
                          }
                      });
               });
            for (NSIndexPath* indexPath in indexPaths)
            {
                [self.runTable deselectRowAtIndexPath:indexPath animated:NO];
            }
        }
        else
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No data sets were selected for export." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        [indexPaths release];
        [self.runTable setAllowsMultipleSelection: NO];
        _isMultiExportEnabled = false;
    }
    else
    {
        [self.runTable setAllowsMultipleSelection: YES];
        _isMultiExportEnabled = true;
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:^(void)
     {
         
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_currentData != nil)
    {
        SensorRun* run = [_currentData objectAtIndex: indexPath.row];
        NSString* identifier = [NSString stringWithFormat:@"%@", [run dataSetName]];
        UITableViewCell* tableViewCell = [tableView dequeueReusableCellWithIdentifier: identifier];
        if(tableViewCell == nil)
        {
            tableViewCell = [[UITableViewCell alloc] init];
        }
        [[tableViewCell textLabel] setText: identifier];
        return tableViewCell;
    }
    else
    {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_currentData == nil)
    {
        return 0;
    }
    else
    {
        return [_currentData count];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!_isMultiExportEnabled)
    {
        SetInfoViewController* setInfo = nil;
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        {
            setInfo = [[SetInfoViewController alloc] initWithNibName:@"SetInfoViewController" bundle:nil];;
        }
        else
        {
            setInfo = [[SetInfoViewController alloc] initWithNibName:@"SetInfoViewController_iPad" bundle:nil];
        }
        [setInfo parseRun:[_currentData objectAtIndex:indexPath.row]];
        if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        {
            [self.navigationController pushViewController:setInfo animated:YES];
        }
        else
        {
            UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];
            NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, setInfo, nil];
            self.splitViewController.viewControllers = viewControllers;

        }
        [self.runTable deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (IBAction)clearStorageClick:(UIBarButtonItem *)sender {
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext: self.managedObjectContext]];
    NSArray * result = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    for (SensorRun* basket in result)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[basket dataFileName] error:nil];
        [self.managedObjectContext deleteObject:basket];
    }
    [fetch release];
    [self.managedObjectContext save: nil];
    [self.clearAllButtonItem setEnabled:NO];
    [self.exportButtonItem setEnabled:NO];
    [self.exportAllButtonItem setEnabled: NO];
    [_editButton setEnabled: NO];
    _currentData = nil;
    [self.runTable reloadData];
}

- (IBAction)exportAllClick:(UIBarButtonItem *)sender {
    NSMutableDictionary* generatedReports = [[NSMutableDictionary alloc] init];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.splitViewController.view animated:YES];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
       {
           for (SensorRun* sensorRunInfo in _currentData)
           {
               BDSensorRun* run = [NSKeyedUnarchiver unarchiveObjectWithFile: [sensorRunInfo dataFileName]];
               [generatedReports setValue:[[BDReportBuilder createReport: run] dataUsingEncoding:NSUTF8StringEncoding] forKey:[NSString stringWithFormat:@"%@.csv", [run dataSetName]]];
           }
           dispatch_async(dispatch_get_main_queue(), ^(void)
              {
                  if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                  {
                      [MBProgressHUD hideHUDForView:self.view animated:YES];
                      [BDEmailHelper sendEmail:self emailSubject:@"Buster's Demise Output Data" emailText:@"Attached to this e-mail are the selected data sets from Buster's Demise." reports:generatedReports viewController:self];
                  }
                  else
                  {
                      [MBProgressHUD hideHUDForView:self.splitViewController.view animated:YES];
                      [BDEmailHelper sendEmail:self emailSubject:@"Buster's Demise Output Data" emailText:@"Attached to this e-mail are the selected data sets from Buster's Demise." reports:generatedReports viewController:self.splitViewController];
                  }
                  [generatedReports release];
              });
       });
}

-(void) updateButtonConstraints
{
    if(self.managedObjectContext != nil)
    {
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext: self.managedObjectContext]];
        NSArray* result = [self.managedObjectContext executeFetchRequest:fetch error:nil];
        if([result count] > 0)
        {
            _isDataButtonsEnabled = YES;
        }
        else
        {
            _isDataButtonsEnabled = NO;
        }
        [fetch release];
        fetch = nil;
    }
    else
    {
        _isDataButtonsEnabled = NO;
    }
    [self.clearAllButtonItem setEnabled:_isDataButtonsEnabled];
    [self.exportButtonItem setEnabled:_isDataButtonsEnabled];
    [self.exportAllButtonItem setEnabled: _isDataButtonsEnabled];
    [_editButton setEnabled: _isDataButtonsEnabled];
}

-(void)reloadData
{
    MBProgressHUD* loadingHud = [[MBProgressHUD alloc] initWithView:self.view];
    [loadingHud setLabelText:@"Loading..."];
    [self.view addSubview: loadingHud];
    [loadingHud showUsingAnimation:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
       {
           NSMutableArray* currentData = [[NSMutableArray alloc] init];
           NSError* error = nil;
           if(_currentData != nil)
           {
               [_currentData release];
               _currentData = nil;
           }
           NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
           [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext: self.managedObjectContext]];
           
           NSArray* result = [self.managedObjectContext executeFetchRequest:fetch error: &error];
           if(error != nil)
           {
               NSLog(@"%@", error);
           }
           else
           {
               for(int i = 0; i < [result count]; i++)
               {
                   SensorRun* sensorRun = [result objectAtIndex: i];
                   [currentData addObject: sensorRun];
               }
           }
           _currentData = currentData;
           [fetch release];
           dispatch_async(dispatch_get_main_queue(), ^(void)
              {
                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                  [self.runTable reloadData];
              });
       });
    
}

@end
