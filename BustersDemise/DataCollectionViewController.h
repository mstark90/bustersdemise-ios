//
//  DataCollectionViewController.h
//  BustersDemise
//
//  Created by Michael Stark on 7/12/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDSensorReader.h"
#import <MessageUI/MessageUI.h>

#import "FrequencyPickerDataSource.h"

@interface DataCollectionViewController : UIViewController<UITextFieldDelegate>
{
    NSManagedObjectContext* _managedObjectContext;
    UIActionSheet* _pickerActionSheet;
    FrequencyPickerDataSource* _frequencyDataSource;
}

@property(retain, nonatomic) IBOutlet UITextField* dataSetNameTextField;
@property(retain, nonatomic) IBOutlet UISwitch* accelerometerOnSwitch;
@property(retain, nonatomic) IBOutlet UISwitch* gyroscopeOnSwitch;
@property(retain, nonatomic) IBOutlet UIButton* adjustFrequencyButton;
@property(retain, nonatomic) IBOutlet UIButton* startRecordButton;
@property(retain, nonatomic) IBOutlet UIButton* stopRecordButton;
@property(retain, nonatomic) IBOutlet UIPickerView* frequencyPicker;

@property(retain, nonatomic) BDSensorReader* sensorReader;

-(void) onFrequencyPickerCancelled: (id)sender;

-(void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
-(NSManagedObjectContext*) getManagedObjectContext;

@end
