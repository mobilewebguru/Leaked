//
//  CreatePostController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "CreatePostController.h"

#import "APIClient.h"
#import "Account.h"
#import "Post.h"

#import "BannerManager.h"

#import "MBProgressHUD.h"

#import "UIViewController+ECSlidingViewController.h"
#import "UIImageView+WebCache.h"

// --- Defines ---;
// CreatePostController Class;
@interface CreatePostController ()

@end

@implementation CreatePostController

// Functions;
#pragma mark - CreatePostController
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Banner;
    ADBannerView *bannerView = [BannerManager sharedManager].bannerView;
    [viewForBanner addSubview:bannerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == txtForComment) {
        if ([text isEqualToString:@"\n"]) {
            [txtForComment resignFirstResponder];
        }
    }
    
    return YES;
}

#pragma mark - Alert Tips
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

#pragma mark - Check
- (BOOL)checkBlankField
{
    if ([txtForComment.text isEqualToString:@""]) {
        [self showAlertWithTitle:nil message:@"Please fill comment."];
        return NO;
    }
    
    return YES;
}

- (void)resignResponders
{
    if ([txtForComment isFirstResponder]) {
        [txtForComment resignFirstResponder];
    }
}

#pragma mark - Load
- (void)loadProfile
{
    // Account;
    [imgForAvatar sd_setImageWithURL:[NSURL URLWithString:[Account me].avatar] placeholderImage:nil];
    lblForName.text = [Account me].name;
    lblForUsername.text = [Account me].username;
    
    if (self.post) {
        txtForComment.text = [NSString stringWithFormat:@"\"%@\"", self.post.comment];
    }
}

#pragma mark - Events
- (IBAction)onBtnMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)onBtnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnPost:(id)sender
{
    // Check;
    if (![self checkBlankField]) {
        return;
    }
    
    // Responders;
    [self resignResponders];
    
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (!self.post) {
        [APIClient postStatus:txtForComment.text completion:^(Post *post) {
            // Notification;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didPost" object:post];
            
            // Hide;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (post) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
            }
        }];
    } else {
        [APIClient repostStatus:txtForComment.text forPost:self.post completion:^(Post *post) {
            // Notification;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didPost" object:post];
            
            // Hide;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if (post) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                
            }
        }];
    }
}

@end
