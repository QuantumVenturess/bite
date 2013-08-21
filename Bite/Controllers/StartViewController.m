//
//  StartViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MenuBarButtonItem.h"
#import "Place.h"
#import "PlaceCell.h"
#import "StartPlaceNavigationController.h"
#import "StartPlaceStore.h"
#import "StartViewController.h"
#import "TextFieldPadding.h"
#import "User.h"
#import "YelpConnection.h"

@implementation StartViewController

@synthesize searchLocation;
@synthesize searchLocationField;
@synthesize searchNameField;
@synthesize table;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    // Title
    self.title = @"Start";
    self.trackedViewName = self.title;
    // Location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 50;

    [[NSNotificationCenter defaultCenter] addObserver: self
      selector: @selector(signOut) name: CurrentUserSignOut 
        object: nil];
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  CGRect screen = [[UIScreen mainScreen] bounds];
  UIColor *gray40 = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
    blue: (40/255.0) alpha: 1];
  UIFont *font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  // Main view
  UIView *mainView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 
    screen.size.width, (screen.size.height - (20 + 44 + 49)))];
  mainView.backgroundColor = [UIColor backgroundColor];
  self.view = mainView;
  // Table
  self.table = [[UITableView alloc] init];
  self.table.backgroundColor = [UIColor backgroundColor];
  self.table.frame = mainView.frame;
  self.table.dataSource = self;
  self.table.delegate = self;
  self.table.separatorColor = [UIColor colorWithRed: (120/255.0) 
    green: (120/255.0) blue: (120/255.0) alpha: 1];
  self.table.showsVerticalScrollIndicator = NO;
  [self.view addSubview: self.table];
  // Search name field
  self.searchNameField = [[TextFieldPadding alloc] init];
  self.searchNameField.backgroundColor = [UIColor whiteColor];
  self.searchNameField.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.searchNameField.delegate = self;
  self.searchNameField.frame = CGRectMake(10, 8, (screen.size.width - 20), 28);
  self.searchNameField.font = font;
  self.searchNameField.paddingX = 28;
  self.searchNameField.paddingY = 5;
  self.searchNameField.placeholder = @"Name of place";
  self.searchNameField.textColor = gray40;
  self.searchNameField.layer.cornerRadius = 2;
  [self.searchNameField addTarget: self action: @selector(fetchPlaces:)
    forControlEvents: UIControlEventEditingChanged];
  // search name image
  UIImageView *searchNameImage = [[UIImageView alloc] initWithImage: 
    [UIImage imageNamed: @"search_name.png"]];
  searchNameImage.frame = CGRectMake(5, 0, 18, 18);
  searchNameImage.alpha = 0.3;
  UIView *searchNameImageView = [[UIView alloc] init];
  searchNameImageView.frame = CGRectMake(0, 0, 28, 18);
  [searchNameImageView addSubview: searchNameImage];
  self.searchNameField.leftView = searchNameImageView;
  self.searchNameField.leftViewMode = UITextFieldViewModeAlways;
  self.navigationItem.titleView = self.searchNameField;
  // Search location
  self.searchLocation = [[UIView alloc] init];
  self.searchLocation.frame = CGRectMake(0, -44, screen.size.width, 44);
  self.searchLocation.backgroundColor = [UIColor colorWithRed: (200/255.0)
    green: (200/255.0) blue: (200/255.0) alpha: 1];
  [self.view addSubview: self.searchLocation];
  // location field
  self.searchLocationField = [[TextFieldPadding alloc] init];
  self.searchLocationField.backgroundColor = [UIColor whiteColor];
  self.searchLocationField.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.searchLocationField.delegate = self;
  self.searchLocationField.frame = CGRectMake(10, 8, 
    (screen.size.width - (10 + 10 + 58 + 10)), 28);
  self.searchLocationField.font = font;
  self.searchLocationField.paddingX = 28;
  self.searchLocationField.paddingY = 5;
  self.searchLocationField.placeholder = @"City, state, or zip";
  self.searchLocationField.textColor = gray40;
  self.searchLocationField.layer.cornerRadius = 2;
  [self.searchLocation addSubview: self.searchLocationField];
  // search location image
  UIImageView *searchLocationImage = [[UIImageView alloc] initWithImage:
    [UIImage imageNamed: @"search_location.png"]];
  searchLocationImage.frame = CGRectMake(5, 0, 18, 18);
  searchLocationImage.alpha = 0.3;
  UIView *searchLocationImageView = [[UIView alloc] init];
  searchLocationImageView.frame = CGRectMake(0, 0, 28, 18);
  [searchLocationImageView addSubview: searchLocationImage];
  self.searchLocationField.leftView = searchLocationImageView;
  self.searchLocationField.leftViewMode = UITextFieldViewModeAlways;
  // cancel button
  UIButton *cancelButton = [[UIButton alloc] init];
  cancelButton.backgroundColor = [UIColor colorWithRed: (240/255.0) 
    green: (240/255.0) blue: (240/255.0) alpha: 1];
  cancelButton.backgroundColor = [UIColor clearColor];
  cancelButton.frame = 
    CGRectMake((10 + self.searchLocationField.frame.size.width + 10), 8, 
      58, 28);
  cancelButton.layer.cornerRadius = 2;
  cancelButton.layer.masksToBounds = YES;
  cancelButton.titleLabel.font = 
    [UIFont fontWithName: @"HelveticaNeue-Bold" size: 12];
  cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [cancelButton addTarget: self action: @selector(cancelSearch:) 
    forControlEvents: UIControlEventTouchUpInside];
  [cancelButton setTitle: @"Cancel" forState: UIControlStateNormal];
  [cancelButton setTitleColor: gray40 forState: UIControlStateNormal];
  [self.searchLocation addSubview: cancelButton];
}

