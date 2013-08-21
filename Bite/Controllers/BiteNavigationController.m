//
//  BiteNavigationController.m
//  Bite
//
//  Created by Tommy DANGerous on 6/10/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteNavigationController.h"
#import "FlatNavigationBar.h"
#import "UIColor+Extensions.h"

@implementation BiteNavigationController

#pragma mark - Initializer

- (id) initWithRootViewController: (UIViewController *) rootViewController
{
  self = [super initWithRootViewController: rootViewController];
  if (self) {
    // Navigation item
    [self setValue: [[FlatNavigationBar alloc] init] forKey: @"navigationBar"];
  }
  return self;
}

@end
