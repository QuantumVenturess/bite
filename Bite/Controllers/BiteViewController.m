//
//  BiteViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 6/3/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteViewController.h"
#import "MenuBarButtonItem.h"
#import "UnviewedNewsConnection.h"
#import "User.h"

@implementation BiteViewController

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver: self
      selector: @selector(refreshUnviewedNewsCount)
        name: BiteAccessTokenReceivedNotification object: nil];
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  // Navigation item
  self.navigationItem.leftBarButtonItem = [[MenuBarButtonItem alloc] init];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];

  if ([User currentUser].biteAccessToken) {
    [self refreshUnviewedNewsCount];
  }
}

- (void) setTitle: (NSString *) title
{
  [super setTitle: title];
  UILabel *label = [[UILabel alloc] init];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont fontWithName: @"HelveticaNeue" size: 20];
  label.frame = CGRectMake(0, 0, 0, 44);
  label.shadowColor = [UIColor clearColor];
  label.shadowOffset = CGSizeMake(0, 0);
  label.text = title;
  label.textAlignment = NSTextAlignmentCenter;
  label.textColor = [UIColor whiteColor];
  [label sizeToFit];
  self.navigationItem.titleView = label;
}

#pragma mark - Methods

- (void) back
{
  [self.navigationController popViewControllerAnimated: YES];
}

- (void) refreshUnviewedNewsCount
{
  UnviewedNewsConnection *connection = 
    [[UnviewedNewsConnection alloc] init];
  [connection start];
}

@end
