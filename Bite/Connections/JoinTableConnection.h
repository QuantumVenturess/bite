//
//  JoinTableConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteConnection.h"

@class Seat;

@interface JoinTableConnection : BiteConnection

@property (nonatomic, weak) Seat *seat;

#pragma mark - Initializer

- (id) initWithSeat: (Seat *) seatObject;

@end
