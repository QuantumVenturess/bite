//
//  StartPlaceNavigationController.m
//  Bite
//
//  Created by Tommy DANGerous on 6/3/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "FlatNavigationBar.h"
#import "Place.h"
#import "StartPlaceNavigationController.h"
#import "StartPlaceViewController.h"
#import "StartViewController.h"
#import "TableDetailViewController.h"

@implementation StartPlaceNavigationController

#pragma mark Initializer

- (id) initWithPlace: (Place *) placeObject viewController: (id) viewController
{
  self = [super init];
  if (self) {
    [self setValue: [[FlatNavigationBar alloc] init] forKey: @"navigationBar"];
    StartPlaceViewController *startPlace = 
      [[StartPlaceViewController alloc] initWithPlace: placeObject];
    if ([viewController isKindOfClass: [StartViewController class]]) {
      startPlace.startViewController = viewController;
    }
    self.viewControllers = [NSArray arrayWithObject: startPlace];
  }
  return self;
}

- (id) initWithTable: (Table *) tableObject viewController: (id) viewController
{
  self = [super init];
  if (self) {
    [self setValue: [[FlatNavigationBar alloc] init] forKey: @"navigationBar"];
    StartPlaceViewController *startPlace = 
      [[StartPlaceViewController alloc] initWithTable: tableObject];
    if ([viewController isKindOfClass: [TableDetailViewController class]]) {
      startPlace.tableDetailViewController = viewController;
    }
    self.viewControllers = [NSArray arrayWithObject: startPlace];
  }
  return self;
}

@end
