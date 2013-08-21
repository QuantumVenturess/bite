//
//  Seat.h
//  Bite
//
//  Created by Tommy DANGerous on 5/20/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Table;
@class User;

@interface Seat : NSObject

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, weak) Table *table;
@property (nonatomic) int tableId;
@property (nonatomic) int uid;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, weak) User *user;
@property (nonatomic) int userId;

#pragma mark Methods

- (void) readFromDictionary: (NSDictionary *) dictionary;

@end
