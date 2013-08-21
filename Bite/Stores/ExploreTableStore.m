//
//  ExploreTableStore.m
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "ExploreTableStore.h"
#import "Table.h"
#import "TableConnection.h"
#import "User.h"

@implementation ExploreTableStore

#pragma mark - Methods

+ (ExploreTableStore *) sharedStore
{
  static ExploreTableStore *store = nil;
  if (!store) {
    store = [[ExploreTableStore alloc] init];
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
        [[[ExploreTableStore sharedStore] sortedTablesByCreatedAt] 
          objectAtIndex: i];
      [array addObject: [NSNumber numberWithInt: table.uid]];
    }
    NSString *tableIds = [array componentsJoinedByString: @","];
    NSString *requestString = [NSString stringWithFormat:
      @"%@/explore.json?p=%i&bite_access_token=%@&table_ids=%@",
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
    @"%@/explore.json?p=%i&bite_access_token=%@",
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
