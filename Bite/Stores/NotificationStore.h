//
//  NotificationStore.h
//  Bite
//
//  Created by Tommy DANGerous on 6/4/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@class Notification;

@interface NotificationStore : NSObject

@property (nonatomic, strong) NSMutableArray *notifications;
@property (nonatomic, weak) id viewController;

#pragma mark - Methods

+ (NotificationStore *) sharedStore;

- (void) addNotification: (Notification *) notification;
- (void) clearNotifications;
- (void) fetchNotificationsForPage: (NSUInteger) page
withCompletion: (void (^) (NSError *error)) block;
- (void) markAllUnviewedNotificationsViewed;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (NSArray *) sortedNotificationsByCreatedAt;
- (NSArray *) unviewedNotifications;

@end