- (void) viewWillAppear: (BOOL) animated
{
  [super viewWillAppear: animated];
  // Find user's location
  [locationManager startUpdatingLocation];
  if ([CLLocationManager authorizationStatus] != 
    kCLAuthorizationStatusAuthorized) { 
    if (![[User currentUser].location isEqual: @""]) {
      self.searchLocationField.text = [User currentUser].location;
    }
  }
  // If no places are on screen, make name field first responder
  if ([StartPlaceStore sharedStore].places.count == 0) {
    [self.searchNameField becomeFirstResponder];
  }
}

- (void) viewWillDisappear: (BOOL) animated
{
  [super viewWillDisappear: animated];
  [locationManager stopUpdatingLocation];
}

#pragma mark - Protocol CLLocationManagerDelegate

- (void) locationManager: (CLLocationManager *) manager
didFailyWithError: (NSError *) error
{
  NSLog(@"StartViewController Location Manager Error: %@",
    error.localizedDescription);
}

- (void) locationManager: (CLLocationManager *) manager
didUpdateLocations: (NSArray *) locations
{
  [self foundLocation: locations];
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

- (void) scrollViewWillBeginDragging: (UIScrollView *) scrollView
{
  if (self.searchLocationField.isFirstResponder || 
    self.searchNameField.isFirstResponder) {

    [self hideSearch];
  }
}

#pragma mark - Protocol UITableViewDataSource

- (NSInteger) numberOfRowsInTableView: (UITableView *) tableView
{
  return 1;
}

- (UITableViewCell *) tableView: (UITableView *) tableView
cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
  static NSString *cellReuseIdentifier = @"PlaceCell";
  Place *place = [[StartPlaceStore sharedStore].places objectAtIndex: 
    indexPath.row];
  PlaceCell *cell = [self.table dequeueReusableCellWithIdentifier: 
    cellReuseIdentifier];
  if (!cell) {
    cell = [[PlaceCell alloc] initWithStyle: UITableViewCellStyleDefault
      reuseIdentifier: cellReuseIdentifier];
  }
  [cell loadPlaceData: place];
  if (!place.image) {
    if (self.table.decelerating == NO && self.table.dragging == NO) {
      [place downloadImage:
        ^(void) {
          cell.placeImageView.image = [place tableCellImage];
        }
      ];
    }
    cell.placeImageView.image = [UIImage imageNamed: @"placeholder.png"];
  }
  else {
    cell.placeImageView.image = place.image;
  }

  return cell;
}

- (NSInteger) tableView: (UITableView *) tableView
numberOfRowsInSection: (NSInteger) section
{
  return [StartPlaceStore sharedStore].places.count;
}

#pragma mark - Protocol UITableViewDelegate

