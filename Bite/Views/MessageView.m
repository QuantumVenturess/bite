//
//  MessageView.m
//  Bite
//
//  Created by Tommy DANGerous on 5/28/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "NSDate+TimeAgo.h"
#import "Message.h"
#import "MessageView.h"
#import "User.h"

@implementation MessageView

@synthesize message;
@synthesize userNameButton;

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame message: (Message *) messageObject
{
  self = [super initWithFrame: frame];
  if (self) {
    self.message = messageObject;
    // Border
    CALayer *topBorder = [CALayer layer];
    topBorder.backgroundColor = [UIColor colorWithRed: (160/255.0) 
      green: (160/255.0) blue: (160/255.0) alpha: 1].CGColor;
    topBorder.frame = CGRectMake(0, 0, self.frame.size.width, 1);
    [self.layer addSublayer: topBorder];
    // Image
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode   = UIViewContentModeTopLeft;
    imageView.frame         = CGRectMake(0, (1 + 10), 30, 30);
    if (!self.message.user.image) {
      void (^completionBlock) (void) =
      ^void (void) {
        imageView.image = [self.message.user image30By30];
      };
      [self.message.user downloadImage: completionBlock];
    }
    else {
      imageView.image = [self.message.user image30By30];
    }
    [self addSubview: imageView];
    UIColor *gray40 = [UIColor colorWithRed: (40/255.0) green: (40/255.0) 
      blue: (40/255.0) alpha: 1];
    // Name
    self.userNameButton = [[UIButton alloc] init];
    self.userNameButton.backgroundColor = [UIColor clearColor];
    self.userNameButton.contentHorizontalAlignment = 
      UIControlContentHorizontalAlignmentLeft;
    self.userNameButton.frame = CGRectMake((30 + 10), (1 + 10), 
      ((self.frame.size.width - (30 + 10)) * 0.65), 15);
    self.userNameButton.titleLabel.font = [UIFont fontWithName: 
      @"HelveticaNeue-Bold" size: 13];
    self.userNameButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.userNameButton setTitle: self.message.user.name 
      forState: UIControlStateNormal];
    [self.userNameButton setTitleColor: gray40
      forState: UIControlStateNormal];
    [self addSubview: self.userNameButton];
    // Timestamp
    UILabel *timestamp = [[UILabel alloc] init];
    timestamp.backgroundColor = [UIColor clearColor];
    timestamp.font = [UIFont fontWithName: @"HelveticaNeue" size: 12];
    timestamp.frame = 
      CGRectMake((self.userNameButton.frame.origin.x + 
        self.userNameButton.frame.size.width), (1 + 10), 
          ((self.frame.size.width - (30 + 10)) * 0.35), 15);
    timestamp.lineBreakMode = NSLineBreakByTruncatingTail;
    timestamp.text = [[NSDate dateWithTimeIntervalSince1970: 
      self.message.createdAt] timeAgo];
    timestamp.textAlignment = NSTextAlignmentRight;
    timestamp.textColor = [UIColor colorWithRed: (160/255.0) green: (160/255.0) 
      blue: (160/255.0) alpha: 1];
    [self addSubview: timestamp];
    // Content
    UILabel *content = [[UILabel alloc] init];
    content.backgroundColor = [UIColor clearColor];
    content.font = [UIFont fontWithName: @"HelveticaNeue" size: 13];
    content.frame = CGRectMake((30 + 10), (1 + 10 + 15 + 4), 
      (self.frame.size.width - (30 + 10)), 15);
    content.numberOfLines = 0;
    content.text = self.message.content;
    content.textColor = gray40;
    [content sizeToFit];
    [self addSubview: content];
    // Resize message view frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
      self.frame.size.width, 
        (1 + 10 + 15 + 4 + content.frame.size.height + 10));
  }
  return self;
}

@end
