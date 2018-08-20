//
//  BannerManager.m
//  Leaked
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "BannerManager.h"

// --- Defines ---;
// BannerManager Class;
@implementation BannerManager

// Functions;
#pragma mark - Shared Functions
+ (instancetype)sharedManager
{
    static BannerManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[BannerManager alloc] init];
    });
    
    return _sharedManager;
}

#pragma mark - BannerManager
- (id)init
{
    self = [super init];
    if (self) {
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
            _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        } else {
            _bannerView = [[ADBannerView alloc] init];
        }
        
        _bannerView.delegate = self;
        _bannerView.hidden = YES;
    }
    return self;
}

#pragma mark - ADBannerViewDelegate
- (void)bannerViewWillLoadAd:(ADBannerView *)banner
{
    NSLog(@"bannerViewWillLoadAd");
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    banner.hidden = NO;
    NSLog(@"bannerViewDidLoadAd");
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"didFailToReceiveAdWithError");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"willLeaveApplication");
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"bannerViewActionDidFinish");
}

@end
