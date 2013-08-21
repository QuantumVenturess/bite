//
//  UserDetailCompleteTableStore.m
//  Bite
//
//  Created by Tommy DANGerous on 6/10/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailCompleteConnection.h"
#import "UserDetailCompleteTableStore.h"

@implementation UserDetailCompleteTableStore

#pragma mark - Methods

+ (UserDetailCompleteTableStore *) sharedStore
{
  static UserDetailCompleteTableStore *store = nil;
  if (!store) {
    store = [[UserDetailCompleteTableStore alloc] init];
  }
  return store;
}

- (void) fetchTablesForPage: (NSUInteger) page forUser: (User *) user
withCompletion: (void (^) (NSError *error)) block
{
  NSString *requestString = [NSString stringWithFormat:
    @"%@/users/%i/complete.json?p=%i&bite_access_token=%@",
      BiteApiURL, user.uid, page, [User currentUser].biteAccessToken];
  NSURL *url = [NSURL URLWithString: requestString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setTimeoutInterval: RequestTimeoutInterval];

  UserDetailCompleteConnection *connection = 
    [[UserDetailCompleteConnection alloc] initWithRequest: request];
  connection.completionBlock = block;
  connection.delegate = self;
  connection.viewController = self.viewController;
  [connection start];
}

- (NSArray *) tablesForUser: (User *) user
{
  return [self sortedTablesByDateCompleteForUser: user];
}

@end
