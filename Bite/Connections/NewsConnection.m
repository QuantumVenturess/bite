//
//  NewsConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/4/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteTableViewController.h"
#import "NewsConnection.h"
#import "NotificationStore.h"

@implementation NewsConnection

@synthesize delegate;
@synthesize viewController;

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  int maxPages = [[json objectForKey: @"pages"] integerValue];
  if (maxPages == 0) {
    maxPages = 1;
  }
  [(BiteTableViewController *) self.viewController setMaxPages: maxPages];
  [self.delegate readFromDictionary: [json objectForKey: @"notifications"]];

  [super connectionDidFinishLoading: connection];
}

@end
