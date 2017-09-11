//
//  ConnectViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "ConnectViewController.h"
#import "UserViewController.h"
#import "CreatePostController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ConnectCell.h"
#import "MoreCell.h"
#import "MBProgressHUD.h"
#import "BannerManager.h"
#import "Account.h"
#import "APIClient.h"
#import "User.h"

#import "UIViewController+ECSlidingViewController.h"

// --- Defines ---;
// ConnectViewController Class;
@interface ConnectViewController () <ConnectCellDelegate>
{
    UIRefreshControl *refreshControl;    
    BOOL more;
}

// Properties;
@property (nonatomic, strong) NSMutableArray *users;

@end

@implementation ConnectViewController

// Functions;
#pragma mark - ConnectViewController
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
    [refreshControl addTarget:self action:@selector(loadUsers) forControlEvents:UIControlEventValueChanged];
    [tblForConnect addSubview:refreshControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtForSearch) {
        [txtForSearch resignFirstResponder];
    }
    
    return YES;
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
    UserViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserViewController"];
    viewController.user = self.users[indexPath.row];
    [self.navigationController pushViewController:viewController animated:YES];
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
            [tblForConnect reloadData];
        }];
    } else {
        [APIClient unfollowUser:user completion:^(BOOL finished) {
            // Reload;
            [tblForConnect reloadData];
        }];
    }
}

#pragma mark -
- (void)resignResponders
{
    if ([txtForSearch isFirstResponder]) {
        [txtForSearch resignFirstResponder];
    }
}

#pragma mark - Load
- (void)loadUsers
{
    // Get;
    [APIClient searchUsers:txtForSearch.text last:0 count:DEFAULT_COUNT completion:^(NSArray *users) {
        // Users;
        self.users = [NSMutableArray arrayWithArray:users];
        
        // More;
        more = [users count] == DEFAULT_COUNT;
        
        if ([refreshControl isRefreshing]) {
            [refreshControl endRefreshing];
        }
        
        // Reload;
        [tblForConnect reloadData];
    }];
}

- (void)loadMore
{
    [APIClient searchUsers:txtForSearch.text last:[self.users count] count:DEFAULT_COUNT completion:^(NSArray *users) {
        // Users;
        [self.users addObjectsFromArray:users];
        
        // More;
        more = [users count] == DEFAULT_COUNT;

        // Reload;
        [tblForConnect reloadData];
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

- (IBAction)onBtnSearch:(id)sender
{
    // Resign;
    [self resignResponders];
    
    // Load;
    [self loadUsers];
}

- (IBAction)onBtnFacebook:(id)sender
{
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Sign;
    [self signInFacebook];
}

#pragma mark - Sign
- (void)signInFacebook
{
    if (![FBSession activeSession].isOpen) {
        if (![FBSession activeSession].state != FBSessionStateCreated) {
            FBSession *session = [[FBSession alloc] initWithPermissions:@[@"email"]];
            
            // Set;
            [FBSession setActiveSession:session];
        }
        
        // Login;
        [[FBSession activeSession] openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error) {
                // Hide;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self showAlertWithTitle:nil message:@"Invalid Connection!"];
            } else {
                [self fetchProfile];
            }
        }];
    } else {
        [self fetchProfile];
    }
}

- (void)fetchProfile
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            // Hide;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self showAlertWithTitle:nil message:@"Invalid Connection!"];
        } else {
            id profile = result;
            FBRequest* friendsRequest = [FBRequest requestWithGraphPath:@"me/friends?fields=id" parameters:nil HTTPMethod:@"GET"];
            
            [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection, NSDictionary* result, NSError *error) {
                NSMutableArray *friends = [NSMutableArray array];
                NSArray *users = [result objectForKey:@"data"];
                
                for (NSDictionary<FBGraphUser>* user in users) {
                    if (user[@"installed"]) {
                        [friends addObject:user.objectID];
                    }
                }
                
                [self connectToFacebook:profile withFriends:friends];
            }];
        }
    }];
}

- (void)connectToFacebook:(id)profile withFriends:(NSArray *)friends
{
    [APIClient connectToFacebookWithId:profile[@"id"] friends:friends completion:^(Account *account, BOOL successed) {
        // Hide;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([account isAuthenticated]) {
            // Dismiss;
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                // Notification;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didUserLogin" object:nil];
            }];
        } else {
            // Alert;
            [self showAlertWithTitle:nil message:@"Invalid username/password"];
        }
    }];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

@end
