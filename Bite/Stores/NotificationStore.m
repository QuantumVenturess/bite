//
//  NotificationStore.m
//  Bite
//
//  Created by Tommy DANGerous on 6/4/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "NewsConnection.h"
#import "Notification.h"
#import "NotificationStore.h"
#import "User.h"

@implementation NotificationStore

@synthesize notifications;
@synthesize viewController;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.notifications = [NSMutableArray array];
  }
  return self;
}

#pragma mark - Methods

+ (NotificationStore *) sharedStore
{
  static NotificationStore *store = nil;
  if (!store) {
    store = [[NotificationStore alloc] init];
  }
  return store;
}

- (void) addNotification: (Notification *) notification
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"uid", notification.uid];
  if ([self.notifications filteredArrayUsingPredicate: predicate].count == 0) {
    [self.notifications addObject: notification];
  }
  else {
    NSUInteger index = [self.notifications indexOfObjectPassingTest: 
      ^BOOL (id obj, NSUInteger idx, BOOL *stop) {
        NSString *n1 = [NSString stringWithFormat: @"%i", 
          [(Notification *) obj uid]];
        NSString *n2 = [NSString stringWithFormat: @"%i", notification.uid];
        if ([n1 isEqualToString: n2]) {
          *stop = YES;
          return YES;
        }
        else {
          return NO;
        }
      }
    ];
    if (index != NSNotFound) {
      Notification *object = [self.notifications objectAtIndex: index];
      object.viewed = notification.viewed;
    }
  }
}

- (void) clearNotifications
{
  [self.notifications removeAllObjects];
}

- (void) fetchNotificationsForPage: (NSUInteger) page
withCompletion: (void (^) (NSError *error)) block
{
  NSString *requestString = [NSString stringWithFormat:
    @"%@/news.json?p=%i&bite_access_token=%@",
      BiteApiURL, page, [User currentUser].biteAccessToken];
  NSURL *url = [NSURL URLWithString: requestString];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
  [request setTimeoutInterval: RequestTimeoutInterval];

  NewsConnection *connection = 
    [[NewsConnection alloc] initWithRequest: request];
  connection.completionBlock = block;
  connection.delegate        = self;
  connection.viewController  = self.viewController;
  [connection start];
}

- (void) markAllUnviewedNotificationsViewed
{
  for (Notification *notification in [self unviewedNotifications]) {
    notification.viewed = YES;
  }
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  for (NSDictionary *notificationDictionary in dictionary) {
    Notification *notification = [[Notification alloc] init];
    [notification readFromDictionary: notificationDictionary];
    [self addNotification: notification];
  }
}

- (NSArray *) sortedNotificationsByCreatedAt
{
  NSSortDescriptor *created = 
    [NSSortDescriptor sortDescriptorWithKey: @"createdAt" ascending: NO];
  return [self.notifications sortedArrayUsingDescriptors: 
    [NSArray arrayWithObject: created]];
}

- (NSArray *) unviewedNotifications
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat: 
    @"%K == %@", @"viewed", [NSNumber numberWithBool: NO]];
  return [self.notifications filteredArrayUsingPredicate: predicate];
}

@end
