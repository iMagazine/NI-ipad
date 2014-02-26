//
//  NIAULoginViewController.h
//  New Internationalist Magazine Australia
//
//  Created by Simon Loffler on 8/10/13.
//  Copyright (c) 2013 New Internationalist Australia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAUHelper.h"
#import "NIAUWebsiteViewController.h"

@interface NIAULoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *password;

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;

@end
