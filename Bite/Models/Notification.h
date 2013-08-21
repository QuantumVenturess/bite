//
//  Notification.h
//  Bite
//
//  Created by Tommy DANGerous on 6/4/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;
@class Seat;
@class Table;
@class User;

@interface Notification : NSObject

@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, strong) Message *message;
@property (nonatomic) int messageId;
@property (nonatomic, strong) Table *messageTable;
@property (nonatomic, strong) Seat *seat;
@property (nonatomic) int seatId;
@property (nonatomic, strong) Table *seatTable;
@property (nonatomic, strong) User *seatUser;
@property (nonatomic, strong) Table *table;
@property (nonatomic) int tableId;
@property (nonatomic) int uid;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic, strong) User *user;
@property (nonatomic) int userId;
@property (nonatomic) BOOL viewed;

#pragma mark - Methods

- (UIImage *) cellImage;
- (void) downloadImage: (void (^)(void)) block;
- (BOOL) hasImage;
- (NSString *) notificationContent;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (Table *) tableToForward;

@end
