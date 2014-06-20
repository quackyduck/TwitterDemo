//
//  LoginViewController.h
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/19/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginCompleteDelegate.h"

@interface LoginViewController : UIViewController <LoginCompleteDelegate>

- (void)loginComplete;

@end
