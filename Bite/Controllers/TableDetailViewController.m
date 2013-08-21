//
//  TableDetailViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/22/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BiteTableViewController.h"
#import "ExploreTableStore.h"
#import "ExploreViewController.h"
#import "JoinTableConnection.h"
#import "LeaveTableConnection.h"
#import "MenuBarButtonItem.h"
#import "MessageConnection.h"
#import "MessagesView.h"
#import "MessageNavigationController.h"
#import "Place.h"
#import "PlaceImageDownloader.h"
#import "Seat.h"
#import "SeatConnection.h"
#import "SittingTableStore.h"
#import "SittingViewController.h"
#import "StartPlaceNavigationController.h"
#import "Table.h"
#import "TableDetailViewController.h"
#import "UIImage+Resize.h"
#import "User.h"
#import "UserDetailViewController.h"
#import "UserSeat.h"

@implementation TableDetailViewController

@synthesize composeBarButtonItem;
@synthesize exploreViewController;
@synthesize joinTableButton;
@synthesize joinTableView;
@synthesize infoView;
@synthesize leaveTableButton;
@synthesize leaveTableView;
@synthesize messagesView;
@synthesize peopleSittingLabel;
@synthesize scrollView;
@synthesize seatView;
@synthesize sittingViewController;
@synthesize startDateButton;
@synthesize subviews;
@synthesize table;
@synthesize tableSeats;

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject
{
  self = [super init];
  if (self) {
    self.subviews = [NSMutableArray array];
    self.table    = tableObject;
    self.title    = tableObject.place.name;
    self.trackedViewName = @"Table Detail";

    UITabBarController *tabBarController = (UITabBarController *) 
      [UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController *exploreNavController = (UINavigationController *) 
      [tabBarController.viewControllers objectAtIndex: 0];
    self.exploreViewController = (ExploreViewController *)
      [exploreNavController.viewControllers objectAtIndex: 0];
    UINavigationController *sittingNavController = (UINavigationController *)
      [tabBarController.viewControllers objectAtIndex: 1];
    self.sittingViewController = (SittingViewController *)
      [sittingNavController.viewControllers objectAtIndex: 0];

    // [[NSNotificationCenter defaultCenter] addObserver: self
    //   selector: @selector(loadMessages) name: RefreshDataNotification
    //     object: nil];
    // [[NSNotificationCenter defaultCenter] addObserver: self
    //   selector: @selector(loadSeats) name: RefreshDataNotification
    //     object: nil];
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  // Navigation item
  // back button
  UIImage *backButtonImage = [UIImage imageNamed: @"back.png"];
  UIButton *backButton = [UIButton buttonWithType: UIButtonTypeCustom];
  backButton.frame = CGRectMake(0, 0, backButtonImage.size.width + 16,
    backButtonImage.size.height);
  [backButton addTarget: self action: @selector(back) 
    forControlEvents: UIControlEventTouchUpInside];
  [backButton setImage: backButtonImage forState: UIControlStateNormal];
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: backButton];
  // compose button
  UIImage *composeImage = 
    [UIImage image: [UIImage imageNamed: @"compose.png"] 
      resized: CGSizeMake(24, 24) position: CGPointMake(0, 0)];
  UIButton *composeButton = [UIButton buttonWithType: UIButtonTypeCustom];
  composeButton.frame = CGRectMake(0, 0, (24 + 12), 24);
  [composeButton addTarget: self action: @selector(newMessage)
    forControlEvents: UIControlEventTouchUpInside];
  [composeButton setImage: composeImage forState: UIControlStateNormal];
  self.composeBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: composeButton];
    
  // Colors
  UIColor *gray40 = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
    blue: (40/255.0) alpha: 1];
  UIColor *gray160 = [UIColor colorWithRed: (160/255.0) green: (160/255.0) 
    blue: (160/255.0) alpha: 1];
  UIColor *gray235 = [UIColor colorWithRed: (235/255.0) green: (235/255.0) 
    blue: (235/255.0) alpha: 1];
  // Font
  UIFont *font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  // Screen
  CGRect screen = [[UIScreen mainScreen] bounds];
  // Scroll view
  self.scrollView = [[UIScrollView alloc] initWithFrame:
    CGRectMake(0, 0, screen.size.width, screen.size.height)];
  self.scrollView.alwaysBounceVertical = YES;
  self.scrollView.backgroundColor = [UIColor backgroundColor]; 
  self.scrollView.showsVerticalScrollIndicator = NO;
  self.view = self.scrollView;
  // Info view
  self.infoView = [[UIView alloc] initWithFrame: 
    CGRectMake(0, 0, screen.size.width, 206)];
  [self.subviews addObject: self.infoView];
  // Name
  UILabel *nameLabel = [[UILabel alloc] initWithFrame: 
    CGRectMake(10, 10, (screen.size.width - 20), 25)];
  nameLabel.backgroundColor = [UIColor clearColor];
  nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 18];
  nameLabel.numberOfLines = 0; // word wrap
  nameLabel.text = self.table.place.name;
  nameLabel.textColor = gray40;
  [self.infoView addSubview: nameLabel];
  // Image
  UIView *placeImage = [[UIView alloc] initWithFrame:
    CGRectMake(0, (10 + 25 + 10), 120, 120)];
  placeImage.backgroundColor = gray235;
  UIImageView *placeImageView = [[UIImageView alloc] initWithFrame:
    CGRectMake(10, 10, 100, 100)];
  if (self.table.place.image) {
    placeImageView.image = self.table.place.image;
  }
  else {
    PlaceImageDownloader *placeImageDownloader =
      [[PlaceImageDownloader alloc] initWithPlace: self.table.place];
    placeImageDownloader.completionBlock = 
    ^(void) {
      placeImageView.image = self.table.place.image;
    };
    [placeImageDownloader startDownload];
  }
  [placeImage addSubview: placeImageView];
  [self.infoView addSubview: placeImage];
  // Rating & Review
  // rating
  UIView *ratingView = [[UIView alloc] initWithFrame: 
    CGRectMake((120 + 1), (10 + 25 + 10), (screen.size.width - (120 + 1)), 30)];
  ratingView.backgroundColor = gray235;
  UIImageView *ratingImageView = [[UIImageView alloc] initWithFrame:
    CGRectMake(10, (5 + 2), 84, 16)];
  ratingImageView.image = [self.table.place yelpRatingImage];
  [ratingView addSubview: ratingImageView];
  // review count
  UILabel *reviewCountLabel = [[UILabel alloc] initWithFrame:
    CGRectMake((10 + 84 + 5), 5, 
      (ratingView.frame.size.width - (10 + 84 + 5 + 10)), 20)];
  reviewCountLabel.backgroundColor = [UIColor clearColor];
  reviewCountLabel.font = font;
  reviewCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  reviewCountLabel.text = [NSString stringWithFormat: @"%i %@", 
    self.table.place.reviewCount, 
    self.table.place.reviewCount == 1 ? @"review" : @"reviews"];
  reviewCountLabel.textColor = gray160;
  [ratingView addSubview: reviewCountLabel];
  [self.infoView addSubview: ratingView];
  // Location
  UIView *locationView = [[UIView alloc] initWithFrame: 
    CGRectMake((120 + 1), (10 + 25 + 10 + 30 + 1), 
      (screen.size.width - (120 + 1)), 89)];
  locationView.backgroundColor = gray235;
  // address
  UILabel *addressLabel = [[UILabel alloc] initWithFrame:
    CGRectMake(10, 10, (locationView.frame.size.width - (10 + 10)), 23)];
  addressLabel.backgroundColor = [UIColor clearColor];
  addressLabel.font = font;
  addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  addressLabel.text = self.table.place.address;
  addressLabel.textColor = gray40;
  [locationView addSubview: addressLabel];
  // city, state zip
  UILabel *cityStateZip = [[UILabel alloc] initWithFrame:
    CGRectMake(10, (10 + 23), 
      (locationView.frame.size.width - (10 + 10)), 23)];
  cityStateZip.backgroundColor = [UIColor clearColor];
  cityStateZip.font = font;
  cityStateZip.lineBreakMode = NSLineBreakByTruncatingTail;
  cityStateZip.text = [NSString stringWithFormat: @"%@, %@ %i", 
    self.table.place.city, self.table.place.stateCode, 
    self.table.place.postalCode];
  cityStateZip.textColor = gray40;
  [locationView addSubview: cityStateZip];
  // phone
  UILabel *phoneLabel = [[UILabel alloc] initWithFrame:
    CGRectMake(10, (10 + 23 + 23), 
      (locationView.frame.size.width - (10 + 10)), 23)];
  phoneLabel.backgroundColor = [UIColor clearColor];
  phoneLabel.font = font;
  phoneLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  if ([self.table.place.phone length] >= 10) {
    phoneLabel.text = [NSString stringWithFormat: @"(%@) %@-%@",
      [self.table.place.phone substringWithRange: NSMakeRange(0, 3)], 
      [self.table.place.phone substringWithRange: NSMakeRange(3, 3)],
      [self.table.place.phone substringWithRange: NSMakeRange(6, 4)]];
  }
  phoneLabel.textColor = gray40;
  [locationView addSubview: phoneLabel];
  [self.infoView addSubview: locationView];
  // Start date
  self.startDateButton = [[UIButton alloc] init];
  self.startDateButton.backgroundColor = gray235;
  self.startDateButton.frame = CGRectMake(0, (10 + 25 + 10 + 120 + 1), 
    screen.size.width, 40);
  self.startDateButton.titleLabel.font = font;
  [self.startDateButton addTarget: self action: @selector(changeStartDate:)
    forControlEvents: UIControlEventTouchUpInside];
  [self.infoView addSubview: self.startDateButton];
  // Join Table
  self.joinTableView = [[UIView alloc] initWithFrame:
    CGRectMake(0, 206, screen.size.width, (10 + 36 + 10))];
  // join table button
  self.joinTableButton = [[UIButton alloc] initWithFrame: 
    CGRectMake(10, 10, (screen.size.width - 20), 36)];
  self.joinTableButton.backgroundColor = [UIColor colorWithRed: (207/255.0) 
      green: (4/255.0) blue: (4/255.0) alpha: 1];
  self.joinTableButton.titleLabel.font = font;
  [self.joinTableButton addTarget: self action: @selector(joinTable:) 
    forControlEvents: UIControlEventTouchUpInside];
  [self.joinTableButton setTitle: @"Join Table" 
    forState: UIControlStateNormal];
  [self.joinTableButton setTitleColor: [UIColor whiteColor]
    forState: UIControlStateNormal];
  [self.joinTableView addSubview: self.joinTableButton];
  // Messages
  self.messagesView = [[MessagesView alloc] initWithFrame:
    CGRectMake(0, 206, screen.size.width, 36) table: self.table];
  // Seat view - sitting label, table seats
  self.seatView = [[UIView alloc] init];
  [self.subviews addObject: self.seatView];
  // people sitting label
  self.peopleSittingLabel = [[UILabel alloc] initWithFrame:
    CGRectMake(10, 0, (screen.size.width - 20), 36)];
  self.peopleSittingLabel.backgroundColor = [UIColor clearColor];
  self.peopleSittingLabel.font = font;
  self.peopleSittingLabel.lineBreakMode = NSLineBreakByTruncatingTail;
  self.peopleSittingLabel.textColor = gray40;
  CALayer *bottomBorder = [CALayer layer];
  bottomBorder.frame = CGRectMake(0, 35, 
    peopleSittingLabel.frame.size.width, 1);
  bottomBorder.backgroundColor = gray160.CGColor;
  [self.peopleSittingLabel.layer addSublayer: bottomBorder];
  CALayer *topBorder = [CALayer layer];
  topBorder.frame = CGRectMake(0, 0, 
    self.peopleSittingLabel.frame.size.width, 1);
  topBorder.backgroundColor = gray160.CGColor;
  [self.peopleSittingLabel.layer addSublayer: topBorder];
  [self.seatView addSubview: self.peopleSittingLabel];
  // table seats
  self.tableSeats = [[UIView alloc] init];
  [self.seatView addSubview: self.tableSeats];

  // Leave Table view
  self.leaveTableView = [[UIView alloc] init];
  self.leaveTableButton = [[UIButton alloc] initWithFrame:
    CGRectMake(10, 0, (screen.size.width - 20), 36)];
  self.leaveTableButton.backgroundColor = [UIColor colorWithRed: (230/255.0)
    green: (230/255.0) blue: (230/255.0) alpha: 1];
  self.leaveTableButton.titleLabel.font = font;
  [self.leaveTableButton addTarget: self action: @selector(leaveTable:)
    forControlEvents: UIControlEventTouchUpInside];
  [self.leaveTableButton setTitle: @"Leave Table"
    forState: UIControlStateNormal];
  [self.leaveTableButton setTitleColor: gray40
    forState: UIControlStateNormal];
  [self.leaveTableView addSubview: self.leaveTableButton];

  // Add all views in subviews to scroll view's subviews
  for (UIView *view in self.subviews) {
    [self.scrollView addSubview: view];
  }
}

