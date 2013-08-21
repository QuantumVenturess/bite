//
//  MessagesView.h
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Table;

@interface MessagesView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *messages;
@property (nonatomic, weak) Table *table;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame table: (Table *) tableObject;

#pragma mark - Methds

- (void) refreshData;

@end
