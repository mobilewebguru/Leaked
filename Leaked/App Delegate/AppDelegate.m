//
//  AppDelegate.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "APIClient.h"
#import "Account.h"
#import "MBProgressHUD.h"

// --- Defines ---;
// AppDelegate Class;
@implementation AppDelegate

// Functions;
#pragma mark - AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Status Bar;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    // Navigation Bar;
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:26.0f/255.0f green:43.0f/255.0f blue:50.0f/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:246.0f/255.0f green:74.0f/255.0f blue:28.0f/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.username = nil;
    self.userpassword = nil;
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    static BOOL first = YES;
    
    if (first) {
        if (![[Account me] isAuthenticated]) {
            UIViewController *viewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginNaviController"];
            [self.window.rootViewController presentViewController:viewController animated:NO completion:nil];
        }
        else {
            [Account me].userID = nil;
            self.username = [Account me].username;
            self.userpassword = [Account me].userpassword;
            UIViewController *viewController = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"LoginNaviController"];
            [self.window.rootViewController presentViewController:viewController animated:NO completion:nil];            
        }
        // Set;
        first = NO;
    }

    // Facebook;
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActiveWithSession:[FBSession activeSession]];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[FBSession activeSession] close];
}

- (BOOL)application:(UIApplication *) application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[FBSession activeSession]];
}

@end
