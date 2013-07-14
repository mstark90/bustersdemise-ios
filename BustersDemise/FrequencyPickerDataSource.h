//
//  FrequencyPickerDataSource.h
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrequencyPickerDataSource : NSObject<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSArray* _frequencies;
}

-(id) init;

-(NSArray*) getFrequencies;



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;

@end
