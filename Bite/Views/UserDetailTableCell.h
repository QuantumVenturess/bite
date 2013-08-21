//
//  UserDetailTableCell.h
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+TimeAgo.h"
#import "Place.h"
#import "Table.h"

@interface UserDetailTableCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) Table *table;
@property (nonatomic, strong) UILabel *timestamp;

#pragma mark - Methods

- (void) loadTableData: (Table *) tableObject;

@end
