//
//  ComposeViewController.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/21/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "ComposeViewController.h"
#import "User.h"

#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

#import "TwitterClient.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;


@end

@implementation ComposeViewController

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
    NSLog(@"Me: %@", [User currentUser]);
    self.nameLabel.text = [[User currentUser] name];
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", [[User currentUser] screenName]];
    
    self.tweetTextView.text = @"";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(postTweet:)];
    
    self.tweetTextView.contentInset = UIEdgeInsetsMake(0.0,0.0,0,0.0);
    [self.tweetTextView becomeFirstResponder];
    
    if (self.placeHolderText) {
        self.tweetTextView.text = self.placeHolderText;
    }
    
    NSURL *profileURL = [NSURL URLWithString:[[User currentUser] profileImageURL]];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:profileURL];
    
    [self.profileImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageView.alpha = 0.0;
        NSLog(@"Downloaded profile image.");
        
        UIGraphicsBeginImageContextWithOptions(self.profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:self.profileImageView.bounds cornerRadius:4.0] addClip];
        [image drawInRect:self.profileImageView.bounds];
        
        self.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.profileImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load Yelp item's pic.");
    }];
    
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)postTweet:(id)sender {
    [[TwitterClient sharedInstance] postTweetStatus:self.tweetTextView.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Posted tweet %@", self.tweetTextView.text);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to post %@", error);
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
