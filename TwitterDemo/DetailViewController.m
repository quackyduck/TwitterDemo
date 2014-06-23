//
//  DetailViewController.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/22/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailTweetCell.h"
#import "Tweet.h"

#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) DetailTweetCell *detailViewCell;

@end

@implementation DetailViewController

- (id)initWithTweet:(Tweet *)tweet {
    self = [self initWithNibName:nil bundle:nil];
    self.tweetDetails = tweet;
    
    
    

    return self;
}

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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *detailTweetNib = [UINib nibWithNibName:@"DetailTweetCell" bundle:nil];
    
    NSArray *nibs = [detailTweetNib instantiateWithOwner:nil options:nil];
    self.detailViewCell = nibs[0];
    
    self.detailViewCell.nameLabel.text = self.tweetDetails.name;
    self.detailViewCell.screenNameLabel.text = self.tweetDetails.screenName;
    self.detailViewCell.tweetTextLabel.text = self.tweetDetails.text;
    
    [self.detailViewCell sizeToFit];
    
    self.detailViewCell.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweetDetails.retweetCount];
    self.detailViewCell.favoriteCountLabel.text = [NSString stringWithFormat:@"%ld", self.tweetDetails.favoriteCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.detailViewCell layoutSubviews];
    CGFloat height = [self.detailViewCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *profileURL = [NSURL URLWithString:self.tweetDetails.profileURL];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:profileURL];
    
    [self.detailViewCell.profileImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.detailViewCell.profileImageView.alpha = 0.0;
        NSLog(@"Downloaded profile image.");
        
        UIGraphicsBeginImageContextWithOptions(self.detailViewCell.profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:self.detailViewCell.profileImageView.bounds cornerRadius:4.0] addClip];
        [image drawInRect:self.detailViewCell.profileImageView.bounds];
        
        self.detailViewCell.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.detailViewCell.profileImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load Yelp item's pic.");
    }];
    

    return self.detailViewCell;
}

@end
