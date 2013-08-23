//
//  BSTemporarySensorRun.h
//  BustersDemise
//
//  Created by Michael Stark on 7/17/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BDSensorRecord.h"

@interface BDSensorRun : NSObject<NSCoding>
{
    NSMutableArray* sensorRecords;
    NSDateFormatter* _dateFormatter;
}

-(id) init;
-(id) initWithCoder:(NSCoder *)aDecoder;

-(void) dealloc;

-(NSArray*) getSensorRecords;
-(void) addRecord: (BDSensorRecord*) record;

-(void) encodeWithCoder:(NSCoder *)aCoder;


@property(nonatomic, retain) NSString* dataSetName;
@property(nonatomic, retain) NSDate* startTime;
@property(nonatomic, retain) NSDate* endTime;
@property(nonatomic) BOOL wasAccelerometerRecorded;
@property(nonatomic) BOOL wasGyroscopeRecorded;

@end
