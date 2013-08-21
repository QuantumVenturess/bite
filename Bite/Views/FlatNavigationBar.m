//
//  FlatNavigationBar.m
//  Bite
//
//  Created by Tommy DANGerous on 5/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "FlatNavigationBar.h"
#import "UIColor+Extensions.h"

@implementation FlatNavigationBar

#pragma mark - Override

- (void) drawRect: (CGRect) rect
{
  UIColor *color = [UIColor darkRed];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColor(context, CGColorGetComponents([color CGColor]));
  CGContextFillRect(context, rect);
}

@end
