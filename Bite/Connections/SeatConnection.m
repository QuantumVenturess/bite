//
//  SeatConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Seat.h"
#import "SeatConnection.h"
#import "Table.h"
#import "User.h"

@implementation SeatConnection

@synthesize table;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject
{
  NSString *requestString = 
    [NSString stringWithFormat: @"%@/tables/%i/seats.json?bite_access_token=%@",
      BiteApiURL, tableObject.uid, [User currentUser].biteAccessToken];
  NSURL *url = [NSURL URLWithString: requestString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setTimeoutInterval: RequestTimeoutInterval];
  
  self = [super initWithRequest: request];
  if (self) {
    self.table = tableObject;
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{ 
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  NSMutableArray *userIds = [NSMutableArray array];
  // Add seats
  for (NSDictionary *dictionary in json) {
    Seat *seat = [[Seat alloc] init];
    seat.table = self.table;
    [seat readFromDictionary: dictionary];
    [self.table addSeat: seat];
    [userIds addObject: [NSNumber numberWithInt: seat.userId]];
  }
  // Remove seats
  [self.table removeSeatsInArray: userIds];

  [super connectionDidFinishLoading: connection];
}

@end
