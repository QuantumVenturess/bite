//
//  Place.h
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

// attributes
@property (nonatomic, strong) NSString *address;
@property (nonatomic) NSTimeInterval createdAt;
@property (nonatomic) int uid;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic) int postalCode;
@property (nonatomic) float rating;
@property (nonatomic) int reviewCount;
@property (nonatomic, strong) NSURL *s3URL;
@property (nonatomic, strong) NSString *stateCode;
@property (nonatomic, strong) NSString *yelpId;
@property (nonatomic) NSTimeInterval updatedAt;
// ios
@property (nonatomic, strong) UIImage *image;

#pragma mark Methods

- (void) downloadImage: (void (^) (void)) block;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (void) readFromYelpDictionary: (NSDictionary *) dictionary;
- (UIImage *) tableCellImage;
- (UIImage *) tableCompleteCellImage;
- (UIImage *) yelpRatingImage;

@end
