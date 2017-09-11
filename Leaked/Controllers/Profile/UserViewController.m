//
//  UserViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "UserViewController.h"
#import "PostListController.h"
#import "FollowerListController.h"
#import "FollowingListController.h"

#import "APIClient.h"
#import "User.h"

#import "MBProgressHUD.h"

#import "UIViewController+ECSlidingViewController.h"
#import "UIImageView+WebCache.h"

// --- Defines ---;
// UserViewController Class;
@interface UserViewController ()

@end

@implementation UserViewController

// Functions;
#pragma mark - UserViewController
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
    
    // Load;
    [self loadProfile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Show;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Block;
        if (!self.user.blocking) {
            [APIClient blockUser:self.user completion:^(BOOL successed) {
                // Hide;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        } else {
            [APIClient unblockUser:self.user completion:^(BOOL successed) {
                // Hide;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
    }
}

#pragma mark - Load
- (void)loadProfile
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@'s profile", self.user.name];
    lblForPosts.text = [[NSNumber numberWithInteger:self.user.posts] stringValue];
    lblForFollowers.text = [[NSNumber numberWithInteger:self.user.followers] stringValue];
    lblForFollowings.text = [[NSNumber numberWithInteger:self.user.followings] stringValue];;
    [imgForAvatar sd_setImageWithURL:[NSURL URLWithString:self.user.avatar] placeholderImage:nil];
    lblForName.text = self.user.name;
    lblForUsername.text = self.user.username;
    btnForFollow.selected = self.user.following;
    lblForPeoples.text = [[NSNumber numberWithInteger:self.user.peoples] stringValue];
    txtForBiography.text = self.user.biography;
    
    // View;
    [APIClient viewUser:self.user completion:^(BOOL successed) {
        
    }];
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnFollow:(id)sender
{
    // Show;
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Follow;
    if (!self.user.following) {
        [APIClient followUser:self.user completion:^(BOOL finished) {
            // Hide;
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            if (finished) {
                btnForFollow.selected = YES;
            }
        }];
    } else {
        [APIClient unfollowUser:self.user completion:^(BOOL finished) {
            // Hide;
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            if (finished) {
                btnForFollow.selected = NO;
            }
        }];
    }
}

- (IBAction)onBtnBlock:(id)sender
{
    if (!self.user.blocking) {
        [[[UIActionSheet alloc] initWithTitle:@"Block this user" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Block" otherButtonTitles:nil] showInView:self.view];
    } else {
        [[[UIActionSheet alloc] initWithTitle:@"Unblock this user" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Unblock" otherButtonTitles:nil] showInView:self.view];
    }
}

- (IBAction)onBtnPosts:(id)sender
{
    PostListController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostListController"];
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onBtnFollowers:(id)sender
{
    FollowerListController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowerListController"];
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)onBtnFollowings:(id)sender
{
    FollowingListController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FollowingListController"];
    viewController.user = self.user;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
