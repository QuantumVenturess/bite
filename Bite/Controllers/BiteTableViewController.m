//
//  BiteTableViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteTableViewController.h"
#import "UIColor+Extensions.h"

@implementation BiteTableViewController

@synthesize currentPage;
@synthesize maxPages;
@synthesize refreshControl;
@synthesize spinner;
@synthesize table;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.currentPage = self.maxPages = 1;

    [[NSNotificationCenter defaultCenter] addObserver: self
      selector: @selector(signOut) name: CurrentUserSignOut 
        object: nil];
    // [[NSNotificationCenter defaultCenter] addObserver: self
    //   selector: @selector(loadSeats) name: RefreshDataNotification 
    //     object: nil];
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  // Create main table view
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.table = [[UITableView alloc] init];
  self.table.backgroundColor = [UIColor gray: 235];
  self.table.dataSource = self;
  self.table.delegate = self;
  self.table.frame = CGRectMake(0, 0, screen.size.width, screen.size.height);
  self.table.separatorColor = [UIColor gray: 120];
  self.table.showsVerticalScrollIndicator = NO;
  self.view = self.table;

  // Add spinner
  self.spinner = [[UIActivityIndicatorView alloc] init];
  self.spinner.activityIndicatorViewStyle = 
    UIActivityIndicatorViewStyleWhiteLarge;
  self.spinner.color = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.7];
  self.spinner.frame = CGRectMake((screen.size.width / 2.0), 
    (screen.size.height - 160), 0, 0);
  self.spinner.hidesWhenStopped = YES;
  [self.table addSubview: self.spinner];

  // Add refresh control
  self.refreshControl = [[UIRefreshControl alloc] init];
  self.refreshControl.attributedTitle = 
    [[NSAttributedString alloc] initWithString: @"Pull down to refresh"];
  self.refreshControl.tintColor = [UIColor colorWithRed: (207/255.0)
    green: (4/255.0) blue: (4/255.0) alpha: 1];
  [self.refreshControl addTarget: self action: @selector(refreshTable)
    forControlEvents: UIControlEventValueChanged];
  [self.view addSubview: self.refreshControl];
}

- (void) viewDidLoad
{
  [super viewDidLoad];
  [self.spinner startAnimating];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  [self.table reloadData];
  [self loadSeatsWithFinalCompletion: nil];
  if ([User currentUser].biteAccessToken) {
    [self loadTablesWithFinalCompletion: nil];
  }
  if (self.refreshControl.isRefreshing) {
    [self.refreshControl endRefreshing];
  }
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  [self cleanTablesWithFinalCompletion: nil];
}

#pragma mark - Protocol UIScrollViewDelegate

- (void) scrollViewDidEndDecelerating: (UIScrollView *) scrollView
{
  [self loadImagesForOnscreenRows];
}

- (void) scrollViewDidEndDragging: (UIScrollView *) scrollView 
willDecelerate: (BOOL) decelerate
{
  if (!decelerate) {
    [self loadImagesForOnscreenRows];
  }
}

- (void) scrollViewDidScroll: (UIScrollView *) scrollView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  self.spinner.frame = CGRectMake((screen.size.width / 2.0), 
    (scrollView.contentOffset.y + (screen.size.height - 160)), 0, 0);
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView *) tableView
{
  return 1;
}

#pragma mark - Protocol UITableViewDelegate

- (CGFloat) tableView: (UITableView *) tableView
heightForFooterInSection: (NSInteger) section
{
  return 0.1f;
}

- (UIView *) tableView: (UITableView *) tableView 
viewForFooterInSection: (NSInteger) section
{
  return [[UIView alloc] init];
}

#pragma mark - Methods

- (void) cleanTablesWithFinalCompletion: (void (^) (NSError *error)) block
{
  // Sub classes will implement this
}

- (void) loadImagesForOnscreenRows
{
  // Sub classes will implement this
}

- (void) loadSeats
{
  [self loadSeatsWithFinalCompletion: nil];
}

- (void) loadSeatsWithFinalCompletion: (void (^) (NSError *error)) block
{
  if ([self.table numberOfRowsInSection: 0] == 0) {
    if (block) {
      block(nil);
    }
    return;
  }
  // Sub classes will implement this
}

- (void) loadTablesWithFinalCompletion: (void (^) (NSError *error)) block
{
  // Sub classes will implement this
}

- (void) refreshTable
{
  [self loadTablesWithFinalCompletion: 
    ^(NSError *error) {
      [self cleanTablesWithFinalCompletion:
        ^(NSError *error) {
          [self loadSeatsWithFinalCompletion:
            ^(NSError *error) {
              [self.refreshControl endRefreshing];
            }
          ];
        }
      ];
    }
  ];
}

- (void) showTables
{
  [self.table reloadData];
  [self.spinner stopAnimating];
}

- (void) signOut
{
  self.currentPage = self.maxPages = 1;
  [self.spinner startAnimating];
  [self.table reloadData];
}

@end
