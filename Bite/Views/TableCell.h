//
//  TableCell.h
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;
@class Table;

@interface TableCell : UITableViewCell

@property (nonatomic, strong) UIButton *joinTableButton;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *placeImageView;
@property (nonatomic, strong) UIView *seatsView;
@property (nonatomic, strong) UILabel *startedBy;
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) Table *table;
@property (nonatomic, weak) UITableView *tableView;

#pragma mark - Methods

- (void) joinTable: (id) sender;
- (void) loadSeatImageViews;
- (void) loadTableData: (Table *) tableObject;

@end
