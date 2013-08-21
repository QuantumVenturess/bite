//
//  Notification.m
//  Bite
//
//  Created by Tommy DANGerous on 6/4/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AllTableStore.h"
#import "Message.h"
#import "Notification.h"
#import "Place.h"
#import "PlaceImageDownloader.h"
#import "Seat.h"
#import "Table.h"
#import "UIImage+Resize.h"
#import "User.h"
#import "UserImageDownloader.h"

@implementation Notification

@synthesize createdAt;
@synthesize message;
@synthesize messageTable;
@synthesize messageId;
@synthesize seat;
@synthesize seatTable;
@synthesize seatId;
@synthesize table;
@synthesize tableId;
@synthesize uid;
@synthesize updatedAt;
@synthesize user;
@synthesize userId;
@synthesize viewed;

#pragma mark - Methods

- (UIImage *) cellImage
{
  UIImage *image;
  if (self.message) {
    image = self.messageTable.place.image;
  }
  if (self.seat) {
    image = self.seat.user.image;
  }
  if (self.table) {
    image = self.table.place.image;
  }
  if (image) {
    float newHeight, newWidth;
    if (image.size.width < image.size.height) {
      newWidth  = 40.0;
      newHeight = (newWidth / image.size.width) * image.size.height;
    }
    else {
      newHeight = 40.0;
      newWidth  = (newHeight / image.size.height) * image.size.width;
    }
    return [UIImage image: image resized: CGSizeMake(newWidth, newHeight)
      position: CGPointMake(0, 0)];
  }
  else {
    return image;
  }
}

- (void) downloadImage: (void (^)(void)) block
{
  if (self.message) {
    PlaceImageDownloader *downloader = 
      [[PlaceImageDownloader alloc] initWithPlace: self.messageTable.place];
    downloader.completionBlock = block;
    [downloader startDownload];
  }
  if (self.seat) {
    UserImageDownloader *downloader = 
      [[UserImageDownloader alloc] initWithUser: self.seatUser];
    downloader.completionBlock = block;
    [downloader startDownload];
  }
  if (self.table) {
    PlaceImageDownloader *downloader = 
      [[PlaceImageDownloader alloc] initWithPlace: self.table.place];
    downloader.completionBlock = block;
    [downloader startDownload];
  }
}

- (BOOL) hasImage
{
  if (self.message) {
    return self.messageTable.place.image ? YES : NO;
  }
  if (self.seat) {
    return self.seatUser.image ? YES : NO;
  }
  if (self.table) {
    return self.table.place.image ? YES : NO;
  }
  return NO;
}

- (NSString *) notificationContent
{
  NSString *content;
  if (self.message) {
    content = [NSString stringWithFormat: @"New message for table at %@",
      self.messageTable.place.name];
  }
  if (self.seat) {
    content = [NSString stringWithFormat: @"%@ sat down at %@",
      self.seatUser.firstName, self.seatTable.place.name];  
  }
  if (self.table) {
    content = [NSString stringWithFormat: @"%@ table is ready",
      self.table.place.name];
  }
  return content;
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  self.createdAt = [[[NSDate date] initWithString: 
    [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  NSDictionary *messageDictionary = [dictionary objectForKey: @"message"];
  if (messageDictionary) {
    Message *messageObject = [[Message alloc] init];
    [messageObject readFromDictionary: messageDictionary];
    self.message   = messageObject;
    self.messageId = [[dictionary objectForKey: @"message_id"] integerValue];
    // Fetch, create, assign table
    NSDictionary *messageTableDictionary = [messageDictionary objectForKey: 
      @"table"];
    if (messageTableDictionary) {
      self.messageTable = [[AllTableStore sharedStore] table: 
        self.message.table.uid];
      if (!self.messageTable) {
        self.messageTable = [[Table alloc] init];
        [self.messageTable readFromDictionary: messageTableDictionary];
        [[AllTableStore sharedStore] addTable: self.messageTable];
      }
    }
  }
  NSDictionary *seatDictionary = [dictionary objectForKey: @"seat"];
  if (seatDictionary) {
    Seat *seatObject = [[Seat alloc] init];
    [seatObject readFromDictionary: seatDictionary];
    self.seat   = seatObject;
    self.seatId = [[dictionary objectForKey: @"seat_id"] integerValue];
    // Fetch, create, assign table
    NSDictionary *seatTableDictionary = [seatDictionary objectForKey: @"table"];
    if (seatTableDictionary) {
      self.seatTable = [[AllTableStore sharedStore] table: 
        self.seat.table.uid];
      if (!self.seatTable) {
        self.seatTable = [[Table alloc] init];
        [self.seatTable readFromDictionary: seatTableDictionary];
        [[AllTableStore sharedStore] addTable: self.seatTable];
      }
      self.seatUser = self.seat.user;
    }
  }
  NSDictionary *tableDictionary = [dictionary objectForKey: @"table"];
  if (tableDictionary) {
    self.tableId = [[dictionary objectForKey: @"table_id"] integerValue];
    Table *tableObject = [[AllTableStore sharedStore] table: self.tableId];
    if (!tableObject) {
      tableObject = [[Table alloc] init];
      [tableObject readFromDictionary: tableDictionary];
      [[AllTableStore sharedStore] addTable: tableObject];
    }
    self.table = tableObject;
  }
  self.uid = [[dictionary objectForKey: @"id"] integerValue];
  self.updatedAt = [[[NSDate date] initWithString:
    [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
  self.user   = [User currentUser];
  self.userId = [[dictionary objectForKey: @"user_id"] integerValue];
  if ([[dictionary objectForKey: @"viewed"] integerValue] == 1) {
    self.viewed = YES;
  }
  else {
    self.viewed = NO;
  }
}

- (Table *) tableToForward
{
  if (self.message) {
    return self.messageTable;
  }
  if (self.seat) {
    return self.seatTable;
  }
  if (self.table) {
    return self.table;
  }
  return nil;
}

@end
