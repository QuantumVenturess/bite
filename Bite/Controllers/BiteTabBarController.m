//
//  BiteTabBarController.m
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteTabBarController.h"
#import "ExploreNavigationController.h"
#import "FlatTabBar.h"
#import "NewsNavigationController.h"
#import "SittingNavigationController.h"
#import "StartNavigationController.h"

@implementation BiteTabBarController

- (id) init
{
  self = [super init];
  if (self) {
    ExploreNavigationController *explore = 
      [[ExploreNavigationController alloc] init];
    SittingNavigationController *sitting =
      [[SittingNavigationController alloc] init];
    StartNavigationController *start = 
      [[StartNavigationController alloc] init];
    NewsNavigationController *news = 
      [[NewsNavigationController alloc] init];
    [self setValue: [[FlatTabBar alloc] init] forKey: @"tabBar"];
    self.viewControllers = [NSArray arrayWithObjects: 
      explore, sitting, start, news, nil];
    self.selectedViewController = explore;
    self.tabBar.selectionIndicatorImage = [[UIImage alloc] init];
  }
  return self;
}

@end
