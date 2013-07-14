//
//  SetInfoViewController.h
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "SensorRun.h"

@interface SetInfoViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    NSDateFormatter* _dateFormatter;
    SensorRun* _displayedRun;
}

@property(retain, nonatomic) IBOutlet UILabel* startTimeLabel;
@property(retain, nonatomic) IBOutlet UILabel* endTimeLabel;
@property(retain, nonatomic) IBOutlet UILabel* gyroscopeOnLabel;
@property(retain, nonatomic) IBOutlet UILabel* accelerometerOnLabel;
@property(retain, nonatomic) IBOutlet UILabel* eventCountLabel;

-(void) parseRun: (SensorRun*) run;

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@end
