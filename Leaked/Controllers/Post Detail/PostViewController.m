//
//  PostViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "PostViewController.h"
#import "CreatePostController.h"

#import "APIClient.h"
#import "Post.h"
#import "Mark.h"

#import "IconCell.h"
#import "FeedCell.h"

#import "BannerManager.h"

#import "Helper.h"

#import "PickerView.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// PostViewController Class;
@interface PostViewController () <FeedCellDelegate>
{
    UIView *viewForPopup;
}

// Properties;
@property (nonatomic, strong) Post *replyingPost;

@end

@implementation PostViewController

// Functions;
#pragma mark - PostViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load;
    [self loadPost];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
    
    // Banner;
    ADBannerView *bannerView = [BannerManager sharedManager].bannerView;
    [viewForBanner addSubview:bannerView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + [self.post.replied count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [FeedCell heightForPost:self.post];
    } else {
        return 101.0f;
    }
    
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        Post *post = self.post;
        
        static NSString *cellIdentifier = @"FeedCell";
        FeedCell *cell = [tblForPost dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.post = post;
        return cell;
    } else {
        Post *replied = self.post.replied[indexPath.row - 1];
        
        static NSString *cellIdentifier = @"RepliedCell";
        FeedCell *cell = [tblForPost dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.post = replied;
        return cell;
    }
    
    return nil;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self replyStatus:txtForComment.text];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Show;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Delete;
        [APIClient deleteStatus:self.post completion:^(BOOL successed) {
            // Hide;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            // Notification;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didDelete" object:self.post];
            
            // Pop;
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - FeedCellDelegate
- (void)didDelete
{
    [[[UIAlertView alloc] initWithTitle:@"Delete Post" message:@"Do you want to delete this post?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
}

- (void)didReply:(Post *)post withItem:(NSInteger)item
{
    switch (item) {
        case 0:
            [self markStatus:@"hearts" forPost:post];
            break;
            
        case 1:
            [self markStatus:@"heart_eyes" forPost:post];
            break;
            
        case 2:
            [self markStatus:@"angry_faces" forPost:post];
            break;
            
        case 3:
            [self markStatus:@"question_marks" forPost:post];
            break;
            
        case 4:
            [self markStatus:@"wtfs" forPost:post];
            break;
            
        case 5:
            [self markStatus:@"thumb_downs" forPost:post];
            break;
            
        case 6:
            [self markStatus:@"middle_fingers" forPost:post];
            break;
            
        case 7:
            [self repostStatus:post];
            break;
            
        case 8:
            [self markStatus:@"saves" forPost:post];
            break;
            
        case 9:
            self.replyingPost = post.parent ? post.parent : post;
            [self showReply];
            break;
            
        default:
            break;
    }
}

- (void)markStatus:(NSString *)mark forPost:(Post *)post
{
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Mark;
    [APIClient markStatus:mark forPost:post completion:^(BOOL successed) {
        // Hide;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Reload;
        [tblForPost reloadData];
    }];
}

- (void)repostStatus:(Post *)post
{
    CreatePostController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePostController"];
    viewController.post = post;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)showReply
{
    id <UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = appDelegate.window.rootViewController;
    CGRect frame = rootViewController.view.bounds;
    
    if (!viewForPopup) {
        viewForPopup = [[UIView alloc] initWithFrame:frame];
        viewForPopup.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.5f alpha:0.4f];
        viewForPopup.alpha = 0.0f;
        
        [rootViewController.view addSubview:viewForPopup];
        
        // Add;
        [viewForPopup addSubview:viewForReply];
    }
    
    // Alpha;
    viewForPopup.alpha = 1.0f;
    
    // Center;
    CGPoint point = viewForPopup.center;
    point.y = frame.size.height - viewForReply.bounds.size.height / 2;
    viewForReply.center = point;
    txtForComment.text = @"";
    
    // First Responder;
    [txtForComment becomeFirstResponder];
}

- (void)hideReply
{
    // First Responder;
    [txtForComment resignFirstResponder];
}

- (void)replyStatus:(NSString *)comment
{
    // Hide;
    [self hideReply];
    
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Mark;
    [APIClient replyStatus:comment forPost:self.replyingPost completion:^(Post *post) {
        // Hide;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Reload;
        [tblForPost reloadData];
    }];
}

#pragma mark - Notification
- (void)willShowKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = viewForReply.frame;
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.origin.y -= keyboardFrame.size.height;
    
    // Animation;
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:curve];
	[UIView setAnimationDuration:duration];
    viewForReply.frame = frame;
	[UIView commitAnimations];
}

- (void)willHideKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = viewForReply.frame;
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.origin.y += keyboardFrame.size.height;
    
    // Animation;
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:curve];
	[UIView setAnimationDuration:duration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didComplete)];
    viewForReply.frame = frame;
	[UIView commitAnimations];
}

- (void)didComplete
{
    [UIView animateWithDuration:0.2 animations:^{
        viewForPopup.alpha = 0.0f;
    }];
}

#pragma mark - Load
- (void)loadPost
{
    
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnClose:(id)sender
{
    [self hideReply];
}

@end