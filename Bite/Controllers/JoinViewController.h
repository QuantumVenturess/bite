//
//  JoinViewController.h
//  Bite
//
//  Created by Tommy DANGerous on 5/15/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BiteViewController.h"

@interface JoinViewController : BiteViewController

@property (strong, nonatomic) UIActivityIndicatorView *spinner;

#pragma mark Methods

- (void) signIn: (id) sender;
- (void) signInFailed;

@end
