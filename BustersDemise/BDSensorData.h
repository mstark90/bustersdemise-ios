//
//  BDSensorData.h
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface BDSensorData : NSObject

@property(nonatomic) float AccelerationX;
@property(nonatomic) float AccelerationY;
@property(nonatomic) float AccelerationZ;
@property(nonatomic) float GyroscopeX;
@property(nonatomic) float GyroscopeY;
@property(nonatomic) float GyroscopeZ;
@property(nonatomic) long long Timestamp;

-(id)init;

@end
