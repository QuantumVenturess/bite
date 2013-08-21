//
//  ChangeDateConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/3/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "ChangeDateConnection.h"
#import "Table.h"
#import "User.h"

@implementation ChangeDateConnection

@synthesize table;

- (id) initWithTable: (Table *) tableObject
{
  self = [super init];
  if (self) {
      self.table = tableObject;

    // Start date and time
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: 
      self.table.startDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *startDay = [dateFormatter stringFromDate: date];
    dateFormatter.dateFormat = @"H";
    int startHour = [[dateFormatter stringFromDate: date] integerValue];
    dateFormatter.dateFormat = @"mm";
    int startMinute = [[dateFormatter stringFromDate: date] integerValue];

    NSString *requestString = [NSString stringWithFormat: 
      @"%@/tables/%i/date.json", BiteApiURL, self.table.uid];
    NSString *params = [NSString stringWithFormat: 
      @"bite_access_token=%@&"
      @"day=%@&"
      @"date[hour]=%i&"
      @"date[minute]=%i",
      [User currentUser].biteAccessToken,
      startDay, startHour, startMinute];
    params = [params stringByAddingPercentEscapesUsingEncoding:
      NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
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
  NSString *error = [json objectForKey: @"error"];
  if (error) {
    NSLog(@"ChangeDateConnection Error: %@", error);
  }
  else {
    // Update table information
    [self.table readFromDictionary: [json objectForKey: @"table"]];
  }
  [super connectionDidFinishLoading: connection];
}

@end
