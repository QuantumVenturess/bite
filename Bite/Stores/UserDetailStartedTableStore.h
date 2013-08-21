//
//  UserDetailStartedTableStore.h
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailTableStore.h"

@interface UserDetailStartedTableStore : UserDetailTableStore

#pragma mark - Methods

+ (UserDetailStartedTableStore *) sharedStore;

@end
