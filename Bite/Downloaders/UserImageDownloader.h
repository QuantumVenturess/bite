//
//  UserImageDownloader.h
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "ImageDownloader.h"

@class User;

@interface UserImageDownloader : ImageDownloader

@property (nonatomic, weak) User *user;

#pragma mark - Initializer

- (id) initWithUser: (User *) userObject;

@end
