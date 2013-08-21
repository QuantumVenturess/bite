//
//  AppDelegate.m
//  Bite
//
//  Created by Tommy DANGerous on 5/15/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <NewRelicAgent/NewRelicAgent.h>
#import <Parse/Parse.h>
#import "AboutViewController.h"
#import "AllTableStore.h"
#import "AppDelegate.h"
#import "BiteConnection.h"
#import "BiteNavigationController.h"
#import "BiteTabBarController.h"
#import "BiteTableFullScreenViewController.h"
#import "BiteTableViewController.h"
#import "BiteViewController.h"
#import "ExploreTableStore.h"
#import "ExploreNavigationController.h"
#import "GAI.h"
#import "JoinViewController.h"
#import "MenuBarButtonItem.h"
#import "MenuView.h"
#import "NewsNavigationController.h"
#import "NotificationStore.h"
#import "SittingTableStore.h"
#import "SittingNavigationController.h"
#import "StartNavigationController.h"
#import "StartViewController.h"
#import "Table.h"
#import "TableDetailConnection.h"
#import "TableDetailViewController.h"
#import "TutorialView.h"
#import "User.h"
#import "UserStore.h"

NSString *const BiteApiURL = @"https://abiteapp.herokuapp.com";
NSString *const CurrentUserSignOut = @"CurrentUserSignOut";
NSString *const FBSessionStateChangedNotification =
  @"com.quantum.Login:FBSessionStateChangedNotification";
NSString *const RefreshDataNotification = 
  @"RefreshDataNotification";

@implementation AppDelegate

@synthesize aboutNavigationController;
@synthesize joinViewController;
@synthesize completionBlock;
@synthesize menuView;
@synthesize newsTabBarItem;
@synthesize tabBarController;
@synthesize tutorialView;

#pragma mark - Protocol UIApplicationDelegate

- (BOOL) application: (UIApplication *) application 
didFinishLaunchingWithOptions: (NSDictionary *) launchOptions
{
  // Google analytics
  // Optional: automatically send uncaught exceptions to Google Analytics
  [GAI sharedInstance].trackUncaughtExceptions = YES;
  // Optional: set Google Analytics dispatch interval to e.g. 20 seconds
  [GAI sharedInstance].dispatchInterval = 20;
  // Optional: set debug to YES for extra debugging information
  [GAI sharedInstance].debug = YES;
  // Create tracker instance
  [[GAI sharedInstance] trackerWithTrackingId: @"UA-41570926-1"];
  // [[GAI sharedInstance] defaultTracker];

  // New Relic
  [NewRelicAgent startWithApplicationToken:
    @"AAbf27ee4337833822e4ba714a2d827ae3d16459ff"];

  // Parse setup
  [Parse setApplicationId: @"39yTYLkulJm5DgsHiauOrH3vedCxegGlpfJJtG7c" 
    clientKey: @"95M9CI31m8K4fzL4mtSoL4SzyaFARBDAUaiogNqh"];

  // Register for push notifications
  [application registerForRemoteNotificationTypes:
    UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge];

  // Notifications
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(refreshRootViewController)
      name: BiteAccessTokenReceivedNotification object: nil];
  [[NSNotificationCenter defaultCenter] addObserver: self
    selector: @selector(signOut) name: CurrentUserSignOut object: nil];

  // Window
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.window = [[UIWindow alloc] initWithFrame: screen];

  // View controllers
  self.joinViewController = [[JoinViewController alloc] init];
  
  // Tab bar controller
  self.tabBarController = [[BiteTabBarController alloc] init];
  self.tabBarController.delegate = self;

  // News tab bar item
  NewsNavigationController *newsNav = (NewsNavigationController *)
    [self.tabBarController.viewControllers lastObject];
  self.newsTabBarItem = newsNav.tabBarItem;

  // Menu view
  self.menuView = [[MenuView alloc] init];
  [self.tabBarController.view addSubview: self.menuView];
  // About view controller
  self.aboutNavigationController = 
    [[BiteNavigationController alloc] initWithRootViewController: 
      [[AboutViewController alloc] init]];

  // Tutorial view
  self.tutorialView = [[TutorialView alloc] init];
  self.tutorialView.hidden = YES;
  [self.tabBarController.view addSubview: self.tutorialView];

  self.window.rootViewController = self.tabBarController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];

  // See if the app has a valid token for the current state
  if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
    // Yes, so just open the session (this won't display any UI)
    [self openSession];
  }
  else {
    // No, display the login page
    [self showJoinView];
  }

  // Extract the notification data
  NSDictionary *notificationPayload = 
    launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];

  if (notificationPayload) {
    [[NSNotificationCenter defaultCenter] addObserver: self
      selector: @selector(launchCompletionBlock)
        name: BiteAccessTokenReceivedNotification object: nil];

    UINavigationController *nav = (UINavigationController *)
      self.tabBarController.selectedViewController;
    self.completionBlock = ^(void) {
      int tableId = [[notificationPayload objectForKey: 
        @"table_id"] integerValue];
      if (tableId) {
        TableDetailConnection *connection = 
          [[TableDetailConnection alloc] initWithTableId: tableId];
        connection.completionBlock = ^(NSError *error) {
          if (!error) {
            Table *table = [[AllTableStore sharedStore] table: tableId];
            TableDetailViewController *tableDetail = 
              [[TableDetailViewController alloc] initWithTable: table];
            [nav pushViewController: tableDetail animated: NO];
          }
        };
        [connection start];
      }
    };
  }

  return YES;
}

