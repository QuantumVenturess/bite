//
//  UserDetailViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TableDetailViewController.h"
#import "UIColor+Extensions.h"
#import "User.h"
#import "UserDetailCompleteTableCell.h"
#import "UserDetailCompleteTableStore.h"
#import "UserDetailSittingTableCell.h"
#import "UserDetailSittingTableStore.h"
#import "UserDetailStartedTableCell.h"
#import "UserDetailStartedTableStore.h"
#import "UserDetailTableCell.h"
#import "UserDetailViewController.h"
#import "UserStatsConnection.h"

enum UserDetailTabSelected: NSInteger {
  UserDetailTabStarted,
  UserDetailTabSitting,
  UserDetailTabComplete
};

@implementation UserDetailViewController

@synthesize completeCountLabel;
@synthesize completeCurrentPage;
@synthesize completeLabel;
@synthesize completeMaxPages;
@synthesize completeStatsButton;
@synthesize completeTableView;

@synthesize infoView;

@synthesize sittingCountLabel;
@synthesize sittingCurrentPage;
@synthesize sittingLabel;
@synthesize sittingMaxPages;
@synthesize sittingStatsButton;
@synthesize sittingTableView;

@synthesize startedCountLabel;
@synthesize startedCurrentPage;
@synthesize startedLabel;
@synthesize startedMaxPages;
@synthesize startedStatsButton;
@synthesize startedTableView;

@synthesize tabUnderline;
@synthesize user;

#pragma mark - Initializer

