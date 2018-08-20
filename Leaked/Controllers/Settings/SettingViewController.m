//
//  SettingViewController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import <FacebookSDK/FacebookSDK.h>

#import "SettingViewController.h"
#import "CreatePostController.h"

#import "APIClient.h"
#import "Account.h"

#import "MBProgressHUD.h"

#import "UIViewController+ECSlidingViewController.h"
#import "UIButton+WebCache.h"

// --- Defines ---;
// SettingViewController Class;
@interface SettingViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    UIView *viewForPopup;
    BOOL showing;
}

// Properties;
@property (nonatomic, strong) UIImage *avatar;

@end

@implementation SettingViewController

// Functions;
#pragma mark - SettingViewController
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
    btnForAvatar.layer.borderWidth = 1.0f;
    btnForAvatar.layer.borderColor = [UIColor colorWithRed:155.0f / 255.0f green:155.0f / 255.0f blue:155.0f / 255.0f alpha:1.0f].CGColor;
    btnForAvatar.layer.cornerRadius = btnForAvatar.bounds.size.width / 2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Status;
    imgForName.hidden = YES;
    imgForUsername.hidden = YES;
    imgForEmail.hidden = YES;
    imgForConfirmEmail.hidden = YES;
    
    // Load;
    [self loadProfile];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Scroll;
    viewForScroll.contentSize = viewForContent.frame.size;
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerController.allowsEditing = YES;
            
            // Present;
            [self presentViewController:pickerController animated:YES completion:^{
                
            }];
            break;
        }
            
        case 1:
        {
            UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
            
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerController.allowsEditing = YES;
            
            // Present;
            [self presentViewController:pickerController animated:YES completion:^{
                
            }];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)pickerController didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Set;
    self.avatar = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // UI;
    [btnForAvatar setImage:self.avatar forState:UIControlStateNormal];
    
    // Dismiss;
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pickerController
{
    // Dismiss;
    [pickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == txtForName) {
        imgForName.hidden = txtForName.text.length == 0;
        imgForName.highlighted = txtForName.text.length > 1;
        
        [txtForUsername becomeFirstResponder];
    } else if (textField == txtForUsername) {
        imgForUsername.hidden = txtForUsername.text.length == 0;
        imgForUsername.highlighted = txtForUsername.text.length > 1;
        
        [txtForEmail becomeFirstResponder];
    } else if (textField == txtForEmail) {
        imgForEmail.hidden = txtForEmail.text.length == 0;
        imgForEmail.highlighted = [self isEmailAddress:txtForEmail.text];
        
        [txtForConfirmEmail becomeFirstResponder];
    } else if (textField == txtForConfirmEmail) {
        imgForConfirmEmail.hidden = txtForConfirmEmail.text.length == 0;
        imgForConfirmEmail.highlighted = [self isEmailAddress:txtForConfirmEmail.text] && [txtForEmail.text isEqualToString:txtForConfirmEmail.text];
        
        [txtForConfirmEmail resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - UItextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [self hideBiography];
        
        // Save;
        [APIClient saveBiography:txtForBiography.text completion:^(BOOL successed) {
            
        }];
        return NO;
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
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    // Animation;
    if (!showing) {
        CGRect frame = viewForScroll.frame;
        frame.size.height = self.view.bounds.size.height - keyboardFrame.size.height;
        
        // Animation;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDuration:duration];
        viewForScroll.frame = frame;
        [UIView commitAnimations];
    } else {
        CGRect frame = viewForBiography.frame;
        frame.origin.y -= keyboardFrame.size.height;
        
        // Animation;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDuration:duration];
        viewForBiography.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)willHideKeyBoard:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSTimeInterval duration;
    UIViewAnimationCurve curve;
    CGRect keyboardFrame;
    
    // Keyboard;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    
    if (!showing) {
        CGRect frame = viewForScroll.frame;
        frame.size.height = self.view.bounds.size.height;
        
        // Animation;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelegate:self];
        viewForScroll.frame = frame;
        [UIView commitAnimations];
        
    } else {
        CGRect frame = viewForBiography.frame;
        frame.origin.y += keyboardFrame.size.height;
        
        // Animation;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(didComplete)];
        viewForBiography.frame = frame;
        [UIView commitAnimations];
    }
}

- (void)didComplete
{
    [UIView animateWithDuration:0.2 animations:^{
        viewForPopup.alpha = 0.0f;
        showing = NO;
    }];
}

- (void)showBiography
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
        [viewForPopup addSubview:viewForBiography];
    }
    
    // Alpha;
    viewForPopup.alpha = 1.0f;
    showing = YES;
    
    // Center;
    CGPoint point = viewForPopup.center;
    point.y = frame.size.height - viewForBiography.bounds.size.height / 2;
    viewForBiography.center = point;
//  txtForBiography.text = @"";
    
    // First Responder;
    [txtForBiography becomeFirstResponder];
}

