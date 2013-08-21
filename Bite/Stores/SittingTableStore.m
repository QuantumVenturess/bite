//
//  SittingTableStore.m
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "SittingTableStore.h"
#import "Table.h"
#import "TableConnection.h"
#import "User.h"

@implementation SittingTableStore

#pragma mark - Methods

+ (SittingTableStore *) sharedStore
{
  static SittingTableStore *store = nil;
  if (!store) {
    store = [[SittingTableStore alloc] init];
  }
  return store;
}

- (void) cleanTablesForPage: (NSUInteger) page
withCompletion: (void (^) (NSError *error)) block
{
  [super cleanTablesForPage: page withCompletion: block];
  if (self.tables.count > 0) {
    NSMutableArray *array = [NSMutableArray array];
    int i, min, max;
    min = (10 * (page - 1));
    max = (10 * page) - 1;
    if (max >= self.tables.count) {
      max = self.tables.count - 1;
    }
    if (min > max) {
      min = max;
    }
    for (i = min; i < max + 1; ++i) {
      Table *table = 
        [[[SittingTableStore sharedStore] sortedTablesByStartDate] 
          objectAtIndex: i];
      [array addObject: [NSNumber numberWithInt: table.uid]];
    }
    NSString *tableIds = [array componentsJoinedByString: @","];
    NSString *requestString = [NSString stringWithFormat:
      @"%@/sitting.json?p=%i&bite_access_token=%@&table_ids=%@",
        BiteApiURL, page, [User currentUser].biteAccessToken, tableIds];
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
    [request setTimeoutInterval: RequestTimeoutInterval];
    
    TableConnection *connection = 
      [[TableConnection alloc] initWithRequest: request];
    connection.completionBlock = block;
    connection.delegate = self;
    connection.viewController = self.viewController;
    [connection start];
  }
}

- (void) fetchTablesForPage: (NSUInteger) page
withCompletion: (void (^) (NSError *error)) block
{
  NSString *requestString = [NSString stringWithFormat:
    @"%@/sitting.json?p=%i&bite_access_token=%@",
    BiteApiURL, page, [User currentUser].biteAccessToken];
  NSURL *url = [NSURL URLWithString: requestString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setTimeoutInterval: RequestTimeoutInterval];
  
  TableConnection *connection = 
    [[TableConnection alloc] initWithRequest: request];
  connection.completionBlock = block;
  connection.delegate = self;
  connection.viewController = self.viewController;
  [connection start];
}

@end
