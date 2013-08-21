//
//  UserImageDownloader.m
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "User.h"
#import "UserImageDownloader.h"

@implementation UserImageDownloader

@synthesize user;

#pragma mark - Initializer

- (id) initWithUser: (User *) userObject
{
  self = [super init];
  if (self) {
    self.user     = userObject;
    self.imageURL = self.user.imageURL;
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  // Set image and clear temprary data/image
  UIImage *image = [[UIImage alloc] initWithData: self.activeDownload];
  self.user.image = image;
  self.activeDownload  = nil;
  self.imageConnection = nil;
  if (self.completionBlock) {
    self.completionBlock();
  }
}

@end
