//
//  BiteConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteConnection.h"
#import "BiteViewController.h"

NSTimeInterval RequestTimeoutInterval = 10;
NSMutableArray *sharedConnectionList = nil;

@implementation BiteConnection

@synthesize completionBlock;
@synthesize createdAt;
@synthesize delegate;
@synthesize request;
@synthesize viewController;

#pragma mark - Initializer

- (id) init
{
  return [self initWithRequest: nil];
}

- (id) initWithRequest: (NSURLRequest *) req
{
  self = [super init];
  if (self) {
    self.createdAt = [[NSDate date] timeIntervalSince1970];
    self.request   = req;
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  if (self.completionBlock) {
    self.completionBlock(nil);
  }
  [sharedConnectionList removeObject: self];
  NSMutableArray *connectionsToRemove = [NSMutableArray array];
  for (BiteConnection *biteConnection in sharedConnectionList) {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - biteConnection.createdAt > 5) {
      [biteConnection cancelConnection];
      [connectionsToRemove addObject: biteConnection];
    }
  }
  for (BiteConnection *biteConnection in connectionsToRemove) {
    [sharedConnectionList removeObject: biteConnection];
  }
  if (sharedConnectionList.count == 0) {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }
}

- (void) connection: (NSURLConnection *) connection
didReceiveData: (NSData *) data
{
  [container appendData: data];
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connection: (NSURLConnection *) connection
didFailWithError: (NSError *) error
{
  if (self.completionBlock) {
    self.completionBlock(error);
  }
  [sharedConnectionList removeObject: self];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark Methods

+ (void) clearConnections
{
  if (sharedConnectionList) {
    for (BiteConnection *connection in sharedConnectionList) {
      [connection cancelConnection];
    }
    [sharedConnectionList removeAllObjects];
  }
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void) cancelConnection
{
  [internalConnection cancel];
}

- (void) start
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  container = [[NSMutableData alloc] init];
  internalConnection = [[NSURLConnection alloc] initWithRequest: self.request 
    delegate: self startImmediately: YES];
  if (!sharedConnectionList) {
    sharedConnectionList = [NSMutableArray array];
  }
  [sharedConnectionList addObject: self];
}

@end
