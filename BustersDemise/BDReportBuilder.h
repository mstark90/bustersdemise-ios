//
//  BDReportBuilder.h
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SensorRun.h"

@interface BDReportBuilder : NSObject

+(NSString*) createReport: (SensorRun*) sensorRun;

@end
