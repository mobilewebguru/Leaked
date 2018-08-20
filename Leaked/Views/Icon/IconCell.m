//
//  IconCell.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "IconCell.h"

// --- Defines ---;
// IconCell Class;
@implementation IconCell

// Functions;
#pragma mark - IconCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)setCount:(NSInteger)count
{
    viewForCount.hidden = !count;
    lblForCount.text = [[NSNumber numberWithInteger:count] stringValue];
    imgForIcon.alpha = !count ? 0.4f : 1.0f;
}

- (void)setIcon:(UIImage *)icon
{
    imgForIcon.image = icon;
}

@end
