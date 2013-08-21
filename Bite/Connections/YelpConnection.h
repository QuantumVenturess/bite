//
//  YelpConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 5/31/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSMutableArray *yelpConnectionList;

@class OAConsumer;
@class OAToken;

@interface YelpConnection : NSObject
{
  NSMutableData *container;
  NSURLConnection *internalConnection;
}

@property (nonatomic, copy) void (^completionBlock) (NSError *error);
@property (nonatomic, strong) OAConsumer *consumer;
@property (nonatomic) int limit;
@property (nonatomic, strong) NSString *ll;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *realm;
@property (nonatomic, strong) NSString *term;
@property (nonatomic, strong) OAToken *token;

#pragma mark - Methods

- (void) cancel;
- (void) start;

@end
