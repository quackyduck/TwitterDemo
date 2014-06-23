//
//  User.m
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/21/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "User.h"

@implementation User

static User *currentUser = nil;

- (id)initWithDictionary:(NSDictionary *)rawData {
    self = [super init];
    
    self.name = rawData[@"name"];
    self.screenName = rawData[@"screen_name"];
    
    NSString *profileURL = rawData[@"profile_image_url"];
    self.profileImageURL = [profileURL stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
    
    return self;
}

+ (id)currentUser {
    if (currentUser == nil) {
        NSDictionary *dictionary = [[NSUserDefaults standardUserDefaults] objectForKey:@"current_user"];
        if (dictionary) {
            currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return currentUser;
}

+ (void)setCurrentUser:(NSDictionary *)user {

    NSString *profileURL = user[@"profile_image_url"];
    NSString *screenName = user[@"screen_name"];
    NSString *name = user[@"name"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:profileURL forKey:@"profile_image_url"];
    [userDefaults setObject:screenName forKey:@"screen_name"];
    [userDefaults setObject:name forKey:@"name"];
    [userDefaults synchronize];

    currentUser = [[self alloc] initWithDictionary:@{@"profile_image_url": profileURL, @"screen_name": screenName, @"name": name}];
    
}

@end
