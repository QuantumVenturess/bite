//
//  MenuView.m
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AboutViewController.h"
#import "AppDelegate.h"
#import "MenuView.h"
#import "UIColor+Extensions.h"
#import "User.h"
#import "UserDetailViewController.h"

@implementation MenuView

@synthesize aboutButton;
@synthesize aboutImageView;
@synthesize alertView;
@synthesize backgroundButton;
@synthesize horizontalOffset;
@synthesize menu;
@synthesize profileButton;
@synthesize profileImageView;
@synthesize rateUsButton;
@synthesize rateUsImageView;
@synthesize signOutButton;
@synthesize signOutImageView;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // Create pan gesture recognizer for velocity
    UIPanGestureRecognizer *velocityRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget: self 
        action: @selector(velocityCheck:)];
    [velocityRecognizer setCancelsTouchesInView: NO];
    [self addGestureRecognizer: velocityRecognizer];

    CGRect screen = [[UIScreen mainScreen] bounds];
    UIColor *gray40 = [UIColor colorWithRed: (40/255.0) green: (40/255.0)
      blue: (40/255.0) alpha: 1];
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue" size: 15];
    UIFont *fontBold = [UIFont fontWithName: @"HelveticaNeue-Bold" 
      size: 18];    
    // Main view
    self.frame = CGRectMake((screen.size.width * -1), 20, screen.size.width, 
      (screen.size.height - 20));
    // Background view
    self.backgroundButton = [[UIButton alloc] init];
    self.backgroundButton.backgroundColor = [UIColor colorWithRed: (0/255.0) 
      green: (0/255.0) blue: (0/255.0) alpha: 0.5];
    self.backgroundButton.frame = CGRectMake(0, 0, self.frame.size.width,
      self.frame.size.height);
    [self.backgroundButton addTarget: self action: @selector(hideMenu)
      forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: self.backgroundButton];
    // Menu
    self.menu = [[UIView alloc] init];
    self.menu.backgroundColor = [UIColor colorWithRed: (245/255.0) 
      green: (245/255.0) blue: (245/255.0) alpha: 1];
    float menuWidth = ((self.frame.size.width * 2.0) / 3.0);
    self.menu.frame = CGRectMake((menuWidth * -1), 0, menuWidth,
      self.frame.size.height);
    [self addSubview: self.menu];
    // Title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.frame = CGRectMake(0, 0, menu.frame.size.width, 44);
    titleLabel.font = fontBold;
    titleLabel.text = @"Menu";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = gray40;
    [self.menu addSubview: titleLabel];
    // Alert view
    self.alertView = [[UIAlertView alloc] init];
    self.alertView.delegate = self;
    self.alertView.title = @"Sign out for sure?";
    [self.alertView addButtonWithTitle: @"Yes"];
    [self.alertView addButtonWithTitle: @"No"];

    // Back button
    // UIImage *backButtonImage = [UIImage imageNamed: @"back.png"];
    // UIButton *backButton = [UIButton buttonWithType: UIButtonTypeCustom];
    // backButton.frame = CGRectMake(10, 12, backButtonImage.size.width,
    //   backButtonImage.size.height);
    // [backButton addTarget: self action: @selector(hideMenu) 
    //   forControlEvents: UIControlEventTouchUpInside];
    // [backButton setImage: backButtonImage forState: UIControlStateNormal];
    // [self.menu addSubview: backButton];

    // Profile button
    self.profileButton = [[UIButton alloc] init];
    self.profileButton.frame = CGRectMake(0, 44,
      self.menu.frame.size.width, 50);
    CALayer *profileButtonBorder = [CALayer layer];
    profileButtonBorder.frame = CGRectMake(0, 0, 
      self.menu.frame.size.width, 1);
    profileButtonBorder.backgroundColor = [UIColor gray: 200].CGColor;
    [self.profileButton.layer addSublayer: profileButtonBorder];
    [self.profileButton addTarget: self action: @selector(showProfile)
      forControlEvents: UIControlEventTouchUpInside];
    [self.menu addSubview: self.profileButton];
    // Profile image view
    self.profileImageView = [[UIImageView alloc] init];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.contentMode = UIViewContentModeTopLeft;
    self.profileImageView.frame = CGRectMake(10, 10, 30, 30);
    self.profileImageView.image = [UIImage imageNamed: @"placeholder.png"];
    [self.profileButton addSubview: self.profileImageView];
    // Profile label
    UILabel *profileLabel = [[UILabel alloc] init];
    profileLabel.backgroundColor = [UIColor clearColor];
    profileLabel.frame = CGRectMake((10 + 30 + 10), 10,
      (self.profileButton.frame.size.width - (10 + 30 + 10 + 10)), 30);
    profileLabel.font = font;
    profileLabel.text = @"Profile";
    profileLabel.textColor = gray40;
    [self.profileButton addSubview: profileLabel];
    // About button
    self.aboutButton = [[UIButton alloc] init];
    self.aboutButton.frame = CGRectMake(0, (44 + 50),
      self.menu.frame.size.width, 50);
    CALayer *aboutButtonBorder = [CALayer layer];
    aboutButtonBorder.frame = CGRectMake(0, 0, 
      self.menu.frame.size.width, 1);
    aboutButtonBorder.backgroundColor = [UIColor gray: 200].CGColor;
    [self.aboutButton.layer addSublayer: aboutButtonBorder];
    [self.aboutButton addTarget: self action: @selector(showAbout)
      forControlEvents: UIControlEventTouchUpInside];
    [self.menu addSubview: self.aboutButton];
    // About image view
    self.aboutImageView = [[UIImageView alloc] init];
    self.aboutImageView.clipsToBounds = YES;
    self.aboutImageView.contentMode = UIViewContentModeTopLeft;
    self.aboutImageView.frame = CGRectMake(10, 10, 30, 30);
    self.aboutImageView.image = [UIImage imageNamed: @"about_icon.png"];
    [self.aboutButton addSubview: self.aboutImageView];
    // About label
    UILabel *aboutLabel = [[UILabel alloc] init];
    aboutLabel.backgroundColor = [UIColor clearColor];
    aboutLabel.frame = CGRectMake((10 + 30 + 10), 10,
      (self.aboutButton.frame.size.width - (10 + 30 + 10 + 10)), 30);
    aboutLabel.font = font;
    aboutLabel.text = @"About Bite";
    aboutLabel.textColor = gray40;
    [self.aboutButton addSubview: aboutLabel];

    // Rate us button
    self.rateUsButton = [[UIButton alloc] init];
    self.rateUsButton.frame = CGRectMake(0, (44 + 50 + 50),
      self.menu.frame.size.width, 50);
    CALayer *rateUsButtonBorder = [CALayer layer];
    rateUsButtonBorder.frame = CGRectMake(0, 0, self.menu.frame.size.width, 1);
    rateUsButtonBorder.backgroundColor = [UIColor gray: 200].CGColor;
    [self.rateUsButton.layer addSublayer: rateUsButtonBorder];
    [self.rateUsButton addTarget: self action: @selector(openURL)
      forControlEvents: UIControlEventTouchUpInside];
    [self.menu addSubview: self.rateUsButton];
    // Rate us image view
    self.rateUsImageView = [[UIImageView alloc] init];
    self.rateUsImageView.clipsToBounds = YES;
    self.rateUsImageView.contentMode = UIViewContentModeTopLeft;
    self.rateUsImageView.frame = CGRectMake(10, 10, 30, 30);
    self.rateUsImageView.image = [UIImage imageNamed: @"rate_us_icon.png"];
    [self.rateUsButton addSubview: self.rateUsImageView];
    // Rate us label
    UILabel *rateUsLabel = [[UILabel alloc] init];
    rateUsLabel.backgroundColor = [UIColor clearColor];
    rateUsLabel.frame = CGRectMake((10 + 30 + 10), 10, 
      (self.rateUsButton.frame.size.width - (10 + 30 + 10 + 10)), 30);
    rateUsLabel.font = font;
    rateUsLabel.text = @"Rate us";
    rateUsLabel.textColor = gray40;
    [self.rateUsButton addSubview: rateUsLabel];

    // Share button
    shareButton = [[UIButton alloc] init];
    shareButton.frame = CGRectMake(0, (44 + 50 + 50 + 50),
      self.menu.frame.size.width, 50);
    CALayer *shareButtonBorder = [CALayer layer];
    shareButtonBorder.frame = CGRectMake(0, 0, self.menu.frame.size.width, 1);
    shareButtonBorder.backgroundColor = [UIColor gray: 200].CGColor;
    [shareButton.layer addSublayer: shareButtonBorder];
    [shareButton addTarget: self action: @selector(share)
      forControlEvents: UIControlEventTouchUpInside];
    [self.menu addSubview: shareButton];
    // image view
    UIImageView *shareImageView = [[UIImageView alloc] init];
    shareImageView.clipsToBounds = YES;
    shareImageView.contentMode = UIViewContentModeTopLeft;
    shareImageView.frame = CGRectMake(10, 10, 30, 30);
    shareImageView.image = [UIImage imageNamed: @"share_icon.png"];
    [shareButton addSubview: shareImageView];
    // label
    UILabel *shareLabel = [[UILabel alloc] init];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.frame = CGRectMake((10 + 30 + 10), 10,
      (shareButton.frame.size.width - (10 + 30 + 10 + 10)), 30);
    shareLabel.font = font;
    shareLabel.text = @"Share";
    shareLabel.textColor = gray40;
    [shareButton addSubview: shareLabel];

    // Sign out button
    self.signOutButton = [[UIButton alloc] init];
    self.signOutButton.frame = CGRectMake(0, (44 + 50 + 50 + 50 + 50),
      self.menu.frame.size.width, 50);
    CALayer *signOutButtonBorder = [CALayer layer];
    signOutButtonBorder.frame = CGRectMake(0, 0, 
      self.menu.frame.size.width, 1);
    signOutButtonBorder.backgroundColor = [UIColor gray: 200].CGColor;
    [self.signOutButton.layer addSublayer: signOutButtonBorder];
    [self.signOutButton addTarget: self action: @selector(signOut)
      forControlEvents: UIControlEventTouchUpInside];
    [self.menu addSubview: self.signOutButton];
    // Sign out image view
    self.signOutImageView = [[UIImageView alloc] init];
    self.signOutImageView.clipsToBounds = YES;
    self.signOutImageView.contentMode = UIViewContentModeTopLeft;
    self.signOutImageView.frame = CGRectMake(10, 10, 30, 30);
    self.signOutImageView.image = [UIImage imageNamed: @"sign_out_icon.png"];
    [self.signOutButton addSubview: self.signOutImageView];
    // Sign out label
    UILabel *signOutLabel = [[UILabel alloc] init];
    signOutLabel.backgroundColor = [UIColor clearColor];
    signOutLabel.frame = CGRectMake((10 + 30 + 10), 10,
      (self.signOutButton.frame.size.width - (10 + 30 + 10 + 10)), 30);
    signOutLabel.font = font;
    signOutLabel.text = @"Sign out";
    signOutLabel.textColor = gray40;
    [self.signOutButton addSubview: signOutLabel];
  }
  return self;
}

