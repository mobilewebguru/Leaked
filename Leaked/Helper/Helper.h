//
//  Helper.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Defines ---;
// Helper Class;
@interface Helper : NSObject

// Functions;
+ (NSString *)time:(NSTimeInterval)time;
+ (NSString *)timeWithAgo:(NSTimeInterval)time;

@end
