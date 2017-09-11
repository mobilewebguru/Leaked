//
//  Post.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "Post.h"

#import "User.h"
#import "Mark.h"

// --- Defines ---;
// Post Class;
@implementation Post

// Functions;
#pragma mark - Post
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        // Set;
//      self.objectID = attributes[@"id"];
        self.postID = attributes[@"postid"];
        self.parent = nil;
        self.userID = attributes[@"userid"];
        self.comment = attributes[@"comment"];
        self.mark = [[Mark alloc] initWithAttributes:attributes[@"marks"]];
        self.replied = [NSMutableArray array];
        self.createAt = [attributes[@"created_at"] integerValue];
        
        // Replied;
        for (NSDictionary *dict in attributes[@"replies"]) {
            Post *post = [[Post alloc] initWithAttributes:dict];

            // Set;
            post.parent = self;
            
            // Add;
            [self.replied addObject:post];
        }
    }
    
    return self;
}

@end
