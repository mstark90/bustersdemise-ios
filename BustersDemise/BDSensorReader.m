//
//  BDSensorReader.m
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "BDSensorReader.h"
#import "BDSensorRecord.h"
#import "BDSensorRun.h"
#import "SensorRun.h"

#include <sys/types.h>
#include <sys/sysctl.h>

@implementation BDSensorReader

@synthesize currentRun;
@synthesize managedObjectContext;
@synthesize outputDirectory;

-(id) init
{
    motionManager = [[CMMotionManager alloc] init];
    operationQueue = [[NSOperationQueue alloc] init];
    [self setCollectionFrequency: 50];
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
                    boottime.tv_sec + (boottime.tv_usec / 1000000)];
    }
    
    [bootDate retain];
    
    sensor_queue = dispatch_queue_create("BDSensorReaderQueue", NULL);
    
    return self;
}

-(void) startReader
{
    NSLog(@"bootDate refcount: %d", [bootDate retainCount]);
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
    [motionManager setDeviceMotionUpdateInterval: (1.0 / self.collectionFrequency)];
    [motionManager startDeviceMotionUpdatesToQueue:operationQueue withHandler:
     ^(CMDeviceMotion *motion, NSError *error) {
         if(self.currentRun)
         {
             BDSensorRecord* dataRecord = [[BDSensorRecord alloc] init];
             [dataRecord setTimestamp: [NSDate dateWithTimeInterval:motion.timestamp sinceDate:bootDate]];
             if(self.collectGyroscope)
             {
                 [dataRecord setGyroscopeX: [motion rotationRate].x];
                 [dataRecord setGyroscopeY: [motion rotationRate].y];
                 [dataRecord setGyroscopeZ: [motion rotationRate].z];
             }
             else
             {
                 [dataRecord setGyroscopeX: 0];
                 [dataRecord setGyroscopeY: 0];
                 [dataRecord setGyroscopeZ: 0];
             }
             if(self.collectAccelerometer)
             {
                 [dataRecord setAccelerometerX: [motion gravity].x];
                 [dataRecord setAccelerometerY: [motion gravity].y];
                 [dataRecord setAccelerometerZ: [motion gravity].z];
             }
             else
             {
                 [dataRecord setAccelerometerX: 0];
                 [dataRecord setAccelerometerY: 0];
                 [dataRecord setAccelerometerZ: 0];
             }
             [self.currentRun addRecord: dataRecord];
         }
     }];
}

-(void) dealloc
{
    [motionManager stopDeviceMotionUpdates];
    if(self.managedObjectContext != nil)
    {
        [self.managedObjectContext release];
        self.managedObjectContext = nil;
    }
    if(currentRun != nil)
    {
        [currentRun release];
        currentRun = nil;
    }
    [bootDate release];
    [super dealloc];
}

-(void) stopReader: (void (^)(NSError*)) handler
{
    [[UIApplication sharedApplication] setIdleTimerDisabled: NO];
    [motionManager stopDeviceMotionUpdates];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void)
       {
           __block NSError* error = nil;
           if(self.managedObjectContext != nil)
           {
               [self.managedObjectContext retain];
               NSString* outputFileName = [NSString stringWithFormat:@"%@/%@.dat", outputDirectory, [currentRun dataSetName]];
               if([[NSFileManager defaultManager] fileExistsAtPath: outputFileName])
               {
                   outputFileName = [NSString stringWithFormat:@"%@/%@_%i.dat", outputDirectory,
                                     [currentRun dataSetName], rand()];
               }
               [NSKeyedArchiver archiveRootObject:currentRun toFile:outputFileName];
               if(error == nil)
               {
                   SensorRun* sensorRun = [[SensorRun alloc] initWithEntity:[NSEntityDescription entityForName:@"SensorRun" inManagedObjectContext:self.managedObjectContext] insertIntoManagedObjectContext:self.managedObjectContext];
                   [sensorRun setDataFileName: outputFileName];
                   [sensorRun setStartTime: [currentRun startTime]];
                   [sensorRun setEndTime: [NSDate date]];
                   [sensorRun setDataSetName: [currentRun dataSetName]];
                   [sensorRun setWasAccelerometerOn: [NSNumber numberWithBool: [currentRun wasAccelerometerRecorded]]];
                   [sensorRun setWasGyroscopeOn: [NSNumber numberWithBool: [currentRun wasGyroscopeRecorded]]];
                   [sensorRun setEventCount: [NSNumber numberWithLong: [[currentRun getSensorRecords] count]]];
                   [self.managedObjectContext save: &error];
               }
               [self.managedObjectContext release];
           }
           if(handler)
           {
               dispatch_async(dispatch_get_main_queue(), ^(void)
                  {
                      handler(error);
                  });
           }
       });
    
}

-(BOOL) isRecording
{
    return [motionManager isDeviceMotionActive];
}

-(dispatch_queue_t) getDispatchQueue
{
    return sensor_queue;
}

@end
