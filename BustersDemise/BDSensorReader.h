//
//  BDSensorReader.h
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "SensorRun.h"

@interface BDSensorReader : NSObject
{
    CMMotionManager* motionManager;
    NSOperationQueue* operationQueue;
    NSDate* bootDate;
};

@property(nonatomic, retain) SensorRun* currentRun;
@property(nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property(nonatomic) BOOL collectAccelerometer;
@property(nonatomic) BOOL collectGyroscope;
@property(nonatomic) int collectionFrequency;

-(id) init;
-(void) startReader;
-(void) stopReader;
-(BOOL) isRecording;

@end
