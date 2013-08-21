//
//  AllTableStore.h
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Table;

@interface AllTableStore : NSObject

@property (nonatomic, strong) NSMutableDictionary *tables;

#pragma mark - Methods

+ (AllTableStore *) sharedStore;

- (void) addTable: (Table *) table;
- (void) clearTables;
- (void) removeTable: (Table *) table;
- (Table *) table: (int) uid;

@end
