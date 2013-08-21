//
//  UserSeat.m
//  Bite
//
//  Created by Tommy DANGerous on 5/23/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Seat.h"
#import "UIImage+Resize.h"
#import "User.h"
#import "UserSeat.h"

@implementation UserSeat

@synthesize seat;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame seat: (Seat *) seatObject
{
  self = [super initWithFrame: frame];
  if (self) {
    self.seat = seatObject;
    // User's image
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode   = UIViewContentModeTopLeft;
    imageView.frame         = CGRectMake(0, 10, 30, 30);
    if (!self.seat.user.image) {
      [self.seat.user downloadImage:
        ^(void) {
          imageView.image = [self.seat.user image30By30];
        }
      ];
      imageView.image = [UIImage imageNamed: @"placeholder.png"];
    }
    else {
      imageView.image = [self.seat.user image30By30];
    }
    [self addSubview: imageView];
    // User's name
    UILabel *label = [[UILabel alloc] initWithFrame: 
      CGRectMake((30 + 10), 10, (self.frame.size.width - (30 + 10)), 30)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 13];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.text = self.seat.user.name;
    label.textColor = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
      blue: (40/255.0) alpha: 1];
    [self addSubview: label];
  }
  return self;
}

@end
