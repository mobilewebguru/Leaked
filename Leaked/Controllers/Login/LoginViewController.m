//
//  LoginViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <FacebookSDK/FacebookSDK.h>

#import "LoginViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import "APIClient.h"
#import "Account.h"

#import "MBProgressHUD.h"

// --- Defines ---;
// LoginViewController Class;
@interface LoginViewController ()

@end

@implementation LoginViewController

// Functions;
#pragma mark - LoginViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Status;
    imgForUsername.hidden = YES;
    imgForPassword.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    AppDelegate * delegate = DELEGATE;
    if (delegate.username != nil) {
        [txtForUsername setText:delegate.username];
        [txtForPassword setText:delegate.userpassword];
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        if (![self checkBlankField]) {
            return;
        }
        
        if (![self checkPassword]) {
            return;
        }
        
        // Resign;
        [self resignResponders];
        
        // Show;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Login;
        [APIClient loginWithUsername:txtForUsername.text password:txtForPassword.text completion:^(Account *account, BOOL successed) {
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

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Notifications;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willShowKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideKeyBoard:) name:UIKeyboardWillHideNotification object:nil];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtForUsername) {
        imgForUsername.hidden = txtForUsername.text.length == 0;
        imgForUsername.highlighted = txtForUsername.text.length > 1;
        
        [txtForPassword becomeFirstResponder];
    } else if (textField == txtForPassword) {
        imgForPassword.hidden = txtForPassword.text.length == 0;
        imgForPassword.highlighted = txtForPassword.text.length > 6;
        
        [txtForPassword resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Notification
- (void)willShowKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = viewForContent.frame;
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.origin.y = - keyboardFrame.size.height / 2;
    
    // Animation;
    [UIView animateWithDuration:duration animations:^{
        viewForContent.frame = frame;
    }];
}

- (void)willHideKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    CGRect frame = viewForContent.frame;
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    frame.origin.y = 0;
    
    // Animation;
    [UIView animateWithDuration:duration animations:^{
        viewForContent.frame = frame;
    }];
}

#pragma mark - Alert Tips
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

#pragma mark - Check
- (BOOL)checkBlankField
{
    NSArray *fields = [NSArray arrayWithObjects:txtForUsername, txtForPassword, nil];
    
    for (NSInteger i = 0; i < [fields count]; i++) {
        UITextField *field = fields[i];
        
        if ([field.text isEqualToString:@""]) {
            [self showAlertWithTitle:nil message:@"Please fill in all the details."];
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)checkPassword
{
    if ([txtForPassword.text length] < 6) {
        [self showAlertWithTitle:nil message:@"Passwords must be at least 6 characters."];
        return NO;
    }
    
    return YES;
}

- (void)resignResponders
{
    if ([txtForUsername isFirstResponder]) {
        [txtForUsername resignFirstResponder];
    } else if ([txtForPassword isFirstResponder]) {
        [txtForPassword resignFirstResponder];
    }
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
                
                [self signInFacebookWithProfile:profile withFriends:friends];
            }];
        }
    }];
}

- (void)signInFacebookWithProfile:(id)profile withFriends:(NSArray *)friends
{
    [APIClient signInFacebookWithUsername:@"" name:profile[@"name"] email:profile[@"email"] facebookId:profile[@"id"] friends:friends completion:^(Account *account, BOOL successed) {
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

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Terms of Service"]) {
        WebViewController *viewController = segue.destinationViewController;
        viewController.titleOfController = @"Terms of Service";
        viewController.url = [[NSBundle mainBundle] pathForResource:@"Terms of Service" ofType:@"docx"];
    } else if ([segue.identifier isEqualToString:@"Privacy Policy"]) {
        WebViewController *viewController = segue.destinationViewController;
        
        viewController.titleOfController = @"Privacy Policy";
        viewController.url = [[NSBundle mainBundle] pathForResource:@"Privacy Policy" ofType:@"docx"];
    }
}

#pragma mark - Events
- (IBAction)onBtnLogin:(id)sender
{
    // Check;
    if (![self checkBlankField]) {
        return;
    }
    
    if (![self checkPassword]) {
        return;
    }
    
    // Resign;
    [self resignResponders];
    
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Login;
    [APIClient loginWithUsername:txtForUsername.text password:txtForPassword.text completion:^(Account *account, BOOL successed) {
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

- (IBAction)onBtnFacebook:(id)sender
{
    // Resign;
    [self resignResponders];
    
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Register;
    [self signInFacebook];
}

- (IBAction)onBtnTwitter:(id)sender
{

}

@end
