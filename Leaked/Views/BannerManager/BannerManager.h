//
//  BannerManager.h
//  Leaked
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

// --- Defines ---;
// BannerManager Class;
@interface BannerManager : NSObject <ADBannerViewDelegate>

// Properties;
@property (nonatomic, strong, readonly) ADBannerView *bannerView;

// Functions;
+ (instancetype)sharedManager;

@end
