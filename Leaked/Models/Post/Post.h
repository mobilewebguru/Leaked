//
//  Post.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Classes ---;
@class Mark;

// --- Defines ---;
// Post Class;
@interface Post : NSObject

// Properties;
@property (nonatomic, strong) NSString *objectID;
@property (nonatomic, strong) NSString *postID;
@property (nonatomic, strong) Post *parent;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) Mark *mark;
@property (nonatomic, strong) NSMutableArray *replied;
@property (nonatomic, assign) NSInteger createAt;

// Functions;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
