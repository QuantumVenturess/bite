//
//  MessageViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiteViewController.h"

@class Table;
@class TableDetailViewController;

@interface MessageViewController : BiteViewController <UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, weak) Table *table;
@property (nonatomic, weak) TableDetailViewController *viewController;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject
viewController: (TableDetailViewController *) controller;

#pragma mark - Methods

- (void) cancel: (id) sender;
- (void) submit: (id) sender;

@end
