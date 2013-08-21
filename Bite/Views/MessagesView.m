//
//  MessagesView.m
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "Message.h"
#import "MessagesView.h"
#import "MessageView.h"
#import "Table.h"
#import "UserDetailViewController.h"

@implementation MessagesView

@synthesize label;
@synthesize messages;
@synthesize table;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame table: (Table *) tableObject
{
  self = [super initWithFrame: frame];
  if (self) {
    self.table = tableObject;

    CGRect screen = [[UIScreen mainScreen] bounds];
    self.label = [[UILabel alloc] initWithFrame:
      CGRectMake(10, 0, (screen.size.width - 20), 36)];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
    self.label.lineBreakMode = NSLineBreakByTruncatingTail;
    self.label.text = @"Messages";
    self.label.textColor = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
      blue: (40/255.0) alpha: 1];
    [self addSubview: self.label];

    self.messages = [[UIView alloc] initWithFrame: CGRectMake(10, 0, 0, 0)];
    [self addSubview: self.messages];

    [self refreshData];
  }
  return self;
}

#pragma mark - Methods

- (void) refreshData
{
  // Clear all previous messages
  [self.messages.subviews makeObjectsPerformSelector: 
    @selector(removeFromSuperview)];
  CGRect screen = [[UIScreen mainScreen] bounds];
  float totalHeight = 0;
  for (Message *message in [self.table sortedMessages]) {
    MessageView *messageView = [[MessageView alloc] initWithFrame: 
      CGRectMake(10, totalHeight, (screen.size.width - 20), 55) 
        message: message];
    [messageView.userNameButton addTarget: self 
      action: @selector(showUserDetailViewController:) 
        forControlEvents: UIControlEventTouchUpInside];
    totalHeight += messageView.frame.size.height;
    [self.messages addSubview: messageView];
  }
  // Resize
  self.messages.frame = 
    CGRectMake(0, 36, (screen.size.width - 20), totalHeight);
  float newHeight = 0;
  for (UIView *view in self.subviews) {
    newHeight += view.frame.size.height;
  }
  self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 
    self.frame.size.width, newHeight);
}

- (void) showUserDetailViewController: (id) sender
{
  MessageView *messageView = (MessageView *) [sender superview];
  UserDetailViewController *userDetail = 
    [[UserDetailViewController alloc] initWithUser: messageView.message.user];
  AppDelegate *appDelegate = (AppDelegate *)
    [UIApplication sharedApplication].delegate;
  UINavigationController *navController = (UINavigationController *)
    appDelegate.tabBarController.selectedViewController;
  [navController pushViewController: userDetail animated: YES];
}

@end
