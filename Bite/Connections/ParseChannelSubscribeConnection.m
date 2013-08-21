//
//  ParseChannelSubscribeConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/8/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParseChannelSubscribeConnection.h"

@implementation ParseChannelSubscribeConnection

#pragma mark - Init

- (id) init
{
  self = [super init];
  if (self) {
    NSString *requestString = [NSString stringWithFormat: 
      @"%@/sitting/all.json?bite_access_token=%@",
        BiteApiURL, [User currentUser].biteAccessToken];
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setTimeoutInterval: RequestTimeoutInterval];
    self.request = req;
  }
  return self;
}

#pragma mark - NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  NSArray *tableIds = [json objectForKey: @"table_ids"];
  for (NSString *tableId in tableIds) {
    NSString *channel = [NSString stringWithFormat: @"table_%@", tableId];
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject: channel forKey: @"channels"];
    [currentInstallation saveInBackground];
  }

  [super connectionDidFinishLoading: connection];
}

@end
