//
//  TwitterClient.h
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/18/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <BDBOAuth1Manager/BDBOAuth1RequestOperationManager.h>

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (id)sharedInstance;
- (void)login;
- (void)homeTimelineWithParameters:(id)parameters
                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
