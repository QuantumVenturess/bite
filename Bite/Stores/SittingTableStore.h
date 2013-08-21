//
//  SittingTableStore.h
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "TableStore.h"
#import "AppDelegate.h"

@interface SittingTableStore : TableStore

#pragma mark - Methods

+ (SittingTableStore *) sharedStore;

@end
