//
//  User.h
//  Bite
//
//  Created by Tommy DANGerous on 5/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import <Foundation/Foundation.h>

extern NSString *const BiteAccessTokenReceivedNotification;

@class Table;

@interface User : NSObject

@property (strong, nonatomic) NSString *accessToken;
@property (nonatomic) BOOL admin;
@property (strong, nonatomic) NSString *biteAccessToken;
@property (nonatomic) int completeCount;
@property (strong, nonatomic) NSString *email;
@property (nonatomic) double facebookId;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL readTutorial;
@property (nonatomic) int sittingCount;
@property (nonatomic) int startedCount;
@property (nonatomic) int uid;
// ios
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic, strong) UIImage *image;

#pragma mark Methods

+ (User *) currentUser;

- (void) authenticateWithServer: (void (^) (NSError *error)) block;
- (void) downloadImage: (void (^) (void)) block;
- (UIImage *) image30By30;
- (UIImage *) image60By60;
- (BOOL) isSittingAtTable: (Table *) table;
- (void) getBiteAccessToken: (NSDictionary *) dictionary;
- (NSString *) partialToken;
- (void) readFromDictionary: (NSDictionary *) dictionary;
- (BOOL) registeredForPushNotifications;
- (NSString *) rememberTokenIos;
- (UIImage *) seatImage;
- (void) sessionStateChanged: (NSNotification *) notification;
- (void) signOut;

@end
