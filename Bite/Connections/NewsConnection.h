//
//  NewsConnection.h
//  Bite
//
//  Created by Tommy DANGerous on 6/4/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "BiteConnection.h"

@interface NewsConnection : BiteConnection

@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) id viewController;

@end
