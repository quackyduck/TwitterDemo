//
//  LoginViewController.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/19/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "LoginViewController.h"
#import "TwitterClient.h"
#import "AppDelegate.h"

@interface LoginViewController ()
- (IBAction)onLogin:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [[TwitterClient sharedInstance] loginWithDelegate:self];
}

- (void)loginComplete {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:appDelegate.mainViewController.view];
    [self.view removeFromSuperview];
}
@end
