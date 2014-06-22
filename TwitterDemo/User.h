//
//  User.h
//  TwitterDemo
//
//  Created by Nicolas Melo on 6/21/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *profileImageURL;

+ (id)currentUser;
+ (void)setCurrentUser:(NSDictionary *)user;
- (id)initWithDictionary:(NSDictionary *)rawData;

@end
