//
//  SaveViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "SaveViewController.h"
#import "CreatePostController.h"
#import "PostViewController.h"

#import "FeedCell.h"

#import "BannerManager.h"

#import "APIClient.h"
#import "Account.h"
#import "Post.h"

#import "UIViewController+ECSlidingViewController.h"

// --- Defines ---;
// SaveViewController Class;
@interface SaveViewController ()
{
    UIRefreshControl *refreshControl;
    
    BOOL more;
    NSInteger last;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation SaveViewController

// Functions;
#pragma mark - SaveViewController
- (void)loadView
{
    [super loadView];
    
    // Refresh Control;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    [tblForSave addSubview:refreshControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUserLogin) name:@"didUserLogin" object:nil];
    
    if ([[Account me] isAuthenticated]) {
        // Load;
        [self loadPosts];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Banner;
    ADBannerView *bannerView = [BannerManager sharedManager].bannerView;
    [viewForBanner addSubview:bannerView];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.posts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FeedCell";
    FeedCell *cell = [tblForSave dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.post = self.posts[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PostViewController"];
    viewController.post = self.posts[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - Notifications
- (void)didUserLogin
{
    if ([[Account me] isAuthenticated]) {
        // Offset;
        [tblForSave setContentOffset:CGPointZero];
        
        // Load;
        [self loadPosts];
    }
}

#pragma mark - Load
- (void)loadPosts
{
    // Get;
    [APIClient getSaves:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
        // Users;
        self.posts = [NSMutableArray arrayWithArray:posts];
        
        // More;
        more = [posts count] == DEFAULT_COUNT;
        
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        
        // Reload;
        [tblForSave reloadData];
    }];
}

- (void)loadMore
{
    // Get;
    [APIClient getSaves:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
        // Users;
        self.posts = [NSMutableArray arrayWithArray:posts];
        
        // More;
        more = [posts count] == DEFAULT_COUNT;
        
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        
        // Reload;
        [tblForSave reloadData];
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

@end