- (void)hideBiography
{
    // First Responder;
    [txtForBiography resignFirstResponder];
}

#pragma mark - Alert Tips
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
}

#pragma mark - Check
- (BOOL)checkChanges
{
    Account *me = [Account me];
    NSInteger count = 0;
    
    if (self.avatar) {
        count++;
    }
    
    if (![txtForName.text isEqualToString:me.name]) {
        count++;
    }
    
    if (![txtForUsername.text isEqualToString:me.username]) {
        count++;
    }
    
    if (![txtForEmail.text isEqualToString:me.email]) {
        count++;
    }
    
    return count;
}

- (void)checkUsername
{
    
}

- (BOOL)isEmailAddress:(NSString *)email
{
    BOOL filter = YES;
    NSString *filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? filterString : laxString;
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (BOOL)checkEmail
{
    BOOL filter = YES;
    NSString *filterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = filter ? filterString : laxString;
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailTest evaluateWithObject:txtForEmail.text]) {
        [self showAlertWithTitle:nil message:@"Input a valid Email address."];
        return NO;
    }
    
    return YES;
}

- (void)resignResponders
{
    if ([txtForName isFirstResponder]) {
        [txtForName resignFirstResponder];
    } else if ([txtForUsername isFirstResponder]) {
        [txtForUsername resignFirstResponder];
    } else if ([txtForEmail isFirstResponder]) {
        [txtForEmail resignFirstResponder];
    } else if ([txtForConfirmEmail isFirstResponder]) {
        [txtForConfirmEmail resignFirstResponder];
    }
}

#pragma mark - Load
- (void)loadProfile
{
    [btnForAvatar sd_setImageWithURL:[NSURL URLWithString:[Account me].avatar] forState:UIControlStateNormal];
    
    txtForName.text = [Account me].name;
    imgForName.hidden = txtForName.text.length == 0;
    imgForName.highlighted = txtForName.text.length > 1;
    
    txtForUsername.text = [Account me].username;
    imgForUsername.hidden = txtForUsername.text.length == 0;
    imgForUsername.highlighted = txtForUsername.text.length > 1;
    
    txtForEmail.text = [Account me].email;
    imgForEmail.hidden = txtForEmail.text.length == 0;
    imgForEmail.highlighted = [self isEmailAddress:txtForEmail.text];
    
    txtForBiography.text = [Account me].biography;
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

- (IBAction)onBtnAvatar:(id)sender
{
    [[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take Photo" otherButtonTitles:@"Choose Existing Photo", nil] showInView:self.view];
}

- (IBAction)onBtnChangeProfilePicture:(id)sender
{
    if (self.avatar) {
        // Show;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // Changing;
        [APIClient changeProfilePicture:self.avatar completion:^(BOOL successed) {
            // Hide;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (IBAction)onBtnBiography:(id)sender
{
    [self resignResponders];
    
    // Show;
    [self showBiography];
}

- (IBAction)onBtnClose:(id)sender
{
    [self hideBiography];
}

- (IBAction)onBtnFacebook:(id)sender
{
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Sign;
    [self signInFacebook];
}

- (IBAction)onBtnSave:(id)sender
{
    if (![self checkEmail]) {
        return;
    }
    
    // Resign;
    [self resignResponders];
    
    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Register;
    [APIClient saveProfile:txtForName.text username:txtForUsername.text email:txtForEmail.text completion:^(BOOL successed) {
        // Hide;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // Edit Profile;
        if (successed) {
            // Notification;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"didUserLogin" object:nil];
            
            // Dismiss;
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } else {
            
        }
    }];
}

- (IBAction)onBtnSignOut:(id)sender
{
    // Log Out;
    [[Account me] logout];
    
    // Login;
    UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNaviController"];
    [self.slidingViewController presentViewController:viewController animated:YES completion:nil];
}

@end
