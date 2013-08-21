//
//  BiteTableViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 5/29/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteViewController.h"
#import "MenuBarButtonItem.h"
#import "Place.h"
#import "Seat.h"
#import "SeatConnection.h"
#import "Table.h"
#import "TableCell.h"
#import "TableDetailViewController.h"
#import "UIImage+Resize.h"
#import "User.h"

@interface BiteTableViewController : BiteViewController
<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSUInteger currentPage;
@property (nonatomic) NSUInteger maxPages;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UITableView *table;

#pragma mark - Methods

- (void) cleanTablesWithFinalCompletion: (void (^) (NSError *error)) block;
- (void) loadImagesForOnscreenRows;
- (void) loadSeats;
- (void) loadSeatsWithFinalCompletion: (void (^) (NSError *error)) block;
- (void) loadTablesWithFinalCompletion: (void (^) (NSError *error)) block;
- (void) refreshTable;
- (void) showTables;
- (void) signOut;

@end