#pragma mark - Override UIResponder

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
  UITouch *touch = [touches anyObject];
  CGPoint point  = [touch locationInView: self];
  self.horizontalOffset = point.x;
}

- (void) touchesCancelled: (NSSet *) touches withEvent: (UIEvent *) event
{
  [self hideOrShowMenu];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
  [self hideOrShowMenu];
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
  UITouch *touch = [touches anyObject];
  CGPoint point  = [touch locationInView: self];
  float horizontalDifference = point.x - self.horizontalOffset;
  float newOriginX = self.menu.frame.origin.x + horizontalDifference;
  if (newOriginX <= 0) {
    self.menu.frame = CGRectMake(newOriginX, self.menu.frame.origin.y, 
      self.menu.frame.size.width, self.menu.frame.size.height);
    self.horizontalOffset = point.x;
  }
}

#pragma mark - Protocol UIAlertView

- (void) alertView: (UIAlertView *) alert 
clickedButtonAtIndex: (NSInteger) buttonIndex
{
  if (buttonIndex == 0) {
    [self hideMenu];
    [[NSNotificationCenter defaultCenter] postNotificationName: 
      CurrentUserSignOut object: nil];
  }
  else if (buttonIndex == 1) {
    [self.alertView dismissWithClickedButtonIndex: 1 animated: YES];
  }
}

