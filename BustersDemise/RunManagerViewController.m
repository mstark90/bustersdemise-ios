//
//  RunManagerViewController.m
//  BustersDemise
//
//  Created by Michael Stark on 7/12/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "RunManagerViewController.h"
#import "SensorRun.h"
#import "BDReportBuilder.h"
#import "SetInfoViewController.h"

@interface RunManagerViewController ()

@end

@implementation RunManagerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setTintColor: [UIColor colorWithRed:0.129411 green:0.6863 blue:0 alpha:1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
