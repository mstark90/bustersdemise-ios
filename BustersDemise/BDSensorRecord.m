//
//  BDTemporarySensorRecord.m
//  BustersDemise
//
//  Created by Michael Stark on 7/17/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "BDSensorRecord.h"

@implementation BDSensorRecord

@synthesize timestamp;

@synthesize gyroscopeX;
@synthesize gyroscopeY;
@synthesize gyroscopeZ;

@synthesize accelerometerX;
@synthesize accelerometerY;
@synthesize accelerometerZ;

-(id) init
{
    [super init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    [_dateFormatter setDateFormat:formatString];
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    [super init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    [_dateFormatter setDateFormat:formatString];
    
    timestamp = [aDecoder decodeObjectForKey:@"timestamp"];
    [timestamp retain];
    
    gyroscopeX = [aDecoder decodeDoubleForKey:@"gyroscope_x"];
    gyroscopeY = [aDecoder decodeDoubleForKey:@"gyroscope_y"];
    gyroscopeZ = [aDecoder decodeDoubleForKey:@"gyroscope_z"];
    
    accelerometerX = [aDecoder decodeDoubleForKey:@"accelerometer_x"];
    accelerometerY = [aDecoder decodeDoubleForKey:@"accelerometer_y"];
    accelerometerZ = [aDecoder decodeDoubleForKey:@"accelerometer_z"];
    
    return self;
}

-(void) dealloc
{
    if(timestamp != nil)
    {
        [timestamp release];
        timestamp = nil;
    }
    if(_dateFormatter != nil)
    {
        [_dateFormatter release];
        _dateFormatter = nil;
    }
    [super dealloc];
}

-(NSDateFormatter*) getDateFormatter
{
    return _dateFormatter;
}

-(void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:timestamp forKey:@"timestamp"];
    
    [aCoder encodeDouble:gyroscopeX forKey:@"gyroscope_x"];
    [aCoder encodeDouble:gyroscopeY forKey:@"gyroscope_y"];
    [aCoder encodeDouble:gyroscopeZ forKey:@"gyroscope_z"];
    
    [aCoder encodeDouble:accelerometerX forKey:@"accelerometer_x"];
    [aCoder encodeDouble:accelerometerY forKey:@"accelerometer_y"];
    [aCoder encodeDouble:accelerometerZ forKey:@"accelerometer_z"];
}

@end
