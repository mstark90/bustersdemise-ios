//
//  SensorRun.h
//  BustersDemise
//
//  Created by Michael Stark on 7/26/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SensorRun : NSManagedObject

@property (nonatomic, retain) NSString * dataFileName;
@property (nonatomic, retain) NSNumber * runID;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * eventCount;
@property (nonatomic, retain) NSNumber * wasAccelerometerOn;
@property (nonatomic, retain) NSNumber * wasGyroscopeOn;
@property (nonatomic, retain) NSString * dataSetName;

@end
