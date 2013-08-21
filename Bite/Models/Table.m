//
//  Table.m
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Parse/Parse.h>
#import "AllTableStore.h"
#import "Message.h"
#import "Place.h"
#import "PlaceStore.h"
#import "Seat.h"
#import "Table.h"
#import "User.h"
#import "UserStore.h"

@implementation Table

// attributes
@synthesize complete;
@synthesize createdAt;
@synthesize dateComplete;
@synthesize dateReady;
@synthesize maxSeats;
@synthesize place;
@synthesize placeId;
@synthesize ready;
@synthesize startDate;
@synthesize updatedAt;
@synthesize uid;
@synthesize user;
@synthesize userId;
// relationships
@synthesize messages;
@synthesize seats;

#pragma mark Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.messages = [NSMutableArray array];
    self.seats    = [NSMutableArray array];
  }
  return self;
}

#pragma mark - Methods

- (void) addMessage: (Message *) message
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"uid", message.uid];
  NSArray *array = [self.messages filteredArrayUsingPredicate: predicate];
  if (array.count == 0) {
    [self.messages addObject: message];
  }
}

- (void) addSeat: (Seat *) seat
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"userId", seat.userId];
  NSArray *array = [self.seats filteredArrayUsingPredicate: predicate];
  if (array.count == 0) {
    [self.seats addObject: seat];
  }
}

- (int) numberOfRows
{
  int number = 0;
  int seatsCount = self.seats.count;
  int maxPerRow = 5;
  // If number of seats is less than or equal to 5, 1 row
  if (seatsCount <= maxPerRow) {
    number = 1;
  }
  else {
    number = (seatsCount / maxPerRow);
    if (seatsCount % maxPerRow != 0) {
      number += 1;
    }
  }
  return number;
}

- (NSString *) pushNotificationChannel
{
  return [NSString stringWithFormat: @"table_%i", self.uid];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  if ([[dictionary objectForKey: @"complete"] isEqual: @"1"]) {
    self.complete = YES;
  }
  else {
    self.complete = NO;
  }
  self.createdAt = 
    [[[NSDate date] initWithString: 
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  if ([dictionary objectForKey: @"date_complete"] != [NSNull null]) {
    self.dateComplete = 
      [[[NSDate date] initWithString:
        [dictionary objectForKey: @"date_complete"]] timeIntervalSince1970];
  }
  if ([dictionary objectForKey: @"date_ready"] != [NSNull null]) {
    self.dateReady = 
      [[[NSDate date] initWithString:
        [dictionary objectForKey: @"date_ready"]] timeIntervalSince1970];
  }
  self.maxSeats = [[dictionary objectForKey: @"max_seats"] integerValue];;

  NSDictionary *placeDictionary = [dictionary objectForKey: @"place"];
  Place *newPlace = [[PlaceStore sharedStore] placeForYelpId: 
    [placeDictionary objectForKey: @"yelp_id"]];
  if (!newPlace) {
    newPlace = [[Place alloc] init];
    [newPlace readFromDictionary: placeDictionary];
    [[PlaceStore sharedStore] addPlace: newPlace];
  }
  self.place = newPlace;
  
  self.placeId = [[dictionary objectForKey: @"place_id"] integerValue];
  if ([[dictionary objectForKey: @"ready"] isEqual: @"1"]) {
    self.ready = YES;
  }
  else {
    self.ready = NO;
  }
  // Seats
  NSArray *seatsArray = [dictionary objectForKey: @"seats"];
  for (NSDictionary *seatDictionary in seatsArray) {
    Seat *seat = [[Seat alloc] init];
    seat.table = self;
    [seat readFromDictionary: seatDictionary];
    [self addSeat: seat];
  }
  if ([dictionary objectForKey: @"start_date"] != [NSNull null]) {
    self.startDate = 
      [[[NSDate date] initWithString:
        [dictionary objectForKey: @"start_date"]] timeIntervalSince1970];
  }
  if ([dictionary objectForKey: @"updated_at"] != [NSNull null]) {
    self.updatedAt = 
      [[[NSDate date] initWithString:
        [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
  }
  self.uid = [[dictionary objectForKey: @"id"] integerValue];
  self.userId = [[dictionary objectForKey: @"user_id"] integerValue];
  // User
  User *newUser = [[UserStore sharedStore] userForKey: self.userId];
  if (!newUser) {
    newUser = [[User alloc] init];
    [newUser readFromDictionary: [dictionary objectForKey: @"user"]];
    [[UserStore sharedStore] addUser: newUser];
  }
  self.user = newUser;
  // Add to AllTableStore
  [[AllTableStore sharedStore] addTable: self];
}

- (void) removeMessage: (Message *) message
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K != %i", @"uid", message.uid];
  self.messages = [NSMutableArray arrayWithArray: 
    [self.messages filteredArrayUsingPredicate: predicate]];
}

- (void) removeSeat: (Seat *) seat
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K != %i", @"userId", seat.userId];
  self.seats = [NSMutableArray arrayWithArray:
    [self.seats filteredArrayUsingPredicate: predicate]];
}

- (void) removeSeatsInArray: (NSArray *) userIds
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"NOT (%K IN %@)", @"userId", userIds];
  NSArray *seatsToRemove = [self.seats filteredArrayUsingPredicate: predicate];
  for (Seat *seat in seatsToRemove) {
    [self removeSeat: seat];
  }
}

- (Seat *) seatForUser: (User *) userObject
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"userId", userObject.uid];
  NSArray *array = [NSArray arrayWithArray:
    [self.seats filteredArrayUsingPredicate: predicate]];
  if (array.count == 1) {
    return [array objectAtIndex: 0];
  }
  else {
    return nil;
  }
}

