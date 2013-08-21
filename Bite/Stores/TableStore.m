//
//  TableStore.m
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AllTableStore.h"
#import "Table.h"
#import "TableConnection.h"
#import "TableStore.h"

@implementation TableStore

@synthesize tables;
@synthesize tablesToKeep;
@synthesize viewController;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.tables       = [NSMutableArray array];
    self.tablesToKeep = [NSMutableArray array];
  }
  return self;
}

#pragma mark - Methods Fetch

- (void) cleanTablesForPage: (NSUInteger) page
withCompletion: (void (^) (NSError *error)) block
{
  if (self.tables.count == 0) {
    block(nil);
    return;
  }
  // Subclass will implement
}

- (void) fetchTablesForPage: (NSUInteger) page 
withCompletion: (void (^) (NSError *error)) block
{
  // Subclass will implement
}

#pragma mark - Methods

- (void) addTable: (Table *) table
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"uid", table.uid];
  if ([self.tables filteredArrayUsingPredicate: predicate].count == 0) {
    [self.tables addObject: table];
  }
  else {
    NSUInteger index = [self.tables indexOfObjectPassingTest: 
      ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        NSString *t1 = [NSString stringWithFormat: @"%i", [(Table *) obj uid]];
        NSString *t2 = [NSString stringWithFormat: @"%i", table.uid];
        if ([t1 isEqualToString: t2]) {
          *stop = YES;
          return YES;
        }
        else {
          return NO;
        }
      }
    ];
    if (index != NSNotFound) {
      Table *object = [self.tables objectAtIndex: index];
      object.startDate = table.startDate;
      object.uid       = table.uid;
      object.user      = table.user;
      object.userId    = table.userId;
    }
  }
}

- (void) clearTables
{
  [self.tables removeAllObjects];
}

- (void) keepTablesInTableIdArray
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"NOT (%K IN %@)", @"uid", self.tablesToKeep];
  NSArray *array = [self.tables filteredArrayUsingPredicate: predicate];
  for (Table *table in array) {
    [self removeTable: table];
  }
  [self.tablesToKeep removeAllObjects];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  for (NSDictionary *tableDictionary in dictionary) {
    Table *table = [[Table alloc] init];
    [table readFromDictionary: tableDictionary];
    [self addTable: table];
  }
}

- (void) removeTable: (Table *) tableObject
{
  [self.tables removeObject: tableObject];
  // NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  // for (Table *table in self.tables) {
  //   [dictionary setObject: table forKey: 
  //     [NSString stringWithFormat: @"%i", table.uid]];
  // }
  // [dictionary removeObjectForKey: 
  //   [NSString stringWithFormat: @"%i", tableObject.uid]];
  // self.tables = [NSMutableArray arrayWithArray: [dictionary allValues]];
}

- (NSArray *) sortedTablesByCreatedAt
{
  NSSortDescriptor *created = 
    [NSSortDescriptor sortDescriptorWithKey: @"createdAt" ascending: NO];
  return [self.tables sortedArrayUsingDescriptors: 
    [NSArray arrayWithObject: created]];
}

- (NSArray *) sortedTablesByStartDate
{
  NSSortDescriptor *start = 
    [NSSortDescriptor sortDescriptorWithKey: @"startDate" ascending: YES];
  return [self.tables sortedArrayUsingDescriptors: 
    [NSArray arrayWithObject: start]];
}

- (void) tablesToRemove: (NSArray *) array
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K IN %@", @"uid", array];
  NSArray *tableArray = [self.tables filteredArrayUsingPredicate: predicate];
  for (Table *table in tableArray) {
    [self removeTable: table];
    [[AllTableStore sharedStore] removeTable: table];
  }
}

@end
