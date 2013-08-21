//
//  StartPlaceConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/3/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "Place.h"
#import "Seat.h"
#import "StartPlaceConnection.h"
#import "Table.h"
#import "User.h"

@implementation StartPlaceConnection

@synthesize table;

#pragma mark - Initializer

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
    NSString *requestString = [NSString stringWithFormat: @"%@/places.json", 
      BiteApiURL];
    NSString *params = [NSString stringWithFormat:
      @"bite_access_token=%@&"
      @"address=%@&"
      @"city=%@&"
      @"image_url=%@&"
      @"latitude=%f&"
      @"longitude=%f&"
      @"name=%@&"
      @"phone=%@&"
      @"postal_code=%i&"
      @"rating=%f&"
      @"review_count=%i&"
      @"state_code=%@&"
      @"yelp_id=%@&"
      @"max_seats=%i&"
      @"start_day=%@&"
      @"start_hour=%i&"
      @"start_minute=%i",
      [User currentUser].biteAccessToken, 
      self.table.place.address, 
      self.table.place.city, 
      [self.table.place.imageURL absoluteString], 
      self.table.place.latitude, 
      self.table.place.longitude, 
      self.table.place.name, 
      self.table.place.phone, 
      self.table.place.postalCode, 
      self.table.place.rating, 
      self.table.place.reviewCount, 
      self.table.place.stateCode, 
      self.table.place.yelpId,
      self.table.maxSeats,
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
  self.table.placeId = [[json objectForKey: @"place_id"] integerValue];
  self.table.uid = [[json objectForKey: @"id"] integerValue];
  NSDictionary *placeDictionary = [json objectForKey: @"place"];
  self.table.place.createdAt = [[[NSDate date] initWithString: 
    [placeDictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  if ([placeDictionary objectForKey: @"s3_url"] != [NSNull null]) {
    self.table.place.s3URL = [NSURL URLWithString: 
      [placeDictionary objectForKey: @"s3_url"]];
  }
  self.table.place.uid = [[placeDictionary objectForKey: @"id"] integerValue];
  self.table.place.updatedAt = table.place.createdAt;
  NSArray *seatsArray = [json objectForKey: @"seats"];
  if (seatsArray.count > 0) {
    NSDictionary *seatDictionary = [seatsArray objectAtIndex: 0];
    Seat *seat = [self.table seatForUser: [User currentUser]];
    if (seat) {
      seat.tableId = [[seatDictionary objectForKey: @"table_id"] integerValue];
      seat.uid = [[seatDictionary objectForKey: @"id"] integerValue];
    }
  }
  // Subscribe to channel after creating table
  [self.table subscribeToChannel];
  
  [super connectionDidFinishLoading: connection];
}

@end
