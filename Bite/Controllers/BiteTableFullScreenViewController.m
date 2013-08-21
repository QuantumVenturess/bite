//
//  BiteTableFullScreenViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 6/10/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteTableFullScreenViewController.h"
#import "UIColor+Extensions.h"

enum ScrollViewDirection: NSInteger {
  ScrollViewDirectionDown,
  ScrollViewDirectionUp
};

@implementation BiteTableFullScreenViewController

@synthesize refreshing;
@synthesize refreshLabel;
@synthesize refreshView;

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  if (self.refreshing == YES) {
    [self refreshTable];
  }
  scrollView.bounces = YES;
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView
willDecelerate: (BOOL) decelerate
{
  [super scrollViewDidEndDragging: scrollView willDecelerate: decelerate];
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect navBarFrame = self.navigationController.navigationBar.frame;
  CGRect tabBarFrame = appDelegate.tabBarController.tabBar.frame;
  if (scrollViewDirection == ScrollViewDirectionDown) {
    // Hide
    navBarFrame.origin.y = -24;
    tabBarFrame.origin.y = screen.size.height;
  }
  else if (scrollViewDirection == ScrollViewDirectionUp) {
    // Show
    navBarFrame.origin.y = 20;
    tabBarFrame.origin.y = screen.size.height - 49;
  }
  // Animate hide or show of nav bar and tab bar
  // if not refreshing and content size is more than the table height and
  // scrolling down and content offset is 20 or more or scrolling up
  if (self.refreshing == NO && 
   self.table.contentSize.height > (screen.size.height + 20 + 40 + 49) && 
      ((self.table.contentOffset.y > 20 && 
        scrollViewDirection == ScrollViewDirectionDown) || 
          scrollViewDirection == ScrollViewDirectionUp)) {

    void (^animations) (void) = ^(void) {
      self.navigationController.navigationBar.frame = navBarFrame;
      appDelegate.tabBarController.tabBar.frame = tabBarFrame;
    };
    [UIView animateWithDuration: 0.1 delay: 0
      options: UIViewAnimationOptionCurveLinear animations: animations
        completion: nil];
  }
  // Refresh if user pulls down far enough and releases
  float y = scrollView.contentOffset.y;
  if (y < -88) {
    [refreshSpinner startAnimating];
    self.refreshing = YES;
  }
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect navBarFrame = self.navigationController.navigationBar.frame;
  CGRect tabBarFrame = appDelegate.tabBarController.tabBar.frame;
  float y = scrollView.contentOffset.y;
  float difference = lastContentOffset - y;
  float maxOffsetScroll = y + (screen.size.height - 20) + 1;
  // Spinner
  float refreshingOffset = self.refreshing ? 44 : 0;
  self.spinner.frame = CGRectMake((screen.size.width / 2.0), 
    ((scrollView.contentOffset.y + 44) + (screen.size.height - 160) - 
      refreshingOffset), 0, 0);

  // Nav bar and tab bar
  if (!disappearing && 
    scrollView.contentSize.height > scrollView.frame.size.height) {

    navBarFrame.origin.y += difference;
    tabBarFrame.origin.y -= difference;
    // Down (difference > 0)
    if (lastContentOffset < y) {
      // Navigation bar
      if (navBarFrame.origin.y < -24) {
        navBarFrame.origin.y = -24;
      }
      // Tab bar
      if (tabBarFrame.origin.y > screen.size.height) {
        tabBarFrame.origin.y = screen.size.height;
      }
      scrollViewDirection = ScrollViewDirectionDown;
    }
    // Up (difference < 0)
    if (lastContentOffset > y) {
      // Navigation bar
      if (navBarFrame.origin.y > 20) {
        navBarFrame.origin.y = 20;
      }
      // Tab bar
      if (tabBarFrame.origin.y < screen.size.height - 49) {
        tabBarFrame.origin.y = screen.size.height - 49;
      }
      scrollViewDirection = ScrollViewDirectionUp;
    }
    if (self.refreshing == NO && y > 20 && 
        maxOffsetScroll < self.table.contentSize.height) {

      self.navigationController.navigationBar.frame = navBarFrame;
      appDelegate.tabBarController.tabBar.frame = tabBarFrame;
    }
    // If scrolling down past 20 and refreshing
    if (lastContentOffset < y && y > 20 && self.refreshing) {
      // Hide refreshing view
      CGRect tableFrame = self.table.frame;
      tableFrame.origin.y = 0;
      self.table.bounces = YES;
      self.table.frame = tableFrame;
      self.refreshing = NO;
    }
    lastContentOffset = y;
  }

  // Refresh pull down
  CGRect refreshFrame = self.refreshView.frame;
  if (y < -44) {
    float newY = (y + 44) * 4;
    float percentage = ((screen.size.height + newY) / screen.size.height);
    float newWidth = percentage * 22;
    if (newWidth < 1) {
      newWidth = 1;
    }
    refreshFrame.size.width = newWidth;
    refreshFrame.origin.x = screen.size.width - (newWidth + 10);
    self.refreshView.frame = refreshFrame;
  }
  if (y > -88) {
    if (self.refreshing == YES) {
      scrollView.bounces = NO;
      void (^animations) (void) = ^(void) {
        CGRect tableFrame = self.table.frame;
        tableFrame.origin.y = 44;
        self.table.frame = tableFrame;
      };
      void (^completion) (BOOL finished) = ^(BOOL finished) {
        scrollView.bounces = YES;
      };
      [UIView animateWithDuration: 0 delay: 0
        options: UIViewAnimationOptionCurveLinear animations: animations
          completion: completion];
    }
    else {
      self.refreshLabel.text = @"Pull down to refresh";
    }
  }
  else if (y < -88) {
    if (self.refreshing == YES) {
      self.refreshLabel.text = @"Refreshing...";
    }
    else {
      self.refreshLabel.text = @"Release to refresh";
    }
  }
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.table.separatorColor = [UIColor clearColor];
  self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.table.tableHeaderView = [[UIView alloc] initWithFrame:
    CGRectMake(0, 0, self.table.frame.size.width, 10)];

  // Refresh
  UIView *refresh = [[UIView alloc] init];
  refresh.frame = CGRectMake(0, (screen.size.height * -1), screen.size.width,
    screen.size.height);
  [self.table.tableHeaderView addSubview: refresh];
  // refresh spinner
  refreshSpinner = [[UIActivityIndicatorView alloc] init];
  refreshSpinner.color = [UIColor gray: 120];
  refreshSpinner.frame = CGRectMake(10, (screen.size.height - 34), 34, 34);
  refreshSpinner.hidesWhenStopped = YES;
  [refresh addSubview: refreshSpinner];
  // refresh view
  self.refreshView = [[UIView alloc] init];
  self.refreshView.backgroundColor = [UIColor darkRed];
  self.refreshView.frame = CGRectMake((screen.size.width - (22 + 10)), 0, 22, 
    screen.size.height);
  [refresh addSubview: self.refreshView];
  // refresh label
  self.refreshLabel = [[UILabel alloc] init];
  self.refreshLabel.backgroundColor = [UIColor clearColor];
  self.refreshLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 13];
  self.refreshLabel.frame = CGRectMake(10, (screen.size.height - 34),
    (screen.size.width - (10 + 10)), 34);
  self.refreshLabel.text = @"Pull down to refresh";
  self.refreshLabel.textAlignment = NSTextAlignmentCenter;
  self.refreshLabel.textColor = [UIColor gray: 120];
  [refresh addSubview: self.refreshLabel];

  [self.refreshControl removeFromSuperview];
}

