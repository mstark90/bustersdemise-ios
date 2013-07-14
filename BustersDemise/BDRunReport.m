//
//  BDRunReport.m
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "BDRunReport.h"
#import "BDReportBuilder.h"

@implementation BDRunReport

@synthesize sensorRun;

-(id) init
{
    sensorRun = nil;
    return self;
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    if(sensorRun != nil)
    {
        return [[BDReportBuilder createReport: sensorRun] dataUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        return [[NSData alloc] init];
    }
}

@end
