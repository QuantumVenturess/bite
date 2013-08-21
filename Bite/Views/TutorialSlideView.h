//
//  TutorialSlideView.h
//  Bite
//
//  Created by Tommy DANGerous on 6/6/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TutorialView;

@interface TutorialSlideView : UIView
{
  int currentPage;
  float horizontalTouchPosition;
}

@property (nonatomic, weak) TutorialView *tutorialView;

@end