- (void) application: (UIApplication *) application
didFailToRegisterForRemoteNotificationsWithError: (NSError *) error
{
  NSLog(@"Failed to register for pushes: %@", error.localizedDescription);
}

- (void) application: (UIApplication *) application
didReceiveRemoteNotification: (NSDictionary *) userInfo
{
  UINavigationController *nav = (UINavigationController *)
    self.tabBarController.selectedViewController;
  if (application.applicationState == UIApplicationStateActive) {
    BiteViewController *biteView = (BiteViewController *)
      [nav topViewController];
    [biteView refreshUnviewedNewsCount];
  }
  else {
    int tableId = [[userInfo objectForKey: @"table_id"] integerValue];
    // Extract the notification data when an app is opened from a notification
    Table *table = [[AllTableStore sharedStore] table: tableId];
    void (^showTableDetailViewController) (Table *tableObject) = 
      ^(Table *tableObject) {
        TableDetailViewController *tableDetail = 
          [[TableDetailViewController alloc] initWithTable: tableObject];
        [nav pushViewController: tableDetail animated: NO];
      };
    if (table) {
      showTableDetailViewController(table);
    }
    else {
      TableDetailConnection *connection = 
        [[TableDetailConnection alloc] initWithTableId: tableId];
      connection.completionBlock = ^(NSError *error) {
        if (!error) {
          Table *newTable = [[AllTableStore sharedStore] table: tableId];
          showTableDetailViewController(newTable);
        }
      };
      [connection start];
    }
  }
}

- (void) application: (UIApplication *) application 
didRegisterForRemoteNotificationsWithDeviceToken: (NSData *) deviceToken
{
  // Store the deviceToken in the current installation and save it to Parse
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  [currentInstallation setDeviceTokenFromData: deviceToken];
  [currentInstallation saveInBackground];
}

- (BOOL) application: (UIApplication *) application openURL: (NSURL *) url
sourceApplication: (NSString *) sourceApplication annotation: (id) annotation
{
  return [FBSession.activeSession handleOpenURL: url];
}

- (void) applicationDidBecomeActive: (UIApplication *) application
{
  // Properly handle activation of the application with regards to Facebook
  [FBSession.activeSession handleDidBecomeActive];

  // Clearing the badge
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  if (currentInstallation.badge != 0) {
    currentInstallation.badge = 0;
    [currentInstallation saveEventually];
  }

  UINavigationController *nav = (UINavigationController *)
      self.tabBarController.selectedViewController;
  UIViewController *viewController = nav.topViewController;
  if (FBSession.activeSession.state == FBSessionStateOpen) {
    // Refresh news count
    if ([viewController isKindOfClass: [BiteViewController class]]) {
      BiteViewController *biteView = (BiteViewController *)
        viewController;
      [biteView refreshUnviewedNewsCount];
    }
    // Refresh tables
    if ([viewController isKindOfClass: [BiteTableViewController class]]) {
      BiteTableViewController *biteTable = (BiteTableViewController *)
        viewController;
      [biteTable refreshTable];
    }
  }
}

- (void) applicationWillResignActive: (UIApplication *) application
{
  // This method is called to let your application know that it is 
  // about to move from the active to inactive state

  // An application in the inactive state continues to run 
  // but does not dispatch incoming events to responders.

  // You should use this method to pause ongoing tasks, disable timers
  NSLog(@"Resign active");
}

- (void) applicationDidEnterBackground: (UIApplication *) application
{
  // You should perform any tasks relating to adjusting your user 
  // interface before this method exits
  NSLog(@"Background");
}

- (void) applicationWillTerminate: (UIApplication *) application
{
  [self signOut];
  NSLog(@"Terminate");
  exit(0);
}

