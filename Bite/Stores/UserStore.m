//
//  UserStore.m
//  Bite
//
//  Created by Tommy DANGerous on 5/21/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "User.h"
#import "UserStore.h"

@implementation UserStore

@synthesize users;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.users = [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - Methods

+ (UserStore *) sharedStore
{
  static UserStore *store = nil;
  if (!store) {
    store = [[UserStore alloc] init];
  }
  return store;
}

- (void) addUser: (User *) user
{
  [self.users setObject: user 
    forKey: [NSString stringWithFormat: @"%i", user.uid]];
}

- (void) clearUsers
{
  [self.users removeAllObjects];
}

- (User *) userForKey: (int) uid
{
  return [self.users objectForKey: [NSString stringWithFormat: @"%i", uid]];
}

@end
