//
//  Place.m
//  Bite
//
//  Created by Tommy DANGerous on 5/17/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "Place.h"
#import "PlaceImageDownloader.h"
#import "UIImage+Resize.h"

@implementation Place

// attributes
@synthesize address;
@synthesize createdAt;
@synthesize uid;
@synthesize city;
@synthesize imageURL;
@synthesize latitude;
@synthesize longitude;
@synthesize name;
@synthesize phone;
@synthesize postalCode;
@synthesize rating;
@synthesize reviewCount;
@synthesize s3URL;
@synthesize stateCode;
@synthesize yelpId;
@synthesize updatedAt;
// ios
@synthesize image;

#pragma mark Methods

- (void) downloadImage: (void (^) (void)) block
{
  PlaceImageDownloader *downloader = 
    [[PlaceImageDownloader alloc] initWithPlace: self];
  downloader.completionBlock = block;
  [downloader startDownload];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  self.address = [dictionary objectForKey: @"address"];
  self.city = [dictionary objectForKey: @"city"];
  self.createdAt = 
    [[[NSDate date] initWithString: 
      [dictionary objectForKey: @"created_at"]] timeIntervalSince1970];
  self.uid = [[dictionary objectForKey: @"id"] integerValue];
  if ([dictionary objectForKey: @"image_url"] != [NSNull null]) {
    self.imageURL = 
      [NSURL URLWithString: [dictionary objectForKey: @"image_url"]];
  }
  self.latitude = [[dictionary objectForKey: @"latitude"] floatValue];
  self.longitude = [[dictionary objectForKey: @"longitude"] floatValue];
  self.name = [dictionary objectForKey: @"name"];
  self.phone = [dictionary objectForKey: @"phone"];
  self.postalCode = [[dictionary objectForKey: @"postal_code"] integerValue];
  self.rating = [[dictionary objectForKey: @"rating"] floatValue];
  self.reviewCount = [[dictionary objectForKey: @"review_count"] integerValue];
  if ([dictionary objectForKey: @"s3_url"] != [NSNull null]){
    self.s3URL = 
      [NSURL URLWithString: [dictionary objectForKey: @"s3_url"]];
  }
  self.stateCode = [dictionary objectForKey: @"state_code"];
  self.yelpId = [dictionary objectForKey: @"yelp_id"];
  self.updatedAt = 
    [[[NSDate date] initWithString:
      [dictionary objectForKey: @"updated_at"]] timeIntervalSince1970];
}

- (void) readFromYelpDictionary: (NSDictionary *) dictionary
{
  NSDictionary *locationDictionary = [dictionary objectForKey: @"location"];
  NSDictionary *coordinateDictionary = [locationDictionary objectForKey: 
    @"coordinate"];
  NSArray *addresses = [locationDictionary objectForKey: @"address"];
  if (addresses.count > 0) {
    self.address = [addresses objectAtIndex: 0];
  }
  else {
    self.address = @"";
  }
  self.city = [locationDictionary objectForKey: @"city"];
  self.imageURL = [NSURL URLWithString: 
    [dictionary objectForKey: @"image_url"]];
  self.latitude = [[coordinateDictionary objectForKey: @"latitude"] floatValue];
  self.longitude = [[coordinateDictionary objectForKey: 
    @"longitude"] floatValue];
  self.name = [dictionary objectForKey: @"name"];
  self.phone = [dictionary objectForKey: @"phone"];
  self.postalCode = 
    [[locationDictionary objectForKey: @"postal_code"] integerValue];
  self.rating = [[dictionary objectForKey: @"rating"] floatValue];
  self.reviewCount = [[dictionary objectForKey: @"review_count"] integerValue];
  self.stateCode = [locationDictionary objectForKey: @"state_code"];
  self.yelpId = [dictionary objectForKey: @"id"];
}

- (UIImage *) tableCellImage
{
  if (self.image) {
    return [UIImage image: self.image resized: CGSizeMake(60, 60) 
      position: CGPointMake(0, 0)];
  }
  else {
    return [[UIImage alloc] init];
  }
}

- (UIImage *) tableCompleteCellImage
{
  if (self.image) {
    return [UIImage image: self.image resized: CGSizeMake(40, 40) 
      position: CGPointMake(0, 0)];
  }
  else {
    return [[UIImage alloc] init];
  }
}

- (UIImage *) yelpRatingImage
{
  NSString *imageName;

  if (self.rating == 0.0)
    imageName = @"zero";
  else if (self.rating == 1.0)
    imageName = @"one";
  else if (self.rating == 1.5)
    imageName = @"one_five";
  else if (self.rating == 2.0)
    imageName = @"two";
  else if (self.rating == 2.5)
    imageName = @"two_five";
  else if (self.rating == 3.0)
    imageName = @"three";
  else if (self.rating == 3.5)
    imageName = @"three_five";
  else if (self.rating == 4.0)
    imageName = @"four";
  else if (self.rating == 4.5)
    imageName = @"four_five";
  else if (self.rating == 5.0)
    imageName = @"five";
  else
    imageName = @"zero";

  return [UIImage imageNamed: [NSString stringWithFormat: 
    @"yelp_%@.png", imageName]];
}

@end
