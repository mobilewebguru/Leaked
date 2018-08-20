//
//  User.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Defines ---;
// User Class;
@interface User : NSObject

// Properties;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *userpassword;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *biography;
@property (nonatomic, assign) NSInteger following;
@property (nonatomic, assign) NSInteger posts;
@property (nonatomic, assign) NSInteger followers;
@property (nonatomic, assign) NSInteger followings;
@property (nonatomic, assign) NSInteger peoples;
@property (nonatomic, assign) NSInteger blocking;

// Functions;
+ (instancetype)me;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
