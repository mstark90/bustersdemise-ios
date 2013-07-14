//
//  SensorRun.h
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SensorDataRecord;

@interface SensorRun : NSManagedObject

@property (nonatomic, retain) NSString * dataSetName;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * runID;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * wasGyroscopeRecorded;
@property (nonatomic, retain) NSNumber * wasAccelerometerRecorded;
@property (nonatomic, retain) NSSet *dataRecords;
@end

@interface SensorRun (CoreDataGeneratedAccessors)

- (void)addDataRecordsObject:(SensorDataRecord *)value;
- (void)removeDataRecordsObject:(SensorDataRecord *)value;
- (void)addDataRecords:(NSSet *)values;
- (void)removeDataRecords:(NSSet *)values;

@end
