//
//  Message.h
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Table;
@class User;

@interface Message : NSObject <NSCopying>

// attributes
@property (nonatomic, strong) NSString *content;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, weak) Table *table;
@property (nonatomic) int tableId;
@property (nonatomic) int uid;
@property (nonatomic, weak) User *user;
@property (nonatomic) int userId;

#pragma mark - Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
