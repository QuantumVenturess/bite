//
//  ImageDownloader.m
//  Bite
//
//  Created by Tommy DANGerous on 5/21/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "ImageDownloader.h"

@implementation ImageDownloader

@synthesize activeDownload;
@synthesize completionBlock;
@synthesize imageConnection;
@synthesize imageURL;

#pragma mark - Methods

- (void) cancelDownload
{
  [self.imageConnection cancel];

  self.activeDownload  = nil;
  self.imageConnection = nil;
}

- (void) startDownload
{
  self.activeDownload = [NSMutableData data];

  NSURLRequest *request = [NSURLRequest requestWithURL: self.imageURL];

  NSURLConnection *connection = 
    [[NSURLConnection alloc] initWithRequest: request delegate: self];

  self.imageConnection = connection;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connection: (NSURLConnection *) connection
didFailWithError: (NSError *) error
{
  // Clear the active download property to allow later attempts
  self.activeDownload  = nil;
  // Release the connection now that it's finished
  self.imageConnection = nil;
}

- (void) connection: (NSURLConnection *) connection 
didReceiveData: (NSData *) data
{
  [self.activeDownload appendData: data];
}

@end
