//
//  MessageNavigationController.h
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableDetailViewController;
@class Table;

@interface MessageNavigationController : UINavigationController

#pragma mark - Initializer

- (id) initWithTable: (Table *) tableObject
viewController: (TableDetailViewController *) viewController;

@end
