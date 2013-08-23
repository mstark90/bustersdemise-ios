//
//  BDRunReport.h
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDSensorRun.h"

@interface BDRunReport : UIDocument

@property(nonatomic, strong) BDSensorRun* sensorRun;

- (id)init;

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError;

@end
