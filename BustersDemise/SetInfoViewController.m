//
//  SetInfoViewController.m
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "SetInfoViewController.h"
#import "BDReportBuilder.h"

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
    [[self navigationItem] setRightBarButtonItem: exportButton];
    [self.startTimeLabel setText: [_dateFormatter stringFromDate: [_displayedRun startTime]]];
    [self.endTimeLabel setText: [_dateFormatter stringFromDate: [_displayedRun endTime]]];
    [self.gyroscopeOnLabel setText: [[_displayedRun wasGyroscopeRecorded] boolValue] == YES ? @"Yes" : @"No"];
    [self.accelerometerOnLabel setText: [[_displayedRun wasAccelerometerRecorded] boolValue] == YES ? @"Yes" : @"No"];
    [self.eventCountLabel setText: [NSString stringWithFormat:@"%d", [[_displayedRun dataRecords] count]]];
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
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:@"Buster's Demise Output Data"];
    [controller addAttachmentData:[[BDReportBuilder createReport: _displayedRun] dataUsingEncoding:NSUTF8StringEncoding] mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"%@.csv", [_displayedRun dataSetName]]];
    [controller setMessageBody:@"Attached to this e-mail are all the selected runs of Buster's Demise." isHTML:NO];
    if (controller)
        [self presentViewController:controller animated:YES completion:^(void)
         {
             
         }];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [controller dismissViewControllerAnimated:YES completion:^(void)
     {
         
     }];
}

@end
