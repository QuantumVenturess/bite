//
//  UserSeat.h
//  Bite
//
//  Created by Tommy DANGerous on 5/23/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Seat;

@interface UserSeat : UIButton

@property (nonatomic, weak) Seat *seat;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame seat: (Seat *) seatObject;

@end