- (void) sendPushNotification
{
  NSString *alert = [NSString stringWithFormat: @"%@ sat down at %@",
    [User currentUser].firstName, self.place.name];
  NSTimeInterval interval = 60 * 60 * 24 * 7;
  NSDictionary *data = @{
    @"alert": alert,
    @"badge": @"Increment",
    @"table_id": [NSString stringWithFormat: @"%i", self.uid]
  };
  PFPush *push = [[PFPush alloc] init];
  [push expireAfterTimeInterval: interval];
  [push setChannel: [self pushNotificationChannel]];
  [push setData: data];
  [push sendPushInBackground];
}

- (NSMutableArray *) sortedMessages
{
  NSSortDescriptor *created = 
    [NSSortDescriptor sortDescriptorWithKey: @"createdAt" ascending: NO];
  [self.messages sortUsingDescriptors: 
    [NSArray arrayWithObjects: created, nil]];
  return self.messages;
}


- (NSString *) startDateStringLong
{
  NSDate *date = [NSDate dateWithTimeIntervalSince1970: self.startDate];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"EEEE - MMM dd, yyyy";
  NSString *day = [dateFormatter stringFromDate: date];
  dateFormatter.dateFormat = @"h:mm a";
  NSString *dateTime = [dateFormatter stringFromDate: date];
  return [NSString stringWithFormat: @"%@ at %@", 
    day, [dateTime lowercaseString]];
}

- (NSString *) startDateStringShort
{
  NSDate *date = [NSDate dateWithTimeIntervalSince1970: self.startDate];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"EEE - MMM dd, yy";
  NSString *day = [dateFormatter stringFromDate: date];
  dateFormatter.dateFormat = @"h:mm a";
  NSString *dateTime = [dateFormatter stringFromDate: date];
  return [NSString stringWithFormat: @"%@ at %@", 
    day, [dateTime lowercaseString]];
}

- (void) subscribeToChannel
{
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  [currentInstallation addUniqueObject: [self pushNotificationChannel] 
    forKey: @"channels"];
  [currentInstallation saveInBackground];
}

- (NSDictionary *) tableToDictionary
{
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat: @"yyyy-MM-dd H:mm:ss +0000"];
  // Place dictionary
  NSDictionary *placeDictionary = @{
    @"address": self.place.address,
    @"city": self.place.city,
    @"created_at": [formatter stringFromDate: 
      [NSDate dateWithTimeIntervalSince1970: self.place.createdAt]],
    @"id": [NSString stringWithFormat: @"%i", self.place.uid],
    @"image_url": [self.place.imageURL absoluteString],
    @"latitude": [NSString stringWithFormat: @"%f", self.place.latitude],
    @"longitude": [NSString stringWithFormat: @"%f", self.place.longitude],
    @"name": self.place.name,
    @"phone": self.place.phone,
    @"postal_code": [NSString stringWithFormat: @"%i", self.place.postalCode],
    @"rating": [NSString stringWithFormat: @"%f", self.place.rating],
    @"review_count": [NSString stringWithFormat: @"%i", self.place.reviewCount],
    @"s3_url": [self.place.s3URL absoluteString],
    @"state_code": self.place.stateCode,
    @"yelp_id": self.place.yelpId,
    @"updated_at": [formatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: self.place.updatedAt]]
  };
  // User dictionary
  NSDictionary *userDictionary = @{
    @"first_name": self.user.firstName,
    @"id": [NSString stringWithFormat: @"%i", self.user.uid],
    @"image": [self.user.imageURL absoluteString],
    @"last_name": self.user.lastName,
    @"name": self.user.name
  };
  // Table dictionary
  NSDictionary *tableDictionary = @{
    @"complete": self.complete ? @"1" : @"0",
    @"created_at": [formatter stringFromDate: 
      [NSDate dateWithTimeIntervalSince1970: self.createdAt]],
    @"date_complete": [formatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: self.dateComplete]],
    @"date_ready": [formatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: self.dateReady]],
    @"id": [NSString stringWithFormat: @"%i", self.uid],
    @"max_seats": [NSString stringWithFormat: @"%i", self.maxSeats],
    @"place": placeDictionary,
    @"place_id": [NSString stringWithFormat: @"%i", self.placeId],
    @"ready": self.ready ? @"1" : @"0",
    @"seats": @"",
    @"start_date": [formatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: self.startDate]],
    @"updated_at": [formatter stringFromDate:
      [NSDate dateWithTimeIntervalSince1970: self.updatedAt]],
    @"user": userDictionary,
    @"user_id": [NSString stringWithFormat: @"%i", self.userId]
  };
  return tableDictionary;
}

- (void) unsubscribeToChannel
{
  PFInstallation *currentInstallation = [PFInstallation currentInstallation];
  [currentInstallation removeObject: [self pushNotificationChannel] 
    forKey: @"channels"];
  [currentInstallation saveInBackground];
}

@end
