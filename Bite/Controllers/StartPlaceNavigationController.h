//
//  StartPlaceNavigationController.h
//  Bite
//
//  Created by Tommy DANGerous on 6/3/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;
@class Table;

@interface StartPlaceNavigationController : UINavigationController

#pragma mark - Initializer

- (id) initWithPlace: (Place *) placeObject viewController: (id) viewController;
- (id) initWithTable: (Table *) tableObject viewController: (id) viewController;

@end
