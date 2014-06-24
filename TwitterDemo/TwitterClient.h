//
//  TwitterClient.h
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/18/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1RequestOperationManager.h>
#import "LoginCompleteDelegate.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (id)sharedInstance;
- (void)loginWithDelegate:(id)delegate;
- (void)homeTimelineWithParameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)verifyMeSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postTweetStatus:(NSString *)status
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)favoriteTweetId:(NSString *)tweetId
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)destroyFavoriteTweetId:(NSString *)tweetId
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)retweetId:(NSString *)tweetId
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
