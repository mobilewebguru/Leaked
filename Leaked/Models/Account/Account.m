//
//  Account.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "Account.h"
#import "User.h"

// --- Defines ---;
// Account Class;
@implementation Account

#pragma mark - Shared Functions
+ (instancetype)me
{
    static Account *_me;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _me = [[Account alloc] init];
    });
    
    return _me;
}

#pragma mark - Account
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        // Set;
        [self setAttributes:attributes];
    }
    
    return self;
}

- (BOOL)isAuthenticated
{
    return self.userID > 0;
}

- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userpassword"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"email"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"biography"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notification"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"privated"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"facebookid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"posts"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"followers"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"followings"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"peoples"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Get
- (NSNumber *)userID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"];
}

- (NSString *)username
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}

- (NSString *)userpassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userpassword"];
}

- (NSString *)name
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

- (NSString *)email
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
}

- (NSString *)avatar
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
}

- (NSString *)biography
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"biography"];
}

- (BOOL)notification
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"notification"];
}

- (BOOL)privated
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"privated"];
}

- (NSString *)facebookID
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"facebookid"];
}

- (NSInteger)posts
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"posts"];
}

- (NSInteger)followers
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"followers"];
}

- (NSInteger)followings
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"followings"];
}

- (NSInteger)peoples
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"peoples"];
}


#pragma mark - Set
- (void)setAttributes:(NSDictionary *)attributes
{
    // Set;
    self.userID = attributes[@"userid"];
    self.username = attributes[@"username"];
    self.userpassword = attributes[@"userpassword"];
    self.name = attributes[@"name"];
    self.email = attributes[@"email"];
    self.avatar = attributes[@"avatar"];
    self.biography = attributes[@"biography"];
    self.notification = [attributes[@"notification"] boolValue];
    self.privated = [attributes[@"privated"] boolValue];
    self.facebookID = attributes[@"facebook_id"];
    self.posts = [attributes[@"posts"] integerValue];
    self.followers = [attributes[@"followers"] integerValue];
    self.followings = [attributes[@"followings"] integerValue];
    self.peoples = [attributes[@"peoples"] integerValue];
}

- (void)setObject:(NSObject *)object forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBool:(BOOL)value forKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setUserID:(NSObject *)userID
{
    [self setObject:userID forKey:@"userid"];
}

- (void)setUsername:(NSString *)username
{
    [self setObject:username forKey:@"username"];
}

- (void)setUserpassword:(NSString *)userpassword
{
    [self setObject:userpassword forKey:@"userpassword"];
}

- (void)setName:(NSString *)name
{
    [self setObject:name forKey:@"name"];
}

- (void)setEmail:(NSString *)email
{
    [self setObject:email forKey:@"email"];
}

- (void)setAvatar:(NSString *)avatar
{
    [self setObject:avatar forKey:@"avatar"];
}

- (void)setBiography:(NSString *)biography
{
    [self setObject:biography forKey:@"biography"];
}

- (void)setNotification:(BOOL)notification
{
    [self setBool:notification forKey:@"notification"];
}

- (void)setPrivated:(BOOL)privated
{
    [self setBool:privated forKey:@"privated"];
}

- (void)setFacebookID:(NSString *)facebookID
{
    [self setObject:facebookID forKey:@"facebookid"];
}

- (void)setPosts:(NSInteger)posts
{
    [self setInteger:posts forKey:@"posts"];
}

- (void)setFollowers:(NSInteger)followers
{
    [self setInteger:followers forKey:@"followers"];
}

- (void)setFollowings:(NSInteger)followings
{
    [self setInteger:followings forKey:@"followings"];
}

- (void)setPeoples:(NSInteger)peoples
{
    [self setInteger:peoples forKey:@"peoples"];
}

@end
