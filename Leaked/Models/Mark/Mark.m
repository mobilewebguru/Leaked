//
//  Mark.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "Mark.h"

// --- Defines ---;
// Mark Class;
@implementation Mark

// Functions;
#pragma mark - Mark
- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self) {
        // Set;
        self.hearts = [attributes[@"hearts"] integerValue];
        self.heartEyes = [attributes[@"heart_eyes"] integerValue];
        self.angryFaces = [attributes[@"angry_faces"] integerValue];
        self.questionMarks = [attributes[@"question_marks"] integerValue];
        self.wtfs = [attributes[@"wtfs"] integerValue];
        self.thumbDowns = [attributes[@"thumb_downs"] integerValue];
        self.middleFingers = [attributes[@"middle_fingers"] integerValue];
        self.reposts = [attributes[@"reposts"] integerValue];
        self.saves = [attributes[@"saves"] integerValue];
        self.replies = [attributes[@"replies"] integerValue];
    }
    
    return self;
}

@end