- (void) tableView: (UITableView *) tableView
didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
  Place *place = [[StartPlaceStore sharedStore].places objectAtIndex: 
    indexPath.row];
  StartPlaceNavigationController *startPlaceNav = 
    [[StartPlaceNavigationController alloc] initWithPlace: place 
      viewController: self];
  [self presentViewController: startPlaceNav animated: YES completion: 
    ^(void) {
      [self hideSearch];
    }
  ];
}

- (CGFloat) tableView: (UITableView *) tableView
heightForFooterInSection: (NSInteger) section
{
  return 0.1f;
}

- (CGFloat) tableView: (UITableView *) tableView
heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
  return 100;
}

- (UIView *) tableView: (UITableView *) tableView
viewForFooterInSection: (NSInteger) section
{
  return [[UIView alloc] init];
}

#pragma mark - Protocol UITextFieldDelegate

- (void) textFieldDidBeginEditing: (UITextField *) textField
{
  [textField becomeFirstResponder];
  if ([textField isEqual: self.searchNameField]) {
    [self showSearch];
  }
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField
{
  if ([self.searchNameField.text isEqual: @""]) {
    [self.searchNameField becomeFirstResponder];
  }
  else {
    [self hideSearch];
    [self fetchPlaces: nil];
  }
  return NO;
}

#pragma mark - Methods

- (void) cancelSearch: (id) sender
{
  self.searchNameField.text = @"";
  [self hideSearch];
  [[StartPlaceStore sharedStore].places removeAllObjects];
  [self.table reloadData];
}

- (void) fetchPlaces: (id) sender
{
  YelpConnection *connection = [[YelpConnection alloc] init];
  if ([self.searchLocationField.text isEqual: @"Locations near me"] &&
    [User currentUser].latitude && [User currentUser].longitude) {

    connection.ll = [NSString stringWithFormat: @"%f,%f",
      [User currentUser].latitude, [User currentUser].longitude];
  }
  else {
    if (self.searchLocationField.text) {
      connection.location = self.searchLocationField.text;
    }
    else {
      connection.location = [User currentUser].location;
    }
  }
  connection.term = self.searchNameField.text;
  connection.completionBlock = 
    ^(NSError *error) {
      [self.table reloadData];
    };
  [connection start];
}

- (void) foundLocation: (NSArray *) locations
{
  for (CLLocation *location in locations) {
    [User currentUser].latitude = location.coordinate.latitude;
    [User currentUser].longitude = location.coordinate.longitude;
  }
  self.searchLocationField.text = @"Locations near me";
}

- (void) hideSearch
{
  void (^animations) (void) = ^(void) {
    self.searchLocation.frame = CGRectMake(0, -44,
      self.searchLocation.frame.size.width,
        self.searchLocation.frame.size.height);
    self.table.frame = CGRectMake(0, 0, 
      self.table.frame.size.width, self.table.frame.size.height);
  };

  [self.searchLocationField resignFirstResponder];
  [self.searchNameField resignFirstResponder];
  [UIView animateWithDuration: 0.15 delay: 0
    options: UIViewAnimationOptionCurveLinear animations: animations
      completion: nil];
}

- (void) loadImagesForOnscreenRows
{
  if ([StartPlaceStore sharedStore].places.count > 0) {
    NSArray *visiblePaths = [self.table indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths) {
      Place *place = [[StartPlaceStore sharedStore].places objectAtIndex: 
        indexPath.row];
      PlaceCell *cell = (PlaceCell *) [self.table cellForRowAtIndexPath: 
        indexPath];
      if (!place.image) {
        [place downloadImage: 
          ^(void) {
            cell.placeImageView.image = [place tableCellImage];
          }
        ];
      }
    }
  }
}

- (void) showSearch
{
  void (^animations) (void) = ^(void) {
    self.searchLocation.frame = CGRectMake(0, 0, 
      self.searchLocation.frame.size.width, 
        self.searchLocation.frame.size.height);
    self.table.frame = CGRectMake(0, 44, 
      self.table.frame.size.width, self.table.frame.size.height);
  };

  [UIView animateWithDuration: 0.15 delay: 0 
    options: UIViewAnimationOptionCurveLinear animations: animations 
      completion: nil];
}

- (void) signOut
{
  [[StartPlaceStore sharedStore] clearPlaces];
  [self.table reloadData];
}

@end
