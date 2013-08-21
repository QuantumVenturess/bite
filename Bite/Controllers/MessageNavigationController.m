//
//  MessageNavigationController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "FlatNavigationBar.h"
#import "MessageNavigationController.h"
#import "MessageViewController.h"
#import "Table.h"
#import "TableDetailViewController.h"

@implementation MessageNavigationController

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject
viewController: (TableDetailViewController *) viewController
{
  self = [super init];
  if (self) {
    [self setValue: [[FlatNavigationBar alloc] init] forKey: @"navigationBar"];
    self.viewControllers = [NSArray arrayWithObject: 
      [[MessageViewController alloc] initWithTable: tableObject
        viewController: viewController]];
  }
  return self;
}

@end
