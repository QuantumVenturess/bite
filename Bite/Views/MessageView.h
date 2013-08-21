//
//  MessageView.h
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Message;

@interface MessageView : UIView

@property (nonatomic, weak) Message *message;
@property (nonatomic, strong) UIButton *userNameButton;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame message: (Message *) messageObject;

@end
