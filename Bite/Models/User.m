//
//  User.m
//  Bite
//
//  Created by Tommy DANGerous on 5/16/13.
//  Copyright (c) 2013 Quantum Ventures. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuView.h"
#import "ParseChannelSubscribeConnection.h"
#import "Table.h"
#import "TableConnection.h"
#import "TableStore.h"
#import "TutorialView.h"
#import "UIImage+Resize.h"
#import "User.h"
#import "UserConnection.h"
#import "UserImageDownloader.h"
#import "UserStore.h"

NSString *const BiteAccessTokenReceivedNotification = 
  @"BiteAccessTokenReceivedNotification";

@implementation User

@synthesize accessToken;
@synthesize admin;
@synthesize biteAccessToken;
@synthesize completeCount;
@synthesize email;
@synthesize facebookId;
@synthesize firstName;
@synthesize uid;
@synthesize imageURL;
@synthesize lastName;
@synthesize location;
@synthesize name;
@synthesize readTutorial;
@synthesize sittingCount;
@synthesize startedCount;
// ios
@synthesize latitude;
@synthesize longitude;
@synthesize image;

#pragma mark - Initializer

- (id) init
{
  self = [super init];
  if (self) {
    self.completeCount = 0;
    self.sittingCount  = 0;
    self.startedCount  = 0;
  }
  return self;
}

#pragma mark - Methods

