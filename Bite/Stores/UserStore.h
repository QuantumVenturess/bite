//
//  UserStore.h
//  Bite
//
//  Created by Tommy DANGerous on 5/21/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface UserStore : NSObject

@property (nonatomic, strong) NSMutableDictionary *users;

#pragma mark - Methods

+ (UserStore *) sharedStore;

- (void) addUser: (User *) user;
- (void) clearUsers;
- (User *) userForKey: (int) uid;

@end
