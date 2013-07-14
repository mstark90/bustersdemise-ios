//
//  SetListViewController.h
//  BustersDemise
//
//  Created by Michael Stark on 7/13/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CoreData/CoreData.h>

@interface SetListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSArray* _currentData;
    bool _isDataButtonsEnabled;
    bool _isMultiExportEnabled;
    UIBarButtonItem* _editButton;
    UIBarButtonItem* _refreshButton;
}

@property(retain, nonatomic) IBOutlet UITableView* runTable;
@property(retain, nonatomic) IBOutlet UIBarButtonItem* exportButtonItem;
@property(retain, nonatomic) IBOutlet UIBarButtonItem* clearAllButtonItem;
@property(retain, nonatomic) IBOutlet UIBarButtonItem* exportAllButtonItem;
@property(retain, nonatomic) IBOutlet UIToolbar* optionsBar;
@property(retain, nonatomic) NSManagedObjectContext* managedObjectContext;

-(void) reloadData;

-(void) updateButtonConstraints;

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

@end
