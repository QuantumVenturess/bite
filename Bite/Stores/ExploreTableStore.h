//
//  ExploreTableStore.h
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "TableStore.h"

@class ExploreViewController;

@interface ExploreTableStore : TableStore

#pragma mark - Methods

+ (ExploreTableStore *) sharedStore;

@end
