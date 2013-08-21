//
//  TableDetailConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/8/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Table.h"
#import "TableDetailConnection.h"

@implementation TableDetailConnection

#pragma mark - Init

- (id) initWithTableId: (int) tableId
{
  self = [super init];
  if (self) {
    NSString *requestString = [NSString stringWithFormat:
      @"%@/tables/%i.json?bite_access_token=%@",
        BiteApiURL, tableId, [User currentUser].biteAccessToken];
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
  Table *table = [[Table alloc] init];
  [table readFromDictionary: json];

  [super connectionDidFinishLoading: connection];
}

@end
