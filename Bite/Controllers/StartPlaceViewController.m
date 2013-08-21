//
//  StartPlaceViewController.m
//  Bite
//
//  Created by Tommy DANGerous on 6/3/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ChangeDateConnection.h"
#import "Place.h"
#import "Seat.h"
#import "SittingTableStore.h"
#import "SittingViewController.h"
#import "StartPlaceConnection.h"
#import "StartPlaceStore.h"
#import "StartPlaceViewController.h"
#import "StartViewController.h"
#import "Table.h"
#import "TableDetailViewController.h"
#import "TextFieldPadding.h"
#import "UIColor+Extensions.h"
#import "User.h"

@implementation StartPlaceViewController

@synthesize place;
@synthesize startDateTextField;
@synthesize startDatePicker;
@synthesize startViewController;
@synthesize table;
@synthesize tableDetailViewController;

#pragma mark - Initializer

- (id) initWithPlace: (Place *) placeObject
{
  self = [super init];
  if (self) {
    self.place = placeObject;
    self.title = self.place.name;
    self.trackedViewName = @"Start Place";
  }
  return self;
}

- (id) initWithTable: (Table *) tableObject
{
  self = [super init];
  if (self) {
    self.table = tableObject;
    self.title = self.table.place.name;
  }
  return self;
}

#pragma mark - Override UIViewController

- (void) loadView
{
  // Navigation item
  CGRect buttonFrame = CGRectMake(0, 0, 50, 28);
  UIColor *gray40 = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
    blue: (40/255.0) alpha: 1];
  // cancel
  UILabel *cancelLabel = [[UILabel alloc] init];
  cancelLabel.backgroundColor = [UIColor clearColor];
  cancelLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  cancelLabel.frame = CGRectMake(5, 0, 45, 28);
  cancelLabel.text = @"Cancel";
  cancelLabel.textAlignment = NSTextAlignmentLeft;
  cancelLabel.textColor = [UIColor whiteColor];
  cancelLabel.layer.cornerRadius = 2;
  cancelLabel.layer.masksToBounds = YES;
  UIButton *cancelButton = [[UIButton alloc] init];
  cancelButton.frame = buttonFrame;
  [cancelButton addTarget: self action: @selector(cancel:) 
    forControlEvents: UIControlEventTouchUpInside];
  [cancelButton addSubview: cancelLabel];
  self.navigationItem.leftBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: cancelButton];
  // submit
  UILabel *submitLabel = [[UILabel alloc] init];
  submitLabel.backgroundColor = [UIColor clearColor];
  submitLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  submitLabel.frame = CGRectMake(0, 0, 45, 28);
  if (self.table) {
    submitLabel.text = @"Save";
  }
  else {
    submitLabel.text = @"Start";
  }
  submitLabel.textAlignment = NSTextAlignmentRight;
  submitLabel.textColor = [UIColor whiteColor];
  submitLabel.layer.cornerRadius = 2;
  submitLabel.layer.masksToBounds = YES;
  UIButton *submitButton = [[UIButton alloc] init];
  submitButton.frame = buttonFrame;
  [submitButton addTarget: self action: @selector(submit:) 
    forControlEvents: UIControlEventTouchUpInside];
  [submitButton addSubview: submitLabel];
  self.navigationItem.rightBarButtonItem = 
    [[UIBarButtonItem alloc] initWithCustomView: submitButton];
  // Main view
  CGRect screen = [[UIScreen mainScreen] bounds];
  UIView *mainView = [[UIView alloc] initWithFrame:
    CGRectMake(0, 0, screen.size.width, (screen.size.height - (20 + 44)))];
  mainView.backgroundColor = [UIColor backgroundColor];
  self.view = mainView;

  // Start date
  // label
  UILabel *startDateLabel = [[UILabel alloc] init];
  startDateLabel.backgroundColor = [UIColor clearColor];
  startDateLabel.font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
  startDateLabel.frame = CGRectMake(10, 10, (screen.size.width - 20), 20);
  startDateLabel.text = @"Choose a start date:";
  startDateLabel.textColor = gray40;
  [self.view addSubview: startDateLabel];
  // text field
  self.startDateTextField = [[TextFieldPadding alloc] init];
  self.startDateTextField.backgroundColor = [UIColor clearColor];
  self.startDateTextField.font = [UIFont fontWithName: @"HelveticaNeue-Bold" 
    size: 14];
  self.startDateTextField.frame = CGRectMake(10, (10 + 20 + 10), 
    (self.view.frame.size.width - 20), 40);
  self.startDateTextField.paddingX = 0;
  self.startDateTextField.paddingY = 0;
  // date
  if (self.table) {
    self.startDateTextField.text = [self dateAndTimeForDate: 
      [NSDate dateWithTimeIntervalSince1970: self.table.startDate]];
  }
  else {
    self.startDateTextField.text = [self dateAndTimeForDate: [NSDate date]];
  }
  self.startDateTextField.textColor = gray40;
  self.startDateTextField.userInteractionEnabled = NO;
  self.startDateTextField.layer.borderWidth = 0;
  self.startDateTextField.layer.borderColor = [UIColor colorWithRed: (160/255.0)
    green: (160/255.0) blue: (160/255.0) alpha: 1].CGColor;
  [self.view addSubview: self.startDateTextField];

  // Date picker
  self.startDatePicker = [[UIDatePicker alloc] init];
  // date picker covers
  UIView *coverLeft = [[UIView alloc] init];
  coverLeft.backgroundColor = [UIColor gray: 245];
  coverLeft.frame = CGRectMake(0, 0, 12, 
    self.startDatePicker.frame.size.height);
  [self.startDatePicker addSubview: coverLeft];
  UIView *coverRight = [[UIView alloc] init];
  coverRight.backgroundColor = [UIColor gray: 245];
  coverRight.frame = CGRectMake((self.startDatePicker.frame.size.width - 12), 
    0, 12, self.startDatePicker.frame.size.height);
  [self.startDatePicker addSubview: coverRight];
  UIView *coverTop = [[UIView alloc] init];
  coverTop.backgroundColor = [UIColor gray: 245];
  coverTop.frame = CGRectMake(0, 0, self.startDatePicker.frame.size.width, 12);
  [self.startDatePicker addSubview: coverTop];
  UIView *coverBottom = [[UIView alloc] init];
  coverBottom.backgroundColor = [UIColor gray: 245];
  coverBottom.frame = CGRectMake(0, 
    (self.startDatePicker.frame.size.height - 12), 
      self.startDatePicker.frame.size.width, 12);
  [self.startDatePicker addSubview: coverBottom];
  if (self.table) {
    self.startDatePicker.date = [NSDate dateWithTimeIntervalSince1970: 
      self.table.startDate];
  }
  else {
    self.startDatePicker.date = [NSDate date];
  }
  self.startDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
  self.startDatePicker.frame = CGRectMake(0, 
    (self.view.frame.size.height - self.startDatePicker.frame.size.height),
      self.view.frame.size.width, self.startDatePicker.frame.size.height);
  self.startDatePicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | 
    UIViewAutoresizingFlexibleWidth;
  [self.startDatePicker addTarget: self action: @selector(dateChanged:)
    forControlEvents: UIControlEventValueChanged];
  [self.view addSubview: self.startDatePicker];
}

