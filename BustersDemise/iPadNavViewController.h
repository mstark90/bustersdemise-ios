//
//  iPadNavViewController.h
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "iPadViewController.h"

@interface iPadNavViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* _navItems;
}

@property(nonatomic, retain) iPadViewController* rootController;

@end
