//
//  UserConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "User.h"
#import "UserConnection.h"

@implementation UserConnection

@synthesize user;

#pragma mark - Initializer

- (id) initWithUser: (User *) userObject
{
  self = [super init];
  if (self) {
    self.user = userObject;
    NSString *requestString = [NSString stringWithFormat: 
      @"%@/authenticate/bite-app.json", BiteApiURL];
    NSURL *url = [NSURL URLWithString: 
      [requestString stringByAddingPercentEscapesUsingEncoding: 
        NSUTF8StringEncoding]];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    NSString *params = [NSString stringWithFormat:
      @"access_token=%@&"
      @"email=%@&"
      @"facebook_id=%0.0f&"
      @"first_name=%@&"
      @"last_name=%@&"
      @"location=%@",
      self.user.accessToken, self.user.email, self.user.facebookId,
      self.user.firstName, self.user.lastName, 
      self.user.location ? self.user.location : @""];
    [req setHTTPBody: [params dataUsingEncoding: NSUTF8StringEncoding]];
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
  [[User currentUser] getBiteAccessToken: json];
  
  [super connectionDidFinishLoading: connection];
}

#pragma mark - Methods

- (void) start
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  container = [[NSMutableData alloc] init];

  internalConnection = [[NSURLConnection alloc] initWithRequest: self.request 
    delegate: self startImmediately: NO];
  [internalConnection scheduleInRunLoop: [NSRunLoop mainRunLoop] 
    forMode: NSDefaultRunLoopMode];
  [internalConnection start];

  if (!sharedConnectionList) {
    sharedConnectionList = [NSMutableArray array];
  }
  [sharedConnectionList addObject: self];
}

@end
