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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonClicked:)];
    _refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshButtonClicked:)];
    
    [_editButton setTintColor: [UIColor blueColor]];
    
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext:[self managedObjectContext]]];
    NSArray* result = [[self managedObjectContext] executeFetchRequest:fetch error:nil];
    
    if([result count] == 0)
    {
        [_editButton setEnabled: NO];
        [self.clearAllButtonItem setEnabled: NO];
        [self.exportAllButtonItem setEnabled: NO];
        [self.exportButtonItem setEnabled: NO];
    }
    
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
        [[self managedObjectContext] save: nil];
        [self.runTable setEditing:NO animated:YES];
        [_editButton setTitle:@"Edit"];
        [_editButton setTintColor: [UIColor blueColor]];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSMutableArray* tmpArray = [NSMutableArray arrayWithArray: _currentData];
        
        SensorRun* run = [_currentData objectAtIndex: indexPath.row];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        [tmpArray removeObjectAtIndex: indexPath.row];
        _currentData = [NSArray arrayWithArray: tmpArray];
        [tableView endUpdates];
        [[self managedObjectContext] deleteObject: run];
    }
}

- (IBAction)refreshButtonClicked:(UIBarButtonItem *)sender {
    [self reloadData];
}

- (IBAction)exportButtonClicked:(UIBarButtonItem *)sender {
    if(_isMultiExportEnabled)
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Buster's Demise Output Data"];
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext:[self managedObjectContext]]];
        NSArray* indexPaths = [self.runTable indexPathsForSelectedRows];
        NSArray* result = [[self managedObjectContext] executeFetchRequest:fetch error:nil];
        for (NSIndexPath* indexPath in indexPaths)
        {
            SensorRun* run = [result objectAtIndex:[indexPath row]];
            [controller addAttachmentData:[[BDReportBuilder createReport: run] dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@.csv", [run dataSetName]]];
        }
        [controller setMessageBody:@"Attached to this e-mail are all the selected runs of Buster's Demise." isHTML:NO];
        if (controller)
        {
            [self presentViewController:controller animated:YES completion:^(void)
             {
                 
             }];
            for (NSIndexPath* indexPath in indexPaths)
            {
                [self.runTable deselectRowAtIndexPath:indexPath animated:NO];
            }
        }
        [self.runTable setAllowsSelection:NO];
        [self.runTable setAllowsMultipleSelection: NO];
        _isMultiExportEnabled = false;
    }
    else
    {
        [self.runTable setAllowsSelection:YES];
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
            iPadViewController * parentController = (iPadViewController*)[self parentViewController];
            UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];
            NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, setInfo, nil];
            parentController.viewControllers = viewControllers;

        }
        [self.runTable deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (IBAction)clearStorageClick:(UIBarButtonItem *)sender {
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"SensorDataRecord" inManagedObjectContext:[self managedObjectContext]]];
    NSArray * result = [[self managedObjectContext] executeFetchRequest:fetch error:nil];
    for (id basket in result)
        [[self managedObjectContext] deleteObject:basket];
    [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext:[self managedObjectContext]]];
    result = [[self managedObjectContext] executeFetchRequest:fetch error:nil];
    for (id basket in result)
        [[self managedObjectContext] deleteObject:basket];
    [[self managedObjectContext] save: nil];
    [self.clearAllButtonItem setEnabled:NO];
    [self.exportButtonItem setEnabled:NO];
    [self.exportAllButtonItem setEnabled: NO];
    [_editButton setEnabled: NO];
    _currentData = nil;
    [self.runTable reloadData];
}

- (IBAction)exportAllClick:(UIBarButtonItem *)sender {
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Buster's Demise Output Data"];
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext:[self managedObjectContext]]];
    NSArray* result = [[self managedObjectContext] executeFetchRequest:fetch error:nil];
    for (SensorRun* run in result)
    {
        [controller addAttachmentData:[[BDReportBuilder createReport: run] dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@.csv", [run dataSetName]]];
    }
    [controller setMessageBody:@"Attached to this e-mail are all the stored runs of Buster's Demise." isHTML:NO];
    if (controller)
        [self presentViewController:controller animated:YES completion:^(void)
         {
             
         }];
}

-(void) updateButtonConstraints
{
    if([self managedObjectContext] != nil)
    {
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext:[self managedObjectContext]]];
        NSArray* result = [[self managedObjectContext] executeFetchRequest:fetch error:nil];
        if([result count] > 0)
        {
            _isDataButtonsEnabled = YES;
        }
        else
        {
            _isDataButtonsEnabled = NO;
        }
    }
    else
    {
        _isDataButtonsEnabled = NO;
    }
    [self.clearAllButtonItem setEnabled:_isDataButtonsEnabled];
    [self.exportButtonItem setEnabled:_isDataButtonsEnabled];
    [self.exportAllButtonItem setEnabled: _isDataButtonsEnabled];
    [_editButton setEnabled: _isDataButtonsEnabled];
    [_refreshButton setEnabled: _isDataButtonsEnabled];
}

-(void)reloadData
{
    NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext:[self managedObjectContext]]];
    _currentData = [[self managedObjectContext] executeFetchRequest:fetch error:nil];
    [self.runTable reloadData];
}

@end
