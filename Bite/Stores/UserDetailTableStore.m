//
//  UserDetailTableStore.m
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AllTableStore.h"
#import "Table.h"
#import "User.h"
#import "UserDetailTableStore.h"

@implementation UserDetailTableStore

@synthesize userTables;
@synthesize viewController;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.userTables = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - Methods

- (void) addTable: (Table *) table forUser: (User *) user
{
  NSString *key = [NSString stringWithFormat: @"%i", user.uid];
  NSMutableArray *array = [self.userTables objectForKey: key];
  if (!array) {
    array = [NSMutableArray array];
    [self.userTables setObject: array forKey: key];
  }
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"uid", table.uid];
  if ([array filteredArrayUsingPredicate: predicate].count == 0) {
    [array addObject: table];
  }
}

- (void) fetchTablesForPage: (NSUInteger) page forUser: (User *) user
withCompletion: (void (^) (NSError *error)) block
{
  // Subclass implements this
}

- (void) readFromDictionary: (NSDictionary *) dictionary forUser: (User *) user
{
  for (NSDictionary *tableDictionary in dictionary) {
    int uid = [[tableDictionary objectForKey: @"id"] integerValue];
    Table *table = [[AllTableStore sharedStore] table: uid];
    if (!table) {
      table = [[Table alloc] init];
      [table readFromDictionary: tableDictionary];
    }
    [self addTable: table forUser: user];
  }
}

- (NSArray *) sortedTablesByCreatedAtForUser: (User *) user
{
  NSString *key = [NSString stringWithFormat: @"%i", user.uid];
  NSArray *array = [self.userTables objectForKey: key];
  if (array) {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey: 
      @"createdAt" ascending: NO];
    array = [array sortedArrayUsingDescriptors: 
      [NSArray arrayWithObject: descriptor]];
  }
  return array;
}

- (NSArray *) sortedTablesByDateCompleteForUser: (User *) user
{
  NSString *key = [NSString stringWithFormat: @"%i", user.uid];
  NSArray *array = [self.userTables objectForKey: key];
  if (array) {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey: 
      @"dateComplete" ascending: NO];
    array = [array sortedArrayUsingDescriptors: 
      [NSArray arrayWithObject: descriptor]];
  }
  return array;
}

- (NSArray *) sortedTablesByStartDateForUser: (User *) user
{
  NSString *key = [NSString stringWithFormat: @"%i", user.uid];
  NSArray *array = [self.userTables objectForKey: key];
  if (array) {
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey: 
      @"startDate" ascending: YES];
    array = [array sortedArrayUsingDescriptors: 
      [NSArray arrayWithObject: descriptor]];
  }
  return array;

}

- (NSArray *) tablesForUser: (User *) user
{
  // Subclass implements this
  return [NSArray array];
}

@end
