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
#import "Tweet.h"
#import "TweetMainCell.h"
#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

@interface TweetsViewController ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) TweetMainCell *offscreenCell;
@end

@implementation TweetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.tweets = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"TweetMainCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"tweetCell"];
    NSArray *nibs = [cellNib instantiateWithOwner:nil options:nil];
    self.offscreenCell = nibs[0];
    
    
    self.titleLabel.text = @"Home";
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.titleLabel sizeToFit];
    
    self.navigationItem.titleView = self.titleLabel;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOut:)];
    
    [self refresh:self];
}

- (void)signOut:(id)sender {
    NSLog(@"Sign OUT!!!");
    [[TwitterClient sharedInstance] deauthorize];
    
    LoginViewController *lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController.view addSubview:lvc.view];
    [self.view removeFromSuperview];
    
}

- (void)refresh:(id)sender {
    [[TwitterClient sharedInstance] homeTimelineWithParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.tweets removeAllObjects];
        
        for (NSDictionary *tweetData in responseObject) {
            Tweet *tweet = [[Tweet alloc] initWithDictionary:tweetData];
            [self.tweets addObject:tweet];
        }
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to load Tweet timeline %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(TweetMainCell *)cell forListing:(Tweet *)tweet {
    cell.tweetBodyLabel.text = tweet.text;
    [cell.tweetBodyLabel sizeToFit];
    cell.nameLabel.text = tweet.name;
    cell.handleLabel.text = [NSString stringWithFormat:@"@%@", tweet.screenName];
    cell.timeLabel.text = [tweet tweetFormattedDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet *tweet = self.tweets[indexPath.row];
    [self configureCell:self.offscreenCell forListing:tweet];
    [self.offscreenCell layoutSubviews];
    CGFloat height = [self.offscreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    NSLog(@"Height of cell: %f", height);
    
    return height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetMainCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    [self configureCell:cell forListing:tweet];
    
    NSURL *profileURL = [NSURL URLWithString:tweet.profileURL];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:profileURL];
    
    NSLog(@"Download image from %@", tweet.profileURL);
    
    [cell.profileImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.profileImageView.alpha = 0.0;
        NSLog(@"Downloaded profile image.");
        
        UIGraphicsBeginImageContextWithOptions(cell.profileImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        [[UIBezierPath bezierPathWithRoundedRect:cell.profileImageView.bounds cornerRadius:4.0] addClip];
        [image drawInRect:cell.profileImageView.bounds];
        
        cell.profileImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             cell.profileImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load Yelp item's pic.");
    }];
    
    return cell;
}


@end
