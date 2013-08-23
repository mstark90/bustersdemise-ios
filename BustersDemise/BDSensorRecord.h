//
//  BDTemporarySensorRecord.h
//  BustersDemise
//
//  Created by Michael Stark on 7/17/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDSensorRecord : NSObject<NSCoding>
{
    NSDateFormatter* _dateFormatter;
}

-(id) init;
-(id) initWithCoder:(NSCoder *)aDecoder;

-(void) dealloc;

@property(nonatomic, retain) NSDate* timestamp;

@property(nonatomic) double gyroscopeX;
@property(nonatomic) double gyroscopeY;
@property(nonatomic) double gyroscopeZ;

@property(nonatomic) double accelerometerX;
@property(nonatomic) double accelerometerY;
@property(nonatomic) double accelerometerZ;

-(void) encodeWithCoder:(NSCoder *)aCoder;

@end
