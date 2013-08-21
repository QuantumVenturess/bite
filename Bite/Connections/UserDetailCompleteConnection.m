    //
//  UserDetailCompleteConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/10/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailCompleteConnection.h"
#import "UserDetailCompleteTableStore.h"
#import "UserDetailViewController.h"

@implementation UserDetailCompleteConnection

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  // User detail view controller
  UserDetailViewController *userDetail = 
    (UserDetailViewController *) self.viewController;
  // Set max pages
  userDetail.completeMaxPages = [[json objectForKey: @"pages"] integerValue];
  // Read user tables json
  [[UserDetailCompleteTableStore sharedStore] readFromDictionary:
    [json objectForKey: @"tables"] forUser: userDetail.user];

  [super connectionDidFinishLoading: connection];
}

@end
