//
//  MenuView.h
//  Bite
//
//  Created by Tommy DANGerous on 6/5/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView <UIAlertViewDelegate>
{
  UIButton *shareButton;
}

@property (nonatomic, strong) UIButton *aboutButton;
@property (nonatomic, strong) UIImageView *aboutImageView;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic) float horizontalOffset;
@property (nonatomic, strong) UIView *menu;
@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIButton *rateUsButton;
@property (nonatomic, strong) UIImageView *rateUsImageView;
@property (nonatomic, strong) UIButton *signOutButton;
@property (nonatomic, strong) UIImageView *signOutImageView;

#pragma mark - Methods

- (void) hideMenu;
- (void) hideOrShowMenu;
- (void) openURL;
- (void) showAbout;
- (void) showMenu;
- (void) showProfile;
- (void) velocityCheck: (UIPanGestureRecognizer *) gesture;

@end
