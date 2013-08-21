//
//  UserDetailSittingTableCell.m
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailSittingTableCell.h"

@implementation UserDetailSittingTableCell

#pragma mark - Methods

- (void) loadTableData: (Table *) tableObject
{
  [super loadTableData: tableObject];
  self.contentLabel.text = self.table.place.name;
  int others = self.table.seats.count - 1;
  NSString *string;
  switch (others) {
    case 0:
      string = @"nobody yet, come join";
      break;
    case 1:
      string = [NSString stringWithFormat: @"%i other", others];
      break;
    default:
      string = [NSString stringWithFormat: @"%i others", others];
      break;
  }
  self.timestamp.text = [NSString stringWithFormat: @"sitting with %@", string];
}

@end
