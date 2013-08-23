//
//  BDEmailHelper.m
//  BustersDemise
//
//  Created by Michael Stark on 7/16/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "BDEmailHelper.h"
#import "MBProgressHUD.h"

#import <MessageUI/MessageUI.h>

@implementation BDEmailHelper

+(void) sendEmail: (id) delegate emailSubject: (NSString*) emailSubject emailText: (NSString*) emailText reports: (NSDictionary*) reports viewController:(UIViewController *)viewController
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = delegate;
    [controller setSubject: emailSubject];
    [controller setMessageBody:emailText isHTML:NO];
    for(NSString* fileName in [reports keyEnumerator])
    {
        [controller addAttachmentData:[reports objectForKey:fileName] mimeType:@"text/plain" fileName:fileName];
    }
    [viewController presentViewController:controller animated:YES completion:^(void){}];
    [viewController release];
}

@end
