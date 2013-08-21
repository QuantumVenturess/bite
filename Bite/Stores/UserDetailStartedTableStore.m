//
//  UserDetailStartedTableStore.m
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailStartedConnection.h"
#import "UserDetailStartedTableStore.h"

@implementation UserDetailStartedTableStore

#pragma mark - Methods

+ (UserDetailStartedTableStore *) sharedStore
{
  static UserDetailStartedTableStore *store = nil;
  if (!store) {
    store = [[UserDetailStartedTableStore alloc] init];
  }
  return store;
}

- (void) fetchTablesForPage: (NSUInteger) page forUser: (User *) user
withCompletion: (void (^) (NSError *error)) block
{
  NSString *requestString = [NSString stringWithFormat:
    @"%@/users/%i/started.json?p=%i&bite_access_token=%@",
      BiteApiURL, user.uid, page, [User currentUser].biteAccessToken];
  NSURL *url = [NSURL URLWithString: requestString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setTimeoutInterval: RequestTimeoutInterval];

  UserDetailStartedConnection *connection = 
    [[UserDetailStartedConnection alloc] initWithRequest: request];
  connection.completionBlock = block;
  connection.delegate = self;
  connection.viewController = self.viewController;
  [connection start];
}

- (NSArray *) tablesForUser: (User *) user
{
  return [self sortedTablesByCreatedAtForUser: user];
}

@end
