//
//  FollowingListController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "FollowingListController.h"
#import "UserViewController.h"
#import "ProfileViewController.h"

#import "ConnectCell.h"
#import "MoreCell.h"

#import "APIClient.h"
#import "Account.h"
#import "User.h"

// --- Defines ---;
// FollowingListController Class;
@interface FollowingListController () <ConnectCellDelegate>
{
    UIRefreshControl *refreshControl;
    
    BOOL more;
    NSInteger last;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation FollowingListController

// Functions;
#pragma mark - FollowingListController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    [refreshControl addTarget:self action:@selector(loadUsers) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load;
    [self loadUsers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (more) {
        return [self.users count] + 1;
    }
    
    return [self.users count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (more && indexPath.row == [self.users count]) {
        static NSString *cellIdentifier = @"MoreCell";
        MoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Start;
        [cell startAnimating];
        
        // Load;
        [self loadMore];
        
        return cell;
    } else {
        static NSString *cellIdentifier = @"ConnectCell";
        ConnectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Set;
        cell.delegate = self;
        cell.user = self.users[indexPath.row];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = self.users[indexPath.row];
    
    if (![user.userID isEqualToString:[Account me].userID]) {
        UserViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
        viewController.user = self.users[indexPath.row];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - ConnectCellDelegate
- (void)didUser:(User *)user
{
    
}

- (void)didFollow:(User *)user
{
    // Follow;
    if (!user.following) {
        [APIClient followUser:user completion:^(BOOL finished) {
            // Reload;
            [self.tableView reloadData];
        }];
    } else {
        [APIClient unfollowUser:user completion:^(BOOL finished) {
            // Reload;
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - Load
- (void)loadUsers
{
    // Get;
    [APIClient getFollowings:self.user last:0 count:DEFAULT_COUNT completion:^(NSArray *users) {
        // Users;
        self.users = [NSMutableArray arrayWithArray:users];
        
        // More;
        User *user = [self.users lastObject];
        more = [users count] == DEFAULT_COUNT;
        last = [user.objectID integerValue];
        
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        
        // Reload;
        [self.tableView reloadData];
    }];
}

- (void)loadMore
{
    // Get;
    [APIClient getFollowings:self.user last:last count:DEFAULT_COUNT completion:^(NSArray *users) {
        // Users;
        [self.users addObjectsFromArray:users];
        
        // More;
        User *user = [self.users lastObject];
        more = [users count] == DEFAULT_COUNT;
        last = [user.objectID integerValue];

        // Reload;
        [self.tableView reloadData];
    }];
}

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
