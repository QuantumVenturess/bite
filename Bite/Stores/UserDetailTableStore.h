//
//  UserDetailTableStore.h
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class Table;
@class User;

@interface UserDetailTableStore : NSObject

@property (nonatomic, strong) NSMutableDictionary *userTables;
@property (nonatomic, weak) id viewController;

#pragma mark - Methods

- (void) addTable: (Table *) table forUser: (User *) user;
- (void) fetchTablesForPage: (NSUInteger) page forUser: (User *) user
withCompletion: (void (^) (NSError *error)) block;
- (void) readFromDictionary: (NSDictionary *) dictionary forUser: (User *) user;
- (NSArray *) sortedTablesByCreatedAtForUser: (User *) user;
- (NSArray *) sortedTablesByDateCompleteForUser: (User *) user;
- (NSArray *) sortedTablesByStartDateForUser: (User *) user;
- (NSArray *) tablesForUser: (User *) user;

@end
