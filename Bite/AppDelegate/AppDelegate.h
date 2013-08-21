//
//  AppDelegate.h
//  Bite
//
//  Created by Tommy DANGerous on 5/15/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

extern NSString *const BiteApiURL;
extern NSString *const CurrentUserSignOut;
extern NSString *const FBSessionStateChangedNotification;
extern NSString *const RefreshDataNotification;

@class BiteNavigationController;
@class JoinViewController;
@class MenuView;
@class TutorialView;

@interface AppDelegate : UIResponder 
<UIAlertViewDelegate, UIApplicationDelegate, UITabBarControllerDelegate>
{
  NSString *registeredDeviceToken;
}

@property (nonatomic, strong) BiteNavigationController 
  *aboutNavigationController;
@property (nonatomic, strong) JoinViewController *joinViewController;
@property (nonatomic, copy) void (^completionBlock) (void);
@property (nonatomic, strong) MenuView *menuView;
@property (nonatomic, strong) UITabBarItem *newsTabBarItem;
@property (nonatomic, strong) UITabBarController *tabBarController;
@property (nonatomic, strong) TutorialView *tutorialView;
@property (nonatomic, strong) UIWindow *window;

#pragma mark Methods

- (void) launchCompletionBlock;
- (void) openSession;
- (void) sessionStateChanged: (FBSession *) session
state: (FBSessionState) state error: (NSError *) error;
- (void) showJoinView;
- (void) signOut;

@end
