//
//  DataCollectionViewController.m
//  BustersDemise
//
//  Created by Michael Stark on 7/12/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "DataCollectionViewController.h"
#import "SensorRun.h"
#import "BDSensorRun.h"
#import "BDReportBuilder.h"
#import "FrequencyPickerDataSource.h"
#import "MBProgressHUD.h"

#import <MessageUI/MessageUI.h>

@interface DataCollectionViewController ()

@end

@implementation DataCollectionViewController

@synthesize sensorReader;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _frequencyDataSource = [[FrequencyPickerDataSource alloc] init];
    }
    return self;
}

- (void) dealloc
{
    if(self.managedObjectContext != nil)
    {
        [self.managedObjectContext release];
        self.managedObjectContext = nil;
    }
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if([self.sensorReader isRecording] == YES)
    {
        [self.startRecordButton setEnabled: NO];
        [self.stopRecordButton setEnabled: YES];
    }
    else
    {
        [self.startRecordButton setEnabled: YES];
        [self.stopRecordButton setEnabled: NO];
    }
    
    [self.frequencyPicker setDataSource:_frequencyDataSource];
    [self.frequencyPicker setDelegate:_frequencyDataSource];
    
    _pickerActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:nil
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    [_pickerActionSheet setActionSheetStyle: UIActionSheetStyleBlackOpaque];
    
    
    UIToolbar* toolBar = [[UIToolbar alloc] init];
    [toolBar setTintColor:[UIColor blackColor]];
    toolBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onFrequencyPickerCancelled:)];
    
    UIBarButtonItem* flexibleSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem* changeButton = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStyleBordered target:self action:@selector(onFrequencyChanged:)];
    
    [toolBar setItems: [NSArray arrayWithObjects:cancelButton, flexibleSpacer, changeButton, nil]];
    
    [_pickerActionSheet addSubview: [self frequencyPicker]];
    [_pickerActionSheet addSubview: toolBar];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"blackButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"blackButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [self.startRecordButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.startRecordButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.startRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.stopRecordButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.stopRecordButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.stopRecordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.adjustFrequencyButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.adjustFrequencyButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    [self.adjustFrequencyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startRecordingButtonClick:(UIButton *)sender {
    if([self.dataSetNameTextField.text length] > 0)
    {
        BDSensorRun* sensorRun = [[BDSensorRun alloc] init];
        [sensorRun setDataSetName: [self.dataSetNameTextField text]];
        [sensorRun setStartTime:[NSDate date]];
        [sensorRun setWasAccelerometerRecorded: self.accelerometerOnSwitch.on];
        [sensorRun setWasGyroscopeRecorded: self.gyroscopeOnSwitch.on];
        [self.sensorReader setCurrentRun:sensorRun];
        [self.sensorReader setCollectAccelerometer: self.accelerometerOnSwitch.on];
        [self.sensorReader setCollectGyroscope: self.gyroscopeOnSwitch.on];
        [self.sensorReader startReader];
        [self.adjustFrequencyButton setEnabled: NO];
        [self.accelerometerOnSwitch setEnabled: NO];
        [self.gyroscopeOnSwitch setEnabled: NO];
        [self.startRecordButton setEnabled: NO];
        [self.dataSetNameTextField setEnabled: NO];
        [self.stopRecordButton setEnabled: YES];
        [self.dataSetNameTextField resignFirstResponder];
    }
    else
    {
        UIAlertView* error = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The data set must have a name to continue." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
}

- (IBAction)stopRecordingClicked:(UIButton *)sender {
    [self.sensorReader.currentRun setEndTime: [NSDate date]];

    
    
    MBProgressHUD* loadingHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [loadingHud setLabelText:@"Saving..."];
    [self.view addSubview: loadingHud];
    [loadingHud showUsingAnimation:YES];

    [self.sensorReader stopReader: ^(NSError* error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if(error != nil)
             {
                 NSLog(@"%@", error);
                 UIAlertView* errorView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The data set could not be saved." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [errorView show];
             }
             [self.sensorReader.currentRun release];
             [self.sensorReader setCurrentRun: nil];
         }];
    [self.adjustFrequencyButton setEnabled: YES];
    [self.accelerometerOnSwitch setEnabled: YES];
    [self.gyroscopeOnSwitch setEnabled: YES];
    [self.startRecordButton setEnabled: YES];
    [self.dataSetNameTextField setEnabled: YES];
    [self.stopRecordButton setEnabled: NO];
    [self.dataSetNameTextField setText:@""];
}

- (IBAction)adjustFrequencyClicked:(UIButton *)sender {
    
    NSNumber* currentFrequency = [NSNumber numberWithInt: [sensorReader collectionFrequency]];
    
    NSArray* frequencies = [_frequencyDataSource getFrequencies];
    
    NSInteger selectedRow = (int)[frequencies indexOfObject:currentFrequency];
    
    [self.frequencyPicker selectRow:selectedRow inComponent:0 animated:NO];
    [_pickerActionSheet showInView:[[UIApplication sharedApplication] keyWindow]];
    
    [self.frequencyPicker setFrame:CGRectMake(0, 44, self.view.bounds.size.width, 216)];
    
    [_pickerActionSheet setFrame:CGRectMake(0, self.view.bounds.size.height - 190, self.view.bounds.size.width, 260)];
}

-(void) onFrequencyPickerCancelled: (id)sender
{
    [_pickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void) onFrequencyChanged: (id)sender
{
    [_pickerActionSheet dismissWithClickedButtonIndex:0 animated:YES];

    NSNumber* frequency = [[_frequencyDataSource getFrequencies] objectAtIndex:[self.frequencyPicker selectedRowInComponent:0]];
    [self.sensorReader setCollectionFrequency: [frequency intValue]];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
