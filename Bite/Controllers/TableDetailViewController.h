//
//  TableDetailViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 5/22/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BiteViewController.h"

@class ExploreViewController;
@class MessagesView;
@class SittingViewController;
@class Table;

@interface TableDetailViewController : BiteViewController

@property (nonatomic, strong) UIBarButtonItem *composeBarButtonItem;
@property (nonatomic, weak) ExploreViewController *exploreViewController;
@property (nonatomic, strong) UIButton *joinTableButton;
@property (nonatomic, strong) UIView *joinTableView;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) UIButton *leaveTableButton;
@property (nonatomic, strong) UIView *leaveTableView;
@property (nonatomic, strong) MessagesView *messagesView;
@property (nonatomic, strong) UILabel *peopleSittingLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *seatView;
@property (nonatomic, weak) SittingViewController *sittingViewController;
@property (nonatomic, strong) UIButton *startDateButton;
@property (nonatomic, strong) NSMutableArray *subviews;
@property (nonatomic, strong) Table *table;
@property (nonatomic, strong) UIView *tableSeats;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject;

#pragma mark - Methods

- (void) changeStartDate: (id) sender;
- (void) joinTable: (id) sender;
- (void) leaveTable: (id) sender;
- (void) loadMessages;
- (void) loadSeats;
- (void) newMessage;
- (void) refreshData;
- (void) showUserDetailViewController: (id) sender;

@end
