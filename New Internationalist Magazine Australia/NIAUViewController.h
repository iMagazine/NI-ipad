//
//  NIAUViewController.h
//  New Internationalist Magazine Australia
//
//  Created by Simon Loffler on 20/06/13.
//  Copyright (c) 2013 New Internationalist Australia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAUIssue.h"
#import "NIAUArticle.h"
#import "NIAUPublisher.h"
#import "NIAUInAppPurchaseHelper.h"
#import "NIAUHelper.h"
#import "NSData+Cookieless.h"
#import "NIAULoginViewController.h"

#import "GAI.h"
#import "GAITracker.h"
#import "GAITrackedViewController.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "GAILogger.h"

@interface NIAUViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NIAUIssue *issue;
@property (nonatomic, weak) NIAUIssue *lastIssue;
@property (nonatomic, weak) NIAUArticle *firstArticle;

@property (nonatomic, strong) IBOutlet UIImageView *cover;

@property (nonatomic, weak) IBOutlet UIButton *magazineArchiveButton;
@property (nonatomic, weak) IBOutlet UIButton *subscribeButton;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (nonatomic, weak) IBOutlet UILabel *issueBanner;

@property(atomic) BOOL isUserLoggedIn;
@property(atomic) BOOL isUserASubscriber;

@property(atomic) BOOL showNewIssueBanner;

@end
