//
//  AllTableStore.m
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AllTableStore.h"
#import "Table.h"

@implementation AllTableStore

@synthesize tables;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.tables = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - Methods

+ (AllTableStore *) sharedStore
{
  static AllTableStore *store = nil;
  if (!store) {
    store = [[AllTableStore alloc] init];
  }
  return store;
}

- (void) addTable: (Table *) table
{
  [self.tables setObject: table forKey: 
    [NSString stringWithFormat: @"%i", table.uid]];
}

- (void) clearTables
{
  [self.tables removeAllObjects];
}

- (void) removeTable: (Table *) table
{
  [self.tables removeObjectForKey: 
    [NSString stringWithFormat: @"%i", table.uid]];
}

- (Table *) table: (int) uid
{
  return [self.tables objectForKey: [NSString stringWithFormat: @"%i", uid]];
}

@end
