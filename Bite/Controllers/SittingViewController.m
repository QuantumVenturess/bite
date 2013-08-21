//
//  SittingViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "SittingTableStore.h"
#import "SittingViewController.h"

@implementation SittingViewController

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // Title
    self.title = @"Sitting";
    self.trackedViewName = self.title;
  }
  return self;
}

#pragma mark - Protocol UITableViewDataSource

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *CellIdentifier = @"TableCell";
  Table *tableObject = 
    [[[SittingTableStore sharedStore] sortedTablesByStartDate] objectAtIndex: 
      indexPath.row];
  TableCell *cell = 
    [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
  if (!cell) {
    cell = [[TableCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: CellIdentifier];
  }
  // After assigning table to cell, load table information into cell
  [cell loadTableData: tableObject];
  // Assign tableView to cell so that cell can reload data
  cell.tableView = tableView;

  // If place has no image
  if (!tableObject.place.image) {
    if (self.table.decelerating == NO && self.table.dragging == NO) {
      [tableObject.place downloadImage:
        ^(void) {
          cell.placeImageView.image = [tableObject.place tableCellImage];
        }
      ];
    }
    cell.placeImageView.image = [UIImage imageNamed: @"placeholder.png"];
  }
  else {
    cell.placeImageView.image = [tableObject.place tableCellImage];
  }
  // Load table seat images
  int i = 0;
  for (UIImageView *imageView in cell.seatsView.subviews) {
    Seat *seat = [cell.table.seats objectAtIndex: i];
    // If the seat's user has no image
    if (!seat.user.image) {
      // Lazy load seat image
      [seat.user downloadImage:
        ^(void) {
          imageView.image = [seat.user seatImage];
        }
      ];
      // Set placeholder image for seat
      imageView.image = [UIImage imageNamed: @"placeholder.png"];
    }
    else {
      // Set image for seat to seat's image
      imageView.image = [seat.user seatImage];
    }
    i++;
  }

  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [SittingTableStore sharedStore].tables.count;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  Table *tableObject = 
    [[[SittingTableStore sharedStore] sortedTablesByStartDate] objectAtIndex: 
      indexPath.row];
  TableDetailViewController *tableDetailViewController = 
    [[TableDetailViewController alloc] initWithTable: tableObject];
  [self.navigationController pushViewController: tableDetailViewController 
    animated: YES];
}

- (CGFloat) tableView: (UITableView *) tableView 
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  Table *tableObject = 
    [[[SittingTableStore sharedStore] sortedTablesByStartDate] objectAtIndex: 
      indexPath.row];
  return ((10 + 10 + 60 + 10 + 10 + 36) + (40 * tableObject.numberOfRows) + 10);
}

- (void) tableView: (UITableView *) tableView 
willDisplayCell: (UITableViewCell *) cell 
forRowAtIndexPath: (NSIndexPath *) indexPath
{
  // If user scrolls to the 2nd to last cell and 
  // the current page is not the last page
  if (indexPath.row == [SittingTableStore sharedStore].tables.count - 2 && 
    self.maxPages > self.currentPage) {

    // Increase current page by 1
    self.currentPage += 1;
    [self.spinner startAnimating];
    [self loadTablesWithFinalCompletion: nil];
  }
}

#pragma mark - Methods

- (void) cleanTablesWithFinalCompletion: (void (^) (NSError *error)) block
{
  void (^completionBlock) (NSError *error) = 
    ^(NSError *error) {
      if (!error) {
        [self.table reloadData];
      }
      else {
        NSLog(@"SittingTableStore Error: %@", error.localizedDescription);
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
    [[SittingTableStore sharedStore] setViewController: self];
    if (i == 1) {
      [[SittingTableStore sharedStore] cleanTablesForPage: i 
        withCompletion: completionFinal];
    }
    else {
      [[SittingTableStore sharedStore] cleanTablesForPage: i 
        withCompletion: completionBlock];
    }
  }
}

- (void) loadImagesForOnscreenRows
{
  // This method is used in case the user scrolled into 
  // a set of cells that don't have their app icons yet
  if ([SittingTableStore sharedStore].tables.count > 0) {
    NSArray *visiblePaths = [self.table indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
      Table *tableObject = [[[SittingTableStore sharedStore] 
        sortedTablesByStartDate] objectAtIndex: indexPath.row];
      TableCell *cell = 
        (TableCell *) [self.table cellForRowAtIndexPath: indexPath];

      if (!tableObject.place.image) {
        // Avoid the image download if the table already has an image
        [tableObject.place downloadImage:
          ^(void) {
            cell.placeImageView.image = [tableObject.place tableCellImage];
          }
        ];
      }
    }
  }
}

- (void) loadSeatsWithFinalCompletion: (void (^) (NSError *error)) block
{
  [super loadSeatsWithFinalCompletion: block];
  for (Table *tableObject in 
    [[SittingTableStore sharedStore] sortedTablesByStartDate]) {

    SeatConnection *connection = [[SeatConnection alloc] initWithTable: 
      tableObject];
    connection.completionBlock =
      ^(NSError *error) {
        if (!error) {
          [self.table reloadData];
        }
        else {
          NSLog(@"SittingViewController load seats error: %@",
            error.localizedDescription);
        }
        if (block) {
          block(error);
        }
      };
    [connection start];
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
        NSLog(@"SittingTableStore Error: %@", error.localizedDescription);
      }
    };
  void (^completionFinal) (NSError *error) =
    ^(NSError *error) {
      completionBlock(error);
      if (block) {
        block(error);
      }
      [super checkToAllowTableViewToScrollPassTabBar];
      for (Table *tableObject in 
        [[SittingTableStore sharedStore] sortedTablesByStartDate]) {
        // Subscribe to channel
        [tableObject subscribeToChannel];
      }
    };
  for (int i = self.currentPage; i != 0; i--) {
    [[SittingTableStore sharedStore] setViewController: self];
    if (i == 1) {
      [[SittingTableStore sharedStore] fetchTablesForPage: i
        withCompletion: completionFinal];
    }
    else {
      [[SittingTableStore sharedStore] fetchTablesForPage: i
        withCompletion: completionBlock];
    }
  }
}

@end
