//
//  BiteTableFullScreenViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 6/10/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteTableViewController.h"

typedef enum ScrollViewDirection: NSInteger ScrollViewDirection;

@interface BiteTableFullScreenViewController : BiteTableViewController
{
  BOOL disappearing;
  float lastContentOffset;
  UIActivityIndicatorView *refreshSpinner;
  ScrollViewDirection scrollViewDirection;
}

@property (nonatomic) BOOL refreshing;
@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIView *refreshView;

#pragma mark - Methods

- (void) cancelRefresh;
- (void) checkToAllowTableViewToScrollPassTabBar;
- (void) resetNavAndTabBar;

@end
