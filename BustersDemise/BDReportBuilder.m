//
//  BDReportBuilder.m
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "BDReportBuilder.h"
#import "BDSensorRun.h"
#import "BDSensorRecord.h"

@implementation BDReportBuilder

+(NSString*) createReport: (BDSensorRun*) sensorRun
{
    NSMutableString* mutableString = [[NSMutableString alloc] init];
    [mutableString appendString: @"timestamp, acceleration_x, acceleration_y, acceleration_z,"];
    [mutableString appendString: @" gyroscope_x, gyroscope_y, gyroscope_z\n"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *formatString = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
    [formatter setDateFormat:formatString];
    NSSortDescriptor* sorter = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    NSArray* sortedRecords = [[sensorRun getSensorRecords] sortedArrayUsingDescriptors:[NSArray arrayWithObjects: sorter, nil]];
    for(BDSensorRecord* record in sortedRecords)
    {
        [mutableString appendFormat: @"%@, %f, %f, %f, %f, %f, %f\n", [formatter stringFromDate:record.timestamp],
            record.accelerometerX, record.accelerometerY, record.accelerometerZ, record.gyroscopeX,
            record.gyroscopeY, record.gyroscopeZ];
        
    }
    [formatter release];
    formatter = nil;
    return [NSString stringWithString:mutableString];
}

@end
