//
//  StartPlaceViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 6/3/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiteViewController.h"

@class Place;
@class StartViewController;
@class Table;
@class TableDetailViewController;
@class TextFieldPadding;

@interface StartPlaceViewController : BiteViewController

@property (nonatomic, weak) Place *place;
@property (nonatomic, strong) UIDatePicker *startDatePicker;
@property (nonatomic, strong) TextFieldPadding *startDateTextField;
@property (nonatomic, weak) StartViewController *startViewController;
@property (nonatomic, weak) Table *table;
@property (nonatomic, weak) TableDetailViewController 
  *tableDetailViewController;

#pragma mark - Initializer

- (id) initWithPlace: (Place *) placeObject;
- (id) initWithTable: (Table *) tableObject;

#pragma mark - Methods

- (void) cancel: (id) sender;
- (void) dateChanged: (id) sender;
- (NSString *) dateAndTimeForDate: (NSDate *) date;
- (void) submit: (id) sender;

@end
