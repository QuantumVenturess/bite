//
//  NewMessageConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteConnection.h"

@class Message;

@interface NewMessageConnection : BiteConnection

@property (nonatomic, weak) Message *message;

#pragma mark - Initializer

- (id) initWithMessage: (Message *) messageObject;

@end
