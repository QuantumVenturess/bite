//
//  SittingNavigationController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "SittingNavigationController.h"
#import "SittingViewController.h"

@implementation SittingNavigationController

#pragma mark - Initializer

- (id) init
{
  self = [super initWithRootViewController:
    [[SittingViewController alloc] init]];
  if (self) {
    // Tab bar
    [[self tabBarItem] setFinishedSelectedImage: 
      [UIImage imageNamed: @"sitting_selected.png"] 
        withFinishedUnselectedImage: 
          [UIImage imageNamed: @"sitting_unselected.png"]];
  }
  return self;
}

@end
