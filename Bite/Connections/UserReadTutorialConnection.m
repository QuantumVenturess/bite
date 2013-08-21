//
//  UserReadTutorialConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/6/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserReadTutorialConnection.h"

@implementation UserReadTutorialConnection

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    NSString *requestString = [NSString stringWithFormat: 
      @"%@/read-tutorial.json?bite_access_token=%@",
        BiteApiURL, [User currentUser].biteAccessToken];
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL: url];
    [req setTimeoutInterval: RequestTimeoutInterval];
    self.request = req;
  }
  return self;
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  if ([[json objectForKey: @"read_tutorial"] integerValue] == 1) {
    [User currentUser].readTutorial = YES;
  }

  [super connectionDidFinishLoading: connection];
}

@end
