//
//  TwitterClient.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/18/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

+ (id)sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com" ] consumerKey:@"iV2nOfCLBH8iucP1aztq4IRlO" consumerSecret:@"70zDmq8RYCCACoUSRdfYZz53vjD43Sz4nwLr1uhxjBiKoNNW3f"];
    });
    return instance;
}

- (void)login {
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"melotwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        NSLog(@"Returned success token! %@", requestToken);
        
        NSString *authURL = [NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:authURL]];
        
        
    } failure:^(NSError *error) {
        NSLog(@"Failed to get request token, %@", error);
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"melotwitter"]) {
        if ([url.host isEqualToString:@"oauth"]) {
            NSLog(@"url: %@", url);
            [[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                NSLog(@"Retrieved access token: %@", accessToken);
                [self.requestSerializer saveAccessToken:accessToken];
            } failure:^(NSError *error) {
                NSLog(@"Failed to get access token: %@", error);
            }];
        }
        return YES;
    }
    return NO;
}

- (void)homeTimelineWithParameters:(id)parameters success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:parameters success:success failure:failure];
}

@end
