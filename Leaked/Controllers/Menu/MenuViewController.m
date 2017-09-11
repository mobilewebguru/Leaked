//
//  MenuViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "MenuViewController.h"
#import "MenuTableController.h"

#import "SlideViewController.h"
#import "NavigationController.h"

#import "Account.h"

#import "UIViewController+ECSlidingViewController.h"
#import "UIImageView+WebCache.h"

// --- Defines ---;
// MenuViewController Class;
@interface MenuViewController ()

@end

@implementation MenuViewController

// Functions;
#pragma mark - MenuViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    [super loadView];

    // Avatar;
    imgForAvatar.layer.borderWidth = 1.0f;
    imgForAvatar.layer.borderColor = [UIColor colorWithRed:155.0f / 255.0f green:155.0f / 255.0f blue:155.0f / 255.0f alpha:1.0f].CGColor;
    imgForAvatar.layer.cornerRadius = imgForAvatar.bounds.size.width / 2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogin) name:@"didUserLogin" object:nil];
    
    // Load;
    [self performSelector:@selector(didUserLogin)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MenuTableController"]) {
        MenuTableController *viewController = segue.destinationViewController;
        viewController.delegate = (SlideViewController *)self.slidingViewController;
    }
}

#pragma mark - Notifications
- (void)didUserLogin
{
    // Account;
    [imgForAvatar sd_setImageWithURL:[NSURL URLWithString:[Account me].avatar] placeholderImage:nil];
    lblForName.text = [Account me].name;
    lblForUsername.text = [Account me].username;
}

@end