#pragma mark - Methods

- (void) hideMenu
{
  void (^animations1) (void) = ^(void) {
    self.menu.frame = CGRectMake((self.menu.frame.size.width * -1),
      self.menu.frame.origin.y, self.menu.frame.size.width,
        self.menu.frame.size.height);
  };

  void (^completion1) (BOOL finished) = ^(BOOL finished) {
    void (^animations2) (void) = ^(void) {
      self.backgroundButton.backgroundColor = [UIColor clearColor];
    };

    void (^completion2) (BOOL finished) = ^(BOOL finished) {
      self.frame = CGRectMake((self.frame.size.width * -1), 
        self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    };

    [UIView animateWithDuration: 0.1 delay: 0
      options: UIViewAnimationOptionCurveLinear animations: animations2
        completion: completion2];
  };

  [UIView animateWithDuration: 0.1 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations1
      completion: completion1];
}

- (void) hideOrShowMenu
{
  if (self.menu.frame.origin.x >= ((self.menu.frame.size.width / 4.0) * -1)) {
    [self showMenu];
  }
  else {
    [self hideMenu];
  }
}

- (void) openURL
{
  [[UIApplication sharedApplication] openURL: [NSURL URLWithString:
    @"http://www.itunes.com/app/biteapp"]];
}

- (void) share
{
  NSString *string = @"Check out Bite, an app for eating with friends:"
    @" http://www.itunes.com/app/biteapp";
  NSArray *dataToShare = @[string];
  UIActivityViewController *activityViewController = 
    [[UIActivityViewController alloc] initWithActivityItems: dataToShare
      applicationActivities: nil];
  AppDelegate *appDelegate = (AppDelegate *)
    [UIApplication sharedApplication].delegate;
  [appDelegate.tabBarController presentViewController: activityViewController
    animated: YES completion: nil];
}

- (void) showAbout
{
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  [appDelegate.tabBarController presentViewController: (UIViewController *)
    appDelegate.aboutNavigationController animated: YES completion: ^(void) {
      [self hideMenu];
    }
  ];
  // UINavigationController *navController = (UINavigationController *) 
  //   appDelegate.tabBarController.selectedViewController;
  // [navController pushViewController: appDelegate.aboutViewController 
  //   animated: YES];
  // [self hideMenu];
}

- (void) showMenu
{
  self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width,
    self.frame.size.height);

  void (^animations1) (void) = ^(void) {
    self.backgroundButton.backgroundColor = [UIColor colorWithRed: (0/255.0) 
      green: (0/255.0) blue: (0/255.0) alpha: 0.5];
  };

  void (^completion1) (BOOL finished) = ^(BOOL finished) {
    void (^animations2) (void) = ^(void) {
      self.menu.frame = CGRectMake(0, self.menu.frame.origin.y, 
        self.menu.frame.size.width, self.menu.frame.size.height);
    };

    [UIView animateWithDuration: 0.1 delay: 0
      options: UIViewAnimationOptionCurveLinear animations: animations2
        completion: nil];
  };
  
  [UIView animateWithDuration: 0.05 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations1
      completion: completion1];
}

- (void) signOut
{
  [self.alertView show];
}

- (void) showProfile
{
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  UINavigationController *navController = (UINavigationController *) 
    appDelegate.tabBarController.selectedViewController;
  UserDetailViewController *userDetailViewController =
    [[UserDetailViewController alloc] initWithUser: [User currentUser]];
  [navController pushViewController: userDetailViewController animated: YES];
  [self hideMenu];
}

- (void) velocityCheck: (UIPanGestureRecognizer *) gesture
{
  CGPoint point = [gesture velocityInView: self];
  if (point.x < -2000) {
    [self hideMenu];
  }
}

@end
