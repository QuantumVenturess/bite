//
//  TableCell.m
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BiteTableFullScreenViewController.h"
#import "ExploreTableStore.h"
#import "ExploreViewController.h"
#import "JoinTableConnection.h"
#import "Place.h"
#import "Seat.h"
#import "SittingTableStore.h"
#import "Table.h"
#import "TableCell.h"
#import "UIImage+Resize.h"
#import "User.h"

@implementation TableCell

@synthesize joinTableButton;
@synthesize locationLabel;
@synthesize mainView;
@synthesize nameLabel;
@synthesize placeImageView;
@synthesize seatsView;
@synthesize startedBy;
@synthesize startDateLabel;
@synthesize table;
@synthesize tableView;

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
  if (self) {
    // Colors
    UIColor *gray40 = 
      [UIColor colorWithRed: (40/255.0) green: (40/255.0) blue: (40/255.0) 
        alpha: 1];
    UIColor *gray160 = 
      [UIColor colorWithRed: (160/255.0) green: (160/255.0) blue: (160/255.0) 
        alpha: 1];
    // Font
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue" size: 14];

    // UITableViewCell properties
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Screen
    CGRect screen = [[UIScreen mainScreen] bounds];

    // Content view
    // CGRect frame;
    // frame = CGRectMake(0, 0, screen.size.width, 200);
    // self.contentView.frame = frame;

    // Main view
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = [UIColor whiteColor];
    self.mainView.frame = CGRectMake(10, 0, (screen.size.width - 20),
      (10 + 60 + 10 + 40 + 10 + 36 + 10));
    [self.contentView addSubview: self.mainView];

    // Image of place
    self.placeImageView = [[UIImageView alloc] init];
    self.placeImageView.frame = CGRectMake(10, 10, 60, 60);
    [self.mainView addSubview: self.placeImageView];

    // Name of place
    self.nameLabel = [[UILabel alloc] initWithFrame: 
      CGRectMake(80, 10, (self.mainView.frame.size.width - (80 + 10)), 20)];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 14];
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.nameLabel.textColor = gray40;
    [self.mainView addSubview: self.nameLabel];

    // Location of place
    self.locationLabel = [[UILabel alloc] initWithFrame: CGRectMake(80, 
      (10 + 20), (self.mainView.frame.size.width - (80 + 10)), 20)];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.font = font;
    self.locationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.locationLabel.textColor = gray160;
    [self.mainView addSubview: self.locationLabel];

    // Start date
    self.startDateLabel = [[UILabel alloc] initWithFrame: CGRectMake(80, 
      (10 + 20 + 20), (self.mainView.frame.size.width - (80 + 10)), 20)];
    self.startDateLabel.backgroundColor = [UIColor clearColor];
    self.startDateLabel.font = font;
    self.startDateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.startDateLabel.textColor = gray40;
    [self.mainView addSubview: self.startDateLabel];

    // Seats view
    self.seatsView = [[UIView alloc] init];
    [self.mainView addSubview: self.seatsView];

    // Table started by user label
    self.startedBy = [[UILabel alloc] init];
    self.startedBy.backgroundColor = [UIColor clearColor];
    self.startedBy.font = [UIFont fontWithName: @"HelveticaNeue" size: 13];
    self.startedBy.lineBreakMode = NSLineBreakByTruncatingTail;
    self.startedBy.textColor = gray160;
    [self.mainView addSubview: self.startedBy];

    // Join table button
    self.joinTableButton = [[UIButton alloc] init];
    self.joinTableButton.backgroundColor = [UIColor colorWithRed: (207/255.0) 
      green: (4/255.0) blue: (4/255.0) alpha: 1];
    self.joinTableButton.titleLabel.font = font;
    self.joinTableButton.layer.cornerRadius = 2;
    self.joinTableButton.layer.masksToBounds = YES;
    [self.joinTableButton setTitle: @"Join Table" 
      forState: UIControlStateNormal];
    [self.joinTableButton setTitleColor: [UIColor whiteColor] 
      forState: UIControlStateNormal];
    [joinTableButton addTarget: self action: @selector(joinTable:) 
      forControlEvents: UIControlEventTouchUpInside];
    [mainView addSubview: self.joinTableButton];
  }

  return self;
}

#pragma mark - Methods

