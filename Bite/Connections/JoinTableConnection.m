//
//  JoinTableConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "JoinTableConnection.h"
#import "Seat.h"
#import "Table.h"
#import "User.h"

@implementation JoinTableConnection

@synthesize seat;

#pragma mark - Initializer

- (id) initWithSeat: (Seat *) seatObject
{
  NSString *requestString = [NSString stringWithFormat: 
    @"%@/tables/%i/join.json?bite_access_token=%@", 
      BiteApiURL, seatObject.table.uid, [User currentUser].biteAccessToken];
  NSURL *url = [NSURL URLWithString: requestString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setHTTPMethod: @"POST"];
  [request setTimeoutInterval: RequestTimeoutInterval];

  self = [super initWithRequest: request];
  if (self) {
    self.seat = seatObject;
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  if ([json objectForKey: @"error"]) {
    NSLog(@"JoinTableConnection Error: %@", [json objectForKey: @"error"]);
  }
  else {
    self.seat.uid = [[json objectForKey: @"id"] integerValue];
    // [[NSNotificationCenter defaultCenter] postNotificationName: 
    //   RefreshDataNotification object: nil];
  }  
  // Send push notification, then...
  [self.seat.table sendPushNotification];
  // Subscribe to channel
  [self.seat.table subscribeToChannel];
  
  [super connectionDidFinishLoading: connection];
}

@end