+ (User *) currentUser
{
  static User *user = nil;
  if (!user) {
    user = [[User alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver: user
      selector: @selector(sessionStateChanged:) 
        name: FBSessionStateChangedNotification object: nil];
  }
  return user;
}

- (void) authenticateWithServer: (void (^) (NSError *error)) block
{
  UserConnection *connection = [[UserConnection alloc] initWithUser: self];
  connection.completionBlock = block;
  [connection start];

  NSLog(@"Authenticate with server");
}

- (void) downloadImage: (void (^) (void)) block
{
  UserImageDownloader *downloader = 
    [[UserImageDownloader alloc] initWithUser: self];
  downloader.completionBlock = block;
  [downloader startDownload];
}

- (void) getBiteAccessToken: (NSDictionary *) dictionary
{
  AppDelegate *appDelegate = (AppDelegate *) 
    [UIApplication sharedApplication].delegate;
  self.biteAccessToken = [dictionary objectForKey: @"bite_access_token"];
  self.uid = [[dictionary objectForKey: @"id"] integerValue];
  if ([[dictionary objectForKey: @"read_tutorial"] integerValue] == 1) {
    self.readTutorial = YES;
    appDelegate.tutorialView.hidden = YES;
  }
  else {
    self.readTutorial = NO;
    appDelegate.tutorialView.hidden = NO;
    void (^animations) (void) = ^(void) {
      appDelegate.tutorialView.alpha = 1;
    };
    [UIView animateWithDuration: 0.1 delay: 0
      options: UIViewAnimationOptionCurveLinear animations: animations
        completion: nil];
  }
  // Alert all controllers of receiving Bite access token
  [[NSNotificationCenter defaultCenter] postNotificationName: 
    BiteAccessTokenReceivedNotification object: nil];
  // Download current user's image and set menu profile image
  [[User currentUser] downloadImage: 
    ^(void) {
      AppDelegate *appDelegate = (AppDelegate *) 
        [UIApplication sharedApplication].delegate;
      appDelegate.menuView.profileImageView.image = 
        [[User currentUser] image30By30];
    }
  ];
  // Subscribe to all tables user is sitting at
  ParseChannelSubscribeConnection *connection =
    [[ParseChannelSubscribeConnection alloc] init];
  [connection start];
  [[UserStore sharedStore] addUser: self];

  NSLog(@"Bite access token received");
}

- (UIImage *) image30By30
{
  UIImage *img = 
    self.image ? self.image : [UIImage imageNamed: @"placeholder.png"];
  // Calculate new height or new width based on which is larger
  float newHeight, newWidth;
  if (img.size.width < img.size.height) {
    newWidth  = 30.0;
    newHeight = (newWidth / img.size.width) * img.size.height;
  }
  else {
    newHeight = 30.0;
    newWidth  = (newHeight / img.size.height) * img.size.width;
  }
  return [UIImage image: img resized: CGSizeMake(newWidth, newHeight) 
    position: CGPointMake(0, 0)];
}

- (UIImage *) image60By60
{
  UIImage *img = 
    self.image ? self.image : [UIImage imageNamed: @"placeholder.png"];
  // Calculate new height or new width based on which is larger
  float newHeight, newWidth;
  if (img.size.width < img.size.height) {
    newWidth  = 60.0;
    newHeight = (newWidth / img.size.width) * img.size.height;
  }
  else {
    newHeight = 60.0;
    newWidth  = (newHeight / img.size.height) * img.size.width;
  }
  return [UIImage image: img resized: CGSizeMake(newWidth, newHeight) 
    position: CGPointMake(0, 0)];
}


- (BOOL) isSittingAtTable: (Table *) table
{
  NSPredicate *predicate = [NSPredicate predicateWithFormat:
    @"%K == %i", @"userId", self.uid];
  NSArray *array = [table.seats filteredArrayUsingPredicate: predicate];
  return array.count > 0 ? YES : NO;
}

- (NSString *) partialToken
{
  return [NSString stringWithFormat: @"%@%@%@%@%@", 
    [self.accessToken substringWithRange: NSMakeRange(4, 1)],
    [self.accessToken substringWithRange: NSMakeRange(8, 1)],
    [self.accessToken substringWithRange: NSMakeRange(12, 1)],
    [self.accessToken substringWithRange: NSMakeRange(21, 1)],
    [self.accessToken substringWithRange: NSMakeRange(24, 1)]];
}

- (void) readFromDictionary: (NSDictionary *) dictionary
{
  self.accessToken = [dictionary objectForKey: @"access_token"];
  NSString *adminBoolean = [dictionary objectForKey: @"admin"];
  if ([adminBoolean isEqual: @"true"]) {
    self.admin = YES;
  }
  else {
    self.admin = NO;
  }
  self.email = [dictionary objectForKey: @"email"];
  self.facebookId = [[dictionary objectForKey: @"facebook_id"] doubleValue];
  self.firstName = [dictionary objectForKey: @"first_name"];
  self.imageURL = [NSURL URLWithString: [dictionary objectForKey: @"image"]];
  self.lastName = [dictionary objectForKey: @"last_name"];
  self.location = [dictionary objectForKey: @"location"];
  self.name = [dictionary objectForKey: @"name"];
  self.uid = [[dictionary objectForKey: @"id"] integerValue];

  [[UserStore sharedStore] addUser: self];
}

- (BOOL) registeredForPushNotifications
{
  UIRemoteNotificationType status = 
    [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
  if (status == UIRemoteNotificationTypeNone) {
    return NO;
  }
  else {
    return YES;
  }
}

- (NSString *) rememberTokenIos
{
  NSNumber *facebook = [NSNumber numberWithDouble: self.facebookId];

  return [NSString stringWithFormat: @"%@%@%@", 
    [facebook stringValue], 
    [self.accessToken substringWithRange: NSMakeRange(0, 14)],
    [self partialToken]];
}

- (UIImage *) seatImage
{
  if (self.image) {
    float newHeight = (60.0 / self.image.size.width) * self.image.size.height;
    return [UIImage image: self.image resized: CGSizeMake(60, newHeight) 
      position: CGPointMake(0, 0)];
  }
  else {
    return [[UIImage alloc] init];
  }
}

- (void) sessionStateChanged: (NSNotification *) notification
{
  if (FBSession.activeSession.isOpen) {

    [FBRequestConnection startForMeWithCompletionHandler:
      ^(FBRequestConnection *connection, id <FBGraphUser> user, 
        NSError *error) {

        if (!error) {
          User *currentUser = [User currentUser];
          NSString *token = 
            [[[FBSession activeSession] accessTokenData] accessToken];
          currentUser.accessToken = token;
          currentUser.admin = NO;
          currentUser.email = [user objectForKey: @"email"];
          currentUser.facebookId = [[user objectForKey: @"id"] doubleValue];
          currentUser.firstName = [user objectForKey: @"first_name"];
          currentUser.imageURL = [NSURL URLWithString: 
            [NSString stringWithFormat: 
              @"http://graph.facebook.com/%0.0f/picture?type=large", 
              currentUser.facebookId]];
          currentUser.lastName = [user objectForKey: @"last_name"];
          currentUser.location = [user.location objectForKey: @"name"];
          currentUser.name = [user objectForKey: @"name"];
          NSLog(@"Facebook active session is open");
          // Authenticate with server
          [self authenticateWithServer: nil];
        }
        else {
          AppDelegate *appDelegate = (AppDelegate *)
            [UIApplication sharedApplication].delegate;
          UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Facebook"
            message: @"Facebook authentication failed" delegate: appDelegate 
              cancelButtonTitle: @"Try again" otherButtonTitles: nil];
          [alert show];
        }
      }
    ];
  }
}

- (void) signOut
{
  [User currentUser].accessToken     = nil;
  [User currentUser].admin           = NO;
  [User currentUser].biteAccessToken = nil;
  [User currentUser].email           = nil;
  [User currentUser].facebookId      = 0;
  [User currentUser].firstName       = nil;
  [User currentUser].imageURL        = nil;
  [User currentUser].lastName        = nil;
  [User currentUser].location        = nil;
  [User currentUser].name            = nil;
  [User currentUser].uid             = 0;
}

@end
