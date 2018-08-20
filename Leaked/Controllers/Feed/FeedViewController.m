//
//  FeedViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "FeedViewController.h"
#import "CreatePostController.h"
#import "PostViewController.h"

#import "FeedCell.h"

#import "BannerManager.h"

#import "APIClient.h"
#import "Account.h"
#import "Post.h"

#import "MBProgressHUD.h"

#import "UIViewController+ECSlidingViewController.h"

// --- Defines ---;
// FeedViewController Class;
@interface FeedViewController () <FeedCellDelegate, UITextViewDelegate>
{
    UIView *viewForPopup;
    
    UIRefreshControl *refreshControl;
    
    BOOL more;
    NSInteger last;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *posts;
@property (nonatomic, strong) Post *replyingPost;
@property (nonatomic, strong) Post *reportingPost;

@end

@implementation FeedViewController

// Functions;
#pragma mark - FeedViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogin) name:@"didUserLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPost:) name:@"didPost" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDelete:) name:@"didDelete" object:nil];
    
    // Refresh Control;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    [tblForFeed addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];

    if ([[Account me] isAuthenticated]) {
        // Load;
        [self loadPosts];
    }

    // Banner;
    ADBannerView *bannerView = [BannerManager sharedManager].bannerView;
    [viewForBanner addSubview:bannerView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if ([[Account me] isAuthenticated]) {
        // Load;
        [self loadPosts];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    // Refresh Control;
    [refreshControl removeFromSuperview];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.posts count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Post *post = self.posts[section];
    return 1 + [post.replied count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        Post *post = self.posts[indexPath.section];
        
        static NSString *cellIdentifier = @"FeedCell";
        FeedCell *cell = [tblForFeed dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.post = post;
        return cell;
    } else {
        Post *post = self.posts[indexPath.section];
        Post *replied = post.replied[indexPath.row - 1];
        
        static NSString *cellIdentifier = @"RepliedCell";
        FeedCell *cell = [tblForFeed dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.post = replied;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
    if (indexPath.row == 0) {
        Post *post = self.posts[indexPath.section];
        viewController.post = post;
    } else {
        Post *post = self.posts[indexPath.section];
        Post *replied = post.replied[indexPath.row - 1];
        viewController.post = replied;
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self replyStatus:txtForComment.text];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // Show;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [APIClient reportStatus:self.reportingPost completion:^(BOOL successed) {
            // Hide;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            // Set;
            self.reportingPost = nil;
        }];
    }
}

#pragma mark - FeedCellDelegate
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
        [tblForFeed reloadData];
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
        [tblForFeed reloadData];
    }];
}

- (void)didReport:(Post *)post
{
    // Set;
    self.reportingPost = post;

    // Action Sheet;
    [[[UIActionSheet alloc] initWithTitle:@"Report this!" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Report" otherButtonTitles:nil] showInView:self.view];
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

#pragma mark - Notifications
- (void)didUserLogin
{
    if ([[Account me] isAuthenticated]) {
        // Offset;
        [tblForFeed setContentOffset:CGPointZero];
        
        // Load;
        [self loadPosts];
    }
}

- (void)didPost:(NSNotification *)notification
{
    Post *post = notification.object;
    
    // Insert;
    [self.posts insertObject:post atIndex:0];
    
    // Reload;
    [tblForFeed reloadData];
}

- (void)didDelete:(NSNotification *)notification
{
/*    Post *post = notification.object;
    
    // Delete;
    [self.posts removeObject:post];
    
    // Reload;
    [self.tableView reloadData];*/
    
    // Load;
    [self loadPosts];
}

#pragma mark - Load
- (void)loadPosts
{
    // Get;
    [APIClient getFeeds:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
        // Users;
        self.posts = [NSMutableArray arrayWithArray:posts];
        
        // More;
        more = [posts count] == DEFAULT_COUNT;
        
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        
        // Reload;
        [tblForFeed reloadData];
    }];
}

- (void)loadMore
{
    // Get;
    [APIClient getFeeds:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
        // Users;
        self.posts = [NSMutableArray arrayWithArray:posts];
        
        // More;
        more = [posts count] == DEFAULT_COUNT;
        
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        
        // Reload;
        [tblForFeed reloadData];
    }];
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

- (IBAction)onBtnClose:(id)sender
{
    [self hideReply];
}

@end
