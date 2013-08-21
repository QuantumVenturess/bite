//
//  TableConnection.m
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteTableViewController.h"
#import "TableConnection.h"
#import "TableStore.h"

NSString *const TableDataReceivedNotification = 
  @"TableDataReceivedNotification";

@implementation TableConnection

#pragma mark - Protocol NSURLConnectionDelegate

- (void) connectionDidFinishLoading: (NSURLConnection *) connection
{
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData: container
    options: 0 error: nil];
  // Set the max pages for the view controller asking for tables
  int maxPages = [[json objectForKey: @"pages"] integerValue];
  if (maxPages == 0) {
    maxPages = 1;
  }
  [(BiteTableViewController *) self.viewController setMaxPages: maxPages];
  if ([[json objectForKey: @"tables_to_remove"] count] > 0) {
    [self.delegate tablesToRemove: [json objectForKey: @"tables_to_remove"]];
  }
  // Read tables from json and add it to the TableStore
  [self.delegate readFromDictionary: [json objectForKey: @"tables"]];
  
  [super connectionDidFinishLoading: connection];
}

@end
