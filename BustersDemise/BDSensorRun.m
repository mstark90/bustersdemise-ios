//
//  BSTemporarySensorRun.m
//  BustersDemise
//
//  Created by Michael Stark on 7/17/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "BDSensorRun.h"

@implementation BDSensorRun

@synthesize dataSetName;
@synthesize startTime;
@synthesize endTime;
@synthesize wasAccelerometerRecorded;
@synthesize wasGyroscopeRecorded;

-(id) init
{
    [super init];
    sensorRecords = [[NSMutableArray alloc] init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yy/MM/dd HH:mm:ss";
    [_dateFormatter setDateFormat:formatString];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    [super init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yy/MM/dd HH:mm:ss";
    [_dateFormatter setDateFormat:formatString];
    sensorRecords = [aDecoder decodeObjectForKey:@"sensor_records"];
    [sensorRecords retain];
    dataSetName = [aDecoder decodeObjectForKey:@"data_set_name"];
    [dataSetName retain];
    startTime = [aDecoder decodeObjectForKey:@"start_time"];
    [startTime retain];
    endTime = [aDecoder decodeObjectForKey:@"end_time"];
    [endTime retain];
    wasAccelerometerRecorded = [aDecoder decodeBoolForKey:@"was_accelerometer_recorded"];
    wasGyroscopeRecorded = [aDecoder decodeBoolForKey:@"was_gyroscope_recorded"];
    return self;
}

-(void) dealloc
{
    if(sensorRecords != nil)
    {
        [sensorRecords release];
        sensorRecords = nil;
    }
    if(_dateFormatter != nil)
    {
        [_dateFormatter release];
        _dateFormatter = nil;
    }
    if(dataSetName != nil)
    {
        [dataSetName release];
        dataSetName = nil;
    }
    if(startTime != nil)
    {
        [startTime release];
        startTime = nil;
    }
    if(endTime != nil)
    {
        [endTime release];
        endTime = nil;
    }
    [super dealloc];
}

-(NSDateFormatter*) getDateFormatter
{
    return _dateFormatter;
}

-(NSArray*) getSensorRecords
{
    return sensorRecords;
}

-(void) addRecord: (BDSensorRecord*) record
{
    [sensorRecords addObject: record];
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:sensorRecords forKey:@"sensor_records"];
    [aCoder encodeObject:dataSetName forKey:@"data_set_name"];
    [aCoder encodeObject:startTime forKey:@"start_time"];
    [aCoder encodeObject:endTime forKey:@"end_time"];
    [aCoder encodeBool:wasAccelerometerRecorded forKey:@"was_accelerometer_recorded"];
    [aCoder encodeBool:wasGyroscopeRecorded forKey:@"was_gyroscope_recorded"];
}

@end
