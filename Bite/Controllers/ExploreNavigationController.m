//
//  ExploreNavigationController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "ExploreNavigationController.h"
#import "ExploreViewController.h"

@implementation ExploreNavigationController

#pragma mark - Initializer

- (id) init
{
  self = [super initWithRootViewController: 
    [[ExploreViewController alloc] init]];
  if (self) {
    // Tab bar
    [[self tabBarItem] setFinishedSelectedImage: 
      [UIImage imageNamed: @"explore_selected.png"] 
        withFinishedUnselectedImage: 
          [UIImage imageNamed: @"explore_unselected.png"]];
  }
  return self;
}

@end
