//
//  StartPlaceStore.m
//  Bite
//
//  Created by Tommy DANGerous on 5/31/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "StartPlaceStore.h"

@implementation StartPlaceStore

@synthesize places;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.places = [NSMutableArray array];
  }
  return self;
}

#pragma mark - Methods

+ (StartPlaceStore *) sharedStore
{
  static StartPlaceStore *store = nil;
  if (!store) {
    store = [[StartPlaceStore alloc] init];
  }
  return store;
}

- (void) clearPlaces
{
  [self.places removeAllObjects];
}

@end
