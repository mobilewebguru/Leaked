//
//  PopoverView.h
//  Ultimate Resize
//
//  Created by Xin Jin on 27/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// PopoverView Class;
@interface PopoverView : UIView 
{
	UIView *contentView;
	NSMutableArray *contentViews;
    UIView *peekView;
    
    BOOL working;
}

// Properties;
@property (nonatomic, weak) UIViewController *delegate;

// Functions;
+ (PopoverView *)popoverView;

- (void)showView:(UIView *)view withCenter:(CGPoint)center;
- (void)hideView:(UIView *)view;

@end
