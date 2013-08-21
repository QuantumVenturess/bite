//
//  MessageViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MenuBarButtonItem.h"
#import "Message.h"
#import "MessageViewController.h"
#import "NewMessageConnection.h"
#import "Table.h"
#import "TableDetailViewController.h"
#import "User.h"

@implementation MessageViewController

@synthesize contentTextView;
@synthesize table;
@synthesize viewController;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject
viewController: (TableDetailViewController *) controller
{
  self = [super init];
  if (self) {
    self.table = tableObject;
    self.title = @"New Message";
    self.trackedViewName = self.title;
    self.viewController = controller;
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  // Navigation item
  CGRect buttonFrame = CGRectMake(0, 0, 50, 28);
  UIColor *gray40 = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
    blue: (40/255.0) alpha: 1];
  // cancel
  UILabel *cancelLabel = [[UILabel alloc] init];
  cancelLabel.backgroundColor = [UIColor clearColor];
  cancelLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  cancelLabel.frame = CGRectMake(5, 0, 45, 28);
  cancelLabel.text = @"Cancel";
  cancelLabel.textAlignment = NSTextAlignmentLeft;
  cancelLabel.textColor = [UIColor whiteColor];
  cancelLabel.layer.cornerRadius = 2;
  cancelLabel.layer.masksToBounds = YES;
  UIButton *cancelButton = [[UIButton alloc] init];
  cancelButton.frame = buttonFrame;
  [cancelButton addTarget: self action: @selector(cancel:) 
    forControlEvents: UIControlEventTouchUpInside];
  [cancelButton addSubview: cancelLabel];
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: cancelButton];
  // submit
  UILabel *submitLabel = [[UILabel alloc] init];
  submitLabel.backgroundColor = [UIColor clearColor];
  submitLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  submitLabel.frame = CGRectMake(0, 0, 45, 28);
  submitLabel.text = @"Submit";
  submitLabel.textAlignment = NSTextAlignmentRight;
  submitLabel.textColor = [UIColor whiteColor];
  submitLabel.layer.cornerRadius = 2;
  submitLabel.layer.masksToBounds = YES;
  UIButton *submitButton = [[UIButton alloc] init];
  submitButton.frame = buttonFrame;
  [submitButton addTarget: self action: @selector(submit:) 
    forControlEvents: UIControlEventTouchUpInside];
  [submitButton addSubview: submitLabel];
  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: submitButton];

  // Main view
  CGRect screen = [[UIScreen mainScreen] bounds];
  UIView *mainView = [[UIView alloc] initWithFrame: screen];
  mainView.backgroundColor = [UIColor backgroundColor];
  self.view = mainView;

  // Text field
  self.contentTextView = [[UITextView alloc] init];
  self.contentTextView.delegate = self;
  self.contentTextView.frame = CGRectMake(10, 10, 
    (screen.size.width - 20), 100);
  self.contentTextView.font = [UIFont fontWithName: @"HelveticaNeue" size: 15];
  self.contentTextView.textColor = gray40;
  self.contentTextView.layer.borderWidth = 1.0f;
  self.contentTextView.layer.borderColor = [UIColor colorWithRed: (160/255.0)
    green: (160/255.0) blue: (160/255.0) alpha: 1].CGColor;
  [self.view addSubview: self.contentTextView];
}

- (void) viewDidLoad
{
  [self.contentTextView becomeFirstResponder];
}

#pragma mark - Protocol UITextViewDelegate

- (void) textViewDidChange: (UITextView *) textView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGSize size = [self.contentTextView.text sizeWithFont: 
    self.contentTextView.font constrainedToSize: 
      CGSizeMake((screen.size.width - 20), 250) lineBreakMode: 
        NSLineBreakByWordWrapping];
  if (size.height > 100) {
    self.contentTextView.frame = CGRectMake(10, 10, (screen.size.width - 20), 
      (size.height + 15));
  }
}

#pragma mark - Methods

- (void) cancel: (id) sender
{
  [self dismissViewControllerAnimated: YES completion: nil];
  [self.contentTextView resignFirstResponder];
}

- (void) submit: (id) sender
{
  NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  NSString *content = 
    [self.contentTextView.text stringByTrimmingCharactersInSet: set];
  if (content.length > 0) {
    int lastId;
    NSSortDescriptor *uid = 
      [NSSortDescriptor sortDescriptorWithKey: @"uid" ascending: NO];
    NSArray *array = [self.table.messages sortedArrayUsingDescriptors:
      [NSArray arrayWithObject: uid]];
    if (array.count > 0) {
      Table *firstObject = [array objectAtIndex: 0];
      lastId = firstObject.uid;
    }
    else {
      lastId = 0;
    }

    Message *message = [[Message alloc] init];
    message.content = content;
    message.createdAt = [[NSDate date] timeIntervalSince1970];
    message.table = self.table;
    message.tableId = self.table.uid;
    message.uid = lastId + 10001;
    message.user = [User currentUser];
    message.userId = message.user.uid;
    [self.table addMessage: message];
    [self cancel: nil];
    // Send message data to server
    NewMessageConnection *connection = 
      [[NewMessageConnection alloc] initWithMessage: message];
    connection.completionBlock = 
      ^(NSError *error) {
        if (!error) {
          [self.viewController loadMessages];
        }
      };
    [connection start];
  }
}

@end
