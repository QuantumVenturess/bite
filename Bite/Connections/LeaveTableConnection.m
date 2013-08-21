//
//  LeaveTableConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "LeaveTableConnection.h"
#import "Table.h"
#import "User.h"
#import "UserStore.h"

@implementation LeaveTableConnection

@synthesize table;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject
{
  self = [super init];
  if (self) {
    self.table = tableObject;

    NSString *requestString = [NSString stringWithFormat: 
      @"%@/tables/%i/leave.json?bite_access_token=%@", 
        BiteApiURL, self.table.uid, [User currentUser].biteAccessToken];
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setHTTPMethod: @"POST"];
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
  if ([json objectForKey: @"error"]) {
    NSLog(@"LeaveTableConnection Error: %@", [json objectForKey: @"error"]);
  }
  else {
    // Update the user and user id of table
    int userId = [[json objectForKey: @"user_id"] integerValue];
    if (userId != self.table.userId) {
      User *user = [[UserStore sharedStore] userForKey: userId];
      if (!user) {
        user = [[User alloc] init];
        [user readFromDictionary: [json objectForKey: @"user"]];
      }
      self.table.user = user;
      self.table.userId = userId;
    }
    // [[NSNotificationCenter defaultCenter] postNotificationName: 
    //   RefreshDataNotification object: nil];
  }
  [self.table unsubscribeToChannel];
  
  [super connectionDidFinishLoading: connection];
}

@end
