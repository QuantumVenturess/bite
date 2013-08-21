//
//  ImageDownloader.h
//  Bite
//
//  Created by Tommy DANGerous on 5/21/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

@interface ImageDownloader : NSObject

@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, copy) void (^completionBlock) (void);
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property (nonatomic, strong) NSURL *imageURL;

#pragma mark - Methods

- (void) cancelDownload;
- (void) startDownload;

@end
