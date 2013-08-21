//
//  UserDetailSittingTableStore.m
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailSittingConnection.h"
#import "UserDetailSittingTableStore.h"

@implementation UserDetailSittingTableStore

#pragma mark - Methods

+ (UserDetailSittingTableStore *) sharedStore
{
  static UserDetailSittingTableStore *store = nil;
  if (!store) {
    store = [[UserDetailSittingTableStore alloc] init];
  }
  return store;
}

- (void) fetchTablesForPage: (NSUInteger) page forUser: (User *) user
withCompletion: (void (^) (NSError *error)) block
{
  NSString *requestString = [NSString stringWithFormat:
    @"%@/users/%i/sitting.json?p=%i&bite_access_token=%@",
      BiteApiURL, user.uid, page, [User currentUser].biteAccessToken];
  NSURL *url = [NSURL URLWithString: requestString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setTimeoutInterval: RequestTimeoutInterval];

  UserDetailSittingConnection *connection = 
    [[UserDetailSittingConnection alloc] initWithRequest: request];
  connection.completionBlock = block;
  connection.delegate = self;
  connection.viewController = self.viewController;
  [connection start];
}

- (NSArray *) tablesForUser: (User *) user
{
  return [self sortedTablesByStartDateForUser: user];
}

@end
