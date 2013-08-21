//
//  MessageConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteConnection.h"

@class Table;

@interface MessageConnection : BiteConnection

@property (nonatomic, weak) Table *table;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject;

@end
