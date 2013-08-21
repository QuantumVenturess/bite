//
//  AboutViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 6/6/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AboutViewController.h"
#import "UIImage+Resize.h"

@implementation AboutViewController

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.trackedViewName = @"About";
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  // Navigation item
  // close button
  CGRect buttonFrame = CGRectMake(0, 0, 50, 28);
  UILabel *closeLabel = [[UILabel alloc] init];
  closeLabel.backgroundColor = [UIColor clearColor];
  closeLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  closeLabel.frame = CGRectMake(5, 0, 45, 28);
  closeLabel.text = @"Close";
  closeLabel.textAlignment = NSTextAlignmentLeft;
  closeLabel.textColor = [UIColor whiteColor];
  closeLabel.layer.cornerRadius = 2;
  closeLabel.layer.masksToBounds = YES;
  UIButton *closeButton = [[UIButton alloc] init];
  closeButton.frame = buttonFrame;
  [closeButton addTarget: self action: @selector(close)
    forControlEvents: UIControlEventTouchUpInside];
  [closeButton addSubview: closeLabel];
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: closeButton];
  // back
  // UIImage *backButtonImage = [UIImage imageNamed: @"back.png"];
  // UIButton *backButton = [UIButton buttonWithType: UIButtonTypeCustom];
  // backButton.frame = CGRectMake(0, 0, backButtonImage.size.width + 16,
  //   backButtonImage.size.height);
  // [backButton addTarget: self action: @selector(back) 
  //   forControlEvents: UIControlEventTouchUpInside];
  // [backButton setImage: backButtonImage forState: UIControlStateNormal];
  // self.navigationItem.leftBarButtonItem = 
  //   [[UIBarButtonItem alloc] initWithCustomView: backButton];
  // title view
  UIImageView *biteLogoImageView = [[UIImageView alloc] init];
  biteLogoImageView.frame = CGRectMake(0, 0, 60, 24);
  biteLogoImageView.image = [UIImage image: 
    [UIImage imageNamed: @"bite_logo.png"] resized: CGSizeMake(60, 24)
      position: CGPointMake(0, 0)];
  self.navigationItem.titleView = biteLogoImageView;
  // Screen
  CGRect screen = [[UIScreen mainScreen] bounds];
  UIColor *gray245 = [UIColor colorWithRed: (245/255.0) green: (245/255.0)
    blue: (245/255.0) alpha: 1];
  UIFont *font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  // Main view
  self.view = [[UIView alloc] init];
  self.view.frame = CGRectMake(0, 0, screen.size.width, screen.size.height);
  // Background image
  float newWidth, newHeight, ratio;
  UIImage *image = [UIImage imageNamed: @"bg.jpg"];
  CGSize mainSize = CGSizeMake(screen.size.width, screen.size.height);
  CGSize imageSize = image.size;
  if (mainSize.width >= mainSize.height) {
    ratio     = mainSize.width / imageSize.width;
    newWidth  = mainSize.width;
    newHeight = imageSize.height * ratio;
  }
  else {
    ratio     = mainSize.height / imageSize.height;
    newWidth  = imageSize.width * ratio;
    newHeight = mainSize.height;
  }
  CGSize newSize    = CGSizeMake(newWidth, newHeight);
  CGPoint newPoint  = CGPointMake(-100, 0);
  UIImage *newImage = [UIImage image: image resized: newSize 
    position: newPoint];
  UIImageView *backgroundImage = [[UIImageView alloc] initWithImage: newImage];
  [self.view addSubview: backgroundImage];
  [self.view sendSubviewToBack: backgroundImage];
  // Never eat alone
  UILabel *neverEatAloneLabel = [[UILabel alloc] init];
  neverEatAloneLabel.backgroundColor = [UIColor clearColor];
  neverEatAloneLabel.font = [UIFont fontWithName: @"HelveticaNeue-Bold" 
    size: 24];
  neverEatAloneLabel.frame = CGRectMake(0, 0, (screen.size.width - 10), 
    (screen.size.height * 0.15));
  neverEatAloneLabel.text = @"Never eat alone";
  neverEatAloneLabel.textAlignment = NSTextAlignmentRight;
  neverEatAloneLabel.textColor = gray245;
  [self.view addSubview: neverEatAloneLabel];
  // Intro
  UIView *introView = [[UIView alloc] init];
  introView.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 
    alpha: 0.7];
  [self.view addSubview: introView];
  // content
  // Eating with people made easy
  float labelWidth = screen.size.width - 20;
  UILabel *label1 = [[UILabel alloc] init];
  label1.backgroundColor = [UIColor clearColor];
  label1.font = font;
  label1.frame = CGRectMake(10, 20, labelWidth, 0);
  label1.lineBreakMode = NSLineBreakByWordWrapping;
  label1.numberOfLines = 0;
  label1.text = @"Eating with people made easy.";
  label1.textColor = gray245;
  [label1 sizeToFit];
  [introView addSubview: label1];
  // What is Bite
  UILabel *label2 = [[UILabel alloc] init];
  label2.backgroundColor = [UIColor clearColor];
  label2.font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 14];
  label2.frame = CGRectMake(10, (20 + label1.frame.size.height + 10),
    labelWidth, 0);
  label2.lineBreakMode = NSLineBreakByWordWrapping;
  label2.numberOfLines = 0;
  label2.text = @"What is Bite";
  label2.textColor = gray245;
  [label2 sizeToFit];
  [introView addSubview: label2];
  // Bite is an app...
  UILabel *label3 = [[UILabel alloc] init];
  label3.backgroundColor = [UIColor clearColor];
  label3.font = font;
  label3.frame = CGRectMake(10, 
    (20 + label1.frame.size.height + 10 + label2.frame.size.height + 10),
      labelWidth, 0);
  label3.lineBreakMode = NSLineBreakByWordWrapping;
  label3.numberOfLines = 0;
  label3.text = @"Bite is an app that creates an environment for you to eat" 
    @" with people you normally don't and try new places with friends.";
  label3.textColor = gray245;
  [label3 sizeToFit];
  [introView addSubview: label3];
  // If you feel like eating...
  UILabel *label4 = [[UILabel alloc] init];
  label4.backgroundColor = [UIColor clearColor];
  label4.font = font;
  label4.frame = CGRectMake(10, (20 + label1.frame.size.height + 10 + 
    label2.frame.size.height + 10 + label3.frame.size.height + 10), 
      labelWidth, 0);
  label4.lineBreakMode = NSLineBreakByWordWrapping;
  label4.numberOfLines = 0;
  label4.text = @"If you feel like eating somewhere and don't know who is down,"
    @" start a table and other people will join. Don't know what to eat or who" 
      @" is eating where? No worries, you can join the tables of others.";
  label4.textColor = gray245;
  [label4 sizeToFit];
  [introView addSubview: label4];

  introView.frame = CGRectMake(0, (screen.size.height * 0.15), 
    screen.size.width, (20 + label1.frame.size.height + 10 + 
      label2.frame.size.height + 10 + label3.frame.size.height + 10 + 
        label4.frame.size.height + 20));
}

#pragma mark - Methods

- (void) close
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

@end
