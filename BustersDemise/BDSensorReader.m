//
//  BDSensorReader.m
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "BDSensorReader.h"
#import "SensorDataRecord.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation BDSensorReader

@synthesize currentRun;
@synthesize managedObjectContext;

-(id) init
{
    motionManager = [[CMMotionManager alloc] init];
    operationQueue = [[NSOperationQueue alloc] init];
    [self setCollectionFrequency: 100];
    currentRun = nil;
    
    int mib[2];
    size_t size;
    struct timeval  boottime;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_BOOTTIME;
    size = sizeof(boottime);
    bootDate = [NSDate date];
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1)
    {
        // successful call
        bootDate = [NSDate dateWithTimeIntervalSince1970:
                    boottime.tv_sec + boottime.tv_usec / 1.e6];
    }
    
    return self;
}

-(void) startReader
{
    [motionManager setDeviceMotionUpdateInterval: (1.0 / self.collectionFrequency)];
    [motionManager startDeviceMotionUpdatesToQueue:operationQueue withHandler:
     ^(CMDeviceMotion *motion, NSError *error) {
         SensorDataRecord* dataRecord = [[SensorDataRecord alloc] initWithEntity:[NSEntityDescription entityForName:@"SensorDataRecord" inManagedObjectContext:managedObjectContext] insertIntoManagedObjectContext:managedObjectContext];

         dataRecord.timestamp = [NSDate dateWithTimeInterval:motion.timestamp sinceDate:bootDate];
         if(self.collectGyroscope)
         {
             dataRecord.gyroscopeX = [NSNumber numberWithDouble: [motion rotationRate].x];
             dataRecord.gyroscopeY = [NSNumber numberWithDouble: [motion rotationRate].y];
             dataRecord.gyroscopeZ = [NSNumber numberWithDouble: [motion rotationRate].z];
         }
         else
         {
             dataRecord.gyroscopeX = [NSNumber numberWithInt:0];
             dataRecord.gyroscopeY = [NSNumber numberWithInt:0];
             dataRecord.gyroscopeZ = [NSNumber numberWithInt:0];
         }
         if(self.collectAccelerometer)
         {
             dataRecord.accelerometerX = [NSNumber numberWithDouble: [motion gravity].x];
             dataRecord.accelerometerY = [NSNumber numberWithDouble: [motion gravity].y];
             dataRecord.accelerometerZ = [NSNumber numberWithDouble: [motion gravity].z];
         }
         else
         {
             dataRecord.accelerometerX = [NSNumber numberWithInt:0];
             dataRecord.accelerometerY = [NSNumber numberWithInt:0];
             dataRecord.accelerometerZ = [NSNumber numberWithInt:0];
         }
         if(currentRun != nil)
         {
             [currentRun addDataRecordsObject:dataRecord];
         }
     }];
}

-(void) stopReader
{
    [motionManager stopDeviceMotionUpdates];
}

-(BOOL) isRecording
{
    return [motionManager isDeviceMotionActive];
}

@end
