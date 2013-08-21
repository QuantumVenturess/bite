//
//  ClearNewsConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "ClearNewsConnection.h"
#import "NewsViewController.h"
#import "NotificationStore.h"

@implementation ClearNewsConnection

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    NSString *requestString = [NSString stringWithFormat: 
      @"%@/clear-news?bite_access_token=%@",
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
  AppDelegate *appDelegate = (AppDelegate *)
    [UIApplication sharedApplication].delegate;
  appDelegate.newsTabBarItem.badgeValue = nil;

  [super connectionDidFinishLoading: connection];
}

@end
