//
//  SetInfoViewController.m
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "SetInfoViewController.h"
#import "BDReportBuilder.h"
#import "BDEmailHelper.h"
#import "MBProgressHUD.h"

@interface SetInfoViewController ()

@end

@implementation SetInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yy/MM/dd HH:mm:ss"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* exportButton = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStyleBordered target:self action:@selector(exportRunData:)];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.pageTitle setTitle: [_displayedRun dataSetName]];
    }
    else
    {
        [[self navigationItem] setRightBarButtonItem: exportButton];
    }
    [self.startTimeLabel setText: [_dateFormatter stringFromDate: [_displayedRun startTime]]];
    [self.endTimeLabel setText: [_dateFormatter stringFromDate: [_displayedRun endTime]]];
    [self.gyroscopeOnLabel setText: [[_displayedRun wasGyroscopeOn] boolValue] == YES ? @"Yes" : @"No"];
    [self.accelerometerOnLabel setText: [[_displayedRun wasAccelerometerOn] boolValue] == YES ? @"Yes" : @"No"];
    [self.eventCountLabel setText: [NSString stringWithFormat:@"%ld", [[_displayedRun eventCount] longValue]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) parseRun:(SensorRun *)run
{
    _displayedRun = run;
    [self setTitle: [run dataSetName]];
}

-(void) exportRunData: (UIBarButtonItem*)sender
{
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
           BDSensorRun* run = [NSKeyedUnarchiver unarchiveObjectWithFile: [_displayedRun dataFileName]];
           [generatedReports setValue:[[BDReportBuilder createReport: run] dataUsingEncoding:NSUTF8StringEncoding] forKey:[NSString stringWithFormat:@"%@.csv", [_displayedRun dataSetName]]];
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:^(void)
     {
         
     }];
}

@end
