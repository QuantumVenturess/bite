//
//  BiteViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 6/3/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GAITrackedViewController.h"
#import "UIColor+Extensions.h"

@interface BiteViewController : GAITrackedViewController

#pragma mark - Methods

- (void) back;
- (void) refreshUnviewedNewsCount;

@end
