//
//  TutorialView.m
//  Bite
//
//  Created by Tommy DANGerous on 6/6/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TutorialSlideView.h"
#import "TutorialView.h"
#import "UserReadTutorialConnection.h"

@implementation TutorialView

@synthesize beginButton;
@synthesize pageControl;
@synthesize slideView;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // Main
    self.alpha = 0;
    self.backgroundColor = [UIColor colorWithRed: 0 green: 0 blue: 0 
      alpha: 0.85];
    CGRect screen = [[UIScreen mainScreen] bounds];
    self.frame = screen;

    // Slide view
    self.slideView = [[TutorialSlideView alloc] init];
    self.slideView.tutorialView = self;
    [self addSubview: self.slideView];
    // Page Control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, (20 + 290 + 20 + 60),
      screen.size.width, 40);
    self.pageControl.numberOfPages = 3;
    self.pageControl.userInteractionEnabled = NO;
    [self addSubview: self.pageControl];
    // Begin button
    self.beginButton = [[UIButton alloc] init];
    self.beginButton.backgroundColor = [UIColor clearColor];
    self.beginButton.frame = CGRectMake((screen.size.width - 90),
      (20 + 290 + 20 + 60 + 40), 80, 40);
    self.beginButton.hidden = YES;
    self.beginButton.layer.cornerRadius = 2;
    self.beginButton.titleLabel.font = [UIFont fontWithName: 
      @"HelveticaNeue-Bold" size: 18];
    [self.beginButton addTarget: self action: @selector(hideTutorial)
      forControlEvents: UIControlEventTouchUpInside];
    [self.beginButton setTitle: @"Begin" forState: UIControlStateNormal];
    [self.beginButton setTitleColor: [UIColor colorWithRed: (255/255.0) 
      green: (26/255.0) blue: 0 alpha: 1] 
        forState: UIControlStateNormal];
    [self addSubview: self.beginButton];
  }
  return self;
}

#pragma mark - Methods

- (void) hideTutorial
{
  void (^animations) (void) = ^(void) {
    self.alpha = 0;
  };
  void (^completion) (BOOL finished) = ^(BOOL finished) {
    self.hidden = YES;
  };
  [UIView animateWithDuration: 0.1 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: completion];
  UserReadTutorialConnection *connection = 
    [[UserReadTutorialConnection alloc] init];
  [connection start];
}

@end
