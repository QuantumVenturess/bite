//
//  Message.m
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AllTableStore.h"
#import "Message.h"
#import "Table.h"
#import "TableStore.h"
#import "User.h"
#import "UserStore.h"

@implementation Message

@synthesize content;
@synthesize createdAt;
@synthesize table;
@synthesize tableId;
@synthesize uid;
@synthesize user;
@synthesize userId;

#pragma mark - Protocol NSCopying

- (id) copyWithZone: (NSZone *) zone
{
  Message *message = [[Message alloc] init];
  message.content = self.content;
  message.createdAt = self.createdAt;
  message.table = self.table;
  message.tableId = self.tableId;
  message.uid = self.uid;
  message.user = self.user;
  message.userId = self.userId;
  
  return message;
}

#pragma mark - Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  self.content = [dictionary objectForKey: @"content"];
  self.createdAt = 
    [[[NSDate date] initWithString:
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  self.tableId = [[dictionary objectForKey: @"table_id"] integerValue];
  self.uid = [[dictionary objectForKey: @"id"] integerValue];
  self.userId = [[dictionary objectForKey: @"user_id"] integerValue];
  User *userObject = [[UserStore sharedStore] userForKey: self.userId];
  if (!userObject) {
    userObject = [[User alloc] init];
    [userObject readFromDictionary: [dictionary objectForKey: @"user"]];
  }
  self.user = userObject;
}

@end
