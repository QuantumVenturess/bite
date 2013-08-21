//
//  PlaceCell.h
//  Bite
//
//  Created by Tommy DANGerous on 6/1/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface PlaceCell : UITableViewCell

@property (nonatomic, strong) Place *place;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *placeImageView;
@property (nonatomic, strong) UIImageView *ratingImageView;
@property (nonatomic, strong) UILabel *reviewCountLabel;

#pragma mark - Methods

- (void) loadPlaceData: (Place *) placeObject;

@end
