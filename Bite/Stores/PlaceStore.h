//
//  PlaceStore.h
//  Bite
//
//  Created by Tommy DANGerous on 5/31/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Place;

@interface PlaceStore : NSObject

@property (nonatomic, strong) NSMutableDictionary *places;

#pragma mark - Methods

+ (PlaceStore *) sharedStore;

- (void) addPlace: (Place *) place;
- (Place *) placeForYelpId: (NSString *) string;

@end
