//
//  Mark.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>

// --- Defines ---;
// Mark Class;
@interface Mark : NSObject

// Properties;
@property (nonatomic, assign) NSInteger hearts;
@property (nonatomic, assign) NSInteger heartEyes;
@property (nonatomic, assign) NSInteger angryFaces;
@property (nonatomic, assign) NSInteger questionMarks;
@property (nonatomic, assign) NSInteger wtfs;
@property (nonatomic, assign) NSInteger thumbDowns;
@property (nonatomic, assign) NSInteger middleFingers;
@property (nonatomic, assign) NSInteger reposts;
@property (nonatomic, assign) NSInteger saves;
@property (nonatomic, assign) NSInteger replies;

// Functions;
- (instancetype)initWithAttributes:(NSDictionary *)attributes;

@end
