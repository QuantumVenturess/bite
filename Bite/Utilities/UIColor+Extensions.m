//
//  UIColor+Extensions.m
//  Bite
//
//  Created by Tommy DANGerous on 6/9/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "UIColor+Extensions.h"

@implementation UIColor (Extensions)

+ (UIColor *) backgroundColor
{
  return [UIColor gray: 245];
}

+ (UIColor *) darkRed
{
  return [UIColor colorWithRed: (207/255.0) green: (4/255.0) blue: (4/255.0) 
    alpha: 1];
}

+ (UIColor *) gray: (int) value
{
  return [UIColor colorWithRed: (value/255.0) green: (value/255.0) 
    blue: (value/255.0) alpha: 1];
}

@end
