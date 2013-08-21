//
//  BiteConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "User.h"

extern NSTimeInterval RequestTimeoutInterval;
extern NSMutableArray *sharedConnectionList;

@class BiteViewController;

@interface BiteConnection : NSObject
{
  NSMutableData *container;
  NSURLConnection *internalConnection;
}

@property (copy, nonatomic) void (^completionBlock) (NSError *error);
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic, weak) id delegate;
@property (copy, nonatomic) NSURLRequest *request;
@property (nonatomic, weak) BiteViewController *viewController;

#pragma mark Initializer

- (id) initWithRequest: (NSURLRequest *) req;

#pragma mark Methods

+ (void) clearConnections;

- (void) cancelConnection;
- (void) connectionDidFinishLoading: (NSURLConnection *) connection;
- (void) connection: (NSURLConnection *) connection
didReceiveData: (NSData *) data;
- (void) start;

@end
