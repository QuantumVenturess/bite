//
//  TutorialView.h
//  Bite
//
//  Created by Tommy DANGerous on 6/6/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TutorialSlideView;

@interface TutorialView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *beginButton;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) TutorialSlideView *slideView;

#pragma mark - Methods

- (void) hideTutorial;

@end
