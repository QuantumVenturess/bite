//
//  NewsNavigationController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "NewsNavigationController.h"
#import "NewsViewController.h"

@implementation NewsNavigationController

#pragma mark - Initializer

- (id) init
{
  self = [super initWithRootViewController: 
    [[NewsViewController alloc] init]];
  if (self) {
    // Tab bar
    [[self tabBarItem] setFinishedSelectedImage: 
      [UIImage imageNamed: @"news_selected.png"] 
        withFinishedUnselectedImage: 
          [UIImage imageNamed: @"news_unselected.png"]];
  }
  return self;
}

@end
