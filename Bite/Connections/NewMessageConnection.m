//
//  NewMessageConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Message.h"
#import "NewMessageConnection.h"
#import "Table.h"
#import "User.h"

@implementation NewMessageConnection

@synthesize message;

#pragma mark - Initializer

- (id) initWithMessage: (Message *) messageObject
{
  NSString *requestString = 
    [NSString stringWithFormat: @"%@/tables/%i/message.json",
      BiteApiURL, messageObject.tableId];
  NSURL *url = [NSURL URLWithString: requestString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  NSString *params = 
    [NSString stringWithFormat: @"bite_access_token=%@&content=%@", 
      [User currentUser].biteAccessToken, messageObject.content];
  [request setHTTPBody: [params dataUsingEncoding: NSUTF8StringEncoding]];
  [request setHTTPMethod: @"POST"];
  [request setTimeoutInterval: RequestTimeoutInterval];
  
  self = [super initWithRequest: request];
  if (self) {
    self.message = messageObject;
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  if ([json objectForKey: @"error"]) {
    NSLog(@"NewMessageConnection Error: %@", [json objectForKey: @"error"]);
  }
  else {
    self.message.uid = [[json objectForKey: @"id"] integerValue];
  }
  
  [super connectionDidFinishLoading: connection];
}

@end
