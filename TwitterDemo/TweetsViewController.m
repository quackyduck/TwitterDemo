//
//  TweetsViewController.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/20/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "TweetsViewController.h"
#import "TwitterClient.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TweetsViewController ()
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = @"Home";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
    
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut:)];
    
    [[TwitterClient sharedInstance] homeTimelineWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Request: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load Tweet timeline %@", error);
    }];
    
}

- (void)signOut:(id)sender {
    NSLog(@"Sign OUT!!!");
    [[TwitterClient sharedInstance] deauthorize];
    
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController.view addSubview:lvc.view];
    [self.view removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
