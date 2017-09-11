//
//  AppDelegate.h
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <UIKit/UIKit.h>

// --- Defines ---;
// AppDelegate Class;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

// Properties;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *userpassword;
#define DELEGATE (AppDelegate*)[[UIApplication sharedApplication]delegate];
@end
