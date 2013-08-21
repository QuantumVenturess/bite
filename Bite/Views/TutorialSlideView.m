//
//  TutorialSlideView.m
//  Bite
//
//  Created by Tommy DANGerous on 6/6/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "TutorialSlideView.h"
#import "TutorialView.h"

@implementation TutorialSlideView

@synthesize tutorialView;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue" size: 15];
    UIColor *gray245 = [UIColor colorWithRed: (245/255.0) green: (245/255.0)
      blue: (245/255.0) alpha: 1];
    CGRect screen = [[UIScreen mainScreen] bounds];

    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, (screen.size.width * 3),
      (screen.size.height - 100));

    // Start
    UIView *start = [[UIView alloc] init];
    start.frame = CGRectMake(0, 0, screen.size.width,
      (screen.size.height - 120));
    [self addSubview: start];
    // image
    UIImageView *startImageView = [[UIImageView alloc] init];
    startImageView.clipsToBounds = YES;
    startImageView.contentMode = UIViewContentModeCenter;
    startImageView.frame = CGRectMake(0, 20, 
      screen.size.width, 290);
    startImageView.image = [UIImage imageNamed: @"tutorial_start.png"];
    [start addSubview: startImageView];
    // text
    UILabel *startLabel = [[UILabel alloc] init];
    startLabel.backgroundColor = [UIColor clearColor];
    startLabel.font = font;
    startLabel.frame = CGRectMake(10, (20 + 290 + 20), 
      (screen.size.width - 20), 0);
    startLabel.lineBreakMode = NSLineBreakByWordWrapping;
    startLabel.numberOfLines = 0;
    startLabel.text = @"To start a table, click on \"Start\","
      @" then search for a place and select a date to begin.";
    startLabel.textColor = gray245;
    [startLabel sizeToFit];
    [start addSubview: startLabel];
    // Explore
    UIView *explore = [[UIView alloc] init];
    explore.frame = CGRectMake(start.frame.size.width, 0, screen.size.width,
      (screen.size.height - 100));
    [self addSubview: explore];
    // image
    UIImageView *exploreImageView = [[UIImageView alloc] init];
    exploreImageView.clipsToBounds = YES;
    exploreImageView.contentMode = UIViewContentModeCenter;
    exploreImageView.frame = CGRectMake(0, 20, 
      screen.size.width, 290);
    exploreImageView.image = [UIImage imageNamed: @"tutorial_explore.png"];
    [explore addSubview: exploreImageView];
    // text
    UILabel *exploreLabel = [[UILabel alloc] init];
    exploreLabel.backgroundColor = [UIColor clearColor];
    exploreLabel.font = font;
    exploreLabel.frame = CGRectMake(10, (20 + 290 + 20), 
      (screen.size.width - 20), 0);
    exploreLabel.lineBreakMode = NSLineBreakByWordWrapping;
    exploreLabel.numberOfLines = 0;
    exploreLabel.text = @"Explore tables started by other people and click"
      @" \"Join Table\" to sit down with them.";
    exploreLabel.textColor = gray245;
    [exploreLabel sizeToFit];
    [explore addSubview: exploreLabel];
    // Message
    UIView *message = [[UIView alloc] init];
    message.frame = CGRectMake(
      (start.frame.size.width + explore.frame.size.width), 0, 
        screen.size.width, (screen.size.height - 100));
    [self addSubview: message];
    // image
    UIImageView *messageImageView = [[UIImageView alloc] init];
    messageImageView.clipsToBounds = YES;
    messageImageView.contentMode = UIViewContentModeCenter;
    messageImageView.frame = CGRectMake(0, 20, 
      screen.size.width, 290);
    messageImageView.image = [UIImage imageNamed: @"tutorial_message.png"];
    [message addSubview: messageImageView];
    // text
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.font = font;
    messageLabel.frame = CGRectMake(10, (20 + 290 + 20), 
      (screen.size.width - 20), 0);
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines = 0;
    messageLabel.text = @"Send messages to people sitting at your table"
      @" and share your plans with them.";
    messageLabel.textColor = gray245;
    [messageLabel sizeToFit];
    [message addSubview: messageLabel];
  }
  return self;
}

#pragma mark - Override UIResponder

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
  UITouch *touch = [touches anyObject];
  CGPoint point  = [touch locationInView: self.superview];
  horizontalTouchPosition = point.x;
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
  [self changePage];
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event
{
  float horizontalDifference, newOriginX, fullWidth, pageWidth;
  fullWidth = self.frame.size.width;
  pageWidth = self.frame.size.width / 3.0;
  UITouch *touch = [touches anyObject];
  CGPoint point  = [touch locationInView: self.superview];
  horizontalDifference = point.x - horizontalTouchPosition;
  newOriginX = self.frame.origin.x + horizontalDifference;
  if (newOriginX <= pageWidth && newOriginX >= ((fullWidth * -1) - pageWidth)) {
    self.frame = CGRectMake(newOriginX, self.frame.origin.y,
      self.frame.size.width, self.frame.size.height);
    horizontalTouchPosition = point.x;
  }
  [self checkCurrentPage];
}

#pragma mark - Methods

- (void) changePage
{
  CGRect frame;
  frame.origin.x = (self.frame.size.width / -3.0) * currentPage;
  frame.origin.y = 0;
  frame.size = self.frame.size;
  void (^animations) (void) = ^(void) {
    self.frame = frame;
  };
  [UIView animateWithDuration: 0.1 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

- (void) checkCurrentPage
{
  float difference, origin, width;
  origin = self.frame.origin.x;
  width  = self.frame.size.width / 3.0;
  difference = ((origin * -1) - (width / 2)) / width;
  if (difference < 0) {
    difference = 0;
  }
  int page = ceil(difference);
  if (page > 2) {
    page = 2;
  }
  else if (page < 0) {
    page = 0;
  }
  if (currentPage != page) {
    self.tutorialView.pageControl.currentPage = page;
  }
  if (page == 2) {
    self.tutorialView.beginButton.hidden = NO;
  }
  else {
    self.tutorialView.beginButton.hidden = YES;
  }
  currentPage = page;
}

@end
