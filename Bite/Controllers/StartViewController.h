//
//  StartViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 5/24/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "BiteViewController.h"

@class TextFieldPadding;

@interface StartViewController : BiteViewController 
<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, 
UITextFieldDelegate>
{
  CLLocationManager *locationManager;
  NSMutableData *responseData;
}

@property (nonatomic, strong) UIView *searchLocation;
@property (nonatomic, strong) TextFieldPadding *searchLocationField;
@property (nonatomic, strong) TextFieldPadding *searchNameField;
@property (nonatomic, strong) UITableView *table;

#pragma mark - Methods

- (void) cancelSearch: (id) sender;
- (void) fetchPlaces: (id) sender;
- (void) foundLocation: (NSArray *) locations;
- (void) hideSearch;
- (void) showSearch;
- (void) signOut;

@end
