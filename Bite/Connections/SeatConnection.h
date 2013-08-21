//
//  SeatConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteConnection.h"

@class Table;

@interface SeatConnection : BiteConnection

@property (nonatomic, weak) Table *table;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject;

@end
