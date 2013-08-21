//
//  Table.h
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

@class Message;
@class Place;
@class Seat;
@class User;

@interface Table : NSObject

// attributes
@property (nonatomic) BOOL complete;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) NSTimeInterval dateComplete;
@property (nonatomic) NSTimeInterval dateReady;
@property (nonatomic) int maxSeats;
@property (nonatomic, strong) Place *place;
@property (nonatomic) int placeId;
@property (nonatomic) BOOL ready;
@property (nonatomic) NSTimeInterval startDate;
@property (nonatomic) NSTimeInterval updatedAt;
@property (nonatomic) int uid;
@property (nonatomic, strong) User *user;
@property (nonatomic) int userId;
// relationships
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *seats;

#pragma mark - Methods

- (void) addMessage: (Message *) message;
- (void) addSeat: (Seat *) seat;
- (int) numberOfRows;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) removeMessage: (Message *) message;
- (void) removeSeat: (Seat *) seat;
- (void) removeSeatsInArray: (NSArray *) userIds;
- (Seat *) seatForUser: (User *) userObject;
- (void) sendPushNotification;
- (NSMutableArray *) sortedMessages;
- (NSString *) startDateStringLong;
- (NSString *) startDateStringShort;
- (void) subscribeToChannel;
- (void) unsubscribeToChannel;

@end
