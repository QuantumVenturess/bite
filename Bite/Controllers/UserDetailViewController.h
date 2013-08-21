//
//  UserDetailViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteTableViewController.h"

@class User;

typedef enum UserDetailTabSelected: NSInteger UserDetailTabSelected;

@interface UserDetailViewController : BiteTableViewController
{
  UserDetailTabSelected userDetailTabSelected;
}

@property (nonatomic, strong) UILabel *completeCountLabel;
@property (nonatomic) int completeCurrentPage;
@property (nonatomic, strong) UILabel *completeLabel;
@property (nonatomic) int completeMaxPages;
@property (nonatomic, strong) UIButton *completeStatsButton;
@property (nonatomic, strong) UITableView *completeTableView;

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UILabel *sittingCountLabel;
@property (nonatomic) int sittingCurrentPage;
@property (nonatomic, strong) UILabel *sittingLabel;
@property (nonatomic) int sittingMaxPages;
@property (nonatomic, strong) UIButton *sittingStatsButton;
@property (nonatomic, strong) UITableView *sittingTableView;

@property (nonatomic, strong) UILabel *startedCountLabel;
@property (nonatomic) int startedCurrentPage;
@property (nonatomic, strong) UILabel *startedLabel;
@property (nonatomic) int startedMaxPages;
@property (nonatomic, strong) UIButton *startedStatsButton;
@property (nonatomic, strong) UITableView *startedTableView;

@property (nonatomic, strong) UIView *tabUnderline;
@property (nonatomic, strong) User *user;

#pragma mark - Initializer

- (id) initWithUser: (User *) userObject;

#pragma mark - Methods

- (void) changeSelectedTab;
- (void) changeTab: (id) sender;
- (int) currentCurrentPage;
- (int) currentMaxPages;
- (void) reloadAllTableViewData;

@end
