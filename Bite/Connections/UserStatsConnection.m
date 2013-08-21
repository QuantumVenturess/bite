//
//  UserStatsConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/10/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "User.h"
#import "UserStatsConnection.h"

@implementation UserStatsConnection

@synthesize user;

#pragma mark - Initializer

- (id) initWithUser: (User *) userObject
{
  self = [super init];
  if (self) {
    self.user = userObject;
    NSString *requestString = [NSString stringWithFormat: 
      @"%@/users/%i/stats.json?bite_access_token=%@",
        BiteApiURL, self.user.uid, [User currentUser].biteAccessToken];
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setTimeoutInterval: RequestTimeoutInterval];
    self.request = req;
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  self.user.completeCount = [[json objectForKey: 
    @"complete_count"] integerValue];
  self.user.sittingCount = [[json objectForKey: 
    @"sitting_count"] integerValue];
  self.user.startedCount = [[json objectForKey: 
    @"started_count"] integerValue];

  [super connectionDidFinishLoading: connection];
}

@end