#pragma mark - Protocol Facebook

- (void) openSessionWithAllowLoginUI
{
  // Invoked when the login button is clicked or when a check is 
  // made for an active session when the main view is initially loaded
}

- (void) sessionStateChanged
{
  // Defines
}

#pragma mark - Protocol UIAlertViewDelegate

- (void) alertView: (UIAlertView *) alertView
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  [[NSNotificationCenter defaultCenter] postNotificationName:
    CurrentUserSignOut object: nil];
}

#pragma mark - Protocol UITabBarControllerDelegate

- (BOOL) tabBarController: (UITabBarController *) tabBarControl
shouldSelectViewController: (UIViewController *) viewController
{
  if ([tabBarControl.selectedViewController isKindOfClass: 
    [viewController class]]) {

    if ([viewController isKindOfClass: [UINavigationController class]]) {
      UINavigationController *nav = (UINavigationController *) viewController;
      if ([[nav topViewController] isKindOfClass:
        [BiteTableViewController class]] || 
          [[nav topViewController] isKindOfClass: 
            [StartViewController class]]) {

        CGPoint offset;
        if ([[nav topViewController] isKindOfClass: 
          [BiteTableFullScreenViewController class]]) {
          offset = CGPointMake(0, -44);
        }
        else {
          offset = CGPointMake(0, 0);
        }
        BiteTableViewController *tableViewController = 
          (BiteTableViewController *) [nav topViewController];
        [tableViewController.table setContentOffset: offset
          animated: YES];
      }
    }
  }
  return YES;
}

#pragma mark - Methods

- (void) launchCompletionBlock
{
  self.completionBlock();
}

- (void) openSession
{
  NSArray *permissions = [NSArray arrayWithObjects: @"email", 
    @"user_location", @"user_birthday", @"user_likes", nil];

  [FBSession openActiveSessionWithReadPermissions: 
    permissions allowLoginUI: YES completionHandler: 
    ^(FBSession *session, FBSessionState state, NSError *error) {
      [self sessionStateChanged: session state: state error: error];
    }
  ];
}

- (void) refreshRootViewController
{
  UINavigationController *nav = (UINavigationController *) 
    self.tabBarController.selectedViewController;
  if ([[nav topViewController] isKindOfClass: 
    [BiteTableViewController class]]) {

    BiteTableViewController *tableViewController = 
      (BiteTableViewController *) [nav topViewController];
    [tableViewController refreshTable];
  }
}

- (void) sessionStateChanged: (FBSession *) session
state: (FBSessionState) state error: (NSError *) error
{
  switch (state) {
    case FBSessionStateOpen: {
      UIViewController *presentedViewController = 
        [self.tabBarController presentedViewController];
      if ([presentedViewController isKindOfClass: 
        [JoinViewController class]]) {
        
        [presentedViewController dismissViewControllerAnimated: YES 
          completion: nil];
      }
      [User currentUser];
      break;
    }
    case FBSessionStateClosed:
    case FBSessionStateClosedLoginFailed:
      [[User currentUser] signOut];
      [FBSession.activeSession closeAndClearTokenInformation];
      [self showJoinView];
      break;
    default:
      break;
  }

  [[NSNotificationCenter defaultCenter] postNotificationName:
    FBSessionStateChangedNotification object: session];

  if (error) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Error" 
      message: error.localizedDescription delegate: nil 
      cancelButtonTitle: @"OK" otherButtonTitles: nil];
    [alertView show];
  }
}

- (void) showJoinView
{
  UIViewController *presentedViewController = 
    [self.tabBarController presentedViewController];

  // If the current view being presented is not the login screen, create it
  if (![presentedViewController isKindOfClass: [JoinViewController class]]) {
    [self.tabBarController presentViewController: self.joinViewController 
      animated: NO completion: nil];
  }
  else {
    JoinViewController *join = (JoinViewController *) presentedViewController;
    [join signInFailed];
  }
}

- (void) signOut
{
  // Reset unviewed news count
  self.newsTabBarItem.badgeValue = nil;
  // Clear all current connections
  [BiteConnection clearConnections];
  // Clear all stores
  [[AllTableStore sharedStore] clearTables];
  [[ExploreTableStore sharedStore] clearTables];
  [[NotificationStore sharedStore] clearNotifications];
  [[SittingTableStore sharedStore] clearTables];
  // StartPlaceStore clearing is handled by StartViewController
  [[UserStore sharedStore] clearUsers];
  // Sign out user and clear user information
  [[User currentUser] signOut];
  [FBSession.activeSession closeAndClearTokenInformation];
}

@end
