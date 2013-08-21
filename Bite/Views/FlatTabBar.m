//
//  FlatTabBar.m
//  Bite
//
//  Created by Tommy DANGerous on 5/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "FlatTabBar.h"
#import "UIImage+Resize.h"

@implementation FlatTabBar

- (id) initWithFrame: (CGRect) frame
{
  self = [super initWithFrame: frame];
  if (self) {
    // self.tintColor = [UIColor redColor];
    // self.selectedImageTintColor = nil;
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIImage *image = [UIImage imageNamed: @"tab_bar_selected.png"];
    self.selectionIndicatorImage = [UIImage image: image resized: 
      CGSizeMake((screen.size.width / 4.0), 49) position: CGPointMake(0, 0)];
  }
  return self;
}

- (void) drawRect: (CGRect) rect
{
  UIColor *color = 
    [UIColor colorWithRed: (60/255.0) green: (60/255.0) blue: (60/255.0) 
      alpha: 1];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColor(context, CGColorGetComponents([color CGColor]));
  CGContextFillRect(context, rect);
}

@end
