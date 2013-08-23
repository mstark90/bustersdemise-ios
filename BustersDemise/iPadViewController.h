//
//  iPadViewController.h
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BDSensorReader.h"

@interface iPadViewController : UISplitViewController<UISplitViewControllerDelegate>

@property(retain, nonatomic) BDSensorReader* sensorReader;
@property(retain, atomic) NSManagedObjectContext* managedObjectContext;
@property(retain, nonatomic) IBOutlet UIViewController* rightViewController;
@property(retain, nonatomic) IBOutlet UINavigationController* navigationController;

@end
