//
//  Seat.m
//  Bite
//
//  Created by Tommy DANGerous on 5/20/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AllTableStore.h"
#import "Seat.h"
#import "Table.h"
#import "User.h"
#import "UserStore.h"

@implementation Seat

@synthesize createdAt;
@synthesize table;
@synthesize tableId;
@synthesize uid;
@synthesize updatedAt;
@synthesize user;
@synthesize userId;

#pragma mark Methods

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  self.createdAt = [[[NSDate date] initWithString: 
    [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  self.tableId = [[dictionary objectForKey: @"table_id"] integerValue];
  self.uid = [[dictionary objectForKey: @"id"] integerValue];
  self.updatedAt = [[[NSDate date] initWithString: 
    [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
  self.userId = [[dictionary objectForKey: @"user_id"] integerValue];
  // User
  User *newUser = [[UserStore sharedStore] userForKey: self.userId];
  if (!newUser) {
    newUser = [[User alloc] init];
    [newUser readFromDictionary: [dictionary objectForKey: @"user"]];
    [[UserStore sharedStore] addUser: newUser];
  }
  self.user = newUser;
}

@end
