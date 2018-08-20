//
//  SlideViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "SlideViewController.h"
#import "MenuViewController.h"
#import "NavigationController.h"

// --- Defines ---;
// SlideViewController Class;
@interface SlideViewController ()

// Properties;
@property (nonatomic, strong) MenuViewController *menuController;
@property (nonatomic, strong) NavigationController *feedController;
@property (nonatomic, strong) NavigationController *activityController;
@property (nonatomic, strong) NavigationController *profileController;
@property (nonatomic, strong) NavigationController *connectController;
@property (nonatomic, strong) NavigationController *saveController;
@property (nonatomic, strong) NavigationController *otherController;
@property (nonatomic, strong) NavigationController *settingController;

@end

@implementation SlideViewController

// Functions;
#pragma mark - AppDelegate
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    // Controllers;
    self.menuController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    self.feedController = [self.storyboard instantiateViewControllerWithIdentifier:@"FeedNaviController"];
    self.activityController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityNaviController"];
    self.profileController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileNaviController"];
    self.connectController = [self.storyboard instantiateViewControllerWithIdentifier:@"ConnectNaviController"];
    self.saveController = [self.storyboard instantiateViewControllerWithIdentifier:@"SaveNaviController"];
    self.otherController = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherNaviController"];
    self.settingController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingNaviController"];

    // Menu Controller;
    self.underLeftViewController = self.menuController;
    
    // Top Controller;
    self.topViewController = self.feedController;
    
    // Set;
    self.anchorRightRevealAmount = 270;
    self.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MenuTableControllerDelegate
- (void)didSelectController:(UIViewController *)viewController
{
    // Top Controller;
    self.topViewController = viewController;
    
    // Reset;
    [self resetTopViewAnimated:YES];
}

- (void)didFeed
{
    [self performSelector:@selector(didSelectController:) withObject:self.feedController];
}

- (void)didActivity
{
    [self performSelector:@selector(didSelectController:) withObject:self.activityController];
}

- (void)didProfile
{
    [self performSelector:@selector(didSelectController:) withObject:self.profileController];
}

- (void)didConnect
{
    [self performSelector:@selector(didSelectController:) withObject:self.connectController];
}

- (void)didSaved
{
    [self performSelector:@selector(didSelectController:) withObject:self.saveController];
}

- (void)didOther
{
    [self performSelector:@selector(didSelectController:) withObject:self.otherController];
}

- (void)didSettings
{
    [self performSelector:@selector(didSelectController:) withObject:self.settingController];
}

@end
