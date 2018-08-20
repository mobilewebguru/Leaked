//
//  PopoverView.m
//  Ultimate Resize
//
//  Created by Xin Jin on 27/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "PopoverView.h"

// --- Defines --- ;
// PopoverView Class;
@implementation PopoverView

// Properties;
@synthesize delegate = _delegate;

// Functions;
#pragma mark - Shared Functions
+ (PopoverView *)popoverView
{
	__strong static PopoverView *_popover = nil;
	static dispatch_once_t onceToken;
    
	dispatch_once(&onceToken, ^{
		id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
		UIViewController *rootViewController = appDelegate.window.rootViewController;
		CGRect frame = rootViewController.view.bounds;
        
        _popover = [[PopoverView alloc] init];
        _popover.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
        _popover.alpha = 0.0f;
        _popover.frame = frame;
        
        [appDelegate.window addSubview:_popover];
//      [rootViewController.view addSubview:_popover];
	});
	
	return _popover;
}

#pragma mark - PopoverView
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)onFinishShow
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	[contentView setTransform:CGAffineTransformIdentity];
	[UIView commitAnimations];
}

- (void)showView:(UIView *)view withCenter:(CGPoint)center
{
    if (working == YES) {
        return;
    }
    
    working = YES;
    
	if (!contentViews) {
		contentViews = [[NSMutableArray alloc] init];
    }
	
	contentView = view;
    contentView.center = center;
    contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);

	[contentViews addObject:contentView];
	[self addSubview:contentView];
    self.alpha = 1.0f;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self ] ;
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDidStopSelector:@selector(onFinishShow)];
    contentView.transform = CGAffineTransformMakeScale(1.2, 1.2);
	[UIView commitAnimations];
}

- (void)hideView:(UIView *)view
{
    working = NO;
    
	if ([contentViews count] == 1) {
		[UIView animateWithDuration:0.05 animations:^{
            self.alpha = 0.0f;
		}];
	}
    
	[contentView removeFromSuperview];
	contentView = nil;
    
	[contentViews removeLastObject];
}

@end
