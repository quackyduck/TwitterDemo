//
//  TwitterClient.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/18/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "TwitterClient.h"
#import "LoginCompleteDelegate.h"

@interface TwitterClient ()

@property (nonatomic, weak) id <LoginCompleteDelegate> delegate;

@end

@implementation TwitterClient

+ (id)sharedInstance {
    static TwitterClient *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com"] consumerKey:@"h8oOTj4XFS1F5zrESSibB9cQe" consumerSecret:@"8PlWUEKlIcPwnkuI1t35tpUSKDCUjG56ciIziySlEsAnwapL59"];
    });
    return instance;
}

- (void)loginWithDelegate:(id)delegate {
    
    self.delegate = delegate;
    [self fetchRequestTokenWithPath:@"/oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"melotwitter://oauth"] scope:nil success:^(BDBOAuthToken *requestToken) {
        
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
                
                [self.delegate loginComplete];
                
            } failure:^(NSError *error) {
                NSLog(@"Failed to get access token: %@", error);
            }];
        }
        
        return YES;
    }
    return NO;
}

- (void)homeTimelineWithParameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    [self GET:@"1.1/statuses/home_timeline.json" parameters:parameters success:success failure:failure];
}

- (void)verifyMeSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:success failure:failure];
}

- (void)postTweetStatus:(NSString *)status
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status": status} success:success failure:failure];
}

@end
