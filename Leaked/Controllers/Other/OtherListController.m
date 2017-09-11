//
//  OtherListController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "OtherListController.h"
#import "CreatePostController.h"
#import "PostViewController.h"

#import "FeedCell.h"

#import "BannerManager.h"

#import "APIClient.h"
#import "Account.h"
#import "Post.h"

#import "UIViewController+ECSlidingViewController.h"

// --- Defines ---;
// OtherListController Class;
@interface OtherListController ()
{
    UIRefreshControl *refreshControl;
    
    BOOL more;
    NSInteger last;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation OtherListController

// Functions;
#pragma mark - OtherListController
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
    
    // Refresh Control;
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl setTintColor:[UIColor whiteColor]];
    [refreshControl addTarget:self action:@selector(loadPosts) forControlEvents:UIControlEventValueChanged];
    [tblForOther addSubview:refreshControl];
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
    FeedCell *cell = [tblForOther dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
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
        [tblForOther setContentOffset:CGPointZero];
        
        // Load;
        [self loadPosts];
    }
}

#pragma mark - Load
- (void)loadPosts
{
    // Get;
    if ([self.mark isEqualToString:@"reposts"]) {
        [APIClient getAccountReposts:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
            // Users;
            self.posts = [NSMutableArray arrayWithArray:posts];
            
            // More;
            more = [posts count] == DEFAULT_COUNT;
            
            if ([refreshControl isRefreshing]) {
                [refreshControl endRefreshing];
            }
            
            // Reload;
            [tblForOther reloadData];
        }];
    }
    else if ([self.mark isEqualToString:@"replies"]) {
        [APIClient getAccountReplies:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
            // Users;
            self.posts = [NSMutableArray arrayWithArray:posts];
            
            // More;
            more = [posts count] == DEFAULT_COUNT;
            
            if ([refreshControl isRefreshing]) {
                [refreshControl endRefreshing];
            }
            
            // Reload;
            [tblForOther reloadData];
        }];
    } else {
        [APIClient getMarkedPosts:self.mark last:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
            // Users;
            self.posts = [NSMutableArray arrayWithArray:posts];
            
            // More;
            more = [posts count] == DEFAULT_COUNT;
            
            if ([refreshControl isRefreshing]) {
                [refreshControl endRefreshing];
            }
            
            // Reload;
            [tblForOther reloadData];
        }];
    }
}

- (void)loadMore
{
    // Get;
    if ([self.mark isEqualToString:@"reposts"]) {
        [APIClient getAccountReposts:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
            // Users;
            self.posts = [NSMutableArray arrayWithArray:posts];
            
            // More;
            more = [posts count] == DEFAULT_COUNT;
            
            if ([refreshControl isRefreshing]) {
                [refreshControl endRefreshing];
            }
            
            // Reload;
            [tblForOther reloadData];
        }];
    }
    else if ([self.mark isEqualToString:@"replies"]) {
        [APIClient getAccountReplies:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
            // Users;
            self.posts = [NSMutableArray arrayWithArray:posts];
            
            // More;
            more = [posts count] == DEFAULT_COUNT;
            
            if ([refreshControl isRefreshing]) {
                [refreshControl endRefreshing];
            }
            
            // Reload;
            [tblForOther reloadData];
        }];
    } else {
        [APIClient getMarkedPosts:self.mark last:0 count:DEFAULT_COUNT completion:^(NSArray *posts) {
            // Users;
            self.posts = [NSMutableArray arrayWithArray:posts];
            
            // More;
            more = [posts count] == DEFAULT_COUNT;
            
            if ([refreshControl isRefreshing]) {
                [refreshControl endRefreshing];
            }
            
            // Reload;
            [tblForOther reloadData];
        }];
    }
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onBtnPost:(id)sender
{
    CreatePostController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePostController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