- (void) viewDidAppear: (BOOL) animated
{
  [super viewDidAppear: animated];
  // Allow table view to go pass the tab bar
  // need to put it here because the view needs to be added to heirarchy
  UIView *tabBarView = (UIView *) 
    [self.tabBarController.view.subviews objectAtIndex: 0];
  tabBarView.frame = [[UIScreen mainScreen] bounds];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  // Enable hiding and full screen view
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  self.navigationController.navigationBar.translucent = YES;
  disappearing = NO;
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  CGRect screen = [[UIScreen mainScreen] bounds];
  // Reset navigation bar
  self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
  self.navigationController.navigationBar.translucent = NO;
  CGRect navBarFrame = self.navigationController.navigationBar.frame;
  navBarFrame.origin.y = 20;
  // Reset tab bar
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  UIView *tabBarView = (UIView *) 
    [self.tabBarController.view.subviews objectAtIndex: 0];
  tabBarView.frame = CGRectMake(screen.origin.x, screen.origin.y,
    screen.size.width, (screen.size.height - 49));
  CGRect tabBarFrame = appDelegate.tabBarController.tabBar.frame;
  tabBarFrame.origin.y = screen.size.height - 49;

  self.navigationController.navigationBar.frame = navBarFrame;
  appDelegate.tabBarController.tabBar.frame     = tabBarFrame;

  // Hide refreshing view
  CGRect tableFrame   = self.table.frame;
  tableFrame.origin.y = 0;
  self.table.bounces  = YES;
  self.table.frame    = tableFrame;

  disappearing    = YES;
  self.refreshing = NO;
}

#pragma mark - Methods

- (void) cancelRefresh
{
  void (^animations) (void) = ^(void) {
    CGRect tableFrame = self.table.frame;
    tableFrame.origin.y = 0;
    self.table.frame = tableFrame;
  };
  void (^completion) (BOOL finished) = ^(BOOL finished) {
    self.refreshing = NO;
    [refreshSpinner stopAnimating];
  };
  [UIView animateWithDuration: 0.1 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: completion];
}

- (void) checkToAllowTableViewToScrollPassTabBar
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  UIView *tabBarView = (UIView *) 
    [self.tabBarController.view.subviews objectAtIndex: 0];
  if (self.table.contentSize.height > (screen.size.height + 20 + 40 + 49)) {
    // Allow table view to scroll below tab bar
    tabBarView.frame = screen;
  }
  else {
    // Do not allow table view to scroll below tab bar
    tabBarView.frame = CGRectMake(screen.origin.x, screen.origin.y,
      screen.size.width, (screen.size.height - 49));
  }
}

- (void) refreshTable
{
  [self loadTablesWithFinalCompletion: 
    ^(NSError *error) {
      [self cleanTablesWithFinalCompletion:
        ^(NSError *error) {
          [self loadSeatsWithFinalCompletion:
            ^(NSError *error) {
              [self cancelRefresh];
            }
          ];
        }
      ];
    }
  ];
}

- (void) resetNavAndTabBar
{
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect navBarFrame = self.navigationController.navigationBar.frame;
  CGRect tabBarFrame = appDelegate.tabBarController.tabBar.frame;
  // Show
  navBarFrame.origin.y = 20;
  tabBarFrame.origin.y = screen.size.height - 49;
  // Animate
  void (^animations) (void) = ^(void) {
    self.navigationController.navigationBar.frame = navBarFrame;
    appDelegate.tabBarController.tabBar.frame = tabBarFrame;
  };
  [UIView animateWithDuration: 0.1 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
  // Do not let table view scroll pass tab bar
  UIView *tabBarView = (UIView *) 
    [self.tabBarController.view.subviews objectAtIndex: 0];
  tabBarView.frame = CGRectMake(screen.origin.x, screen.origin.y,
    screen.size.width, (screen.size.height - 49));
}

@end
