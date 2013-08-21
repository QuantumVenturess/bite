//
//  PlaceStore.m
//  Bite
//
//  Created by Tommy DANGerous on 5/31/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Place.h"
#import "PlaceStore.h"

@implementation PlaceStore

@synthesize places;

#pragma mark - Initalizer

- (id) init
{
  self = [super init];
  if (self) {
    self.places = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - Methods

+ (PlaceStore *) sharedStore
{
  static PlaceStore *store = nil;
  if (!store) {
    store = [[PlaceStore alloc] init];
  }
  return store;
}

- (void) addPlace: (Place *) place
{
  [self.places setObject: place forKey: place.yelpId];
}

- (Place *) placeForYelpId: (NSString *) string
{
  return [self.places objectForKey: string];
}

@end
