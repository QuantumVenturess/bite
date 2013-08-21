//
//  UserStatsConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 6/10/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteConnection.h"

@class User;

@interface UserStatsConnection : BiteConnection

@property (nonatomic, weak) User *user;

#pragma mark - Initializer

- (id) initWithUser: (User *) userObject;

@end
