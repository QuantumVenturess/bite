//
//  UserConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BiteConnection.h"

@class User;

@interface UserConnection : BiteConnection

@property (nonatomic, weak) User *user;

#pragma mark - Initializer

- (id) initWithUser: (User *) userObject;

@end
