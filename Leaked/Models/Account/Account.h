//
//  Account.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Classes ---;
@class User;

// --- Defines ---;
// Account Class;
@interface Account : NSObject

// Properties;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userpassword;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *biography;
@property (nonatomic, assign) BOOL notification;
@property (nonatomic, assign) BOOL privated;
@property (nonatomic, strong) NSString *facebookID;
@property (nonatomic, assign) NSInteger posts;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, assign) NSInteger followings;
@property (nonatomic, assign) NSInteger peoples;

// Functions;
+ (instancetype)me;

- (BOOL)isAuthenticated;
- (void)logout;

- (void)setAttributes:(NSDictionary *)attributes;

@end
