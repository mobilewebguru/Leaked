//
//  ProfileEditController.m
//  Leak
//
//  Created by Xin Jin on 16/6/14.
//  Copyright (c) 2014 Xin Jin. All rights reserved.
//
// --- Headers ---;
#import "ProfileEditController.h"

#import "BannerManager.h"

#import "APIClient.h"
#import "Account.h"

#import "MBProgressHUD.h"

#import "UIButton+WebCache.h"

// --- Defines ---;
// ProfileEditController Class;
@interface ProfileEditController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
{
    UIView *viewForPopup;
    BOOL showing;    
}

// Properties;
@property (nonatomic, strong) UIImage *avatar;

@end

@implementation ProfileEditController

// Functions;
#pragma mark - ProfileEditController
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
    imgForPassword.hidden = YES;
    imgForConfirmPassword.hidden = YES;
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect rect = mainScroll.frame;
//    rect.size.height = screenRect.size.height - rect.origin.y - 60;
    mainScroll.frame = rect;
    mainScroll.contentSize = CGSizeMake(0, 570);

    // Load;
    [self loadProfile];
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
        
        [txtForPassword becomeFirstResponder];
    } else if (textField == txtForPassword) {
        imgForPassword.hidden = txtForPassword.text.length == 0;
        imgForPassword.highlighted = txtForPassword.text.length > 6;
        
        [txtForConfirmPassword becomeFirstResponder];
    } else if (textField == txtForConfirmPassword) {
        imgForConfirmPassword.hidden = txtForConfirmPassword.text.length == 0;
        imgForConfirmPassword.highlighted = txtForConfirmPassword.text.length > 6 && [txtForPassword.text isEqualToString:txtForConfirmPassword.text];
        
        [txtForConfirmPassword resignFirstResponder];
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

    if (!showing) {
        CGRect frame = viewForContent.frame;
        frame.origin.y = - keyboardFrame.size.height / 2;
        
        // Animation;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDuration:duration];
        viewForContent.frame = frame;
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
        CGRect frame = viewForContent.frame;
        
        frame.origin.y = 0;
        
        // Animation;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationDelegate:self];
        viewForContent.frame = frame;
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
    
    if (![txtForPassword.text isEqualToString:@""]) {
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

- (BOOL)checkPassword
{
    if ([txtForPassword.text length] < 6) {
        [self showAlertWithTitle:nil message:@"Passwords must be at least 6 characters."];
        return NO;
    }
    
    if (![txtForPassword.text isEqualToString:txtForConfirmPassword.text]) {
        [self showAlertWithTitle:nil message:@"Passwords not match."];
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
    } else if ([txtForPassword isFirstResponder]) {
        [txtForPassword resignFirstResponder];
    } else if ([txtForConfirmPassword isFirstResponder]) {
        [txtForConfirmPassword resignFirstResponder];
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

#pragma mark - Events
- (IBAction)onBtnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self showBiography];
}

- (IBAction)onBtnClose:(id)sender
{
    [self hideBiography];
}

- (IBAction)onBtnSave:(id)sender
{
    if (![self checkEmail]) {
        return;
    }
    
    if (![self checkPassword]) {
        return;
    }
    
    // Resign;
    [self resignResponders];

    // Show;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Register;
    [APIClient editProfile:txtForName.text username:txtForUsername.text email:txtForEmail.text password:txtForPassword.text completion:^(BOOL successed) {
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

@end
