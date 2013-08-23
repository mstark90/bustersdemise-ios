//
//  BDSensorData.m
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "BDSensorData.h"

@implementation BDSensorData

@synthesize AccelerationX;
@synthesize AccelerationY;
@synthesize AccelerationZ;
@synthesize GyroscopeX;
@synthesize GyroscopeY;
@synthesize GyroscopeZ;
@synthesize Timestamp;

-(id) init
{
    AccelerationX = 0;
    AccelerationY = 0;
    AccelerationZ = 0;
    GyroscopeX = 0;
    GyroscopeY = 0;
    GyroscopeZ = 0;
    time_t cur_time = time(NULL);
    Timestamp = cur_time;
    return self;
}

@end
