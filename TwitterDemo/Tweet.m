//
//  Tweet.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/21/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)rawData {
    self = [super init];
    
    NSString *profileURL = rawData[@"user"][@"profile_image_url"];
    self.profileURL = [profileURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    self.screenName = rawData[@"user"][@"screen_name"];
    self.name = rawData[@"user"][@"name"];
    self.text = rawData[@"text"];
    self.retweetCount = [rawData[@"retweet_count"] intValue];
    self.favoriteCount = [rawData[@"favorite_count"] intValue];
    self.tweetId = rawData[@"id_str"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    
    self.createdDate = [dateFormatter dateFromString:rawData[@"created_at"]];
    
    return self;
}

- (NSString *)tweetFormattedDate {
    
    NSTimeInterval interval = -[self.createdDate timeIntervalSinceNow];
    NSLog(@"Created %f", interval);
    if (interval < 60) {
        return @"Just now";
    }
    else if (interval < 3600) {
        NSInteger minutes = interval / 60;
        return [NSString stringWithFormat:@"%ldm", (long)minutes];
    }
    else if (interval < 86400) {
        NSInteger hours = interval / 60 / 24;
        return [NSString stringWithFormat:@"%ldh", (long)hours];
    }
    else if (interval < 604800) {
        NSInteger days = interval / 60 / 24 / 7;
        return [NSString stringWithFormat:@"%ldd", (long)days];
    }
    
    
    return [NSDateFormatter localizedStringFromDate:self.createdDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *)tweetDetailedDate {
    return [NSDateFormatter localizedStringFromDate:self.createdDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

@end
