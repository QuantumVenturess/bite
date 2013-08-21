//
//  StartNavigationController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "StartNavigationController.h"
#import "StartViewController.h"

@implementation StartNavigationController

#pragma mark - Initializer

- (id) init
{
  self = [super initWithRootViewController:
    [[StartViewController alloc] init]];
  if (self) {
    // Tab bar
    [[self tabBarItem] setFinishedSelectedImage: 
      [UIImage imageNamed: @"start_selected.png"] 
        withFinishedUnselectedImage: 
          [UIImage imageNamed: @"start_unselected.png"]];
  }
  return self;
}

@end
