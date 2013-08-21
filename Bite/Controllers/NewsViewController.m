//
//  NewsViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "ClearNewsConnection.h"
#import "NewsViewController.h"
#import "Notification.h"
#import "NotificationCell.h"
#import "NotificationStore.h"
#import "TableDetailViewController.h"

@implementation NewsViewController

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.currentPage = self.maxPages = 1;
    self.title = @"News";
    self.trackedViewName = self.title;
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  [super loadView];
  self.table.backgroundColor = [UIColor backgroundColor];
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  ClearNewsConnection *connection = [[ClearNewsConnection alloc] init];
  [connection start];
  [[NotificationStore sharedStore] markAllUnviewedNotificationsViewed];
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"NotificationCell";
  Notification *notification = [[[NotificationStore sharedStore] 
    sortedNotificationsByCreatedAt] objectAtIndex: indexPath.row];
  NotificationCell *cell = 
    [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
  if (!cell) {
    cell = [[NotificationCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  }
  [cell loadNotificationData: notification];

  if (![notification hasImage]) {
    if (self.table.decelerating == NO && self.table.dragging == NO) {
      [notification downloadImage:
        ^(void) {
          cell.imageView.image = [notification cellImage];
        }
      ];
    }
    cell.imageView.image = [UIImage imageNamed: @"placeholder.png"];
  }
  else {
    cell.imageView.image = [notification cellImage];
  }

  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [NotificationStore sharedStore].notifications.count;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  Notification *notification = 
    [[[NotificationStore sharedStore] sortedNotificationsByCreatedAt]
      objectAtIndex: indexPath.row];
  TableDetailViewController *tableDetailViewController = 
    [[TableDetailViewController alloc] initWithTable: 
      [notification tableToForward]];
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
  // If user scrolls to the 2nd to last cell and 
  // the current page is not the last page
  if (indexPath.row == 
    [NotificationStore sharedStore].notifications.count - 5 &&
      self.maxPages > self.currentPage) {

    // Increase current page by 1
    self.currentPage += 1;
    [self.spinner startAnimating];
    [self loadTablesWithFinalCompletion: nil];
  }
}

#pragma mark - Methods

- (void) loadImagesForOnscreenRows
{
  if ([NotificationStore sharedStore].notifications.count > 0) {
    NSArray *visiblePaths = [self.table indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
      Notification *notification = 
        [[[NotificationStore sharedStore] sortedNotificationsByCreatedAt]
          objectAtIndex: indexPath.row];
      NotificationCell *cell = (NotificationCell *) 
        [self.table cellForRowAtIndexPath: indexPath];
      if (![notification hasImage]) {
        [notification downloadImage:
          ^(void) {
            cell.imageView.image = [notification cellImage];
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
        NSLog(@"NotificationStore Error: %@", error.localizedDescription);
      }
    };
  void (^completionFinal) (NSError *error) =
    ^(NSError *error) {
      completionBlock(error);
      if (block) {
        block(error);
      }
    };
  for (int i = self.currentPage; i != 0; i--) {
    [NotificationStore sharedStore].viewController = self;
    if (i == 1) {
      [[NotificationStore sharedStore] fetchNotificationsForPage: i
        withCompletion: completionFinal];
    }
    else {
      [[NotificationStore sharedStore] fetchNotificationsForPage: i
        withCompletion: completionBlock];
    }
  }
}

- (void) refreshTable
{
  [self loadTablesWithFinalCompletion:
    ^(NSError *error) {
      [self refreshUnviewedNewsCount];
      [self.refreshControl endRefreshing];
    }
  ];
}

@end
