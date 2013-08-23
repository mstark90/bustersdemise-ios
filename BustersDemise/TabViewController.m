//
//  ViewController.m
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "TabViewController.h"
#import "BDReportBuilder.h"
#import "DataCollectionViewController.h"
#import "RunManagerViewController.h"
#import "SetListViewController.h"

#import <CoreData/CoreData.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TabViewController ()

@end

@implementation TabViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if([viewController isKindOfClass: [RunManagerViewController class]])
    {
        RunManagerViewController* runManager = (RunManagerViewController*)viewController;
        SetListViewController* setView = (SetListViewController*)[[runManager viewControllers] objectAtIndex: 0];
        [setView reloadData];
        [setView updateButtonConstraints];
    }
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
