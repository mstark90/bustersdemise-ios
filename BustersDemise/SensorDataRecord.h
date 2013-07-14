//
//  SensorDataRecord.h
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SensorDataRecord : NSManagedObject

@property (nonatomic, retain) NSNumber * accelerometerX;
@property (nonatomic, retain) NSNumber * accelerometerY;
@property (nonatomic, retain) NSNumber * accelerometerZ;
@property (nonatomic, retain) NSNumber * gyroscopeX;
@property (nonatomic, retain) NSNumber * gyroscopeY;
@property (nonatomic, retain) NSNumber * gyroscopeZ;
@property (nonatomic, retain) NSDate * timestamp;

@end
