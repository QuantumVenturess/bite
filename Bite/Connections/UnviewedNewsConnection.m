//
//  UnviewedNewsConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UnviewedNewsConnection.h"
#import "User.h"

@implementation UnviewedNewsConnection

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    NSString *requestString = [NSString stringWithFormat: 
      @"%@/news-unviewed.json?bite_access_token=%@",
        BiteApiURL, [User currentUser].biteAccessToken];
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL: url];
    [req setTimeoutInterval: RequestTimeoutInterval];
    self.request = req;
  }
  return self;
}

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  int count = [[json objectForKey: @"notifications_unviewed"] integerValue];
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  if (count > 0) {
    appDelegate.newsTabBarItem.badgeValue = [NSString stringWithFormat: 
      @"%i", count];
  }
  else {
    appDelegate.newsTabBarItem.badgeValue = nil;
  }

  [super connectionDidFinishLoading: connection];
}

@end
