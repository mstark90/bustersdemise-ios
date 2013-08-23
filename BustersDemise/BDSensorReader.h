//
//  BDSensorReader.h
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

#import "BDSensorRun.h"

@interface BDSensorReader : NSObject
{
    CMMotionManager* motionManager;
    NSOperationQueue* operationQueue;
    __strong NSDate* bootDate;
    dispatch_queue_t sensor_queue;
};

@property(nonatomic, retain) BDSensorRun* currentRun;
@property(atomic, retain) NSManagedObjectContext* managedObjectContext;
@property(atomic, retain) NSString* outputDirectory;
@property(nonatomic) BOOL collectAccelerometer;
@property(nonatomic) BOOL collectGyroscope;
@property(nonatomic) int collectionFrequency;

-(id) init;
-(void) startReader;
-(void) stopReader: (void (^)(NSError*))handler;
-(BOOL) isRecording;
-(dispatch_queue_t) getDispatchQueue;

@end
