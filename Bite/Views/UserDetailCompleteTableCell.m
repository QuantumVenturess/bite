//
//  UserDetailCompleteTableCell.m
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailCompleteTableCell.h"

@implementation UserDetailCompleteTableCell

#pragma mark - Methods

- (void) loadTableData: (Table *) tableObject
{
  [super loadTableData: tableObject];
  self.contentLabel.text = [NSString stringWithFormat: @"%@ completed", 
    self.table.place.name];
  self.timestamp.text = [NSString stringWithFormat: @"%@ with %i %@",
    [[NSDate dateWithTimeIntervalSince1970: self.table.dateComplete] timeAgo], 
      self.table.seats.count - 1, 
        (self.table.seats.count - 1) == 1 ? @"other" : @"others"];
}

@end
