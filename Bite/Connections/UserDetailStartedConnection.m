//
//  UserDetailStartedConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailStartedConnection.h"
#import "UserDetailStartedTableStore.h"
#import "UserDetailViewController.h"

@implementation UserDetailStartedConnection

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  // User detail view controller
  UserDetailViewController *userDetail = 
    (UserDetailViewController *) self.viewController;
  // Set max pages
  userDetail.startedMaxPages = [[json objectForKey: @"pages"] integerValue];
  // Read user tables json
  [[UserDetailStartedTableStore sharedStore] readFromDictionary:
    [json objectForKey: @"tables"] forUser: userDetail.user];

  [super connectionDidFinishLoading: connection];
}

@end