#pragma mark - Methods

- (void) cancel: (id) sender
{
  [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) dateChanged: (id) sender
{
  self.startDateTextField.text = [self dateAndTimeForDate: [sender date]];
  [self.startDateTextField setNeedsDisplay];
}

- (NSString *) dateAndTimeForDate: (NSDate *) date
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"EEEE MMMM dd, yyyy";
  NSString *day = [dateFormatter stringFromDate: date];
  dateFormatter.dateFormat = @"h:mm a";
  NSString *dateTime = [dateFormatter stringFromDate: date];
  return [NSString stringWithFormat: @"%@ at %@", 
    day, [dateTime lowercaseString]];
}

- (void) submit: (id) sender
{
  if (self.table) {
    self.table.startDate = [[self.startDatePicker date] timeIntervalSince1970];
    ChangeDateConnection *connection = 
      [[ChangeDateConnection alloc] initWithTable: self.table];
    [connection start];
    [self cancel: nil];
  }
  else {
    // Create table
    Table *newTable = [[Table alloc] init];
    newTable.createdAt = [[NSDate date] timeIntervalSince1970];
    newTable.maxSeats = 8;
    newTable.place = place;
    newTable.startDate = [[self.startDatePicker date] timeIntervalSince1970];
    newTable.updatedAt = newTable.createdAt;
    newTable.user = [User currentUser];
    newTable.userId = newTable.user.uid;
    // Create seat
    Seat *seat = [[Seat alloc] init];
    seat.createdAt = newTable.createdAt;
    seat.table = newTable;
    seat.updatedAt = seat.updatedAt;
    seat.user = [User currentUser];
    seat.userId = seat.user.uid;
    // Add seat to table
    [newTable addSeat: seat];
    // Hide start place view controller
    [self cancel: nil];
    // Hide search fields on start view controller
    if (self.startViewController) {
      [self.startViewController cancelSearch: nil];
    }
    // Add table to sitting table store
    [[SittingTableStore sharedStore].tables addObject: newTable];
    
    // Switch to sitting navigation controller
    UITabBarController *tabBarController = 
      (UITabBarController *) 
        [UIApplication sharedApplication].delegate.window.rootViewController;
    tabBarController.selectedIndex = 1;
    UINavigationController *navController = 
      (UINavigationController *) tabBarController.selectedViewController;
    // Pop all view controllers to root view controller (SittingViewController)
    [navController popToRootViewControllerAnimated: NO];
    SittingViewController *sittingViewController = 
      (SittingViewController *) [navController topViewController];
    [sittingViewController.table reloadData];
    // Push table detail view controller
    TableDetailViewController *tableDetail = 
      [[TableDetailViewController alloc] initWithTable: newTable];
    [navController pushViewController: tableDetail animated: NO];
    // Create connection to send data to server
    StartPlaceConnection *connection = 
      [[StartPlaceConnection alloc] initWithTable: newTable];
    [connection start];
  }
}

@end
