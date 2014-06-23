//
//  DetailViewController.h
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/22/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Tweet;

@interface DetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

- (id)initWithTweet:(Tweet *)tweet;
@property (strong, nonatomic) Tweet *tweetDetails;

@end
