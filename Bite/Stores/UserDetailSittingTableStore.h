//
//  UserDetailSittingTableStore.h
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailTableStore.h"

@interface UserDetailSittingTableStore : UserDetailTableStore

#pragma mark - Methods

+ (UserDetailSittingTableStore *) sharedStore;

@end
