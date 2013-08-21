//
//  JoinViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/15/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "JoinViewController.h"
#import "UIImage+Resize.h"
#import "User.h"

@implementation JoinViewController

NSString *fontFamily = @"HelveticaNeue";

@synthesize spinner;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.trackedViewName = @"Join";
  }
  return self;
}

#pragma mark - Override UIViewController
- (void) loadView
{
  CGRect frame;
  float height, margin, newWidth, newHeight, ratio, width;

  // Create main screen
  frame     = [[UIScreen mainScreen] bounds];
  UIView *mainView = [[UIView alloc] initWithFrame: frame];
  self.view = mainView;

  margin = mainView.frame.size.height * 0.04;

  // Create image background
  UIImage *image   = [UIImage imageNamed: @"bg.jpg"];
  CGSize mainSize  = mainView.frame.size;
  CGSize imageSize = image.size;
  // Calculate ratio
  if (mainSize.width >= mainSize.height) {
    ratio = mainSize.width / imageSize.width;
    newWidth = mainSize.width;
    newHeight = imageSize.height * ratio;
  }
  else {
    ratio = mainSize.height / imageSize.height;
    newWidth = imageSize.width * ratio;
    newHeight = mainSize.height;
  }
  // Resize image
  CGSize newSize   = CGSizeMake(newWidth, newHeight);
  CGPoint newPoint = CGPointMake(-100, 0);
  UIImage *newImage = 
    [UIImage image: image resized: newSize position: newPoint];
  // Add image as background
  UIImageView *backgroundImage = [[UIImageView alloc] initWithImage: newImage];
  [self.view addSubview: backgroundImage];
  [self.view sendSubviewToBack: backgroundImage];

  // Create Bite image
  width  = mainView.frame.size.width / 3.0;
  height = width;
  UIImage *biteImage = 
    [UIImage image: [UIImage imageNamed: @"bite_image.png"] 
      resized: CGSizeMake(width, height) position: CGPointMake(0, 0)];
  UIImageView *biteImageView = 
    [[UIImageView alloc] initWithImage: biteImage];
  biteImageView.frame = 
    CGRectMake((mainView.frame.size.width - width) / 2.0, 20, width, height);
  [self.view addSubview: biteImageView];

  // Create Bite logo
  UIImage *biteLogo = [UIImage imageNamed: @"bite_logo.png"];
  ratio = biteLogo.size.height / biteLogo.size.width;
  height = width * ratio;
  UIImage *biteLogoResized = 
    [UIImage image: biteLogo resized: CGSizeMake(width, height) 
      position: CGPointMake(0, 0)];
  UIImageView *biteLogoView = 
    [[UIImageView alloc] initWithImage: biteLogoResized];
  biteLogoView.frame = 
    CGRectMake((mainView.frame.size.width - width) / 2.0, 
      biteImageView.frame.origin.y + biteImageView.frame.size.height + margin, 
      width, height);
  [self.view addSubview: biteLogoView];

  // Create intro
  frame = CGRectMake(0, 
    biteLogoView.frame.origin.y + biteLogoView.frame.size.height + margin, 
    mainView.frame.size.width, 143);
  UIView *intro = [[UIView alloc] initWithFrame: frame];
  intro.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.7];
  [self.view addSubview: intro];

  // Create never eat alone
  UILabel *label1 = [[UILabel alloc] initWithFrame: CGRectMake(0, 15,
    mainView.frame.size.width - 10, 20)];
  label1.backgroundColor = [UIColor clearColor];
  label1.font = [UIFont fontWithName: fontFamily size: 20];
  label1.text = @"Never eat alone";
  label1.textAlignment = NSTextAlignmentRight;
  label1.textColor = [UIColor whiteColor];
  [intro addSubview: label1];
  // Create how it works
  width  = mainView.frame.size.width - 20;
  height = 15;
  UILabel *howItWorks = [[UILabel alloc] initWithFrame: CGRectMake(10, 
    (label1.frame.origin.y + label1.frame.size.height + 10), width, height)];
  howItWorks.backgroundColor = [UIColor clearColor];
  howItWorks.font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 14];
  howItWorks.text = @"How it works";
  howItWorks.textColor = [UIColor whiteColor];
  [intro addSubview: howItWorks];
  // Create 3 step instructions
  // Step 1
  UIFont *font = [UIFont fontWithName: fontFamily size: 14];
  UILabel *step1 = 
    [[UILabel alloc] initWithFrame: CGRectMake(10, 
      (howItWorks.frame.origin.y + height + 8), width, height)];
  step1.backgroundColor = [UIColor clearColor];
  step1.font = font;
  step1.text = @"1. Start your own table so friends can join";
  step1.textColor = [UIColor whiteColor];
  [intro addSubview: step1];
  // Step 2
  UILabel *step2 = [[UILabel alloc] initWithFrame: CGRectMake(10, 
    (step1.frame.origin.y + height + 8), width, height)];
  step2.backgroundColor = [UIColor clearColor];
  step2.font = font;
  step2.text = @"2. Join your friend's table";
  step2.textColor = [UIColor whiteColor];
  [intro addSubview: step2];
  // Step 3
  UILabel *step3 = [[UILabel alloc] initWithFrame: CGRectMake(10, 
    (step2.frame.origin.y + height + 8), width, height)];
  step3.backgroundColor = [UIColor clearColor];
  step3.font = font;
  step3.text = @"3. Send messages to friends at your table";
  step3.textColor = [UIColor whiteColor];
  [intro addSubview: step3];

  // Create Facebook join button
  frame = CGRectMake(10, 
    (intro.frame.origin.y + intro.frame.size.height + margin), 
    mainView.frame.size.width - 20, 44);
  UIButton *joinUsingFacebook = [[UIButton alloc] initWithFrame: frame];
  [joinUsingFacebook addTarget: self action: @selector(signIn:) 
    forControlEvents: UIControlEventTouchUpInside];
  joinUsingFacebook.backgroundColor = 
    [UIColor colorWithRed: 0.278 green: 0.431 blue: 0.639 alpha: 1];
  joinUsingFacebook.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
  joinUsingFacebook.titleLabel.font = [UIFont fontWithName: fontFamily 
    size: 16];
  joinUsingFacebook.titleLabel.textColor = [UIColor whiteColor];
  [joinUsingFacebook setTitle: @"Join using Facebook" 
    forState: UIControlStateNormal];
  // Add Facebook logo image to button
  UIImage *facebookLogo = 
    [UIImage image: [UIImage imageNamed: @"facebook.png"] 
      resized: CGSizeMake(34, 34) position: CGPointMake(5, 5)];
  UIImageView *facebookLogoView = 
    [[UIImageView alloc] initWithImage: facebookLogo];
  [joinUsingFacebook addSubview: facebookLogoView];
  [self.view addSubview: joinUsingFacebook];

  // Add spinner
  spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: 
    UIActivityIndicatorViewStyleWhiteLarge];
  spinner.frame = 
    CGRectMake(mainView.frame.size.width / 2.0, 
      mainView.frame.size.height / 2.0, 0, 0);
  spinner.hidesWhenStopped = YES;
  [self.view addSubview: spinner];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  [self.spinner stopAnimating];
}

#pragma mark - Methods

- (void) signIn: (id) sender
{
  [self.spinner startAnimating];

  AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
  [appDelegate openSession];
}

- (void) signInFailed
{
  [self.spinner stopAnimating];
}

@end
