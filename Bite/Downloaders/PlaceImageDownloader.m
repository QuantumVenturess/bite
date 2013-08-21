//
//  PlaceImageDownloader.m
//  Bite
//
//  Created by Tommy DANGerous on 5/27/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Place.h"
#import "PlaceImageDownloader.h"
#import "UIImage+Resize.h"

@implementation PlaceImageDownloader

@synthesize place;

#pragma mark - Initializer

- (id) initWithPlace: (Place *) placeObject
{
  self = [super init];
  if (self) {
    self.place    = placeObject;
    self.imageURL = self.place.imageURL;
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // Set the place's image and clear temporary data/image
  self.place.image     = [[UIImage alloc] initWithData: self.activeDownload];
  self.activeDownload  = nil;
  self.imageConnection = nil;
  if (self.completionBlock) {
    self.completionBlock();
  }
}

@end
