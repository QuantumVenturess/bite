//
//  MessageConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Message.h"
#import "MessageConnection.h"
#import "Table.h"
#import "User.h"

@implementation MessageConnection

@synthesize table;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject
{
  self = [super init];
  if (self) {
    self.table = tableObject;
    NSString *requestString = [NSString stringWithFormat: 
      @"%@/tables/%i/messages.json?bite_access_token=%@", 
        BiteApiURL, self.table.uid, [User currentUser].biteAccessToken];
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
  for (NSDictionary *dictionary in json) {
    Message *message = [[Message alloc] init];
    [message readFromDictionary: dictionary];
    [self.table addMessage: message];
  }
  
  [super connectionDidFinishLoading: connection];
}

@end
