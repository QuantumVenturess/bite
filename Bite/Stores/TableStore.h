//
//  TableStore.h
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class Table;

@interface TableStore : NSObject

@property (nonatomic, strong) NSMutableArray *tables;
@property (nonatomic, strong) NSMutableArray *tablesToKeep;
@property (nonatomic, weak) id viewController;

#pragma mark - Methods Fetch

- (void) cleanTablesForPage: (NSUInteger) page
withCompletion: (void (^) (NSError *error)) block;
- (void) fetchTablesForPage: (NSUInteger) page 
withCompletion: (void (^) (NSError *error)) block;

#pragma mark - Methods

- (void) addTable: (Table *) table;
- (void) clearTables;
- (void) keepTablesInTableIdArray;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) removeTable: (Table *) tableObject;
- (NSArray *) sortedTablesByCreatedAt;
- (NSArray *) sortedTablesByStartDate;
- (void) tablesToRemove: (NSArray *) array;

@end