#pragma mark - Override UIViewController

- (void) viewDidLoad
{
  self.joinTableButton.layer.cornerRadius   = 2;
  self.joinTableButton.layer.masksToBounds  = YES;
  self.leaveTableButton.layer.cornerRadius  = 2;
  self.leaveTableButton.layer.masksToBounds = YES;
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  if (self.table.uid != 0) {
    // Fetch messages
    [self loadMessages];
    // Fetch seats
    [self loadSeats];
  }
  [self refreshData];
}

#pragma mark - Methods

- (void) changeStartDate: (id) sender
{
  StartPlaceNavigationController *startPlaceNavigationController = 
    [[StartPlaceNavigationController alloc] initWithTable: self.table
      viewController: self];
  [self presentViewController: startPlaceNavigationController 
    animated: YES completion: nil];
}

- (void) joinTable: (id) sender
{
  // Create seat
  Seat *seat = [[Seat alloc] init];
  seat.createdAt = [[NSDate date] timeIntervalSince1970];
  seat.table = self.table;
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
  [self.exploreViewController.table reloadData];
  // Add table to sitting table store
  [[SittingTableStore sharedStore] addTable: self.table];
  [self.sittingViewController.table reloadData];
  // Refresh
  [self refreshData];
}

- (void) leaveTable: (id) sender
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K != %i", @"userId", [User currentUser].uid];
  self.table.seats = [NSMutableArray arrayWithArray: 
    [self.table.seats filteredArrayUsingPredicate: predicate]];
  // Send leave data to server
  LeaveTableConnection *connection = 
    [[LeaveTableConnection alloc] initWithTable: self.table];
  [connection start];
  // Remove table from sitting table store
  [[SittingTableStore sharedStore] removeTable: self.table];
  [self.sittingViewController.table reloadData];
  if (self.table.seats.count == 0) {
    [self.navigationController popViewControllerAnimated: YES];
  }
  else {
    // Add table to explore table store
    [[ExploreTableStore sharedStore] addTable: self.table];
    [self.exploreViewController.table reloadData];
    // Refresh
    [self refreshData];
  }
}

