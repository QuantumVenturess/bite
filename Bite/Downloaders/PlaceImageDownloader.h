//
//  PlaceImageDownloader.h
//  Bite
//
//  Created by Tommy DANGerous on 5/27/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "ImageDownloader.h"

@class Place;

@interface PlaceImageDownloader : ImageDownloader

@property (nonatomic, strong) Place *place;

#pragma mark - Initializer

- (id) initWithPlace: (Place *) placeObject;

@end
