//
//  MenuBarButtonItem.m
//  Bite
//
//  Created by Tommy DANGerous on 5/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuBarButtonItem.h"
#import "MenuView.h"
#import "TableStore.h"
#import "User.h"

@implementation MenuBarButtonItem

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    UIButton *menuView = [[UIButton alloc] initWithFrame: 
      CGRectMake(0, 0, 40, 23)];
    menuView.backgroundColor = [UIColor clearColor];
    menuView.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
    [menuView addTarget: self action: @selector(showMenu) 
      forControlEvents: UIControlEventTouchUpInside];
    [menuView setImage: [UIImage imageNamed: @"menu.png"]
      forState: UIControlStateNormal];
    self.customView = menuView;
  }
  return self;
}

#pragma mark - Methods

- (void) showMenu
{
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  [appDelegate.menuView showMenu];
}

@end
