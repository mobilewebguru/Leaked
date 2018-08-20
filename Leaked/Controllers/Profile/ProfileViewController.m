//
//  ProfileViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "ProfileViewController.h"
#import "CreatePostController.h"
#import "PostListController.h"
#import "FollowerListController.h"
#import "FollowingListController.h"

#import "Account.h"
#import "User.h"

#import "UIViewController+ECSlidingViewController.h"
#import "UIImageView+WebCache.h"

// --- Defines ---;
// ProfileViewController Class;
@interface ProfileViewController ()

@end

@implementation ProfileViewController

// Functions;
#pragma mark - ProfileViewController
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
    
    // Scroll View;
    scrollView.contentSize = contentView.bounds.size;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load;
    [self loadProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Load
- (void)loadProfile
{
    lblForPosts.text = [[NSNumber numberWithInteger:[Account me].posts] stringValue];
    lblForFollowers.text = [[NSNumber numberWithInteger:[Account me].followers] stringValue];
    lblForFollowings.text = [[NSNumber numberWithInteger:[Account me].followings] stringValue];;
    [imgForAvatar sd_setImageWithURL:[NSURL URLWithString:[Account me].avatar] placeholderImage:nil];
    lblForName.text = [Account me].name;
    lblForUsername.text = [Account me].username;
    lblForPeoples.text = [[NSNumber numberWithInteger:[Account me].peoples] stringValue];
    txtForBiography.text = [Account me].biography;
}

#pragma mark - Events
- (IBAction)onBtnMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)onBtnPost:(id)sender
{
    CreatePostController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePostController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onBtnPosts:(id)sender
{
    PostListController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostListController"];
    viewController.user = [User me];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onBtnFollowers:(id)sender
{
    FollowerListController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowerListController"];
    viewController.user = [User me];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onBtnFollowings:(id)sender
{
    FollowingListController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowingListController"];
    viewController.user = [User me];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