- (void) joinTable: (id) sender
{
  // If tableView's delegate is a BiteTableFullScreenViewController
  if ([self.tableView.delegate isKindOfClass: 
    [BiteTableFullScreenViewController class]]) {

    BiteTableFullScreenViewController *fullScreenViewController = (
      BiteTableFullScreenViewController *) self.tableView.delegate;
    // If view controller is refreshing
    if (fullScreenViewController.refreshing) {
      return;
    }
  }
  // Hide Join Table button
  self.joinTableButton.hidden = YES;
  // Create seat
  Seat *seat = [[Seat alloc] init];
  seat.createdAt = [[NSDate date] timeIntervalSince1970];
  seat.table = self.table;
  seat.tableId = self.table.uid;
  seat.updatedAt = [[NSDate date] timeIntervalSince1970];
  seat.user = [User currentUser];
  seat.userId = seat.user.uid;
  // Send join table data to server
  JoinTableConnection *connection = 
    [[JoinTableConnection alloc] initWithSeat: seat];
  [connection start];
  // Add seat to table
  [self.table addSeat: seat];
  // Remove table from explore table store
  [[ExploreTableStore sharedStore] removeTable: self.table];
  // Add table to sitting table store
  [[SittingTableStore sharedStore] addTable: self.table];
  // Reload table view
  [self.tableView reloadData];
  // If the table view's content size is less than or equal to its height
  if (self.tableView.contentSize.height <= (self.tableView.frame.size.height + 
    49)) {
    // Reset ExploreViewController nav and tab bar
    if ([self.tableView.delegate isKindOfClass: 
      [ExploreViewController class]]) {
      ExploreViewController *exploreViewController = (ExploreViewController *)
        self.tableView.delegate;
      [exploreViewController resetNavAndTabBar];
    }
  }
}

- (void) loadSeatImageViews
{
  NSMutableArray *array = [NSMutableArray array];
  int seats = self.table.seats.count;
  int maxSeatsPerRow = 5;
  int rows = (seats / maxSeatsPerRow);
  int remainingSeats = seats - (rows * maxSeatsPerRow);
  for (int row = 0; row < rows; row++) {
    NSArray *rowColumn = [NSArray arrayWithObjects: 
      [NSNumber numberWithInt: row], 
      [NSNumber numberWithInt: maxSeatsPerRow],
      nil];
    [array addObject: rowColumn];
  }
  NSArray *remainingRowColumn = [NSArray arrayWithObjects: 
    [NSNumber numberWithInt: rows], 
    [NSNumber numberWithInt: remainingSeats],
    nil];
  [array addObject: remainingRowColumn];

  for (NSArray *rowAndColumn in array) {
    int rowNumber  = [[rowAndColumn objectAtIndex: 0] integerValue];
    int seatsInRow = [[rowAndColumn objectAtIndex: 1] integerValue];
    for (int i = 0; i < seatsInRow; i++) {
      UIImageView *seatImageView = [[UIImageView alloc] initWithFrame: 
        CGRectMake((60 * i), (40 * rowNumber), 60, 40)];
      seatImageView.clipsToBounds = YES;
      seatImageView.contentMode = UIViewContentModeTopLeft;
      [self.seatsView addSubview: seatImageView];
    }
  }
}

- (void) loadTableData: (Table *) tableObject
{
  self.table = tableObject;
  // Name, rating image, review count, address
  self.nameLabel.text = self.table.place.name;
  self.locationLabel.text = [NSString stringWithFormat: @"%@, %@", 
    self.table.place.city, self.table.place.stateCode];
  self.startDateLabel.text = [self.table startDateStringShort];

  // Main view
  self.mainView.frame = CGRectMake(self.mainView.frame.origin.x, 
    self.mainView.frame.origin.y, self.mainView.frame.size.width,
      (10 + 60 + 10 + 10 + 36 + (40 * self.table.numberOfRows) + 10));

  // Seats view
  self.seatsView.frame = CGRectMake(0, 80, 
    300, (40 * self.table.numberOfRows));

  // Table started by user label
  self.startedBy.frame = 
    CGRectMake(10, (80 + self.seatsView.frame.size.height + 10), 
      ((self.mainView.frame.size.width / 2.0) - 20), 36);
  self.startedBy.text = [NSString stringWithFormat: @"%@ %@. started", 
    self.table.user.firstName, [self.table.user.lastName substringToIndex: 1]];

  // Join Table button
  self.joinTableButton.frame = 
    CGRectMake((self.mainView.frame.size.width / 2.0), 
      (80 + self.seatsView.frame.size.height + 10), 
        ((self.mainView.frame.size.width / 2.0) - 10), 36);
  // Check to see if current user is sitting at this table
  if ([[User currentUser] isSittingAtTable: self.table]) {
    self.joinTableButton.hidden = YES;
  }
  else {
    self.joinTableButton.hidden = NO;
  }
  // Remove all previous subviews in the seat views
  // This takes care of previous subviews from dequeued cells
  [self.seatsView.subviews makeObjectsPerformSelector: 
    @selector(removeFromSuperview)];
  if (self.seatsView.subviews.count < self.table.seats.count) {
    [self loadSeatImageViews];
  }
}

@end
