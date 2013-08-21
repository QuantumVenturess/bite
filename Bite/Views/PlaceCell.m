//
//  PlaceCell.m
//  Bite
//
//  Created by Tommy DANGerous on 6/1/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Place.h"
#import "PlaceCell.h"

@implementation PlaceCell

@synthesize place;
@synthesize locationLabel;
@synthesize nameLabel;
@synthesize placeImageView;
@synthesize ratingImageView;
@synthesize reviewCountLabel;

#pragma mark - Initializer

- (id) initWithStyle: (UITableViewCellStyle) style 
reuseIdentifier: (NSString *) reuseIdentifier
{
  self = [super initWithStyle: UITableViewCellStyleDefault 
    reuseIdentifier: reuseIdentifier];
  if (self) {
    // Fonts, colors
    UIFont *font = [UIFont fontWithName: @"HelveticaNeue" size: 14];
    UIColor *gray40 = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
      blue: (40/255.0) alpha: 1];
    // UITableViewCell properties
    self.selectedBackgroundView = [[UIView alloc] init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Screen
    CGRect screen = [[UIScreen mainScreen] bounds];
    // Content view
    self.contentView.frame = CGRectMake(0, 0, screen.size.width, 100);
    // Place image view
    self.placeImageView = [[UIImageView alloc] init];
    self.placeImageView.frame = CGRectMake(10, 20, 60, 60);
    [self.contentView addSubview: self.placeImageView];
    // Name label
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont fontWithName: @"HelveticaNeue-Bold" size: 14];
    self.nameLabel.frame = CGRectMake((10 + 60 + 10), 20, 
      (screen.size.width - (10 + 60 + 10 + 10)), 20);
    self.nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.nameLabel.textColor = gray40;
    [self.contentView addSubview: self.nameLabel];
    // Rating image view
    self.ratingImageView = [[UIImageView alloc] init];
    self.ratingImageView.frame = CGRectMake((10 + 60 + 10), (20 + 20 + 2), 
      84, 16);
    [self.contentView addSubview: self.ratingImageView];
    // Review count label
    self.reviewCountLabel = [[UILabel alloc] init];
    self.reviewCountLabel.backgroundColor = [UIColor clearColor];
    self.reviewCountLabel.font = font;
    self.reviewCountLabel.frame = CGRectMake((10 + 60 + 10 + 84 + 5), (20 + 20),
      (screen.size.width - (10 + 60 + 10 + 84 + 5 + 10)), 20);
    self.reviewCountLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.reviewCountLabel.textColor = gray40;
    [self.contentView addSubview: self.reviewCountLabel];
    // Location label
    self.locationLabel = [[UILabel alloc] init];
    self.locationLabel.backgroundColor = [UIColor clearColor];
    self.locationLabel.font = font;
    self.locationLabel.frame = CGRectMake((10 + 60 + 10), (20 + 20 + 20),
      (screen.size.width - (10 + 60 + 10 + 10)), 20);
    self.locationLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.locationLabel.textColor = gray40;
    [self.contentView addSubview: self.locationLabel];
  }
  return self;
}

#pragma mark - Methods

- (void) loadPlaceData: (Place *) placeObject
{
  self.place = placeObject;
  self.nameLabel.text = self.place.name;
  self.ratingImageView.image = [self.place yelpRatingImage];
  self.reviewCountLabel.text = [NSString stringWithFormat: @"%i %@",
    self.place.reviewCount, 
      self.place.reviewCount == 1 ? @"review" : @"reviews"];
  self.locationLabel.text = [NSString stringWithFormat: @"%@, %@, %@ %i",
    self.place.address, self.place.city, self.place.stateCode, 
      self.place.postalCode];
}

@end
