//
//  YelpConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/31/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "OAuthConsumer.h"
#import "Place.h"
#import "StartPlaceStore.h"
#import "YelpConnection.h"

NSMutableArray *yelpConnectionList = nil;

@implementation YelpConnection

@synthesize completionBlock;
@synthesize consumer;
@synthesize limit;
@synthesize ll;
@synthesize location;
@synthesize realm;
@synthesize term;
@synthesize token;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.consumer = [[OAConsumer alloc] initWithKey: 
      @"oCdM9xNcKA_F483fK6jWFw" secret: 
        @"bWjkxPqXebFvCXPwImxUaJRee4k"];
    self.limit = 10;
    self.realm = nil;
    self.token = [[OAToken alloc] initWithKey: 
      @"Z00lrMFwppxUcD0Y2xLKBrxqQaS88cl4" secret: 
        @"WII0zh9ffeXNYKtQehG6CU5fKj4"];
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDataDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  NSDictionary *businesses = [json objectForKey: @"businesses"];
  if (businesses) {
    NSMutableArray *places = [NSMutableArray array];
    for (NSDictionary *placeDictionary in businesses) {
      Place *place = [[Place alloc] init];
      [place readFromYelpDictionary: placeDictionary];
      [places addObject: place];
    }
    [StartPlaceStore sharedStore].places = places;
  }
  if (self.completionBlock) {
    self.completionBlock(nil);
  }
  [yelpConnectionList removeObject: self];
  if (yelpConnectionList.count == 0) {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  }
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connection: (NSURLConnection *) connection
didReceiveData: (NSData *) data
{
  [container appendData: data];
}

- (void) connection: (NSURLConnection *) connection
didFailtWithError: (NSError *) error
{
  if (self.completionBlock) {
    self.completionBlock(error);
  }
  [yelpConnectionList removeObject: self];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark - Methods

- (void) cancel
{
  [internalConnection cancel];
}

- (void) start
{
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  NSString *requestString = [NSString stringWithFormat: 
    @"http://api.yelp.com/v2/search?"
    @"term=%@&"
    @"limit=%i",
    self.term, self.limit];
  if (self.ll) {
    requestString = [requestString stringByAppendingString: 
      [NSString stringWithFormat: @"&ll=%@", self.ll]];
  }
  else if (self.location) {
    requestString = [requestString stringByAppendingString: 
      [NSString stringWithFormat: @"&location=%@", self.location]];
  }
  requestString = [requestString stringByAddingPercentEscapesUsingEncoding: 
    NSUTF8StringEncoding];
  NSURL *url = [NSURL URLWithString: requestString];
  id <OASignatureProviding, NSObject> provider = 
    [[OAHMAC_SHA1SignatureProvider alloc] init];
  OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL: url
    consumer: self.consumer token: self.token realm: self.realm 
      signatureProvider: provider];
  [request prepare];
  container = [[NSMutableData alloc] init];
  internalConnection = [[NSURLConnection alloc] initWithRequest: 
    request delegate: self];
  if (!yelpConnectionList) {
    yelpConnectionList = [NSMutableArray array];
  }
  for (YelpConnection *yelpConn in yelpConnectionList) {
    [yelpConn cancel];
  }
  [yelpConnectionList addObject: self];
  [internalConnection start];
}

@end
