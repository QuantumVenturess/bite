//
//  UserDetailStartedTableCell.m
//  Bite
//
//  Created by Tommy DANGerous on 6/11/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UserDetailStartedTableCell.h"

@implementation UserDetailStartedTableCell

#pragma mark - Methods

- (void) loadTableData: (Table *) tableObject
{
  [super loadTableData: tableObject];
  self.contentLabel.text = self.table.place.name;

  // Date calculation
  NSString *string;
  NSTimeInterval now     = [[NSDate date] timeIntervalSince1970];
  NSTimeInterval seconds = self.table.startDate - now;
  if (seconds > 0) {
    int minutes = seconds / 60;
    int hours   = minutes / 60;
    int days    = hours / 24;
    int weeks   = days / 7;
    int months  = days / 30;
    int years   = days / 365;
    if (years > 0) {
      string = [NSString stringWithFormat: @"%i %@", years, 
        years == 1 ? @"year" : @"years"];
    }
    else if (months > 0) {
      string = [NSString stringWithFormat: @"%i %@", months, 
        months == 1 ? @"month" : @"months"];
    }
    else if (weeks > 0) {
      string = [NSString stringWithFormat: @"%i %@", weeks, 
        weeks == 1 ? @"week" : @"weeks"];
    }
    else if (days > 0) {
      string = [NSString stringWithFormat: @"%i %@", days, 
        days == 1 ? @"day" : @"days"];
    }
    else if (hours > 0) {
      string = [NSString stringWithFormat: @"%i %@", hours, 
        hours == 1 ? @"hour" : @"hours"];
    }
    else if (minutes > 0) {
      string = [NSString stringWithFormat: @"%i %@", minutes, 
        minutes == 1 ? @"minute" : @"minutes"];
    }
    else {
      string = [NSString stringWithFormat: @"%i %@", (int) seconds,
        seconds == 1 ? @"second" : @"seconds"];
    }
    string = [NSString stringWithFormat: @"starting in %@", string];
  }
  else {
    string = @"already started";
  }
  self.timestamp.text = string;
}

@end
