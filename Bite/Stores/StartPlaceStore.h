//
//  StartPlaceStore.h
//  Bite
//
//  Created by Tommy DANGerous on 5/31/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartPlaceStore : NSObject

@property (nonatomic, strong) NSMutableArray *places;

#pragma mark - Methods

+ (StartPlaceStore *) sharedStore;

- (void) clearPlaces;

@end
