//
//  User.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "User.h"

#import "Account.h"

// --- Defines ---;
// User Class;
@implementation User

// Functions;
#pragma mark - Shared Functions
+ (instancetype)me
{
    static User *_me;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _me = [[User alloc] init];
    });

    _me.userID = [Account me].userID;
    _me.username = [Account me].username;
    _me.userpassword = [Account me].userpassword;
    _me.name = [Account me].name;
    _me.avatar = [Account me].avatar;
    _me.following = 0;
    _me.posts = [Account me].posts;
    _me.followers = [Account me].followers;
    _me.followings = [Account me].followings;
    _me.peoples = [Account me].peoples;
    
    return _me;
}

#pragma mark - User
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        // Set;
        [self setAttributes:attributes];
    }
    
    return self;
}

#pragma mark - Set
- (void)setAttributes:(NSDictionary *)attributes
{
    // Set;
    self.objectID = attributes[@"id"];
    self.userID = attributes[@"userid"];
    self.username = attributes[@"username"];
    self.userpassword = attributes[@"userpassword"];
    self.name = attributes[@"name"];
    self.avatar = attributes[@"avatar"];
    self.biography = attributes[@"biography"];
    self.following = [attributes[@"following"] integerValue];
    self.posts = [attributes[@"posts"] integerValue];
    self.followers = [attributes[@"followers"] integerValue];
    self.followings = [attributes[@"followings"] integerValue];
    self.peoples = [attributes[@"peoples"] integerValue];
    self.blocking = [attributes[@"blocking"] integerValue];
}

@end
