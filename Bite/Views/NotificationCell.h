//
//  NotificationCell.h
//  Bite
//
//  Created by Tommy DANGerous on 6/4/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Notification;

@interface NotificationCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) Notification *notification;
@property (nonatomic, strong) UILabel *timestamp;

#pragma mark - Methods

- (void) animateBackgroundColor: (UIColor *) color;
- (void) loadNotificationData: (Notification *) notificationObject;

@end
