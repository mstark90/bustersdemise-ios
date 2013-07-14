//
//  FrequencyPickerDataSource.m
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "FrequencyPickerDataSource.h"

#import <UIKit/UIKit.h>

@implementation FrequencyPickerDataSource

-(id) init
{
    _frequencies = [NSArray arrayWithObjects: [NSNumber numberWithInt:25], [NSNumber numberWithInt:25], [NSNumber numberWithInt:50], [NSNumber numberWithInt:75], [NSNumber numberWithInt:100], [NSNumber numberWithInt:125], [NSNumber numberWithInt:150], [NSNumber numberWithInt:175], [NSNumber numberWithInt:200], nil];
    return self;
}

-(NSArray*) getFrequencies
{
    return _frequencies;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component > 0)
    {
        return 0;
    }
    return [_frequencies count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [((NSNumber*)[_frequencies objectAtIndex: row]) stringValue];
}

@end