- (id) initWithUser: (User *) userObject
{
  self = [super init];
  if (self) {
    self.user  = userObject;
    self.title = self.user.name;
    self.trackedViewName = @"User Detail";

    self.completeCurrentPage = self.completeMaxPages = 1;
    self.sittingCurrentPage  = self.sittingMaxPages  = 1;
    self.startedCurrentPage  = self.startedMaxPages  = 1;
    userDetailTabSelected = UserDetailTabSitting;
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  // Navigation item, back button
  UIImage *backButtonImage = [UIImage imageNamed: @"back.png"];
  UIButton *backButton = [UIButton buttonWithType: UIButtonTypeCustom];
  backButton.frame = CGRectMake(0, 0, backButtonImage.size.width + 16,
    backButtonImage.size.height);
  [backButton addTarget: self action: @selector(back) 
    forControlEvents: UIControlEventTouchUpInside];
  [backButton setImage: backButtonImage forState: UIControlStateNormal];
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: backButton];

  // Screen
  CGRect screen = [[UIScreen mainScreen] bounds];
  // Colors
  UIColor *gray40 = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
    blue: (40/255.0) alpha: 1];
  UIColor *gray160 = [UIColor colorWithRed: (160/255.0) green: (160/255.0) 
    blue: (160/255.0) alpha: 1];
  UIColor *gray235 = [UIColor colorWithRed: (235/255.0) green: (235/255.0) 
    blue: (235/255.0) alpha: 1];
  UIColor *gray245 = [UIColor colorWithRed: (245/255.0) green: (245/255.0) 
    blue: (245/255.) alpha: 1];

  // Tables
  // complete
  self.completeTableView = [[UITableView alloc] init];
  self.completeTableView.backgroundColor = [UIColor backgroundColor];
  self.completeTableView.frame = screen;
  self.completeTableView.separatorColor = [UIColor gray: 120];
  self.completeTableView.showsVerticalScrollIndicator = NO;
  // sitting
  self.sittingTableView = [[UITableView alloc] init];
  self.sittingTableView.backgroundColor = [UIColor backgroundColor];
  self.sittingTableView.frame = screen;
  self.sittingTableView.separatorColor = [UIColor gray: 120];
  self.sittingTableView.showsVerticalScrollIndicator = NO;
  // sitting
  self.startedTableView = [[UITableView alloc] init];
  self.startedTableView.backgroundColor = [UIColor backgroundColor];
  self.startedTableView.frame = screen;
  self.startedTableView.separatorColor = [UIColor gray: 120];
  self.startedTableView.showsVerticalScrollIndicator = NO;

  self.sittingTableView.dataSource = self;
  self.sittingTableView.delegate = self;
  self.view = self.sittingTableView;

  // Add spinner
  self.spinner = [[UIActivityIndicatorView alloc] init];
  self.spinner.activityIndicatorViewStyle = 
    UIActivityIndicatorViewStyleWhiteLarge;
  self.spinner.color = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.7];
  self.spinner.frame = CGRectMake((screen.size.width / 2.0), 
    (screen.size.height - 160), 0, 0);
  self.spinner.hidesWhenStopped = YES;
  [self.view addSubview: self.spinner];

  // Add refresh control
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.attributedTitle = 
    [[NSAttributedString alloc] initWithString: @"Pull down to refresh"];
  self.refreshControl.tintColor = [UIColor colorWithRed: (207/255.0)
    green: (4/255.0) blue: (4/255.0) alpha: 1];
  [self.refreshControl addTarget: self action: @selector(refreshTable)
    forControlEvents: UIControlEventValueChanged];
  [self.view addSubview: self.refreshControl];

  // Info view
  self.infoView = [[UIView alloc] init];
  self.infoView.backgroundColor = gray235;
  self.infoView.frame = CGRectMake(0, 0, screen.size.width, 170);
  // User image
  UIImageView *userImageView = [[UIImageView alloc] init];
  userImageView.clipsToBounds = YES;
  userImageView.contentMode = UIViewContentModeTopLeft;
  userImageView.frame = CGRectMake(10, 20, 60, 60);
  if (self.user.image) {
    userImageView.image = [self.user image60By60];
  }
  else {
    [self.user downloadImage:
      ^(void) {
        userImageView.image = [self.user image60By60];
      }
    ];
  }
  [self.infoView addSubview: userImageView];
  // User name
  // first name
  UILabel *firstNameLabel = [[UILabel alloc] init];
  firstNameLabel.backgroundColor = [UIColor clearColor];
  firstNameLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 18];
  firstNameLabel.frame = CGRectMake((10 + 60 + 20), 20,
    (screen.size.width - (10 + 60 + 20 + 10)), 30);
  firstNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  firstNameLabel.text = self.user.firstName;
  firstNameLabel.textColor = gray40;
  [self.infoView addSubview: firstNameLabel];
  // last name
  UILabel *lastNameLabel = [[UILabel alloc] init];
  lastNameLabel.backgroundColor = [UIColor clearColor];
  lastNameLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 18];
  lastNameLabel.frame = CGRectMake((10 + 60 + 20), (20 + 30),
    (screen.size.width - (10 + 60 + 20 + 10)), 30);
  lastNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  lastNameLabel.text = self.user.lastName;
  lastNameLabel.textColor = gray40;
  [self.infoView addSubview: lastNameLabel];
  // User stats
  UIFont *fontCount = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 14];
  UIFont *fontLabel = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  UIView *statsView = [[UIView alloc] init];
  statsView.frame = CGRectMake(0, 100, screen.size.width, 50);
  CALayer *topBorder = [CALayer layer];
  topBorder.frame = CGRectMake(0, 0, screen.size.width, 1);
  topBorder.backgroundColor = gray245.CGColor;
  [statsView.layer addSublayer: topBorder];
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.frame = CGRectMake(0, 49, screen.size.width, 1);
  bottomBorder.backgroundColor = gray245.CGColor;
  [statsView.layer addSublayer: bottomBorder];
  [self.infoView addSubview: statsView];

  // Started stats
  self.startedStatsButton = [[UIButton alloc] init];
  self.startedStatsButton.frame = CGRectMake(0, 0, 
    (screen.size.width / 3.0), 50);
  self.startedStatsButton.tag = 0;
  [self.startedStatsButton addTarget: self action: @selector(changeTab:)
    forControlEvents: UIControlEventTouchUpInside];
  [statsView addSubview: self.startedStatsButton];
  // started count label
  self.startedCountLabel = [[UILabel alloc] init];
  self.startedCountLabel.backgroundColor = [UIColor clearColor];
  self.startedCountLabel.font = fontCount;
  self.startedCountLabel.frame = CGRectMake(0, 6, 
    (self.startedStatsButton.frame.size.width), 19);
  self.startedCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.startedCountLabel.text = [NSString stringWithFormat: @"%i",
    self.user.startedCount];
  self.startedCountLabel.textAlignment = NSTextAlignmentCenter;
  self.startedCountLabel.textColor = gray160;
  [self.startedStatsButton addSubview: self.startedCountLabel];
  // started label
  self.startedLabel = [[UILabel alloc] init];
  self.startedLabel.backgroundColor = [UIColor clearColor];
  self.startedLabel.font = fontLabel;
  self.startedLabel.frame = CGRectMake(0, (6 + 19), 
    (self.startedStatsButton.frame.size.width), 19);
  self.startedLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.startedLabel.text = @"Started";
  self.startedLabel.textAlignment = NSTextAlignmentCenter;
  self.startedLabel.textColor = gray160;
  [self.startedStatsButton addSubview: self.startedLabel];

  // Sitting stats
  self.sittingStatsButton = [[UIButton alloc] init];
  self.sittingStatsButton.frame = CGRectMake((screen.size.width / 3.0), 0, 
    (screen.size.width / 3.0), 50);
  self.sittingStatsButton.tag = 1;
  [self.sittingStatsButton addTarget: self action: @selector(changeTab:)
    forControlEvents: UIControlEventTouchUpInside];
  CALayer *sittingLeftBorder = [CALayer layer];
  sittingLeftBorder.frame = CGRectMake(0, 0, 1, 50);
  sittingLeftBorder.backgroundColor = gray245.CGColor;
  [self.sittingStatsButton.layer addSublayer: sittingLeftBorder];
  CALayer *sittingRightBorder = [CALayer layer];
  sittingRightBorder.frame = 
    CGRectMake((self.sittingStatsButton.frame.size.width - 1), 0, 1, 50);
  sittingRightBorder.backgroundColor = gray245.CGColor;
  [self.sittingStatsButton.layer addSublayer: sittingRightBorder];
  [statsView addSubview: self.sittingStatsButton];
  // sitting count label
  self.sittingCountLabel = [[UILabel alloc] init];
  self.sittingCountLabel.backgroundColor = [UIColor clearColor];
  self.sittingCountLabel.font = fontCount;  
  self.sittingCountLabel.frame = CGRectMake(0, 6, 
    (self.sittingStatsButton.frame.size.width), 19);
  self.sittingCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.sittingCountLabel.text = [NSString stringWithFormat: @"%i",
    self.user.sittingCount];
  self.sittingCountLabel.textAlignment = NSTextAlignmentCenter;
  self.sittingCountLabel.textColor = [UIColor gray: 40];
  [self.sittingStatsButton addSubview: self.sittingCountLabel];
  // sitting label
  self.sittingLabel = [[UILabel alloc] init];
  self.sittingLabel.backgroundColor = [UIColor clearColor];
  self.sittingLabel.font = fontLabel;  
  self.sittingLabel.frame = CGRectMake(0, (6 + 19), 
    (self.sittingStatsButton.frame.size.width), 19);
  self.sittingLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.sittingLabel.text = @"Sitting";
  self.sittingLabel.textAlignment = NSTextAlignmentCenter;
  self.sittingLabel.textColor = [UIColor gray: 40];
  [self.sittingStatsButton addSubview: self.sittingLabel];

  // Complete stats
  self.completeStatsButton = [[UIButton alloc] init];
  self.completeStatsButton.frame = CGRectMake(((screen.size.width / 3.0) * 2), 
    0, (screen.size.width / 3.0), 50);
  self.completeStatsButton.tag = 2;
  [self.completeStatsButton addTarget: self action: @selector(changeTab:)
    forControlEvents: UIControlEventTouchUpInside];
  [statsView addSubview: self.completeStatsButton];
  // complete count label
  self.completeCountLabel = [[UILabel alloc] init];
  self.completeCountLabel.backgroundColor = [UIColor clearColor];
  self.completeCountLabel.font = fontCount;
  self.completeCountLabel.frame = CGRectMake(0, 6, 
    (self.completeStatsButton.frame.size.width), 19);
  self.completeCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.completeCountLabel.text = [NSString stringWithFormat: @"%i",
    self.user.completeCount];
  self.completeCountLabel.textAlignment = NSTextAlignmentCenter;
  self.completeCountLabel.textColor = gray160;
  [self.completeStatsButton addSubview: self.completeCountLabel];
  // complete label
  self.completeLabel = [[UILabel alloc] init];
  self.completeLabel.backgroundColor = [UIColor clearColor];
  self.completeLabel.font = fontLabel;  
  self.completeLabel.frame = CGRectMake(0, (6 + 19), 
    (self.completeStatsButton.frame.size.width), 19);
  self.completeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.completeLabel.text = @"Complete";
  self.completeLabel.textAlignment = NSTextAlignmentCenter;
  self.completeLabel.textColor = gray160;
  [self.completeStatsButton addSubview: self.completeLabel];

  // Add info view to all table header views
  // self.completeTableView.tableHeaderView = self.infoView;;
  self.sittingTableView.tableHeaderView  = self.infoView;
  // self.startedTableView.tableHeaderView  = self.infoView;

  // Tab underline for selected tab
  self.tabUnderline = [[UIView alloc] init];
  self.tabUnderline.backgroundColor = [UIColor darkRed];
  self.tabUnderline.frame = CGRectMake((screen.size.width / 3.0), 149,
    (screen.size.width / 3.0), 1);
  [self.infoView addSubview: self.tabUnderline];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  [self reloadAllTableViewData];
  // Load user's stats
  UserStatsConnection *userStatsConnection = 
    [[UserStatsConnection alloc] initWithUser: self.user];
  userStatsConnection.completionBlock = ^(NSError *error) {
    if (!error) {
      self.completeCountLabel.text = [NSString stringWithFormat: @"%i", 
        self.user.completeCount];
      self.sittingCountLabel.text = [NSString stringWithFormat: @"%i", 
        self.user.sittingCount];
      self.startedCountLabel.text = [NSString stringWithFormat: @"%i",
        self.user.startedCount];
    }
  };
  [userStatsConnection start];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"UserDetailTableCell";
  Table *tableObject;
  UserDetailTableCell *cell = [tableView dequeueReusableCellWithIdentifier: 
    CellIdentifier];
  // Figure out which table cell to load
  if (userDetailTabSelected == UserDetailTabStarted) {
    tableObject = 
      [[[UserDetailStartedTableStore sharedStore] tablesForUser: 
        self.user] objectAtIndex: indexPath.row];
    if (!cell) {
      cell = [[UserDetailStartedTableCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
  }
  else if (userDetailTabSelected == UserDetailTabSitting) {
    tableObject = 
      [[[UserDetailSittingTableStore sharedStore] tablesForUser: 
        self.user] objectAtIndex: indexPath.row];
    if (!cell) {
      cell = [[UserDetailSittingTableCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
  }
  else if (userDetailTabSelected == UserDetailTabComplete) {
    tableObject = 
      [[[UserDetailCompleteTableStore sharedStore] tablesForUser: 
        self.user] objectAtIndex: indexPath.row];
    if (!cell) {
      cell = [[UserDetailCompleteTableCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
  }
  else {
    tableObject = 
      [[[UserDetailSittingTableStore sharedStore] tablesForUser: 
        self.user] objectAtIndex: indexPath.row];
    if (!cell) {
      cell = [[UserDetailSittingTableCell alloc] initWithStyle: 
        UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    }
  }
  // Load the data into the cell
  [cell loadTableData: tableObject];
  if (!tableObject.place.image) {
    if (self.table.decelerating == NO && self.table.dragging == NO) {
      [tableObject.place downloadImage:
        ^(void) {
          cell.imageView.image = 
            [tableObject.place tableCompleteCellImage];
        }
      ];
    }
    cell.imageView.image = [UIImage imageNamed: @"placeholder.png"];
  }
  else {
    cell.imageView.image = [tableObject.place tableCompleteCellImage];
  }
  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  if (userDetailTabSelected == UserDetailTabStarted) {
    return [[UserDetailStartedTableStore sharedStore] tablesForUser: 
      self.user].count;
  }
  else if (userDetailTabSelected == UserDetailTabSitting) {
    return [[UserDetailSittingTableStore sharedStore] tablesForUser: 
      self.user].count;
  }
  else if (userDetailTabSelected == UserDetailTabComplete) {
    return [[UserDetailCompleteTableStore sharedStore] tablesForUser: 
      self.user].count;
  }
  else {
    return 0;
  }
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  Table *tableObject;
  if (userDetailTabSelected == UserDetailTabStarted) {
    tableObject = 
      [[[UserDetailStartedTableStore sharedStore] tablesForUser: 
        self.user] objectAtIndex: indexPath.row];
  }
  else if (userDetailTabSelected == UserDetailTabSitting) {
    tableObject = 
      [[[UserDetailSittingTableStore sharedStore] tablesForUser: 
        self.user] objectAtIndex: indexPath.row];
  }
  else if (userDetailTabSelected == UserDetailTabComplete) {
    tableObject = 
      [[[UserDetailCompleteTableStore sharedStore] tablesForUser: 
        self.user] objectAtIndex: indexPath.row];
  }
  TableDetailViewController *tableDetailViewController = 
    [[TableDetailViewController alloc] initWithTable: tableObject];
  [self.navigationController pushViewController: tableDetailViewController 
    animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 60;
}

- (void) tableView: (UITableView *) tableView 
willDisplayCell: (UITableViewCell *) cell 
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  NSArray *tables;
  if (userDetailTabSelected == UserDetailTabStarted) {
    tables = [[UserDetailStartedTableStore sharedStore] tablesForUser: 
      self.user];
  }
  else if (userDetailTabSelected == UserDetailTabSitting) {
    tables = [[UserDetailSittingTableStore sharedStore] tablesForUser: 
      self.user];
  }
  else if (userDetailTabSelected == UserDetailTabComplete) {
    tables = [[UserDetailCompleteTableStore sharedStore] tablesForUser: 
      self.user];
  }
  if (indexPath.row == (tables.count - 5) && 
    [self currentMaxPages] > [self currentCurrentPage]) {

    if (userDetailTabSelected == UserDetailTabStarted) {
      self.startedCurrentPage += 1;
    }
    else if (userDetailTabSelected == UserDetailTabSitting) {
      self.sittingCurrentPage += 1;
    }
    else if (userDetailTabSelected == UserDetailTabComplete) {
      self.completeCurrentPage += 1;
    }
    [self.spinner startAnimating];
    [self loadTablesWithFinalCompletion: nil];
  }
}

#pragma mark - Methods

- (void) changeSelectedTab
{
  // Move tab underline
  CGRect screen = [[UIScreen mainScreen] bounds];
  CGRect frame  = self.tabUnderline.frame;
  UIColor *startedColor;
  UIColor *sittingColor;
  UIColor *completeColor;
  if (userDetailTabSelected == UserDetailTabStarted) {
    startedColor  = [UIColor gray: 40];
    sittingColor  = [UIColor gray: 160];
    completeColor = [UIColor gray: 160];
    frame.origin.x = 0;
    self.startedTableView.dataSource      = self;
    self.startedTableView.delegate        = self;
    self.view = self.startedTableView;
    self.startedTableView.tableHeaderView = self.infoView;
  }
  else if (userDetailTabSelected == UserDetailTabSitting) {
    startedColor  = [UIColor gray: 160];
    sittingColor  = [UIColor gray: 40];
    completeColor = [UIColor gray: 160];
    frame.origin.x = screen.size.width / 3.0;
    self.sittingTableView.dataSource      = self;
    self.sittingTableView.delegate        = self;
    self.view = self.sittingTableView;
    self.sittingTableView.tableHeaderView = self.infoView;
  }
  else if (userDetailTabSelected == UserDetailTabComplete) {
    startedColor  = [UIColor gray: 160];
    sittingColor  = [UIColor gray: 160];
    completeColor = [UIColor gray: 40];
    frame.origin.x = (screen.size.width * 2.0) / 3.0;
    self.completeTableView.dataSource      = self;
    self.completeTableView.delegate        = self;
    self.view = self.completeTableView;
    self.completeTableView.tableHeaderView = self.infoView;
  }
  [self.view addSubview: self.spinner];
  [self reloadAllTableViewData];
  [self loadTablesWithFinalCompletion: nil];

  void (^animations) (void) = ^(void) {
    self.startedCountLabel.textColor = startedColor;
    self.startedLabel.textColor = startedColor;
    self.sittingCountLabel.textColor = sittingColor;
    self.sittingLabel.textColor = sittingColor;
    self.completeCountLabel.textColor = completeColor;
    self.completeLabel.textColor = completeColor;
    self.tabUnderline.frame = frame;
  };
  [UIView animateWithDuration: 0.05 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

- (void) changeTab: (id) sender
{
  UIView *senderView = (UIView *) sender;
  switch (senderView.tag) {
    case 0:
      userDetailTabSelected = UserDetailTabStarted;
      break;
    case 1:
      userDetailTabSelected = UserDetailTabSitting;
      break;
    case 2:
      userDetailTabSelected = UserDetailTabComplete;
      break;
    default:
      userDetailTabSelected = UserDetailTabSitting;
      break;
  }
  [self.spinner removeFromSuperview];
  self.completeTableView.tableHeaderView = nil;
  self.sittingTableView.tableHeaderView  = nil;
  self.startedTableView.tableHeaderView  = nil;
  [self changeSelectedTab];
}

- (int) currentCurrentPage
{
  if (userDetailTabSelected == UserDetailTabStarted) {
    return self.startedCurrentPage;
  }
  else if (userDetailTabSelected == UserDetailTabSitting) {
    return self.sittingCurrentPage;
  }
  else if (userDetailTabSelected == UserDetailTabComplete) {
    return self.completeCurrentPage;
  }
  else {
    return 1;
  }
}

- (int) currentMaxPages
{
  if (userDetailTabSelected == UserDetailTabStarted) {
    return self.startedMaxPages;
  }
  else if (userDetailTabSelected == UserDetailTabSitting) {
    return self.sittingMaxPages;
  }
  else if (userDetailTabSelected == UserDetailTabComplete) {
    return self.completeMaxPages;
  }
  else {
    return 1;
  }
}

- (void) loadImagesForOnScreenRows
{
  NSArray *tables;
  UITableView *currentTableView;
  if (userDetailTabSelected == UserDetailTabStarted) {
    currentTableView = self.startedTableView;
    tables = [[UserDetailStartedTableStore sharedStore] tablesForUser:
      self.user];
  }
  else if (userDetailTabSelected == UserDetailTabSitting) {
    currentTableView = self.sittingTableView;
    tables = [[UserDetailSittingTableStore sharedStore] tablesForUser: 
      self.user];
  }
  else if (userDetailTabSelected == UserDetailTabComplete) {
    currentTableView = self.completeTableView;
    tables = [[UserDetailCompleteTableStore sharedStore] tablesForUser: 
      self.user];
  }
  if (tables.count > 0) {
    NSArray *visiblePaths = [currentTableView indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
      Table *tableObject = [tables objectAtIndex: indexPath.row];
      UserDetailTableCell *cell = (UserDetailTableCell *)
        [currentTableView cellForRowAtIndexPath: indexPath];
      if (!tableObject.place.image) {
        [tableObject.place downloadImage:
          ^(void) {
            cell.imageView.image = [tableObject.place tableCompleteCellImage];
          }
        ];
      }
    }
  }
}

- (void) loadTablesWithFinalCompletion: (void (^) (NSError *error)) block
{
  void (^completionBlock) (NSError *error) =
    ^(NSError *error) {
      if (!error) {
        [self showTables];
      }
      else {
        NSLog(@"UserDetailTableStore Error: %@", error.localizedDescription);
      }
    };
  void (^completionFinal) (NSError *error) =
    ^(NSError *error) {
      completionBlock(error);
      if (block) {
        block(error);
      }
    };
  // Iterate through all the current pages
  for (int i = [self currentCurrentPage]; i != 0; i--) {
    if (userDetailTabSelected == UserDetailTabStarted) {
      [UserDetailStartedTableStore sharedStore].viewController = self;
      if (i == 1) {
        [[UserDetailStartedTableStore sharedStore] fetchTablesForPage: i
          forUser: self.user withCompletion: completionFinal];
      }
      else {
        [[UserDetailStartedTableStore sharedStore] fetchTablesForPage: i
          forUser: self.user withCompletion: completionBlock];
      }
    }
    else if (userDetailTabSelected == UserDetailTabSitting) {
      [UserDetailSittingTableStore sharedStore].viewController = self;
      if (i == 1) {
        [[UserDetailSittingTableStore sharedStore] fetchTablesForPage: i
          forUser: self.user withCompletion: completionFinal];
      }
      else {
        [[UserDetailSittingTableStore sharedStore] fetchTablesForPage: i
          forUser: self.user withCompletion: completionBlock];
      }
    }
    else if (userDetailTabSelected == UserDetailTabComplete) {
      [UserDetailCompleteTableStore sharedStore].viewController = self;
      if (i == 1) {
        [[UserDetailCompleteTableStore sharedStore] fetchTablesForPage: i
          forUser: self.user withCompletion: completionFinal];
      }
      else {
        [[UserDetailCompleteTableStore sharedStore] fetchTablesForPage: i
          forUser: self.user withCompletion: completionBlock];
      }
    }
  }
}

- (void) refreshTable
{
  [self loadTablesWithFinalCompletion:
    ^(NSError *error) {
      [self.refreshControl endRefreshing];
    }
  ];
}

- (void) reloadAllTableViewData
{
  [self.completeTableView reloadData];
  [self.sittingTableView reloadData];
  [self.startedTableView reloadData];
}

- (void) showTables
{
  [self reloadAllTableViewData];
  [self.spinner stopAnimating];
}

- (void) signOut
{
  [self.spinner startAnimating];
  self.completeCurrentPage = self.completeMaxPages = 1;
  self.sittingCurrentPage  = self.sittingMaxPages  = 1;
  self.startedCurrentPage  = self.startedMaxPages  = 1;
  [self reloadAllTableViewData];
}

@end
