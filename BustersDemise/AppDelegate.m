//
//  AppDelegate.m
//  BustersDemise
//
//  Created by Michael Stark on 7/11/13.
//  Copyright (c) 2013 Michael Stark. All rights reserved.
//

#import "AppDelegate.h"

#import "TabViewController.h"
#import "DataCollectionViewController.h"
#import "RunManagerViewController.h"
#import "SetListViewController.h"
#import "iPadViewController.h"
#import "iPadNavViewController.h"

#import <CoreData/CoreData.h>
#include <sqlite3.h>


@implementation AppDelegate

@synthesize sensorReader;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSPersistentStoreCoordinator* persistentStoreCoordination = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [NSManagedObjectModel mergedModelFromBundles: nil]];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    NSString* databasePath = [[NSString alloc]
                              initWithString: [docsDir stringByAppendingPathComponent:
                                               @"contacts.db"]];
    
    [persistentStoreCoordination addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:databasePath] options:nil error:nil];
    
    NSManagedObjectContext* objectContext = [[NSManagedObjectContext alloc] init];
    [objectContext setPersistentStoreCoordinator: persistentStoreCoordination];
    
    [self setSensorReader: [[BDSensorReader alloc] init]];
    [self.sensorReader setManagedObjectContext:objectContext];
    [self.sensorReader setOutputDirectory: docsDir];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        TabViewController* tabViewController = [[TabViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
        // Pass the managed object context to the view controller.
        NSMutableArray *assetBrowserControllers = [NSMutableArray arrayWithCapacity:0];
        
        DataCollectionViewController* dataCollection = [[DataCollectionViewController alloc] initWithNibName:@"DataCollectionViewController" bundle:nil];
        
        UITabBarItem* dataCollectionTab = [[UITabBarItem alloc] initWithTitle:@"Run Manager" image: [UIImage imageNamed:@"record.png"]tag:0];
        
        [dataCollection setTabBarItem: dataCollectionTab];
        [dataCollection setTitle:@"Data Collection"];
        [dataCollection setSensorReader: [self sensorReader]];
        [dataCollection setManagedObjectContext:objectContext];
        
        [assetBrowserControllers addObject: dataCollection];
        
        RunManagerViewController* runManager = [[RunManagerViewController alloc] initWithNibName:@"RunManagerViewController" bundle:nil];
        
        UITabBarItem* runManagerTab = [[UITabBarItem alloc] initWithTitle:@"Run Manager" image: [UIImage imageNamed:@"sets.png"] tag:0];
        
        [runManager setTabBarItem: runManagerTab];
        [[runManager navigationBar] setBarStyle: UIBarStyleBlackOpaque];
        
        SetListViewController* listController = [[SetListViewController alloc] initWithNibName:@"SetListViewController" bundle:nil];
        
        [listController setManagedObjectContext:objectContext];
        [listController setTitle:@"Data Sets"];
        
        [runManager pushViewController:listController animated:NO];
        
        
        [assetBrowserControllers addObject: runManager];
        
        [tabViewController setViewControllers: assetBrowserControllers animated: NO];
        self.viewController = tabViewController;
    } else {
        iPadViewController* iPadController = [[iPadViewController alloc] initWithNibName:@"iPadViewController" bundle:nil];
        
        [iPadController setManagedObjectContext:objectContext];
        [iPadController setSensorReader: [self sensorReader]];
        
        NSMutableArray* viewControllers = [[NSMutableArray alloc] initWithCapacity:0];
        
        iPadNavViewController* navViewController = [[iPadNavViewController alloc] initWithStyle: UITableViewStylePlain];
        [navViewController setRootController: iPadController];
        
        UINavigationController* navController = [[UINavigationController alloc] init];
        navController.navigationBar.barStyle = UIBarStyleBlackOpaque;
        [navController pushViewController: navViewController animated:NO];
        
        DataCollectionViewController* dataCollector = [[DataCollectionViewController alloc] initWithNibName:@"DataCollectionViewController_iPad" bundle:nil];
        [dataCollector setTitle: @"Data Collection"];
        [dataCollector setManagedObjectContext:objectContext];
        [dataCollector setSensorReader: [self sensorReader]];
        
        [viewControllers addObject: navController];
        [viewControllers addObject: dataCollector];
        
        iPadController.viewControllers = viewControllers;
        
        self.viewController = iPadController;
    }
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if([self sensorReader] != nil)
    {
        [[self sensorReader] stopReader: ^(NSError* error){}];
    }
    [self.sensorReader release];
}

@end