- (void) loadMessages;
{
  MessageConnection *connection = 
    [[MessageConnection alloc] initWithTable: self.table];
  connection.completionBlock = 
    ^(NSError *error) {
      if (!error) {
        [self refreshData];
      }
      else {
        NSLog(@"Load Message Error: %@", error.localizedDescription);
      }
    };
  [connection start];
}

- (void) loadSeats
{
  void (^completionBlock) (NSError *error) =
  ^(NSError *error) {
    if (!error) {
      // Reload the view to show the messages
      [self refreshData];
    }
    else {
      NSLog(@"Load Seats Error: %@", error.localizedDescription);
    }
  };
  SeatConnection *connection = 
    [[SeatConnection alloc] initWithTable: self.table];
  connection.completionBlock = completionBlock;
  [connection start];
}

- (void) newMessage
{
  MessageNavigationController *messageNav = 
    [[MessageNavigationController alloc] initWithTable: self.table
      viewController: self];
  [self presentViewController: messageNav animated: YES completion: nil];
}

- (void) refreshData
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  NSUInteger viewIndex;
  // If user started table
  [self.startDateButton setTitle: self.table.startDateStringLong
    forState: UIControlStateNormal];
  if (self.table.userId == [User currentUser].uid) {
    self.startDateButton.userInteractionEnabled = YES;
    [self.startDateButton setTitleColor: [UIColor colorWithRed: (48/255.0) 
      green: (157/255.0) blue: (227/255.0) alpha: 1] 
        forState: UIControlStateNormal];
  }
  else {
    self.startDateButton.userInteractionEnabled = NO;
    [self.startDateButton setTitleColor: [UIColor colorWithRed: (40/255.0) 
      green: (40/255.0) blue: (40/255.0) alpha: 1] 
        forState: UIControlStateNormal];
  }
  // Refresh message data
  [self.messagesView refreshData];
  // Hide Join Table button if current user is sitting at table or table full
  float paddingBottom = 0, spacingHeight, spacingOrigin;
  // If user is sitting at table
  if ([[User currentUser] isSittingAtTable: self.table] || 
    self.table.seats.count >= self.table.maxSeats) {

    // remove join table
    [self.joinTableView removeFromSuperview];
    [self.subviews removeObject: self.joinTableView];
    if ([[User currentUser] isSittingAtTable: self.table]) {
      // add compose button
      self.navigationItem.rightBarButtonItem = self.composeBarButtonItem;
      // If messages view is not in the subviews, add it
      if ([self.subviews indexOfObject: self.messagesView] == NSNotFound) {
        [self.scrollView addSubview: self.messagesView];
        [self.subviews addObject: self.messagesView];
      }
      spacingHeight = self.messagesView.frame.size.height;
      spacingOrigin = self.messagesView.frame.origin.y;
    }
    else {
      paddingBottom = 10;
      spacingHeight = 10;
      spacingOrigin = self.joinTableView.frame.origin.y;
    }
  }
  else {
    // remove compose button
    self.navigationItem.rightBarButtonItem = nil;
    // If join table view is not in the subviews, add it
    if ([self.subviews indexOfObject: self.joinTableView] == NSNotFound) {
      [self.scrollView addSubview: self.joinTableView];
      [self.subviews addObject: self.joinTableView];
      // remove messages
      [self.messagesView removeFromSuperview];
      [self.subviews removeObject: self.messagesView];
    }
    spacingHeight = self.joinTableView.frame.size.height;
    spacingOrigin = self.joinTableView.frame.origin.y;
  }
  // Set how many people sitting at table
  self.peopleSittingLabel.text = 
    [NSString stringWithFormat: @"People sitting %i out of %i", 
      self.table.seats.count, self.table.maxSeats];
  // Calculate size of seats and number of seats
  self.tableSeats.frame = CGRectMake(10, 36, 
    (screen.size.width - 20), (40 * self.table.seats.count));
  // remove all previous seats
  [self.tableSeats.subviews makeObjectsPerformSelector: 
    @selector(removeFromSuperview)];
  // re-add seats
  int i = 0;
  for (Seat *seat in self.table.seats) {
    UserSeat *userSeat = [[UserSeat alloc] initWithFrame: 
      CGRectMake(0, (40 * i), (screen.size.width - 20), 40) seat: seat];
    [userSeat addTarget: self action: @selector(showUserDetailViewController:)
      forControlEvents: UIControlEventTouchUpInside];
    [self.tableSeats addSubview: userSeat];
    i++;
  }
  // Calculate seat view frame
  self.seatView.frame = CGRectMake(0, (spacingOrigin + spacingHeight), 
    screen.size.width, (36 + (40 * self.table.seats.count) + 10));
  // If user is sitting at table
  if ([[User currentUser] isSittingAtTable: self.table]) {
    self.leaveTableView.frame = CGRectMake(0, 
      (self.seatView.frame.origin.y + self.seatView.frame.size.height), 
        screen.size.width, (36 + 10));
    // If leave table view is not in subviews, add it
    viewIndex = [self.subviews indexOfObject: self.leaveTableView];
    if (viewIndex == NSNotFound) {
      [self.scrollView addSubview: self.leaveTableView];
      [self.subviews addObject: self.leaveTableView];
    }
  }
  else {
    [self.leaveTableView removeFromSuperview];
    [self.subviews removeObject: self.leaveTableView];
  }
  // Calculate scroll view content size
  float contentSizeHeight = 0;
  for (UIView *view in self.subviews) {
    contentSizeHeight += view.frame.size.height;
  }
  self.scrollView.contentSize = CGSizeMake(screen.size.width, 
    contentSizeHeight + paddingBottom);
}

- (void) showUserDetailViewController: (id) sender
{
  UserSeat *userSeat = (UserSeat *) sender;
  UserDetailViewController *userDetail = 
    [[UserDetailViewController alloc] initWithUser: userSeat.seat.user];
  [self.navigationController pushViewController: userDetail animated: YES];
}

@end
